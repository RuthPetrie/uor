#!/bin/ksh
# 
# Convert file to png and move to public folder
#
# Ruth Petrie
# Jan 2013
#

# Parameters
publicloc = '/home/wx019276/public_html/teacosi/figs/'
dataloc = '/export/quince/data-06/wx019276/um_expts/analysis/'

# Variables
publicfolder = 'um_expts/expt1/'
datafolder = 'iceonly_response/'
filename = 'mslp_ioprsp_finescale_sig_global'


convert -rotate -90 $dataloc+$datafolder+$filename+'.ps' $publicloc+$publicfolder+$filename+'.png'
