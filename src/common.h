/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#ifndef _INCLUDED_COMMON_H_
#define _INCLUDED_COMMON_H_

#include <allegro.h>
#include "console.h"
#include "tiled_map.h"


extern Console console;
extern BITMAP *buffer;
extern TileRepository *tileRepository;

#endif
