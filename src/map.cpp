/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

	Bjorn: this class has got to go!
*/

#include "rpg.h"
#include "map.h"


Map::Map()
{
	map = new SquareMap(TILES_W, TILES_H);
	map->setCamera(
		Point(0,0),
		Rectangle(0, 0, buffer->w, buffer->h),
		false, false
	);
}

Map::~Map()
{
	list<Object*>::iterator i;
	while (!objects.empty())
	{
		i = objects.begin();
		delete (*i);
		objects.erase(i);
	}

	delete map;
}

int Map::loadMap(const char* mapName)
{
	char tempstr[256] = "";
	usprintf(tempstr, "%s", mapName);

	PACKFILE *file = pack_fopen(tempstr, F_READ_PACKED);
	map->loadFrom(file, tileRepository);
	pack_fclose(file);
	return 0;
}

Object* Map::addObject(int x, int y, const char* type)
{
	console.log(CON_LOG, CON_VDEBUG, "Adding object of type \"%s\"...", type);

	lua_getglobal(L, type);
	if (!lua_istable(L, -1)) {
		console.log(CON_LOG | CON_CONSOLE, CON_ALWAYS, "Error: object type \"%s\" not defined.", type);
	}
	lua_pop(L, 1);

	lua_newtable(L);
	Object* newObject = new Object(lua_ref(L, 1), this);
	newObject->x = x;
	newObject->y = y;
	
	lua_getglobal(L, "inherit");
	lua_getref(L, newObject->tableRef);
	lua_getglobal(L, type);
	if (lua_istable(L, -1)) {
		lua_call(L, 2, 0);
	}

	objects.push_back(newObject);
	newObject->initialize();

	return newObject;
}

void Map::removeReference(Object* obj)
{
	objects.remove(obj);
}

void Map::addReference(Object* obj)
{
	objects.push_back(obj);
}

Object* Map::registerObject(int tableRef)
{
	console.log(CON_LOG, CON_VDEBUG, "Registering object.");
	Object* newObject = new Object(tableRef, this);
	
	objects.push_back(newObject);
	newObject->initialize();

	return newObject;
}


void Map::updateObjects()
{
	list<Object*>::iterator i;

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
		if ((*i)->_destroy)
		{
			//console.log(CON_CONSOLE, CON_DEBUG, "Destroying object at (%d, %d)", (*i)->x, (*i)->y);
			list<Object*>::iterator i2 = i;

			// We can safely iterate one back because the first object never needs to
			// be destroyed.
			i--;

			delete (*i2);
			objects.erase(i2);
		}
		else
		{
			(*i)->update();
		}
	}
}
