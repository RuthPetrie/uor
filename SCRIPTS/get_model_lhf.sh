#!/bin/ksh
echo this
setup cdo 
DIR=/export/quince/data-06/wx019276/um_expts/ctrl/

~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*son*.pp -o ${DIR}ncfiles/ctrl_shlf_djf.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*djf*.pp -o ${DIR}ncfiles/ctrl_shlf_mam.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*mam*.pp -o ${DIR}ncfiles/ctrl_shlf_jja.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*jja*.pp -o ${DIR}ncfiles/ctrl_shlf_son.nc -p 114

cdo mergetime  ${DIR}ncfiles/ctrl_shlf_djf.nc ${DIR}ncfiles/ctrl_shlf_mam.nc ${DIR}ncfiles/ctrl_shlf_jja.nc ${DIR}ncfiles/ctrl_shlf_son.nc ${DIR}ncfiles/ctrl_shlf_sm.nc 
cdo yseasmean  ${DIR}ncfiles/ctrl_shlf_sm.nc ${DIR}ncfiles/ctrl_shlf_msm.nc 
   
DIR=/export/quince/data-06/wx019276/um_expts/fullpert/

~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*son*.pp -o ${DIR}ncfiles/pert_shlf_djf.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*djf*.pp -o ${DIR}ncfiles/pert_shlf_mam.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*mam*.pp -o ${DIR}ncfiles/pert_shlf_jja.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*jja*.pp -o ${DIR}ncfiles/pert_shlf_son.nc -p 114
cdo mergetime  ${DIR}ncfiles/pert_shlf_djf.nc ${DIR}ncfiles/pert_shlf_mam.nc ${DIR}ncfiles/pert_shlf_jja.nc ${DIR}ncfiles/pert_shlf_son.nc ${DIR}ncfiles/pert_shlf_sm.nc 
cdo yseasmean  ${DIR}ncfiles/pert_shlf_sm.nc ${DIR}ncfiles/pert_shlf_msm.nc 
   
DIR=/export/quince/data-05/wx019276/um_expts/iceonly/

~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*son*.pp -o ${DIR}ncfiles/iceo_shlf_djf.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*djf*.pp -o ${DIR}ncfiles/iceo_shlf_mam.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*mam*.pp -o ${DIR}ncfiles/iceo_shlf_jja.nc -p 114
~/SHELL_SCRIPTS/converters/convpp2nc.tcl -i ${DIR}output/*jja*.pp -o ${DIR}ncfiles/iceo_shlf_son.nc -p 114
cdo mergetime  ${DIR}ncfiles/iceo_shlf_djf.nc ${DIR}ncfiles/iceo_shlf_mam.nc ${DIR}ncfiles/iceo_shlf_jja.nc ${DIR}ncfiles/iceo_shlf_son.nc ${DIR}ncfiles/iceo_shlf_sm.nc 
cdo yseasmean  ${DIR}ncfiles/iceo_shlf_sm.nc ${DIR}ncfiles/iceo_shlf_msm.nc 
 
