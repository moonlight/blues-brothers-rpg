/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/


#ifndef _INCLUDED_MAP_H_
#define _INCLUDED_MAP_H_

#include "../tiled_map.h"
#include <list>

class Object;


class Map
{
public:
	Map();
	~Map();

	int loadMap(const char* mapName);
	Object* addObject(int x, int y, const char* type);
	Object* registerObject(int tableRef);

	void setMap(TiledMap* map);

	void removeReference(Object* obj);
	void addReference(Object* obj);

	void updateObjects();

	TiledMap* map;
	list<Object*> objects;
};



#endif
