SOURCES=convert_track.c \
        meantrd.c \
        orog_test.c \
        read_tracks.c \
        sincos.c \
        write_fields_netcdf.c \
        write_intflux_netcdf.c


OBJECTS=$(SOURCES:.c=.o)

#CFLAGS = -g -Xa -I../../include ${ADDINCS} -D${SYSTEM} -D${HAVNETC} $(AD_C_FLAGS) -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64


CFLAGS = -g -ansi -Wall -I../../include ${ADDINCS} -D${SYSTEM} -D${HAVNETC} $(AD_C_FLAGS) -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64

LIBS = -lm ${ADLIBS}


.KEEP_STATE:

all: tcident tcident_flux combine_reg reg_diff write_fields diffke

tcident: tc_identify.c $(OBJECTS)
	$(CC) $(CFLAGS) -c tc_identify.c
	$(CC) $(CFLAGS) -o ../bin/$@ tc_identify.o $(OBJECTS) $(LIBS)

tcident_flux: tc_identify_flux.c $(OBJECTS)
	$(CC) $(CFLAGS) -c tc_identify_flux.c
	$(CC) $(CFLAGS) -o ../bin/$@ tc_identify_flux.o $(OBJECTS) $(LIBS)

combine_reg: combine_reg.c
	$(CC) $(CFLAGS) -o ../bin/$@ combine_reg.c

reg_diff: reg_diff.c
	$(CC) $(CFLAGS) -o ../bin/$@ reg_diff.c

write_fields: write_fields.c
	$(CC) $(CFLAGS) -o ../bin/$@ write_fields.c read_tracks.o

diffke: diffke.c
	$(CC) $(CFLAGS) -o ../bin/$@ diffke.c read_tracks.o $(LIBS)

