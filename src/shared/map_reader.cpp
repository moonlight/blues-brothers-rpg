/*
 *  RAGE - Role & Adventure Games Engine
 *  Website: http://alternativegamers.com/
 *  Copyright 2005 Ramine Darabiha
 *
 *  This file is part of RAGE.
 *
 *  RAGE is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  any later version.
 *
 *  RAGE is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with RAGE; if not, write to the Free Software Foundation, Inc.,
 *  59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  $Id$
 */

#include "map_reader.h"

#include "base64.h"
#include "console.h"
#include "../common.h"
#include "inflate.h"
#include "module.h"
#include "object.h"
#include "tiled_map.h"

TiledMap*
MapReader::readMap(const char *filename)
{
    console.log(CON_LOG, CON_VDEBUG, "- Attempting to parse XML map data");

    FILE* f = fopen(filename, "rb");
    char *map_string;

    if (!f) {
        console.log(CON_QUIT, CON_ALWAYS, "Error: %s failed to open!",
                filename);
    }

    // Get size of file
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);

    // Read file into character array
    map_string = new char[size + 1];
    fread(map_string, 1, size, f);
    map_string[size] = '\0';

    fclose(f);

    xmlDocPtr doc = xmlReadMemory(map_string, size, NULL, NULL, 0);
    delete[] map_string;

    if (doc) {
        console.log(CON_LOG, CON_VDEBUG, "- Looking for root node");
        xmlNodePtr node = xmlDocGetRootElement(doc);

        if (!node || !xmlStrEqual(node->name, BAD_CAST "map")) {
            console.log(CON_LOG, CON_ALWAYS,
                    "Warning, no map file (%s)!", filename);
            return NULL;
        }

        console.log(CON_LOG, CON_VDEBUG, "- Loading map from XML tree");
        return readMap(node, filename);
        xmlFreeDoc(doc);
    } else {
        console.log(CON_LOG, CON_ALWAYS,
                "Error while parsing map file (%s), trying old format...!",
                filename);

        TiledMap *mmap = new SquareMap(TILES_W, TILES_H);
        mmap->loadMap(filename);
        return mmap;
    }

    return NULL;
}

TiledMap*
MapReader::readMap(xmlNodePtr node, const std::string &path)
{
    xmlChar *prop;

    prop = xmlGetProp(node, BAD_CAST "version");
    xmlFree(prop);

    int w = getProperty(node, "width", 0);
    int h = getProperty(node, "height", 0);
    int tilew = getProperty(node, "tilewidth", TILES_W);
    int tileh = getProperty(node, "tileheight", TILES_H);
    TiledMap* map = new SquareMap(tilew, tileh);
    map->width = w;
    map->height = h;
    map->deleteLayers();

    for (node = node->xmlChildrenNode; node != NULL; node = node->next)
    {
        if (xmlStrEqual(node->name, BAD_CAST "tileset"))
        {
            Tileset* set = readTileset(node, path);
            if (set) {
                map->tilesets.push_back(set);
            }
        }
        else if (xmlStrEqual(node->name, BAD_CAST "layer"))
        {
            console.log(CON_LOG, CON_VDEBUG, "- Loading layer %d",
                    map->mapLayers.size() + 1);
            map->mapLayers.push_back(readLayer(node, map));
        }
        else if (xmlStrEqual(node->name, BAD_CAST "object"))
        {
            int x = getProperty(node, "x", 0);
            int y = getProperty(node, "y", 0);

            // Spawn the object
            prop = xmlGetProp(node, BAD_CAST "type");

            console.log(CON_LOG, CON_VDEBUG, "- Adding %s at (%d, %d)",
                    (char*) prop, x, y);
            map->addObject((double) x / TILES_W,
                           (double) y / TILES_H,
                           (char*) prop);
            xmlFree(prop);
        }
    }

    return map;
}

TiledMapLayer*
MapReader::readLayer(xmlNodePtr node, TiledMap *map)
{
    TiledMapLayer *layer = new TiledMapLayer();

    // Get layer attributes
    int w = getProperty(node, "width", 0);
    int h = getProperty(node, "height", 0);
    xmlChar *name = xmlGetProp(node, BAD_CAST "name");
    bool obstacleLayer = false;
    if (name) {
        layer->setName((char*)name);
        if (xmlStrEqual(name, BAD_CAST "Obstacle")) {
            obstacleLayer = true;
        }
        xmlFree(name);
    }

    layer->resizeTo(w, h);

    node = node->xmlChildrenNode;
    int x = 0;
    int y = 0;

    // Load the tile data
    while (node != NULL)
    {
        if (xmlStrEqual(node->name, BAD_CAST "tile") && y < h)
        {
            xmlChar *name = xmlGetProp(node, BAD_CAST "name");
            //xmlChar *obs = xmlGetProp(node, BAD_CAST "obstacle");
            int gid = getProperty(node, "gid", -1);

            if (gid > -1) {
                layer->setTile(Point(x, y), map->getTile(gid));
            }
            else if (name) {
                // DEPRECATED: Old way of storing tiles
                char buf[64];
                strncpy(buf, (char*) name, 64);
                char *nr = strstr(buf, ".");
                if (nr) {
                    *nr = '\0';
                    int id = atoi(++nr);
                    Tileset* ts = map->getTileset(buf);
                    if (ts) {
                        layer->setTile(Point(x, y), ts->getTile(id));
                    }
                }

                xmlFree(name);
            }
            else {
                layer->setTile(Point(x, y), NULL);
            }

            /*
            if (obs) {
                tile->obstacle =
                    ((obs[0] == '1') ? OB_TOP : 0) |
                    ((obs[1] == '1') ? OB_RIGHT : 0) |
                    ((obs[2] == '1') ? OB_BOTTOM : 0) |
                    ((obs[3] == '1') ? OB_LEFT : 0);
                xmlFree(obs);
            }
            else {
                tile->obstacle = 0;
            }
            */

            x++;
            if (x == w) {x = 0; y++;}
        }

        if (xmlStrEqual(node->name, BAD_CAST "data"))
        {
            xmlChar *encoding = xmlGetProp(node, BAD_CAST "encoding");
            xmlChar *compression = xmlGetProp(node, BAD_CAST "compression");
            bool base64Encoded = false;
            bool gzipCompressed = false;

            if (encoding && xmlStrEqual(encoding, BAD_CAST "base64"))
            {
                base64Encoded = true;
                xmlFree(encoding);
            }

            if (compression && xmlStrEqual(compression, BAD_CAST "gzip"))
            {
                gzipCompressed = true;
                xmlFree(compression);
            }

            if (base64Encoded)
            {
                xmlNodePtr dataChild = node->xmlChildrenNode;
                if (!dataChild) {
                    console.log(CON_QUIT, CON_ALWAYS, "Layer data missing!");
                }

                int len = strlen((char const *)dataChild->content) + 1;
                unsigned char *charData = new unsigned char[len + 1];
                char const *charStart = (char const *)dataChild->content;
                unsigned char *charIndex = charData;

                while (*charStart) {
                    if (*charStart != ' ' && *charStart != '\t' &&
                            *charStart != '\n')
                    {
                        *charIndex = *charStart;
                        charIndex++;
                    }
                    charStart++;
                }
                *charIndex = '\0';

                int binLen;
                unsigned char *binData = php3_base64_decode(charData,
                        strlen((const char*) charData), &binLen);

                delete[] charData;

                if (!binData) {
                    console.log(CON_QUIT, CON_ALWAYS,
                            "Layer data decode failed!");
                }

                if (gzipCompressed)
                {
                    unsigned char *inflatedData;
                    unsigned int inflatedLen;
                    inflateMemory(binData, binLen, inflatedData, inflatedLen);

                    free(binData);
                    binData = inflatedData;
                    binLen = inflatedLen;

                    if (inflatedData == NULL)
                    {
                        console.log(CON_QUIT, CON_ALWAYS,
                                "Layer data decompression failed!");
                    }
                }

                for (int i = 0; i < binLen - 3; i += 4)
                {
                    int gid = binData[i] |
                              binData[i + 1] << 8 |
                              binData[i + 2] << 16 |
                              binData[i + 3] << 24;

                    TileType *type = map->getTile(gid);

                    if (obstacleLayer)
                    {
                        Tile *tile = map->getLayer((unsigned int)0)->getTile(
                                Point(x, y));
                        if (type)
                        {
                            tile->obstacle = type->getId();
                        }
                    }
                    else
                    {
                        layer->setTile(Point(x, y), type);
                    }

                    x++;
                    if (x == w) { x = 0; y++; }
                }

                free(binData);

                // Make sure the while loop stops
                node = NULL;
            }
            else
            {
                // This is to support tile elements in a data element
                node = node->xmlChildrenNode;
            }
        }
        else
        {
            node = node->next;
        }
    }

    return layer;
}

Tileset*
MapReader::readTileset(xmlNodePtr node, const std::string &path)
{
    Tileset* set = NULL;

    xmlChar* prop = xmlGetProp(node, BAD_CAST "source");
    if (prop) {
        console.log(CON_LOG, CON_ALWAYS,
                "Warning: External tilesets not supported yet.");
        xmlFree(prop);
        return NULL;
    }

    int firstgid = getProperty(node, "firstgid", 0);
    int tw = getProperty(node, "tilewidth", TILES_W);
    int th = getProperty(node, "tileheight", TILES_H);
    int ts = getProperty(node, "spacing", 0);
    xmlChar *name = xmlGetProp(node, BAD_CAST "name");

    node = node->xmlChildrenNode;

    while (node != NULL)
    {
        if (xmlStrEqual(node->name, BAD_CAST "image"))
        {
            xmlChar* source = xmlGetProp(node, BAD_CAST "source");

            if (source)
            {
                std::string filename = path.substr(0, path.rfind("/") + 1) +
                                       std::string((const char*)source);
                const char *nameOnly = get_filename(filename.c_str());
                BITMAP* tilebmp = module->findBitmap(nameOnly);

                if (tilebmp) {
                    set = new Tileset();
                    set->importTileBitmap(tilebmp, (char*)source, tw, th, ts);
                    set->setFirstGid(firstgid);
                    if (name) {
                        set->setName((char*)name);
                    }
                    xmlFree(source);
                } else {
                    printf("Warning: Failed to load tileset %s (%s) for map "
                            "%s\n", nameOnly, (char*)name,
                            path.c_str());
                }
            }

            break;
        }

        node = node->next;
    }

    xmlFree(name);

    return set;
}

int
MapReader::getProperty(xmlNodePtr node, const char* name, int def)
{
    xmlChar *prop = xmlGetProp(node, BAD_CAST name);
    if (prop) {
        int val = atoi((char*)prop);
        xmlFree(prop);
        return val;
    } else {
        return def;
    }
}
