/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003, 2004  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#ifndef _INCLUDED_RPG_H_
#define _INCLUDED_RPG_H_

#include "shared/tiled_map.h"
#include "shared/console.h"
#include "shared/module.h"
#include <map>
#include <allegro.h>

// Some engine settings
#define PROGRAM_ID			"Moonlight RPG engine"
extern int lps;								// Game loops per second  -  sets the game speed and possible frame rate


extern volatile int frames_to_do;
extern volatile int fps, fps_counter;

extern int inkey;							// Last pressed key

extern DATAFILE *interface_graphics;
extern int gameClassInstance;

extern TileType *selectedTile;
extern list<TiledMap*> maps;

extern bool game_end;
extern bool exclusive_mode;

void init_engine();
void init_rpg();
void init_graphics();
void handle_input();
void update_screen();
void draw_screen();
void exit_program();

#endif
