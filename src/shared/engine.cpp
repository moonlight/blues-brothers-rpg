/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#include <allegro.h>
#include <time.h>
#include <list>
#include "../console.h"
#include "../tiled_map.h"
#include "engine.h"
#include "../script.h"
#include "../common.h"

using namespace std;

list<Map*> maps;

bool exclusive_mode = false;


//===================   Object   =====================================================

int Object::id_counter = 0;

Object::Object(int luaTableRef, Map* myMap):
	_destroy(0),
	walking(0), speed(0), dir(0), prev_dir(0),
	count(0), tick(0),
	bitmap(NULL),
	x(0), y(0), px(0), py(0), nx(0), ny(0), w(1), h(1), obstacle(0),
	offset_x(0), offset_y(0), offset_z(0),
	tableRef(luaTableRef), entity(NULL),
	map(myMap)
{
	id = ++id_counter;

	if (map) {
		// Create my entity and put it on the map
		entity = new Entity();
		entity->pos = map->map->tileToMap(Point(int(x),int(y)));
		map->map->addEntity(entity);
	}

	// Set the metatable and _pointer value of my table in Lua
	lua_getref(L, tableRef);
	lua_getglobal(L, "ObjectMetatable");
	lua_setmetatable(L, -2);
	lua_pushstring(L, "_pointer" );
	lua_pushlightuserdata(L, this);
	lua_rawset(L, -3);
	lua_pop(L, 1);
}



Object::~Object()
{
	if (tableRef != 0) {
		// Notify the object that it is being destroyed
		callMemberFunction(tableRef, "destroyed");

		// Set the reference to the C++ object to NULL in the Lua table
		lua_getref(L, tableRef);         // 1
		lua_pushstring(L, "_pointer");   // 2
		lua_pushlightuserdata(L, NULL);  // 3
		lua_rawset(L, -3);               // 1
		lua_pop(L, 1);                   // 0

		// Allow Lua to garbage collect the object.
		lua_unref(L, tableRef);
	}

	if (entity != NULL && map != NULL) {
		// Remove the entity from the map and delete it.
		map->map->removeEntity(entity);
	}
	if (entity != NULL) {
		delete entity;
		entity = NULL;
	}
	if (map != NULL) {
		map->removeReference(this);
		map = NULL;
	}
}

void Object::walk(int dir, bool col)
{
	if (!map || dir == DIR_NONE) return;

	if (walking == 0)
	{
		set_dir(dir);
		update_entity();

		// Precalculate where the player is going
		double next_x = x, next_y = y;
		switch (dir) {
		case DIR_UP:    next_y -= 1.0; break;
		case DIR_DOWN:  next_y += 1.0; break;
		case DIR_LEFT:  next_x -= 1.0; break;
		case DIR_RIGHT: next_x += 1.0; break;
		}

		if (col) {
			// Check for map obstacle
			Tile *nextTile = map->map->getLayer(0)->getTile(Point((int)next_x, (int)next_y));
			if (!nextTile || next_x < 0 || next_y < 0 ||
				(dir == DIR_UP    && (nextTile->obstacle & OB_BOTTOM)) ||
				(dir == DIR_DOWN  && (nextTile->obstacle & OB_TOP)) ||
				(dir == DIR_LEFT  && (nextTile->obstacle & OB_RIGHT)) ||
				(dir == DIR_RIGHT && (nextTile->obstacle & OB_LEFT)))
			{
				callMemberFunction(tableRef, "event_bump_into");
				check_stand_on();
				return;
			}

			// Check for object in the way
			list<Object*>::iterator i;
			for (i = map->objects.begin(); i != map->objects.end(); i++) {
				Object *obj = (*i);
				if ((obstacle) &&
					(obj->obstacle) &&
					(((obj->x + obj->w > next_x && obj->x  <= next_x) &&
					(obj->y   - obj->h < next_y && obj->y  >= next_y)) ||
					((obj->nx + obj->w > next_x && obj->nx <= next_x) && obj->walking > 0 &&
					(obj->ny  - obj->h < next_y && obj->ny >= next_y))))
				{
					callMemberFunction(tableRef, "event_bump_into", "o", obj);
					callMemberFunction(obj->tableRef, "event_bumped_into", "o", this);
					check_stand_on();
					return;
				}
			}
		}

		// No obstacles, so start walking
		walking = 100;
		px = x;
		py = y;
		nx = next_x;
		ny = next_y;
		callMemberFunction(tableRef, "event_walk_start");
	}
}


void Object::set_dir(int dir)
{
	if (dir == DIR_NONE) return;

	if (this->dir != dir) {
		this->dir = dir;
		callMemberFunction(tableRef, "event_dir_change");
	}
}

void Object::check_stand_on()
{
	if (!map) return;

	// Check if this object is now standing on something
	list<Object*>::iterator i;
	for (i = map->objects.begin(); i != map->objects.end(); i++) {
		Object *obj = (*i);
		if ((obj != this) &&
			(obj->x + obj->w > x && obj->x <= x) &&
			(obj->y - obj->h < y && obj->y >= y))
		{
			callMemberFunction(tableRef, "event_standing_on", "o", obj);
			callMemberFunction(obj->tableRef, "event_stand_on", "o", this);
		}
	}
}

void Object::initialize()
{
	update_entity();
}

void Object::update()
{
	if (walking > 0) {
		walking -= speed;

		if (walking <= 0) {
			if (walking < 0) walking = 0;
			x = nx;
			y = ny;
			callMemberFunction(tableRef, "event_walk_finished");
			// Check if this object is now standing on something
			check_stand_on();
		}
		else {
			double wp = 1.0 - (walking / 100.0);
			x = px + (nx - px) * wp;
			y = py + (ny - py) * wp;
		}
	}

	if (tick > 0) {
		count++;
		if (count >= tick) {
			// Call script "tick" function
			callMemberFunction(tableRef, "tick");
			count = 0;
		}
	} else {
		count = 0;
	}

	if (dir != prev_dir) {
		prev_dir = dir;
		callMemberFunction(tableRef, "event_dir_change");
	}
}

void Object::update_entity()
{
	if (entity) {
		entity->bitmap = bitmap;

		mapPos.x = int(x * TILES_W);
		mapPos.y = int(y * TILES_H);
		mapPos.z = 0;
		mapPos.x += offset_x;
		mapPos.y += offset_y;
		mapPos.z += offset_z;

		entity->pos = mapPos;
	}
}

void Object::setMap(Map* newMap)
{
	if (entity != NULL && map != NULL) {
		map->map->removeEntity(entity);
	}
	if (map != NULL) {
		map->removeReference(this);
	}

	newMap->addReference(this);
	map = newMap;

	if (entity != NULL && map != NULL) {
		map->map->addEntity(entity);
	}
}




//===================   Engine functions   ===========================================

void update_objects()
{
	// Iterate through all maps
	for (list<Map*>::iterator i = maps.begin(); i != maps.end(); i++)
		(*i)->updateObjects();
}
