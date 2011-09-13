SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .c .o

# Common prefix 
# NOTE: This directory must exist when you start installation.
prefix = /usr/local
exec_prefix = $(prefix)
# Directory in which to put the executable
bindir = $(exec_prefix)/bin
# Directory in which to put runtime configuration
sysconfdir = $(prefix)/etc
# Directory in which to put rc.d/initd scripts
initdir = $(exec_prefix)/etc/rc.d
# Directory in which to put Lua modules
packagepath = $(prefix)/share/lua/5.1
packagecpath = $(prefix)/lib/lua/5.1

SRCDIR = src
OBJDIR = obj

# Lua 5.1 config
LUAINC = $(prefix)/include/lua51
LUALIB = $(prefix)/lib/lua51
LLIB = lua

## LuaJIT2
#LUAINC = $(prefix)/include/luajit-2.0
#LUALIB = $(prefix)/lib
#LLIB = luajit-5.1

# basic setup
CC = gcc
WARN = -Wall
INCS = -I./$(SRCDIR) -I$(prefix)/include -I$(LUAINC)
LIBS = -L$(prefix)/lib -L$(LUALIB) -lm -lpthread -lfcgi -l$(LLIB)
#DEBUG = -ggdb 
OPTS = -O2
#OPTS = -O3 -march=native
CFLAGS = $(INCS) $(WARN) $(OPTS) $(DEBUG) $G
LDFLAGS = $(LIBS) $(OPTS) $(DEBUG)

VPATH = ../$(SRCDIR)

SOURCES = main.c config.c pool.c buffer.c request.c
OBJECTS = $(SOURCES:%.c=%.o)
EXEC = luafcgid
	
all: $(SOURCES) $(EXEC)

$(EXEC): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

install: all
	install -b $(EXEC) $(bindir)
	@mkdir -p $(packagepath)
	install -b ../scripts/luafcgid.lua $(packagepath)/luafcgid.lua
	@mkdir -p $(sysconfdir)/luafcgid
	install -b ../scripts/etc/config.lua $(sysconfdir)/luafcgid/config.lua
	install -b ../scripts/etc/rc.d/luafcgid $(initdir)/luafcgid

clean:
	rm -f $(OBJECTS) $(EXEC)




