/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

// Stuff to think about:
// - Unload all data loaded from disk, and unload datafile in destructor?
//   * How to identify if stuff is loaded from disk or datafile?
// - Maybe unify findBitmap, findMidi, etc. functions into findResource?

#include <allegro.h>
#include <string.h>
#include <dirent.h>
#include "../common.h"
#include "module.h"
#include "../script.h"
#include "engine.h"


Module::Module(const char *name)
{
    // Remember the path to be able to load from files later
    path = new char[strlen(name) + 1];
    strcpy(path, name);
    
    // Open the datafile
    char *filename = new char[strlen(name) + 1 + 4];
    strcpy(filename, name);
    strcat(filename, ".dat");
    datafile = load_datafile(filename);
    delete[] filename;
}

Module::~Module()
{
    delete[] path;
}

void Module::loadScript(const char *name)
{
    // Create the indent
    char *spaces = new char[loadLevel + 1];
    int i;
    for (i = 0; i < loadLevel; i++) spaces[i] = ' ';
    spaces[loadLevel] = '\0';

    char *script = findScript(name);
    if (script) {
        if (loadedScripts.find(script) == loadedScripts.end()) {
            loadedScripts.insert(script);
            console.log(CON_LOG, CON_ALWAYS, "%s> \"%s\"", spaces, name);
            if (luaL_loadbuffer(L, script, strlen(script), name))
            {
                lua_error(L);
            }
            loadLevel++;
            lua_call(L, 0, 0); // call main
            loadLevel--;
        }
    }
    else {
        console.log(CON_LOG, CON_ALWAYS, "%sX \"%s\" not found!", spaces, name);
    }
    
    delete[] spaces;
}

void Module::loadScripts()
{
    console.log(CON_LOG, CON_ALWAYS, "Loading scripts from \"%s\"...", path);

    int i;
    char *dirname = makeFilename("", "/scripts");
    DIR *dir;

    dir = opendir(dirname);
    if (dir) {
        // Read the scripts from the file system
        struct dirent *direntry;
        while ((direntry = readdir(dir)) != NULL) {
            if (strstr(direntry->d_name, ".lua")) {
                loadLevel = 0;
                loadScript(direntry->d_name);
            }
        }
        closedir(dir);
    }
    else {
        // Read the scripts from the datafile
        const char *name;
        for (i = 0; datafile[i].type != DAT_END; i++) {
            name = get_datafile_property(datafile + i, DAT_NAME);
            if (datafile[i].type == DAT_LUA) {
                loadLevel = 0;
                loadScript(name);
            }
        }
    }

    delete[] dirname;
}

TiledMap* Module::loadMap(const char *name)
{
    console.log(CON_LOG, CON_ALWAYS, "Loading map \"%s\"...", name);
    TiledMap *mmap = NULL;
    char *filename = makeFilename(name, "/maps");

    if (exists(filename)) {
        mmap = new SquareMap(TILES_W, TILES_H);
        mmap->loadMap(filename);
    }
    else if (datafile) {
        DATAFILE *df = find_datafile_object(datafile, name);
        if (df) {
            //char *mapstring = new char[df->size + 1];
            //memcpy(mapstring, df->dat, df->size);
            //mapstring[df->size] = '\0';

            xmlDocPtr doc = xmlReadMemory((char*)df->dat, df->size,
                    NULL, NULL, 0);
            if (doc) {
                xmlNodePtr cur = xmlDocGetRootElement(doc);
                mmap = new SquareMap(TILES_W, TILES_H);
                mmap->loadFrom(cur, tileRepository);
                xmlFreeDoc(doc);
            }
        }
    }

    //if (mmap) {
    //    maps.push_front(mmap);
    //}

    delete[] filename;
    return mmap;
}

BITMAP* Module::findBitmap(const char *name)
{
    BITMAP *bitmap = NULL;
    map<const char*, BITMAP*, ltstr>::iterator i = bitmaps.find(name);

    if (i != bitmaps.end()) {
        bitmap = (*i).second;
    }
    else {
        char *filename = makeFilename(name, "/bitmaps");
    
        // Attempt to load from disk, and otherwise from the datafile
        if (exists(filename)) {
            bitmap = load_bitmap(filename, NULL);
            console.log(CON_LOG, CON_DEBUG, "From disk: \"%s\"", name);
        }
        else if (datafile) {
            DATAFILE *df = find_datafile_object(datafile, name);
            if (df) bitmap = (BITMAP*)df->dat;
            console.log(CON_LOG, CON_DEBUG, "From datafile: \"%s\"", name);
        }
    
        if (bitmap) bitmaps[name] = bitmap;
        delete[] filename;
    }
    
    return bitmap;
}

MIDI* Module::findMidi(const char *name)
{
    MIDI *midi = NULL;
    map<const char*, MIDI*, ltstr>::iterator i = midis.find(name);

    if (i != midis.end()) {
        midi = (*i).second;
    }
    else {
        char *filename = makeFilename(name, "/music");
    
        // Attempt to load from disk, and otherwise from the datafile
        if (exists(filename)) {
            midi = load_midi(filename);
        }
        else if (datafile) {
            DATAFILE *df = find_datafile_object(datafile, name);
            if (df) midi = (MIDI*)df->dat;
        }
    
        if (midi) midis[name] = midi;
        delete[] filename;
    }
    
    return midi;
}

SAMPLE* Module::findSample(const char *name)
{
    SAMPLE *sample = NULL;
    map<const char*, SAMPLE*, ltstr>::iterator i = samples.find(name);

    if (i != samples.end()) {
        sample = (*i).second;
    }
    else {
        char *filename = makeFilename(name, "/samples");
    
        // Attempt to load from disk, and otherwise from the datafile
        if (exists(filename)) {
            sample = load_sample(filename);
        }
        else if (datafile) {
            DATAFILE *df = find_datafile_object(datafile, name);
            if (df) sample = (SAMPLE*)df->dat;
        }
    
        if (sample) samples[name] = sample;
        delete[] filename;
    }
    
    return sample;
}

FONT* Module::findFont(const char *name)
{
    FONT *font = NULL;
    map<const char*, FONT*, ltstr>::iterator i = fonts.find(name);

    if (i != fonts.end()) {
        font = (*i).second;
    }
    else {
        // Allegro can only load fonts from a datafile
        if (datafile) {
            DATAFILE *df = find_datafile_object(datafile, name);
            if (df) font = (FONT*)df->dat;
        }
    
        if (font) fonts[name] = font;
    }
    
    return font;
}

char* Module::findScript(const char *name)
{
    char *script = NULL;
    map<const char*, char*, ltstr>::iterator i = scripts.find(name);

    if (i != scripts.end()) {
        script = (*i).second;
    }
    else {
        char *filename = makeFilename(name, "/scripts");

        if (exists(filename)) {
            FILE* f = fopen(filename, "rb");

            // Get size of file
            fseek(f, 0, SEEK_END);
            long size = ftell(f);
            rewind(f);
            
            // Read file into character array
            script = new char[size + 1];
            fread(script, 1, size, f);
            script[size] = '\0';
            fclose(f);
        }
        else if (datafile) {
            DATAFILE *df = find_datafile_object(datafile, name);
            if (df) {
                script = new char[df->size + 1];
                memcpy(script, df->dat, df->size);
                script[df->size] = '\0';
            }
        }

        if (script) scripts[name] = script;
        delete[] filename;
    }
    
    return script;
}

char* Module::makeFilename(const char *name, const char *subdir)
{
    int length = strlen(path) + strlen(subdir) + strlen(name) + 2;
    char *filename = new char[length];
    strcpy(filename, path);
    strcat(filename, subdir);
    strcat(filename, "/");
    strcat(filename, name);
    return filename;
}
