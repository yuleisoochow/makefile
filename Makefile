# My basic makefile for linux apps
# Automatic loading all c files in root directory and all subdirectorys, ignore .git and .svn
#

SHELL = /bin/bash
CC = gcc

#BIN = $(shell pwd | sed "s/.*\///" ) 
BIN = my_app

CFLAGS += -O2 -Wall -Werror -Wextra -pthread -DNDEBUG

LDFLAGS += -L./




SRC_DIRECTORY := $(shell find -path "./.git" -prune -o -path "./.svn" -prune -o -type d -print)
CFLAGS += $(foreach i, $(SRC_DIRECTORY), -I$i)

SOURCE := $(foreach i, $(SRC_DIRECTORY), $(wildcard $i/*.c))

OBJS := $(patsubst ./%.c, %.o, $(SOURCE))
OBJS_NUM := $(words $(OBJS))



all: start $(BIN)


$(BIN): $(OBJS)
	@echo -e "\\e[35m[Link  $(BIN)]\\e[0m"
	$(CC) $(CFLAGS) -o $(BIN) $(OBJS) $(LDFLAGS)
	@echo -e "\\e[35m========== Build $(BIN) success ==========\\e[0m"

start:
	@echo -e "\\e[35m---------- Start build: $(BIN) ----------\\e[0m"


%.o:%.c
	@echo -e -n "\\e[36m["
	@for i in {1..$(OBJS_NUM)} ; do a=($(OBJS)); if [ $@ == $${a[$$i-1]} ]; then echo -n $$(expr $$i \* 100 / \( $(OBJS_NUM) + 0 \) );break; fi done
	@echo -e "%] build  $< \\e[0m"
	$(CC) $(CFLAGS) -o $@ -c $< 

clean:
	@echo -e "\\e[35m---------- Clean app: $(BIN) ----------\\e[0m"
	rm -f $(OBJS) $(BIN) *.o *.d *.ko
	@echo -e "\\e[35m---------- Clean $(BIN) end ----------\\e[0m"

run:
	./$(BIN)


