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
localdir='/export/quince/data-06/wx019276/um_expts/'
localexpt=fullpert/output/rerun/

# REMOTE DIRECTORY INFORMATION
lmsdir=/nerc/n02/n02/wx019276/
exptid=xhuid
lmsexptid=pert_${exptid}/rerun/

scp wx019276@login.hector.ac.uk:${lmsdir}${lmsexptid}*.p* ${localdir}${expt}


