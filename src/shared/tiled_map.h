/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003, 2004  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#ifndef _INCLUDED_TILEDMAP_H_
#define _INCLUDED_TILEDMAP_H_

#include <map>
#include <list>
#include <vector>
#include <allegro.h>
#include <libxml/xmlwriter.h>
#include <libxml/tree.h>

using namespace std;

class Object;


#define TILES_W                 24
#define TILES_H                 24

#define DM_INVISIBLE            0
#define DM_ADD                  1
#define DM_MASKED               2
#define DM_ALPHA                3
#define DM_TRANS                4
#define DM_MULTIPLY             5

#define OB_TOP                  1
#define OB_RIGHT                2
#define OB_BOTTOM               4
#define OB_LEFT                 8


// Point class ===============================================================

class Point {
    public:
        Point() {x = y = z = 0;}
        Point(int X, int Y, int Z = 0) {x = X; y = Y; z = Z;}
        Point(Point p, int Z) {x = p.x; y = p.y; z = Z;}
        int x, y, z;
};


// Vector class ==============================================================

struct Vector
{
    Vector();
    Vector(double x, double y, double z);
    Vector(const Vector &v);
    Vector operator*(double c);
    Vector operator/(double c);
    Vector operator+(const Vector &v);
    Vector operator-(const Vector &v);
    double x, y, z;
};


// Rectangle class ===========================================================

class Rectangle {
    public:
        Rectangle() {x = y = w = h = 0;}
        Rectangle(int x, int y, int w, int h);
        void rectToClip(BITMAP *dest);
        void clipToRect(BITMAP *src);
        bool collides(const Rectangle &r);
        int x, y, w, h;
};


// TileType ==================================================================
//  An object holding static information about a tile type.

class TileType {
    public:
        TileType(BITMAP *tileBitmap, const char *tileName);
        ~TileType();

        BITMAP* getBitmap() {return bitmap;}
        char*   getName()   {return name;}
        int     getColor()  {return color;}

    protected:
        BITMAP* bitmap;
        char*   name;
        int     color;
};


// TileRepository ============================================================
//  A tile repository to handle a collection of tile types


// Comparator used for string indexed maps

struct ltstr {
    bool operator()(const char* s1, const char* s2) const {
        return strcmp(s1, s2) < 0;
    }
};

class TileRepository {
    public:
        ~TileRepository();

        void importDatafile(DATAFILE *dataFile);
        void importBitmap(BITMAP* tileBitmap, const char* group_name,
                int tile_w, int tile_h, int tile_spacing);
        void importBitmap(const char *filename,
                int tile_w, int tile_h, int tile_spacing);
        void exportBitmap(const char *filename,
                int tile_w, int tile_h, int tile_spacing, int tiles_in_row);

        TileType* getTileType(const char *tileName);
        vector<TileType*> generateTileArray();
    protected:
        map<const char*, TileType*, ltstr> tileTypes;
};


// Tile class ================================================================

class Tile {
    public:
        Tile();

        void saveTo(PACKFILE *file);
        void saveTo(xmlTextWriterPtr writer);
        void loadFrom(PACKFILE *file, TileRepository *tileRepository);
        void loadFrom(xmlNodePtr reader, TileRepository *tileRepository);

        void setType(TileType* tileType);
        TileType* getType() {return tileType;}

        int  obstacle;
    protected:
        TileType* tileType;
};


// Entity sorting helper class ===============================================

class EntityP {
    public:
        EntityP(Object *ent) {this->ent = ent;}
        Object *ent;
        bool operator< (const EntityP& X) const;
};


// TiledMapLayer =============================================================
//  Defines a tiled layer, used by tiled maps

class TiledMapLayer {
    public:
        TiledMapLayer();
        ~TiledMapLayer();

        // Layer functions
        void resizeTo(int w, int h, int dx = 0, int dy = 0);
        void saveTo(PACKFILE* file);
        void saveTo(xmlTextWriterPtr writer);
        void loadFrom(PACKFILE* file, TileRepository *tileRepository);
        void loadFrom(xmlNodePtr reader, TileRepository *tileRepository);

        int getWidth()  { return width; }
        int getHeight() { return height; }

        void setName(const char* newName);
        void setOpacity(float opacity);
        const char* getName();
        float getOpacity();

        Tile* getTile(Point tileCoords);

    private:
        int width, height;
        char *name;
        float opacity;
        Tile** tileMap;
};


// TiledMap class ============================================================
//  Defines a generic tiled map interface and data model.


class TiledMap {
    public:
        TiledMap();
        virtual ~TiledMap();

        // Map functions
        void resizeTo(int w, int h, int dx = 0, int dy = 0);
        void saveTo(PACKFILE* file);
        void saveTo(xmlTextWriterPtr writer);
        int loadMap(const char* filename);
        void loadFrom(PACKFILE* file, TileRepository *tileRepository);
        void loadFrom(xmlNodePtr reader, TileRepository *tileRepository);

        int getWidth()  {return width;}
        int getHeight() {return height;}

        // Tile and entity methods
        //Tile* getTile(Point tileCoords);
        TiledMapLayer* getLayer(int i);

        // Drawing the map
        virtual void setCamera(Point cameraCoords, Rectangle screenRect,
                bool centerCamera = false, bool modify = true);
        virtual void draw(BITMAP *dest, bool drawObstacle) = 0;
        virtual void drawLayer(BITMAP *dest, bool drawObstacle,
                TiledMapLayer *layer, int opacity = 255) = 0;

        void drawEntities(BITMAP *dest);
        void drawAirborneEntities(BITMAP *dest);

        // Entity methods
        Object* addObject(double x, double y, const char* type);
        Object* registerObject(int tableRef);
        void updateObjects();
        void removeReference(Object* obj);
        void addReference(Object* obj);
        void removeObjects();

        // Coordinate space converters
        virtual Point screenToTile(Point screenCoords);
        virtual Point tileToScreen(Point tileCoords);
        virtual Point screenToMap(Point screenCoords) = 0;
        virtual Point mapToScreen(Point mapCoords) = 0;
        virtual Point mapToTile(Point mapCoords) = 0;
        virtual Point tileToMap(Point tileCoords) = 0;

        virtual Point getMapSize() = 0;

        // The layers
        TiledMapLayer *mapLayers[2];
        int nrLayers;

        // Entity list
        list<Object*> objects;


        int width, height;
    protected:
        // Camera properties
        Point cameraCoords;
        Rectangle cameraScreenRect;
};


// SquareMap class ===========================================================
//  Provides algorithms for square-tiled maps

class SquareMap : public TiledMap {
    public:
        SquareMap(int tileSize);
        SquareMap(int tileWidth, int tileHeight);

        // Draw the map
        virtual void draw(BITMAP *dest, bool drawObstacle = false);
        virtual void drawLayer(BITMAP *dest, bool drawObstacle,
                TiledMapLayer *layer, int opacity = 255);

        // Coordinate space converters
        virtual Point screenToMap(Point screenCoords);
        virtual Point mapToScreen(Point mapCoords);
        virtual Point mapToTile(Point mapCoords);
        virtual Point tileToMap(Point tileCoords);

        virtual Point getMapSize();

    protected:
        int tileWidth, tileHeight;
};


// IsometricMap class ========================================================
//  Provides algorithms for isometric-tiled maps

class IsometricMap : public TiledMap
{
    public:
        IsometricMap(int tileStepX, int tileStepY);

        // Draw the map
        virtual void draw(BITMAP *dest, bool drawObstacle = false);
        virtual void drawLayer(BITMAP *dest, bool drawObstacle,
                TiledMapLayer *layer, int opacity = 255);

        // Coordinate space converters
        virtual Point screenToMap(Point screenCoords);
        virtual Point mapToScreen(Point mapCoords);
        virtual Point mapToTile(Point mapCoords);
        virtual Point tileToMap(Point tileCoords);

        virtual Point getMapSize();

    protected:
        int tileGridSize;
        int tileStepX, tileStepY;
};


#endif
