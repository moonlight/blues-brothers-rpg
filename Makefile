#
#  RPG makefile
#
#   run "make" to compile the RPG and RPG Edit
#   run "make remake" to recompile everything
#   run "make clean" to clean up the object files
#
CC := g++
CPPFLAGS := -Wall -O2 # -mwindows
ENGINE_EXE := rpg
EDITOR_EXE := rpgedit

COMMON_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/shared/*.cpp))
EDITOR_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/editor/*.cpp))
ENGINE_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/*.cpp))
LIBS := `allegro-config --libs` -llua -llualib
#LIBS := -lalleg -llua -llualib

.PHONY: default remake clean


default: $(ENGINE_EXE) $(EDITOR_EXE)
remake: clean default

clean:
	rm -f src/*.o src/editor/*.o src/shared/*.o


$(ENGINE_EXE): $(COMMON_OBJS) $(ENGINE_OBJS)
	$(CC)  $(CPPFLAGS)  -o $(ENGINE_EXE) $(COMMON_OBJS) $(ENGINE_OBJS) $(LIBS)

$(EDITOR_EXE): $(COMMON_OBJS) $(EDITOR_OBJS)
	$(CC)  $(CPPFLAGS)  -o $(EDITOR_EXE) $(COMMON_OBJS) $(EDITOR_OBJS) $(LIBS)
