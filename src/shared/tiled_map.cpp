/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003, 2004  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#include "object.h"
#include "tiled_map.h"
#include "../common.h"
#include "../script.h"
#include <stdio.h>
#include <allegro.h>
#include <map>
#include <cassert>
#include <algorithm>
#include <libxml/xmlwriter.h>
#include <libxml/xmlreader.h>

inline int clamp(int a, int min, int max)
{
    return (a < min) ? min : ((a > max) ? max : a);
}

// Vector class ==============================================================

Vector::Vector()
{
    x = y = z = 0.0f;
}

Vector::Vector(double x, double y, double z)
{
    this->x = x;
    this->y = y;
    this->z = z;
}

Vector::Vector(const Vector &v):
    x(v.x),
    y(v.y),
    z(v.z)
{
}

Vector Vector::operator*(double c)
{
    Vector result;
    result.x = x * c;
    result.y = y * c;
    result.z = z * c;
    return result;
}

Vector Vector::operator/(double c)
{
    Vector result;
    result.x = x / c;
    result.y = y / c;
    result.z = z / c;
    return result;
}

Vector Vector::operator+(const Vector &v)
{
    Vector result;
    result.x = x + v.x;
    result.y = y + v.y;
    result.z = z + v.z;
    return result;
}

Vector Vector::operator-(const Vector &v)
{
    Vector result;
    result.x = x - v.x;
    result.y = y - v.y;
    result.z = z - v.z;
    return result;
}


// Rectangle class ===========================================================

Rectangle::Rectangle(int x, int y, int w, int h)
{
    this->x = x;
    this->y = y;
    this->w = w;
    this->h = h;
}

void Rectangle::rectToClip(BITMAP *dest)
{
    set_clip_rect(dest, x, y, x + w - 1, y + h - 1);
}

void Rectangle::clipToRect(BITMAP *src)
{
    x = src->cl;
    y = src->ct;
    w = src->cr - src->cl + 1;
    h = src->cb - src->ct + 1;
}

bool Rectangle::collides(const Rectangle &r)
{
    return !(x + w < r.x ||
             y + h < r.y ||
             x > r.x + r.w ||
             y > r.y + r.h);
}


// TileType ==================================================================
//  An object holding static information about a tile type.

TileType::TileType(BITMAP *tileBitmap, const char *tileName, int id):
    mId(id)
{
    bitmap = tileBitmap;
    if (tileName) {
        name = (char*)malloc(ustrsizez(tileName));
        ustrcpy(name, tileName);
    }
    else {
        name = NULL;
    }
    int x, y;
    unsigned long r = 0, g = 0, b = 0;
    unsigned long pixels = tileBitmap->w * tileBitmap->h;

    // Calculate average color
    for (x = 0; x < tileBitmap->w; x++) {
        for (y = 0; y < tileBitmap->h; y++) {
            int c = getpixel(tileBitmap, x, y);
            r += getr(c);
            g += getg(c);
            b += getb(c);
        }
    }

    color = makecol(r / pixels, g / pixels, b / pixels);
}

TileType::~TileType()
{
    destroy_bitmap(bitmap);
    free(name);
}


// Tile class ================================================================

Tile::Tile():
    obstacle(0),
    tileType(NULL)
{
}

void Tile::saveTo(PACKFILE *file)
{
    // Write tile name to file
    if (tileType) {
        pack_fputs(tileType->getName(), file);
    }
    pack_fputs("\n", file);

    pack_iputw(obstacle, file);
}

void Tile::saveTo(xmlTextWriterPtr writer)
{
    xmlTextWriterStartElement(writer, BAD_CAST "tile");

    if (tileType) {
        xmlTextWriterWriteAttribute(writer,
                BAD_CAST "name", BAD_CAST tileType->getName());
    }

    if (obstacle) {
        char obs[5];
        obs[0] = (obstacle & OB_TOP) ? '1' : '0';
        obs[1] = (obstacle & OB_RIGHT) ? '1' : '0';
        obs[2] = (obstacle & OB_BOTTOM) ? '1' : '0';
        obs[3] = (obstacle & OB_LEFT) ? '1' : '0';
        obs[4] = '\0';
        xmlTextWriterWriteAttribute(writer,
                BAD_CAST "obstacle", BAD_CAST obs);
    }

    xmlTextWriterEndElement(writer);
}

void Tile::loadFrom(PACKFILE *file, TileRepository *tileRepository)
{
    // Load tile name from file and look it up in the tile repository
    char name[32];
    pack_fgets(name, 32, file);
    setType(tileRepository->getTileType(name));

    obstacle = pack_igetw(file);
}

void Tile::setType(TileType *tileType)
{
    this->tileType = tileType;
}


// Entity sorting helper class ===============================================

bool EntityP::operator< (const EntityP& X) const {
    return (ent->pos.y + ent->pos.z < X.ent->pos.y + X.ent->pos.z);
}


// TileRepository ============================================================
//  A tile repository to handle a collection of tile types

TileRepository::~TileRepository()
{
    // Remove tile types from memory
    map<const char*, TileType*, ltstr>::iterator i;
    while (!tileTypes.empty())
    {
        i = tileTypes.begin();
        TileType* tempTileType = (*i).second;
        tileTypes.erase(i);
        delete tempTileType;
    }
}

void TileRepository::importDatafile(DATAFILE *file)
{
    if (!file) return;

    TileType *tempTileType;
    BITMAP *tempBitmap;

    // Import bitmaps from the datafile
    while (file->type != DAT_END) {
        switch (file->type) {
            case DAT_FILE:
                // Go recursively into nested datafiles
                importDatafile((DATAFILE*)file->dat);
                break;
            case DAT_BITMAP:
                // Create a new tile type and add it to the hash_map
                tempBitmap = create_bitmap(
                        ((BITMAP*)file->dat)->w, ((BITMAP*)file->dat)->h);
                blit((BITMAP*)file->dat, tempBitmap, 0, 0, 0, 0,
                        tempBitmap->w, tempBitmap->h);

                tempTileType = new TileType(tempBitmap,
                        get_datafile_property(file, DAT_ID('N','A','M','E')));

                tileTypes.insert(std::make_pair(
                            tempTileType->getName(), tempTileType));
                break;
        }
        file++;
    }
}

void TileRepository::importBitmap(
        BITMAP* tileBitmap, const char* group_name,
        int tile_w, int tile_h, int tile_spacing)
{
    BITMAP *tempBitmap;
    TileType *tempTileType;
    char tempTilename[256];
    int x, y;

    ASSERT(tileBitmap);

    for (y = 0; y < (tileBitmap->h / (tile_h + tile_spacing)); y++)
    {
        for (x = 0; x < (tileBitmap->w / (tile_w + tile_spacing)); x++)
        {
            // Create a new tile type and add it to the hash_map
            tempBitmap = create_bitmap(tile_w, tile_h);
            blit(
                    tileBitmap, tempBitmap,
                    x * (tile_w + tile_spacing),
                    y * (tile_h + tile_spacing),
                    0, 0, tile_w, tile_h
                );

            sprintf(tempTilename, "%s%03d", group_name,
                    y * (tileBitmap->w / tile_w) + x);

            tempTileType = new TileType(tempBitmap, tempTilename);
            tileTypes.insert(std::make_pair(tempTileType->getName(), tempTileType));
        }
    }
}

void TileRepository::importBitmap(
        const char *filename,
        int tile_w, int tile_h, int tile_spacing)
{
    BITMAP *tileBitmap;
    char tempFilename[256];
    PALETTE pal;

    tileBitmap = load_bitmap(filename, pal);
    if (!tileBitmap) {
        allegro_message("Warning, %s is not a valid tile bitmap!\n", filename);
        return;
    }

    set_palette(pal);
    replace_extension(tempFilename, get_filename(filename), "", 256);

    importBitmap(tileBitmap, tempFilename, tile_w, tile_h, tile_spacing);

    destroy_bitmap(tileBitmap);
}

void TileRepository::exportBitmap(
        const char *filename,
        int tile_w, int tile_h, int tile_spacing, int tiles_in_row)
{
    std::list<TileType*> tiles_to_save;
    std::map<const char*, TileType*, ltstr>::iterator i;
    std::list<TileType*>::iterator j;
    char tempTilename[256];
    char tempFilename[256];
    replace_extension(tempFilename, get_filename(filename), "", 256);

    if (!(tiles_in_row > 0 && tile_w > 0 && tile_h > 0)) {
        allegro_message("WARNING: tiles_in_row (%d), tile_w (%d) and tile_h (%d) must all be larger than 0.", tiles_in_row, tile_w, tile_h);
        return;
    }

    for (i = tileTypes.begin(); i != tileTypes.end(); i++)
    {
        TileType* tempTileType = (*i).second;
        replace_extension(tempTilename, tempTileType->getName(), "", 256);
        if (ustrcmp(tempFilename, tempTilename) == 0) {
            tiles_to_save.push_back(tempTileType);
        }
    }

    if (tiles_to_save.empty()) {
        allegro_message("WARNING: No tiles to save in %s.", filename);
        return;
    }

    BITMAP *tile_bitmap;
    PALETTE pal;

    tile_bitmap = create_bitmap
        (
         tiles_in_row * tile_w,
         ((int)tiles_to_save.size() / tiles_in_row +
          (int)tiles_to_save.size() % tiles_in_row) * tile_h
        );
    int x = 0;
    int y = 0;

    for (j = tiles_to_save.begin(); j != tiles_to_save.end(); j++)
    {
        blit((*j)->getBitmap(), tile_bitmap, 0, 0,
                x * tile_w, y * tile_h, tile_w, tile_h);
        x++;
        if (x == tiles_in_row) {
            y++;
            x = 0;
        }
    }

    get_palette(pal);
    save_bitmap(filename, tile_bitmap, pal);

    destroy_bitmap(tile_bitmap);
}

TileType* TileRepository::getTileType(const char *tileName)
{
    std::map<const char*, TileType*, ltstr>::iterator found =
        tileTypes.find(tileName);

    if (found != tileTypes.end()) {
        return (*found).second;
    } else {
        return NULL;
    }
}

std::vector<TileType*> TileRepository::generateTileArray()
{
    std::map<const char*, TileType*, ltstr>::iterator i;
    std::vector<TileType*> tileArray;

    for (i = tileTypes.begin(); i != tileTypes.end(); i++)
    {
        tileArray.push_back((*i).second);
    }

    return tileArray;
}

// Tileset ===================================================================

Tileset::Tileset()
{
    tileWidth = tileHeight = tileSpacing = 0;
    firstgid = 0;
}

void
Tileset::importTileBitmap(BITMAP *tileImage,
                          const std::string &source,
                          int tw, int th, int ts)
{
    assert(tw > 0 && th > 0 && ts >= 0 && tileImage);

    mImgSource = source;
    int x, y, id = 0;
    tileWidth = tw;
    tileHeight = th;
    tileSpacing = ts;

    for (y = 0; y < (tileImage->h / (th + ts)); y++)
    {
        for (x = 0; x < (tileImage->w / (tw + ts)); x++)
        {
            // Create a new tile type and add it to the vector
            BITMAP *subImage = create_sub_bitmap(tileImage,
                                                 x * (tw + ts),
                                                 y * (th + ts),
                                                 tw, th);

            TileType *tileType = new TileType(subImage, NULL, id++);
            tileType->setTileset(this);
            tiles.push_back(tileType);
        }
    }
}

TileType* Tileset::getTile(int id)
{
    if (id >= 0 && (unsigned int) id < tiles.size()) {
        return tiles[id];
    } else {
        return NULL;
    }
}

// TiledMapLayer =============================================================
//  Defines a tiled layer, used by tiled maps

TiledMapLayer::TiledMapLayer()
{
    width = 0;
    height = 0;
    name = NULL;
    tileMap = NULL;
}

TiledMapLayer::~TiledMapLayer()
{
    // Delete tiles on map
    for (int y = 0; y < height; y++)
        for (int x = 0; x < width; x++)
            delete tileMap[x + y * width];

    free(tileMap);
}

void TiledMapLayer::setName(const char *newName)
{
    // Delete any previous name
    if (name) {
        delete[] name;
        name = NULL;
    }

    // Set the new name if it is not NULL
    if (newName) {
        name = new char[strlen(newName) + 1];
        strcpy(name, newName);
    }
}

const char* TiledMapLayer::getName()
{
    return name;
}

void TiledMapLayer::setOpacity(float opacity)
{
    this->opacity = opacity;
}

float TiledMapLayer::getOpacity()
{
    return opacity;
}

void TiledMapLayer::resizeTo(int w, int h, int dx, int dy)
{
    Tile** newTileMap = NULL;
    int x, y;
    int xn, yn;

    // Create new map
    newTileMap = (Tile**) malloc(w * h * sizeof(Tile*));
    ASSERT(newTileMap);
    for (y = 0; y < h; y++)
        for (x = 0; x < w; x++)
            newTileMap[x + y * w] = new Tile();

    // Copy old map data
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++)
        {
            xn = x + dx;
            yn = y + dy;

            if (xn >= 0 && yn >= 0 && xn < w && yn < h)
            {
                Tile *newTile = newTileMap[xn + yn * w];
                Tile *oldTile = tileMap[x + y * width];
                newTile->setType(oldTile->getType());
                newTile->obstacle = oldTile->obstacle;
            }
        }
    }

    // Delete tiles on old map
    for (y = 0; y < height; y++)
        for (x = 0; x < width; x++)
            delete tileMap[x + y * width];

    free(tileMap);
    tileMap = newTileMap;
    width = w;
    height = h;
}

void TiledMapLayer::saveTo(PACKFILE *file)
{
    ASSERT(file);

    // The layer header
    pack_iputw(width, file);
    pack_iputw(height, file);

    // The tile data
    for (int y = 0; y < height; y++)
        for (int x = 0; x < width; x++)
            getTile(Point(x,y))->saveTo(file);
}

void TiledMapLayer::saveTo(xmlTextWriterPtr writer)
{
    char strbuf[16];

    xmlTextWriterStartElement(writer, BAD_CAST "layer");

    snprintf(strbuf, 16, "%d", width);
    xmlTextWriterWriteAttribute(writer, BAD_CAST "width", BAD_CAST strbuf);

    snprintf(strbuf, 16, "%d", height);
    xmlTextWriterWriteAttribute(writer, BAD_CAST "height", BAD_CAST strbuf);

    for (int y = 0; y < height; y++)
        for (int x = 0; x < width; x++)
            getTile(Point(x,y))->saveTo(writer);

    xmlTextWriterEndElement(writer);
}

void TiledMapLayer::loadFrom(PACKFILE *file, TileRepository *tileRepository)
{
    ASSERT(file);

    // Load the map header
    int w = pack_igetw(file);
    int h = pack_igetw(file);
    resizeTo(w, h);

    // Load the tile data
    for (int y = 0; y < height; y++)
        for (int x = 0; x < width; x++)
            getTile(Point(x,y))->loadFrom(file, tileRepository);
}

Tile *TiledMapLayer::getTile(const Point &tile)
{
    if (tile.x < 0 || tile.x >= width || tile.y < 0 || tile.y >= height)
    {
        return NULL;
    }
    else
    {
        return tileMap[tile.x + tile.y * width];
    }
}

void
TiledMapLayer::setTile(const Point &tile, TileType *type)
{
    if (!(tile.x < 0 || tile.x >= width || tile.y < 0 || tile.y >= height)) {
        tileMap[tile.x + tile.y * width]->setType(type);
    }
}


// TiledMap class ============================================================
//  Defines a generic tiled map interface and data model.

TiledMap::TiledMap():
    width(0), height(0)
{
    mapLayers.push_back(new TiledMapLayer());
    mapLayers.push_back(new TiledMapLayer());
}

TiledMap::~TiledMap()
{
    deleteLayers();
}

void TiledMap::deleteLayers()
{
    for (unsigned int i = 0; i < mapLayers.size(); i++) {
        if (mapLayers[i]) {
            delete mapLayers[i];
        }
    }
    mapLayers.clear();
}

void TiledMap::setCamera(Point cam, Rectangle rect, bool center, bool modify)
{
    if (center) {
        cam.x -= rect.w / 2;
        cam.y -= rect.h / 2;
    }
    if (modify) {
        Point mapSize = getMapSize();
        cam.x = clamp(cam.x, 0, mapSize.x - rect.w);
        cam.y = clamp(cam.y, 0, mapSize.y - rect.h);
    }

    cameraCoords = cam;
    cameraScreenRect = rect;
}

void TiledMap::resizeTo(int w, int h, int dx, int dy)
{
    for (unsigned int i = 0; i < mapLayers.size(); i++)
    {
        mapLayers[i]->resizeTo(w, h, dx, dy);
    }
    width = w;
    height = h;
}

void TiledMap::saveTo(PACKFILE *file)
{
    ASSERT(file);

    // Version info
    // Version 1: No version number stored, one layer in map
    // Version 2: First int is version number, second one the number of layers
    // Version 3: Object list stored at end of tile data.
    pack_iputw(3, file);
    // The map header
    pack_iputw(mapLayers.size(), file);

    // The tile data
    for (unsigned int i = 0; i < mapLayers.size(); i++) {
        mapLayers[i]->saveTo(file);
    }

    // Object data
    std::list<Object*>::iterator i;
    pack_iputw(objects.size(), file);
    for (i = objects.begin(); i != objects.end(); i++) {
        pack_iputw(int(TILES_W * (*i)->x), file);
        pack_iputw(int(TILES_H * (*i)->y), file);
        pack_fputs((*i)->className, file);
        pack_fputs("\n", file);
    }

    // Extra newline fixes last tile not loaded.
    pack_fputs("\n", file);
}

void TiledMap::saveTo(xmlTextWriterPtr writer)
{
    char strbuf[16];

    xmlTextWriterStartElement(writer, BAD_CAST "map");
    xmlTextWriterWriteAttribute(writer, BAD_CAST "version", BAD_CAST "4.0");

    // Tile data
    for (unsigned int i = 0; i < mapLayers.size(); i++) {
        mapLayers[i]->saveTo(writer);
    }

    // Object data
    std::list<Object*>::iterator i;
    for (i = objects.begin(); i != objects.end(); i++)
    {
        xmlTextWriterStartElement(writer, BAD_CAST "object");

        snprintf(strbuf, 16, "%d", int(TILES_W * (*i)->x));
        xmlTextWriterWriteAttribute(writer, BAD_CAST "x", BAD_CAST strbuf);

        snprintf(strbuf, 16, "%d", int(TILES_H * (*i)->y));
        xmlTextWriterWriteAttribute(writer, BAD_CAST "y", BAD_CAST strbuf);

        snprintf(strbuf, 64, "%d", int(TILES_W * (*i)->x));
        xmlTextWriterWriteAttribute(writer, BAD_CAST "type",
                BAD_CAST (*i)->className);

        xmlTextWriterEndElement(writer);
    }

    xmlTextWriterEndElement(writer);
}

int TiledMap::loadMap(const char* filename)
{
    console.log(CON_LOG, CON_VDEBUG, "- Attempting to parse XML map data");

    console.log(CON_LOG, CON_VDEBUG, "- Attempting to load packfile map");
    PACKFILE *file = pack_fopen(filename, F_READ_PACKED);

    if (!file) {
        console.log(CON_LOG, CON_ALWAYS,
                "Warning, no such file (%s)!", filename);
        return 1;
    }

    console.log(CON_LOG, CON_VDEBUG, "- Loading map from packfile");
    this->loadFrom(file, tileRepository);
    pack_fclose(file);

    return 0;
}

void TiledMap::loadFrom(PACKFILE *file, TileRepository *tileRepository)
{
    ASSERT(file);

    // Remove the objects from the map
    removeObjects();

    // Load the map header
    int version = pack_igetw(file);
    int layers = pack_igetw(file);

    // Load the tile data
    //allegro_message("Loading %d layers from map version %d", layers, version);
    for (int i = 0; i < layers; i++) {
        mapLayers[i]->loadFrom(file, tileRepository);
    }

    // Load object data
    if (version == 3) {
        int nrObjects = pack_igetw(file);

        for (int i = 0; i < nrObjects; i++) {
            int x = pack_igetw(file); //int(TILES_W * (*i)->x), file);
            int y = pack_igetw(file); //pack_iputw(int(TILES_H * (*i)->y),file);
            char *className = new char[64];
            pack_fgets(className, 64, file);

            // Spawn the object
            addObject(
                    double(x) / TILES_W,
                    double(y) / TILES_H,
                    className);

            delete[] className;
        }
    }

    width = mapLayers[0]->getWidth();
    height = mapLayers[0]->getHeight();
}

TiledMapLayer *TiledMap::getLayer(unsigned int i)
{
    if (i < 0 || i >= mapLayers.size()) {
        return NULL;
    }
    else {
        return mapLayers[i];
    }
}

TiledMapLayer*
TiledMap::getLayer(const char *name)
{
    for (unsigned int i = 0; i < mapLayers.size(); i++) {
        if (mapLayers[i] && strcmp(mapLayers[i]->getName(), name) == 0) {
            return mapLayers[i];
        }
    }
    return NULL;
}

Object* TiledMap::addObject(double x, double y, const char* type)
{
    int objectInstance = 0;
    char *className = new char[strlen(type) + 1];
    strcpy(className, type);
    console.log(CON_LOG, CON_VDEBUG, "Adding object of type \"%s\"...", type);

    lua_pushstring(L, type);
    lua_gettable(L, LUA_GLOBALSINDEX);
    if (!lua_isnil(L, -1)) {
        lua_call(L, putLuaArguments(L, "m", this), 1);
        if (lua_istable(L, -1)) {
            objectInstance = lua_ref(L, -1);
        } else {
            console.log(CON_QUIT, CON_ALWAYS,
                    "Error while instaniating \"%s\"", className);
        }
    } else {
        console.log(CON_QUIT, CON_ALWAYS,
                "Error: could not find class \"%s\"", className);
    }

    lua_getref(L, objectInstance);
    lua_pushstring(L, "_pointer");
    lua_gettable(L, -2);
    Object* obj = (Object*)lua_touserdata(L, -1);
    obj->x = x;
    obj->y = y;
    // Assign class name (maybe not the best place for this)
    obj->className = className;
    lua_pop(L, 1);

    return obj;
}

void TiledMap::removeReference(Object* obj)
{
    if (obj) objects.remove(obj);
}

void TiledMap::addReference(Object* obj)
{
    if (obj) objects.push_back(obj);
}

Object* TiledMap::registerObject(int tableRef)
{
    console.log(CON_LOG, CON_VDEBUG, "Registering object.");
    Object* newObject = new Object(tableRef, this);

    objects.push_back(newObject);
    newObject->initialize();

    return newObject;
}

void TiledMap::removeObjects()
{
    // Delete the objects
    std::list<Object*>::iterator i;
    while (!objects.empty()) {
        i = objects.begin();
        delete (*i);
        objects.erase(i);
    }
}


Tileset* TiledMap::getTileset(const char* name) const
{
    std::list<Tileset*>::const_iterator i;
    for (i = tilesets.begin(); i != tilesets.end(); i++) {
        if (!strcmp(name, (*i)->getName().c_str())) {
            return (*i);
        }
    }
    return NULL;
}

TileType* TiledMap::getTile(int gid) const
{
    std::list<Tileset*>::const_reverse_iterator i;
    for (i = tilesets.rbegin(); i != tilesets.rend(); i++)
    {
        if ((*i)->getFirstGid() <= gid)
        {
             return (*i)->getTile(gid - (*i)->getFirstGid());
        }
    }
    return NULL;
}

void TiledMap::drawEntities(BITMAP *dest)
{
    std::list<EntityP> visibleEnts;
    std::list<Object*>::iterator i;
    std::list<EntityP>::iterator j;

    for (i = objects.begin(); i != objects.end(); i++)
    {
        if (!(*i)->in_air && (*i)->visible(dest, mapToScreen((*i)->pos)))
        {
            visibleEnts.push_back(EntityP((*i)));
        }
    }

    // Sort the visible entities on y value.
    visibleEnts.sort();

    for (j = visibleEnts.begin(); j != visibleEnts.end(); j++) {
        (*j).ent->draw(dest, mapToScreen((*j).ent->pos));
    }

    if (debug_mode) {
        textprintf_ex(
                dest, font,
                cameraScreenRect.x + 10, cameraScreenRect.y + 10,
                makecol(200,200,200), -1, "%d entities",
                objects.size());
        textprintf_ex(
                dest, font,
                cameraScreenRect.x + 10, cameraScreenRect.y + 20,
                makecol(200,200,200), -1, "%d drawn entities",
                visibleEnts.size());
    }
}

void TiledMap::drawAirborneEntities(BITMAP *dest)
{
    std::list<EntityP> visibleEnts;
    std::list<Object*>::iterator i;
    std::list<EntityP>::iterator j;

    for (i = objects.begin(); i != objects.end(); i++)
    {
        if ((*i)->in_air && (*i)->visible(dest, mapToScreen((*i)->pos)))
        {
            visibleEnts.push_back(EntityP((*i)));
        }
    }

    // Sort the visible entities on y value.
    visibleEnts.sort();

    for (j = visibleEnts.begin(); j != visibleEnts.end(); j++) {
        (*j).ent->draw(dest, mapToScreen((*j).ent->pos));
    }

    if (debug_mode) {
        textprintf_ex(
                dest, font,
                cameraScreenRect.x + 10, cameraScreenRect.y + 30,
                makecol(200,200,200), -1, "%d drawn sky entities",
                visibleEnts.size());
    }
}

void TiledMap::updateObjects()
{
    std::list<Object*>::iterator i;

    // Destroy all objects at the beginning of the object map
    // that should be destroyed
    while (!objects.empty() && (*objects.begin())->_destroy)
    {
        i = objects.begin();

        delete (*i);
        objects.erase(i);
    }

    // Iterate through all objects, destroying the dead and updating the others.
    for (i = objects.begin(); i != objects.end(); i++)
    {
        if ((*i)->_destroy) {
            std::list<Object*>::iterator i2 = i;

            // We can safely iterate one back because the first object never
            // needs to be destroyed.
            i--;

            delete (*i2);
            objects.erase(i2);
        }
        else {
            (*i)->update();
        }
    }
}


Point TiledMap::screenToTile(Point screenCoords)
{
    return mapToTile(screenToMap(screenCoords));
}

Point TiledMap::tileToScreen(Point tileCoords)
{
    return mapToScreen(tileToMap(tileCoords));
}


// SquareMap class ===========================================================
//  Provides algorithms for simple square-tiled maps

SquareMap::SquareMap(int tileSize)
{
    this->tileWidth = tileSize;
    this->tileHeight = tileSize;
    setCamera(
            Point(0,0),
            Rectangle(0, 0, buffer->w, buffer->h),
            false, false
            );
}

SquareMap::SquareMap(int tileWidth, int tileHeight)
{
    this->tileWidth = tileWidth;
    this->tileHeight = tileHeight;
    setCamera(
            Point(0,0),
            Rectangle(0, 0, buffer->w, buffer->h),
            false, false
            );
}

void SquareMap::draw(BITMAP *dest, bool drawObstacle)
{
    Rectangle oldClip;
    oldClip.clipToRect(dest);
    cameraScreenRect.rectToClip(dest);

    if (mapLayers.size() > 0 && mapLayers[0]) {
        drawLayer(dest, drawObstacle, mapLayers[0]);
    }
    drawEntities(dest);
    if (mapLayers.size() > 1 && mapLayers[1]) {
        drawLayer(dest, drawObstacle, mapLayers[1]);
    }
    drawAirborneEntities(dest);

    oldClip.rectToClip(dest);
}

void SquareMap::drawLayer(
        BITMAP *dest, bool drawObstacle,
        TiledMapLayer *layer, int opacity)
{
    Rectangle oldClip;
    TileType *tempTileType;
    Tile* tempTile;

    oldClip.clipToRect(dest);
    cameraScreenRect.rectToClip(dest);

    // Calculate the part of the map that needs to be drawn (visible part)
    Point start = screenToTile(Point(cameraScreenRect.x, cameraScreenRect.y));
    Point end = screenToTile(Point(cameraScreenRect.x + cameraScreenRect.w - 1,
               cameraScreenRect.y + cameraScreenRect.h - 1));

    start.x = clamp(start.x, 0, width - 1);
    start.y = clamp(start.y, 0, height - 1);


    for (int y = start.y; y <= end.y; y++)
    {
        for (int x = start.x; x <= end.x; x++)
        {
            tempTile = layer->getTile(Point(x, y));
            if (!tempTile) continue;
            tempTileType = tempTile->getType();
            if (tempTileType) {
                if (opacity < 255) {
                    set_trans_blender(0, 0, 0, opacity);
                    drawing_mode(DRAW_MODE_TRANS, NULL, 0, 0);
                    draw_trans_sprite(
                            dest,
                            tempTileType->getBitmap(),
                            cameraScreenRect.x - cameraCoords.x + x * tileWidth,
                            cameraScreenRect.y - cameraCoords.y + y * tileHeight
                            );
                    drawing_mode(DRAW_MODE_SOLID, NULL, 0, 0);
                }
                else {
                    draw_sprite(
                            dest,
                            tempTileType->getBitmap(),
                            cameraScreenRect.x - cameraCoords.x + x * tileWidth,
                            cameraScreenRect.y - cameraCoords.y + y * tileHeight
                            );
                }
            }
            if (drawObstacle) {
                int tx = cameraScreenRect.x - cameraCoords.x + x * tileWidth;
                int ty = cameraScreenRect.y - cameraCoords.y + y * tileHeight;
                int tw = tileWidth;
                int th = tileHeight;
                int to = tempTile->obstacle;

                set_trans_blender(0, 0, 0, 100);
                drawing_mode(DRAW_MODE_TRANS, NULL, 0, 0);
                if (to & OB_TOP) {
                    line(dest, tx + 2, ty + 2, tx + tw - 3, ty + 2,
                            makecol(255,0,0));
                    line(dest, tx + 3, ty + 3, tx + tw - 2, ty + 3,
                            makecol(0,0,0));
                }
                if (to & OB_LEFT) {
                    line(dest, tx + 2, ty + 2, tx + 2, ty + th - 3,
                            makecol(255,0,0));
                    line(dest, tx + 3, ty + 3, tx + 3, ty + th - 2,
                            makecol(0,0,0));
                }
                if (to & OB_RIGHT) {
                    line(dest, tx + tw - 3, ty + 2, tx + tw - 3, ty + th - 3,
                            makecol(255,0,0));
                    line(dest, tx + tw - 2, ty + 3, tx + tw - 2, ty + th - 2,
                            makecol(0,0,0));
                }
                if (to & OB_BOTTOM) {
                    line(dest, tx + 2, ty + th - 3, tx + tw - 3, ty + th - 3,
                            makecol(255,0,0));
                    line(dest, tx + 3, ty + th - 2, tx + tw - 2, ty + th - 2,
                            makecol(0,0,0));
                }
                drawing_mode(DRAW_MODE_SOLID, NULL, 0, 0);
            }
        }
    }

    oldClip.rectToClip(dest);
}

Point SquareMap::screenToMap(Point screenCoords)
{
    return Point(
            cameraCoords.x - cameraScreenRect.x + screenCoords.x,
            cameraCoords.y - cameraScreenRect.y + screenCoords.y,
            screenCoords.z
            );
}

Point SquareMap::mapToScreen(Point mapCoords)
{
    return Point(
            cameraScreenRect.x - cameraCoords.x + mapCoords.x,
            cameraScreenRect.y - cameraCoords.y + mapCoords.y,
            mapCoords.z
            );
}

Point SquareMap::mapToTile(Point mapCoords)
{
    return Point(clamp(mapCoords.x / tileWidth, 0, width - 1),
                 clamp(mapCoords.y / tileHeight, 0, height - 1),
                 mapCoords.z);
}

Point SquareMap::tileToMap(Point tileCoords)
{
    return Point(
            (tileCoords.x + 1) * tileWidth - tileWidth / 2,
            (tileCoords.y + 1) * tileHeight,
            tileCoords.z
            );
}

Point SquareMap::getMapSize()
{
    return Point(
            tileWidth  * width,
            tileHeight * height
            );
}


// IsometricMap class ========================================================
//  Provides algorithms for isometric-tiled maps

IsometricMap::IsometricMap(int tileStepX, int tileStepY)
{
    this->tileGridSize = tileStepX;
    this->tileStepX = tileStepX;
    this->tileStepY = tileStepY;
}

void IsometricMap::draw(BITMAP *dest, bool drawObstacle)
{
    /*
    if (tileMap == NULL) return;

    Rectangle oldClip;
    TileType *tempTileType;
    Point temp, temp2, area;

    oldClip.clipToRect(dest);
    cameraScreenRect.rectToClip(dest);

    temp = screenToTile(Point(cameraScreenRect.x, cameraScreenRect.y));
    area = Point(
            cameraScreenRect.w / (tileStepX * 2) + 3,
            cameraScreenRect.h / tileStepY + 3);

    // Move up one row
    temp.x--;

    for (int y = 0; y < area.y; y++) {
        // Initialize temp2 to draw a horizontal line of tiles
        temp2 = temp;

        for (int x = 0; x < area.x; x++) {
            // Check if we are drawing a valid tile
            tempTileType = getTile(temp2);

            // Draw the tile if valid
            if (tempTileType) {
                draw_sprite(
                        dest,
                        tempTileType->getBitmap(),
                        cameraScreenRect.x - cameraCoords.x + (temp2.x -
                            temp2.y - 1) * tileStepX + height * tileStepX,
                        cameraScreenRect.y - cameraCoords.y + (temp2.x +
                            temp2.y) * tileStepY
                        );
            }

            // Advance to the next tile (to the right)
            temp2.x++; temp2.y--;
        }

        // Advance to the next row
        if ((y & 1) > 0) temp.x++; else temp.y++;
    }

    // Draw a red line along the edges of the map
    Point top    = mapToScreen(Point(-1, 0));
    Point right  = mapToScreen(Point(tileGridSize * width, 0));
    Point bottom = mapToScreen(Point(tileGridSize * width,
                tileGridSize * height + 1));
    Point left   = mapToScreen(Point(-1, tileGridSize * height + 1));
    line(dest, top.x,    top.y,    right.x,  right.y,  makecol(255,0,0));
    line(dest, right.x,  right.y,  bottom.x, bottom.y, makecol(255,0,0));
    line(dest, bottom.x, bottom.y, left.x,   left.y,   makecol(255,0,0));
    line(dest, left.x,   left.y,   top.x,    top.y,    makecol(255,0,0));

    // Now draw the entities
    drawEntities(dest);

    oldClip.rectToClip(dest);
    */
}

void IsometricMap::drawLayer(
        BITMAP *dest, bool drawObstacle,
        TiledMapLayer *layer, int opacity)
{
}

Point IsometricMap::screenToMap(Point screenCoords)
{
    screenCoords.x = screenCoords.x + cameraCoords.x - cameraScreenRect.x -
        height * tileStepX;
    screenCoords.y = screenCoords.y + cameraCoords.y - cameraScreenRect.y;
    return Point(
            screenCoords.y + screenCoords.x / 2,
            screenCoords.y - screenCoords.x / 2,
            screenCoords.z
            );
}

Point IsometricMap::mapToScreen(Point mapCoords)
{
    return Point(
            cameraScreenRect.x - cameraCoords.x + (mapCoords.x - mapCoords.y) +
            height * tileStepX,
            cameraScreenRect.y - cameraCoords.y + (mapCoords.x + mapCoords.y) /
            2,
            mapCoords.z
            );
}

Point IsometricMap::mapToTile(Point mapCoords)
{
    return Point(
            (mapCoords.x < 0) ?
            mapCoords.x / tileGridSize - 1 : mapCoords.x / tileGridSize,
            (mapCoords.y < 0) ?
            mapCoords.y / tileGridSize - 1 : mapCoords.y / tileGridSize,
            mapCoords.z
            );
}

Point IsometricMap::tileToMap(Point tileCoords)
{
    return Point(
            (tileCoords.x + 1) * tileGridSize,
            (tileCoords.y + 1) * tileGridSize,
            tileCoords.z
            );
}

Point IsometricMap::getMapSize()
{
    return Point(
            tileStepX * (width + height),
            tileStepY * (width + height)
            );
}
