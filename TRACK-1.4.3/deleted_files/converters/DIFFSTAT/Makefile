SOURCE1=diff.c \
       malloc_init.c \
       read_stats.c \
       statdmp.c



OBJECT1=$(SOURCE1:.c=.o)

CFLAGS = -g -Xa -xsb

#CFLAGS = -g -ansi -Wall

LIBS = -lm


.KEEP_STATE:

all: diff_stats



diff_stats: $(SOURCE1)
	$(CC) -c $(CFLAGS) $(SOURCE1)
	$(CC) $(CFLAGS) -o $@ $(OBJECT1) $(LIBS)

