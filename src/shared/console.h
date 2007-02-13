/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003, 2004  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#ifndef _INCLUDED_CONSOLE_H_
#define _INCLUDED_CONSOLE_H_

#include <stdio.h>
#include <list>
#include <allegro.h>


#define CON_CONSOLE    1
#define CON_LOG        2
#define CON_QUIT       4
#define CON_POPUP      8

#define CON_ALWAYS     1
#define CON_DEBUG      2
#define CON_VDEBUG     4

/**
 * The console. This class handles logging as well as displaying a console with
 * the log in the game when the tilde is pressed.
 */
class Console
{
    public:
        Console(const char* filename);
        ~Console();

        void update();
        void draw(BITMAP *dest);
        bool handleInput(int key);
        void log(int where, int when, const char *what, ...);

        bool enableLogfile;

    private:
        FILE* logFile;
        char* logFilename;
        std::list<char*> logMessages;
        bool active;
        int progress;
};


#endif

