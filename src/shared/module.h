/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003, 2004  Bjørn Lindeijer

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
#include <string>
#include "tiled_map.h"

using std::map;
using std::set;


class Module
{
    public:
        Module(const char *name);
        ~Module();

        void loadScript(const std::string name);
        void loadScripts();
        TiledMap* loadMap(const std::string name);

        BITMAP* findBitmap(const std::string name);
        MIDI* findMidi(const std::string name);
        SAMPLE* findSample(const std::string name);
        FONT* findFont(const std::string name);
        char* findScript(const std::string name);

    private:
        char* makeFilename(const char *name, const char *subdir);
        char* addMagic(const char *file);
        
        DATAFILE *script_data;
        char *path;
        char *datafile_name;
        int loadLevel;
        
        map<std::string, BITMAP*> bitmaps;
        map<std::string, MIDI*> midis;
        map<std::string, SAMPLE*> samples;
        map<std::string, FONT*> fonts;
        map<std::string, char*> scripts;
};


#endif
