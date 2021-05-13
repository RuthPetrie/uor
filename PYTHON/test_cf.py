from netCDF4 import Dataset as ncfile
import cf
 
ctrl_output_dir = '/export/quince/data-06/wx019276/um_expts/ctrl/output/'

file = ctrl_output_dir+'xhuica.pyl2c10.pp'

pp2cf -f NETCDF4 -o file+'.nc' file+'.pp'






