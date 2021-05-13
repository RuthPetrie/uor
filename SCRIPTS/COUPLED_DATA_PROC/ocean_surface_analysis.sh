#/usr/bin/sh
#include<data_processing_functions.sh>


# Program to calculate monthly surface pressure statistics
# RUN ON JASMIN

#  SEASON FOLDERS
#  
#  MONTHLY
#  BIMONTHLY
#  SEASONALY
#  NON_STD_SEASONS



# Version 1.0 Ruth Petrie 28-5-2014

# ADDITIONAL EXPORT PATH FOR REP ONLY
#export LD_LIBRARY_PATH=$LIBRARY_PATH:/opt/graphics/64/lib


##################################################################################
# include functions
#source ./ocean_surface_functions.sh
# set up tools
setup cdo

# Set DATADIR
VARNAME=sss
UMNAME=sosaline

CDDIR=/net/elm/export/elm/data-06/wx019276/COUPLED_OCEAN_DATA/CTRL/
PDDIR=/net/elm/export/elm/data-06/wx019276/COUPLED_OCEAN_DATA/PERT/

extract_data=true
plot_data=false



##################################################################################
if [ "${extract_data}" = "true" ]; then; 

  echo EXTRACTING DATA

  # EXTRACT THE MONTHLY DATA AND MAKE MONTHLY STATISTICS
  #-------------------------------------------------------
  
#    calc_monthly_stats ${CDDIR} ${UMNAME} ${VARNAME} 
 #   calc_monthly_stats ${PDDIR} ${UMNAME} ${VARNAME} 

    # EXTRACT AND CALCULATE STATS OF BIMONTHLY DATA
    #-------------------------------------------------------
    typeset -Z2 ENS
   
    cd ${CDDIR}/ENSB
  
    for ENS in {1..30}; do 
    
    cdo -timmean, -selmon,4,5, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_DJ.nc
    
    cdo -timmean, -selmon,4,5, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_DJ.nc

    cdo -timmean, -selmon,4,5, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_DJ.nc
    
    cdo -timmean, -selmon,4,5, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_DJ.nc
   
    
    # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
    #-------------------------------------------------------
    cdo -timmean, -selmon,6,7,8 -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_DJF.nc

    cdo -timmean, -selmon,6,7,8 -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_DJF.nc

    cdo -timmean, -selmon,6,7,8 -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_DJF.nc

    cdo -timmean, -selmon,6,7,8 -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_DJF.nc

  done 
  
  BIMONS="AM JJ AS ON DJ"
  SEAS="JJA SON DJF"
  
  for S in ${SEAS}; do
    cdo ensmean salinity_surf_*_${S}.nc ../salinity_surf_${S}.nc
    cdo ensmean temp_surf_*_${S}.nc  ../temp_surf_${S}.nc
    cdo ensmean salinity_subsurf_*_${S}.nc ../salinity_subsurf_${S}.nc
    cdo ensmean temp_subsurf_*_${S}.nc ../temp_subsurf_${S}.nc
  done
  for M in ${BIMONS}; do
    cdo ensmean salinity_surf_*_${M}.nc ../salinity_surf_${M}.nc
    cdo ensmean temp_surf_*_${M}.nc  ../temp_surf_${M}.nc
    cdo ensmean salinity_subsurf_*_${M}.nc ../salinity_subsurf_${M}.nc
    cdo ensmean temp_subsurf_*_${M}.nc ../temp_subsurf_${M}.nc
  done

    cd ${PDDIR}/ENSB
  
    for ENS in {1..30}; do 
    
    cdo -timmean, -selmon,4,5, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_DJ.nc
    
    cdo -timmean, -selmon,4,5, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_DJ.nc

    cdo -timmean, -selmon,4,5, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_DJ.nc
    
    cdo -timmean, -selmon,4,5, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_AM.nc
    cdo -timmean, -selmon,6,7, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_JJ.nc
    cdo -timmean, -selmon,8,9, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_AS.nc
    cdo -timmean, -selmon,10,11, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_ON.nc
    cdo -timmean, -selmon,12,1, -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_DJ.nc
   
    
    # EXTRACT AND CALCULATE STATS OF STANDARD SEASONAL DATA
    #-------------------------------------------------------
    cdo -timmean, -selmon,6,7,8 -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,sosaline ocean_surface_${ENS}.nc salinity_surf_${ENS}_DJF.nc

    cdo -timmean, -selmon,6,7,8 -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,sosstsst ocean_surface_${ENS}.nc temp_surf_${ENS}_DJF.nc

    cdo -timmean, -selmon,6,7,8 -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,vosaline ocean_subsurface_${ENS}.nc salinity_subsurf_${ENS}_DJF.nc

    cdo -timmean, -selmon,6,7,8 -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_JJA.nc
    cdo -timmean, -selmon,9,10,11 -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_SON.nc
    cdo -timmean, -selmon,11,1,2 -selvar,votemper ocean_subsurface_${ENS}.nc temp_subsurf_${ENS}_DJF.nc

  done 
  
  BIMONS="AM JJ AS ON DJ"
  SEAS="JJA SON DJF"
  
  for S in ${SEAS}; do
    cdo ensmean salinity_surf_*_${S}.nc ../salinity_surf_${S}.nc
    cdo ensmean temp_surf_*_${S}.nc  ../temp_surf_${S}.nc
    cdo ensmean salinity_subsurf_*_${S}.nc ../salinity_subsurf_${S}.nc
    cdo ensmean temp_subsurf_*_${S}.nc ../temp_subsurf_${S}.nc
  done
  for M in ${BIMONS}; do
    cdo ensmean salinity_surf_*_${M}.nc ../salinity_surf_${M}.nc
    cdo ensmean temp_surf_*_${M}.nc  ../temp_surf_${M}.nc
    cdo ensmean salinity_subsurf_*_${M}.nc ../salinity_subsurf_${M}.nc
    cdo ensmean temp_subsurf_*_${M}.nc ../temp_subsurf_${M}.nc
  done
 
  
fi
##################################################################################################





##################################################################################################
if [ "${plot_data}" = "true" ]; then; 
  
  
  
#  for HEIGHT in ${heights}; do
    HEIGHT=850
   echo PLOT DATA ${HEIGHT}
    
    CDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/CTRL/
    PDDIR=/net/quince/export/quince/data-05/wx019276/COUPLED_EXPTS/PERT/
    IDLFILELOC='/home/wx019276/teacosi/idl_plotting/coupled_um_expts/coupled_analysis'
    cd $IDLFILELOC
    ODIR='/home/wx019276/figures/teacosi/coupled_expts/canalysis/'
    figoutdir=${ODIR}
    
  #================================================================================================
    TEMPORAL='NON_STD_SEASONS/'
    CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
    PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
    
#    idl -e "plot_u50_nsseas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME}${HEIGHT}
  #================================================================================================
    TEMPORAL='BIMONTHLY/'
    CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
    PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
   
#    idl -e "plot_u50_bimonthly" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME}${HEIGHT}
  #================================================================================================
    TEMPORAL='SEASONALLY/'
    echo $TEMPORAL
    CFILELOC=${CDDIR}${VARDIR}${TEMPORAL}
    PFILELOC=${PDDIR}${VARDIR}${TEMPORAL}
    
    echo $CFILELOC
    echo $PFILELOC

    idl -e "plot_u850_seas" -args ${CFILELOC} ${PFILELOC} ${figoutdir} ${VARNAME}${HEIGHT}
  #================================================================================================
# done
  
fi
#######################################################################








