SOURCES=read_tracks.c \
        toverlap.c \
        measure.c \
        euclid.c \
        geod_dist.c \
        malloc_initl.c \
        meantrd.c \
        realloc_n.c \
        new_time.c \
        sincos.c	

OBJECTS=$(SOURCES:.c=.o)

#CFLAGS = -g -Xa -xsb -I../../include

CFLAGS = -g -ansi -Wall -I../../include -D${SYSTEM} $(AD_C_FLAGS)

#LIBS = -lm -lsunmath
LIBS = -lm


.KEEP_STATE:

all: censemble censemble2 eps ensdiff



censemble: $(OBJECTS) compare_ensemble.c trdist.c
	$(CC) $(CFLAGS) -c compare_ensemble.c trdist.c
	$(CC) $(CFLAGS) -o ../bin/$@ $(OBJECTS) compare_ensemble.o trdist.o $(LIBS)

censemble2: $(OBJECTS) compare_ensemble2.c trdist.c
	$(CC) $(CFLAGS) -c compare_ensemble2.c trdist.c
	$(CC) $(CFLAGS) -o ../bin/$@ $(OBJECTS) compare_ensemble2.o trdist.o $(LIBS)

eps: $(OBJECTS) eps_ensemble.c trdist_eps.c convert_track.c ortho_dist.c
	$(CC) $(CFLAGS) -c eps_ensemble.c trdist_eps.c convert_track.c ortho_dist.c 
	$(CC) $(CFLAGS) -o ../bin/$@ $(OBJECTS) eps_ensemble.o trdist_eps.o convert_track.o ortho_dist.o $(LIBS)

ensdiff: $(OBJECTS) ensdiff.c convert_track.c ortho_dist.c
	$(CC) $(CFLAGS) -c ensdiff.c convert_track.c ortho_dist.c
	$(CC) $(CFLAGS) -o ../bin/$@ $(OBJECTS) ensdiff.o convert_track.o ortho_dist.o $(LIBS)
