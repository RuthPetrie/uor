SOURCE1=combine_ff.c \
        meantrd.c \
        read_tracks.c



OBJECT1=$(SOURCE1:.c=.o)

CFLAGS = -g -Xa -xsb

#CFLAGS = -g -ansi -Wall

LIBS = -lm


.KEEP_STATE:

all: combine



combine: $(SOURCE1)
	$(CC) -c $(CFLAGS) $(SOURCE1)
	$(CC) $(CFLAGS) -o $@ $(OBJECT1) $(LIBS)

