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

EDITOR_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/editor/*.cpp))
ENGINE_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/*.cpp))
LIBS := `allegro-config --libs` -llua -llualib
#LIBS := -lalleg -llua -llualib

.PHONY: default remake clean


default: $(ENGINE_EXE) $(EDITOR_EXE)
remake: clean default

clean:
	rm $(COMMON_OBJS) $(EDITOR_OBJS) $(ENGINE_OBJS)


$(ENGINE_EXE): $(COMMON_OBJS) $(ENGINE_OBJS)
	$(CC) $(CPPFLAGS) -o $(ENGINE_EXE) $(COMMON_OBJS) $(ENGINE_OBJS) $(LIBS)

$(EDITOR_EXE): $(COMMON_OBJS) $(EDITOR_OBJS)
	$(CC) $(CPPFLAGS) -o $(EDITOR_EXE) $(COMMON_OBJS) $(EDITOR_OBJS) $(LIBS)
