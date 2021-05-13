###################################################
#
# USE ssh-add TO USE KEYLESS TRANSFER
# 
# Get experimental data from hector using scp
#  
# RUTH PETRIE
# 30/5/2013
#
####################################################

# LOCAL DIRECTORY INFORMATION
localdir='/net/elm/export/elm/data-06/wx019276/COUPLED_OCEAN_DATA/RAW/'
job=xjhb

# REMOTE DIRECTORY INFORMATION
lmsdir=/nerc/n02/n02/wx019276/
exptid=xhuie
lmsexptid=iceonly_${exptid}/rerun/

scp wx019276@login.hector.ac.uk:${lmsdir}${lmsexptid}*.pci8* ${localdir}


