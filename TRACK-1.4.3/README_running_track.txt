TO RUN TRACK
-------------

1. Create winds at 850 hPa in folder where one file has one year and one season 
   of winds at 6hrly intervals
   
   name format 
   
   dir  ~ /export/quince/data-06/wx019276/um_expts/ctrl/trackdata
   file ~ ctrl_winds_850_1981_son.nc
   
2. From ~/TRACK-1.4.3/

e.g.

run_track_orig.csh {season} {expt} {startyear} {endyear}

run_track_orig.csh jja ctrl 1982 1982



TO RUN TRACK STATS
------------------

1. Change to job directory

2. Check ff files are present

   ls */ff*
   
   unzip: gunzip */ff*

3. Make TOTAL folder in job directory

4. make combine.in file

   This is a file containing in the first three lines
   30 - nfiles
   2  - ??
   3  - ??
   list of 30 files ff_trs_pos (get in list form by ls -1 */ff_trs_pos)

5. combine files using TRACK utilities

   ~/TRACK-1.4.3/utils/bin/combine < combine.in
    
    MOVE COMBINED TRACKS TO /TOTAL 
    
    mv combined_tr_trs TOTAL/tr_trs_VOR850_pos

6. copy across "all_pr_in" file from previous job TOTAL directory

7. run stats program from ~/TRACK-1.4.3/ in csh e.g. 

    bb_stats.job VOR850_pos TOTAL /export/quince/data-05/wx019276/TRACK/iceonly_jja
