SOURCES=convhew.c \
        objectd.c \
        realloc_n.c




OBJECTS=$(SOURCES:.c=.o)

#CFLAGS = -g -Xa -xsb

CFLAGS = -g -ansi -Wall -I../../include -Wno-unknown-pragmas -D${SYSTEM}

LIBS = -lm


.KEEP_STATE:

all: convhew



convhew: $(OBJECTS)
	$(CC) $(CFLAGS) -o ../bin/$@ $(OBJECTS) $(LIBS)

