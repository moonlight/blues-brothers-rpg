#
#  RPG makefile
#
#   run "make" to compile the RPG and RPG Edit
#   run "make remake" to recompile everything
#   run "make clean" to clean up the object files
#
CC := g++
CPPFLAGS := -Wall -O2 # -mwindows
EXE := rpg

OBJS := $(patsubst %.cpp, %.o, $(wildcard src/*.cpp))
LIBS := `allegro-config --libs` -llua -llualib
#LIBS := -lalleg -llua -llualib

.PHONY: default remake clean


default: $(EXE)
remake: clean default

clean:
	rm $(OBJS)


$(EXE): $(OBJS)
	$(CC)  $(CPPFLAGS)  -o $(EXE) $(OBJS) $(LIBS)

