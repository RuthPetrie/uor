SOURCE=count.c \
       box.c \
       meantrd.c \
       read_tracks.c \
       new_time.c

OBJECT1=count.o meantrd.o read_tracks.o new_time.o

OBJECT2=box.o meantrd.o read_tracks.o new_time.o

CFLAGS = -g -Xa -xsb

#CFLAGS = -g -ansi -Wall

LIBS = -lm -lsunmath


.KEEP_STATE:

all: count box

count: $(SOURCE)
	$(CC) -c $(CFLAGS) $(SOURCE)
	$(CC) $(CFLAGS) -o $@ $(OBJECT1) $(LIBS)

box: $(OBJECT2)
	$(CC) $(CFLAGS) -o $@ $(OBJECT2) $(LIBS)


