#
#  RPG makefile
#
#   run "make" to compile the RPG and RPG Edit
#   run "make remake" to recompile everything
#   run "make clean" to clean up the object files
#
CC := g++
CPPFLAGS :=  -Wall -O2   -I/usr/local/include -DENABLE_SOUND
ENGINE_EXE := rpg
EDITOR_EXE := rpgedit

COMMON_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/shared/*.cpp))
EDITOR_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/editor/*.cpp))
ENGINE_OBJS := $(patsubst %.cpp, %.o, $(wildcard src/*.cpp))
COMMON_LIBS :=  -Wall -O2   -I/usr/local/include -DENABLE_SOUND -L/usr/local/lib -L/usr/X11R6/lib -Wl,-export-dynamic -lalleg-4.0.3 -lalleg_unsharable -llua -llualib
#COMMON_LIBS := -lalleg -llua -llualib
ENGINE_LIBS :=  -L/usr/local/lib -lalogg -L/usr/local/lib -L/usr/X11R6/lib -Wl,-export-dynamic -lalleg-4.0.3 -lalleg_unsharable -lvorbisfile -lvorbisenc -lvorbis -logg -lm
#ENGINE_LIBS := =lalogg -logg -lvorbis -lvorbisfile -lvorbisenc

.PHONY: default remake clean


default: $(ENGINE_EXE) $(EDITOR_EXE)
remake: clean default

clean:
	rm -f src/*.o src/editor/*.o src/shared/*.o


$(ENGINE_EXE): $(COMMON_OBJS) $(ENGINE_OBJS)
	$(CC) $(CPPFLAGS) -o $(ENGINE_EXE) $(COMMON_OBJS) $(ENGINE_OBJS) $(COMMON_LIBS) $(ENGINE_LIBS)

$(EDITOR_EXE): $(COMMON_OBJS) $(EDITOR_OBJS)
	$(CC) $(CPPFLAGS) -o $(EDITOR_EXE) $(COMMON_OBJS) $(EDITOR_OBJS) $(COMMON_LIBS)
