/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#ifndef _INCLUDED_ENGINE_H_
#define _INCLUDED_ENGINE_H_

#include "tiled_map.h"
#include "script.h"
#include <list>
#include "shared/map.h"

using namespace std;

extern list<Map*> maps;

#define DIR_NONE		-1
#define DIR_UP			0
#define DIR_LEFT		1
#define DIR_RIGHT		2
#define DIR_DOWN		3

#define TILES_W			24
#define TILES_H			24



//====================================================================================

class Object
{
	static int id_counter;
	Point mapPos;						// The position on the map

public:
	int _destroy;						// Object will be destroyed during next update.
	double walking, speed;
	int dir, prev_dir;
	int count, tick;
	BITMAP* bitmap;
	double x, y, px, py, nx, ny;
	int w, h;
	int obstacle;						// Object is an obstacle to other objects.
	int offset_x, offset_y, offset_z;
	int id;
	int tableRef;						// A reference to the associated Lua table
	Entity* entity;						// A pointer to the associated map entity

	Object(int luaTableRef, Map* myMap);
	~Object();

	// Methods
	void walk(int dir, bool col);
	void set_dir(int dir);

	void initialize();
	void check_stand_on();
	void update();
	void update_entity();

	Map* getMap() {return map;}
	void setMap(Map *newMap);

private:
	Map* map;
};



//===================   Engine functions   ===========================================

void update_objects();


//===================   Script functions   ===========================================

void import_tile_bmp(const char* filename, int tiles_w, int tiles_h, int tile_spacing);

int l_get_bitmap(lua_State *L);
int l_create_sub_bitmap(lua_State *L);
int l_load_map(lua_State *L);
int l_draw_viewport(lua_State *L);

int l_quit_game(lua_State *L);

void quit_game();


//===================   Variables   ==================================================

extern bool exclusive_mode;


#endif
