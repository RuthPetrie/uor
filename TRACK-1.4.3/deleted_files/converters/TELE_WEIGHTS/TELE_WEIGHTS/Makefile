SOURCE1=create_weights.c \
	meantrd_tanh.c \
	read_tracks.c


OBJECT1=$(SOURCE1:.c=.o)

#CFLAGS = -g -Xa -xsb -I../../include

CFLAGS = -g -ansi -Wall -I../../include

LIBS = -lm


.KEEP_STATE:

all: tele_weights



tele_weights: $(SOURCE1)
	$(CC) -c $(CFLAGS) $(SOURCE1)
	$(CC) $(CFLAGS) -o $@ $(OBJECT1) $(LIBS)

