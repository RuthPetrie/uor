SOURCES=diff.c \
       malloc_initl.c \
       read_stats.c \
       statdmp.c



OBJECTS=$(SOURCES:.c=.o)

#CFLAGS = -g -Xa -xsb

CFLAGS = -g -ansi -Wall -I../../include -D${SYSTEM} $(AD_C_FLAGS)

LIBS = -lm


.KEEP_STATE:

all: diff_stats



diff_stats: $(OBJECTS)
	$(CC) $(CFLAGS) -o ../bin/$@ $(OBJECTS) $(LIBS)

