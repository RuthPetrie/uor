SOURCE1=sample.c \
        meantrd.c \
        read_tracks.c \
        ran3.c



OBJECT1=$(SOURCE1:.c=.o)

CFLAGS = -g -Xa -xsb

#CFLAGS = -g -ansi -Wall

LIBS = -lm


.KEEP_STATE:

all: sample



sample: $(SOURCE1)
	$(CC) -c $(CFLAGS) $(SOURCE1)
	$(CC) $(CFLAGS) -o $@ $(OBJECT1) $(LIBS)

