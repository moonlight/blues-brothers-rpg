/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#ifndef _INCLUDED_MODULE_H_
#define _INCLUDED_MODULE_H_

#include <allegro.h>
#include <map>
#include <set>
#include "tiled_map.h"

using std::map;
using std::set;


class Module
{
    public:
        Module(const char *name);
        ~Module();

        void loadScript(const char *name);
        void loadScripts();
        TiledMap* loadMap(const char *name);

        BITMAP* findBitmap(const char *name);
        MIDI* findMidi(const char *name);
        SAMPLE* findSample(const char *name);
        FONT* findFont(const char *name);
        char* findScript(const char *name);

    private:
        char* makeFilename(const char *name, const char *subdir);
        
        DATAFILE *datafile;
        char *path;
        int loadLevel;
        
        map<const char*, BITMAP*, ltstr> bitmaps;
        map<const char*, MIDI*, ltstr> midis;
        map<const char*, SAMPLE*, ltstr> samples;
        map<const char*, FONT*, ltstr> fonts;
        map<const char*, char*, ltstr> scripts;
        set<const char*> loadedScripts;
};


#endif
