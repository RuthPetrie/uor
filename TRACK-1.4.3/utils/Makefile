.KEEP_STATE:


all: symlinks combine convolve convhew count diffstat ensemble lifecycle sample split tc tele_weights tilt transadd

symlinks: FORCE
	chmod u+x makelinks.csh
	makelinks.csh

combine: FORCE
	cd COMBINE; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

convhew: FORCE
	cd HEWSON; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

convolve: FORCE
	cd CONVOLVE; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

count: FORCE
	cd COUNT; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)' 

diffstat: FORCE
	cd DIFFSTAT; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

ensemble: FORCE
	cd ENSEMBLE; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

lifecycle: FORCE
	cd LIFECYCLE; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

sample: FORCE
	cd SAMPLE; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

split: FORCE
	cd SPLIT; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)' 

tc: FORCE
	cd TC; make SYSTEM='${SYSTEM}' HAVNETC='NETCDF' ADDINCS='${ADDINCS}' ADLIBS='${ADLIBS}' AD_C_FLAGS='$(AD_C_FLAGS)'

tele_weights: FORCE
	cd TELE_WEIGHTS; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

tilt: FORCE
	cd TILT; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

transadd: FORCE
	cd TRANSADD; make SYSTEM='${SYSTEM}' AD_C_FLAGS='$(AD_C_FLAGS)'

FORCE:
