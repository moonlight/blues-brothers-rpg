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

#ifndef _RAGE_MAPREADER_H
#define _RAGE_MAPREADER_H

#include <string>
#include <libxml/xmlwriter.h>

class TiledMap;
class TiledMapLayer;
class Tileset;

/**
 * Map reader.
 */
class MapReader
{
    public:
        static TiledMap* readMap(const char *filename);
        static TiledMap* readMap(xmlNodePtr node, const std::string &path);

    private:
        static TiledMapLayer* readLayer(xmlNodePtr node, TiledMap *map);
        static Tileset* readTileset(xmlNodePtr node, const std::string &path);

        static int getProperty(xmlNodePtr node, const char *name, int def);
};

#endif
