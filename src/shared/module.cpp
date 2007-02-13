/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003, 2004  Bjørn Lindeijer

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
#ifndef WIN32
#include <dirent.h>
#endif
#include <string>
#include "module.h"
#include "../common.h"
#include "../script.h"
#include "map_reader.h"


Module::Module(const char *name)
{
    // Remember the path to be able to load from files later
    path = new char[strlen(name) + 1];
    strcpy(path, name);

    // Open the datafile
    datafile_name = new char[strlen(name) + 1 + 4];
    sprintf(datafile_name, "%s.dat", name);

    script_data = NULL;
}

Module::~Module()
{
    delete[] path;
    delete[] datafile_name;
}

void Module::loadScript(const std::string name)
{
    // Create the indent
    char *spaces = new char[loadLevel + 1];
    int i;
    for (i = 0; i < loadLevel; i++) spaces[i] = ' ';
    spaces[loadLevel] = '\0';
    map<std::string, char*>::iterator script_i = scripts.find(name);

    if (script_i != scripts.end()) {
        console.log(CON_LOG, CON_VDEBUG, "%s# Already loaded \"%s\"",
                spaces, name.c_str());
        return;
    }

    char *script = findScript(name);
    if (script) {
        console.log(CON_LOG, CON_ALWAYS, "%s> \"%s\"", spaces, name.c_str());
        if (luaL_loadbuffer(L, script, strlen(script), name.c_str()))
        {
            lua_error(L);
        }
        loadLevel++;
        lua_call(L, 0, 0); // call main
        loadLevel--;
    }
    else {
        console.log(CON_LOG, CON_ALWAYS, "%sX \"%s\" not found!", spaces, name.c_str());
    }

    delete[] spaces;
}

void Module::loadScripts()
{
    console.log(CON_LOG, CON_ALWAYS, "Loading scripts from \"%s\"...", path);

    char *dirname = makeFilename("", "/scripts");
#ifndef WIN32
    DIR *dir;

    dir = opendir(dirname);
    if (dir) {
        // Read the scripts from the file system
        struct dirent *direntry;
        while ((direntry = readdir(dir)) != NULL) {
            char *luaExt = strstr(direntry->d_name, ".lua");
            if (luaExt != NULL && strcmp(luaExt, ".lua") == 0) {
                loadLevel = 0;
                loadScript(direntry->d_name);
            }
        }
        closedir(dir);
    }
    else {
#endif
        // Read the scripts from the datafile
        script_data = load_datafile_object(datafile_name, "data/scripts");
        if (script_data) {
            DATAFILE *temp = (DATAFILE*)script_data->dat;
            const char *name;
            while (temp->type != DAT_END) {
                if (temp->type == DAT_DATA) {
                    name = get_datafile_property(temp, DAT_NAME);
                    loadLevel = 0;
                    loadScript(name);
                }
                temp++;
            }

            // Unload the datafile
            unload_datafile_object(script_data);
            script_data = NULL;
        }
#ifndef WIN32
    }
#endif

    // Clean up any loaded scripts
    /*
    set<const char*>::iterator i;
    for (i = loadedScripts.begin(); i != loadedScripts.end(); i++) {
        delete[] (*i);
    }
    loadedScripts.clear();
    */

    delete[] dirname;
}

TiledMap* Module::loadMap(const std::string name)
{
    TiledMap *mmap = NULL;
    char *filename = makeFilename(name.c_str(), "/maps");
    console.log(CON_LOG, CON_ALWAYS, "Loading map \"%s\"...", filename);

    mmap = MapReader::readMap(filename);

    /*
    if (exists(filename)) {
        mmap = new SquareMap(TILES_W, TILES_H);
        if (mmap) {
            mmap->loadMap(filename);
        } else {
            console.log(CON_QUIT, CON_ALWAYS, "Insufficient memory for map!");
        }
    }
    else {
        DATAFILE *df = load_datafile_object(datafile_name, filename);
        if (df) {
            xmlDocPtr doc = xmlReadMemory((char*)df->dat, df->size,
                    NULL, NULL, 0);
            if (doc) {
                xmlNodePtr cur = xmlDocGetRootElement(doc);
                mmap = new SquareMap(TILES_W, TILES_H);
                mmap->loadFrom(cur, tileRepository);
                xmlFreeDoc(doc);
            }
            unload_datafile_object(df);
        }
    }
    */

    delete[] filename;
    return mmap;
}

BITMAP* Module::findBitmap(const std::string name)
{
    BITMAP *bitmap = NULL;
    map<std::string, BITMAP*>::iterator i = bitmaps.find(name);

    if (i != bitmaps.end()) {
        bitmap = (*i).second;
    }
    else {
        char *filename = makeFilename(name.c_str(), "/bitmaps");

        // Attempt to load from disk, and otherwise from the datafile
        if (exists(filename)) {
            bitmap = load_bitmap(filename, NULL);
        }
        else {
            char *magicFilename = addMagic(filename);
            bitmap = load_bitmap(magicFilename, NULL);
            delete[] magicFilename;
        }
    
        if (bitmap) bitmaps[name] = bitmap;
        delete[] filename;
    }
    
    return bitmap;
}

MIDI* Module::findMidi(const std::string name)
{
    MIDI *midi = NULL;
    map<std::string, MIDI*>::iterator i = midis.find(name);
    char *filename = makeFilename(name.c_str(), "/music");

    if (i != midis.end()) {
        midi = (*i).second;
    }
    else {
    
        // Attempt to load from disk, and otherwise from the datafile
        if (exists(filename)) {
            midi = load_midi(filename);
        }
        else {
            char *magicFilename = addMagic(filename);
            midi = load_midi(magicFilename);
            delete[] magicFilename;
        }
    
        if (midi) midis[name] = midi;
    }
    
    delete[] filename;
    return midi;
}

SAMPLE* Module::findSample(const std::string name)
{
    SAMPLE *sample = NULL;
    map<std::string, SAMPLE*>::iterator i = samples.find(name);
    char *filename = makeFilename(name.c_str(), "/samples");

    if (i != samples.end()) {
        sample = (*i).second;
    }
    else {
    
        // Attempt to load from disk, and otherwise from the datafile
        if (exists(filename)) {
            sample = load_sample(filename);
        }
        else {
            char *magicFilename = addMagic(filename);
            sample = load_sample(magicFilename);
            delete[] magicFilename;
        }
    
        if (sample) samples[name] = sample;
    }
    
    delete[] filename;
    return sample;
}

FONT* Module::findFont(const std::string name)
{
    FONT *font = NULL;
    map<std::string, FONT*>::iterator i = fonts.find(name);

    if (i != fonts.end()) {
        font = (*i).second;
    }
    else {
        // Allegro can only load fonts from a datafile
        if (engine_data) {
            DATAFILE *df = find_datafile_object(engine_data, name.c_str());
            if (df) font = (FONT*)df->dat;
        }
    
        if (font) fonts[name] = font;
    }
    
    return font;
}

char* Module::findScript(const std::string name)
{
    char *script = NULL;
    map<std::string, char*>::iterator i = scripts.find(name);
    char *filename = makeFilename(name.c_str(), "/scripts");

    if (i != scripts.end()) {
        script = (*i).second;
    }
    else {
        if (exists(filename)) {
            FILE* f = fopen(filename, "rb");

            if (!f) {
                console.log(CON_QUIT, CON_ALWAYS,
                        "Error: %s seems to exist but failed to open!",
                        filename);
            }

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
        else {
            DATAFILE *df = load_datafile_object(datafile_name, filename);
            if (df) {
                script = new char[df->size + 1];
                memcpy(script, df->dat, df->size);
                script[df->size] = '\0';
                unload_datafile_object(df);
            }
        }

        if (script) scripts[name] = script;
    }

    delete[] filename;
    return script;
}

char* Module::makeFilename(const char *name, const char *subdir)
{
    int length = strlen(path) + strlen(subdir) + strlen(name) + 2;
    char *filename = new char[length];
    sprintf(filename, "%s%s/%s", path, subdir, name);
    return filename;
}

char* Module::addMagic(const char *file)
{
    int length = strlen(path) + strlen(file) + 6;
    char *filename = new char[length];
    sprintf(filename, "%s.dat#%s", path, file);
    return filename;
}
