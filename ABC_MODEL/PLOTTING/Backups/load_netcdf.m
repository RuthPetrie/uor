
%filename = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_30_covars.nc'

function [x] = load_nc_struct(filename)

ncid=netcdf.open(filename,'nowrite');

x.longs_u = netcdf.getVar(ncid,0);
x.longs_v = netcdf.getVar(ncid,1);
x.full_level = netcdf.getVar(ncid,2);
%x.full_level_1 = netcdf.getVar(ncid,3);
x.half_level = netcdf.getVar(ncid,4);
x.times = netcdf.getVar(ncid,5);
x.energydim = netcdf.getVar(ncid,6);
x.u = netcdf.getVar(ncid,7);
x.v = netcdf.getVar(ncid,8);
x.w = netcdf.getVar(ncid,9);
x.rho_prime = netcdf.getVar(ncid,10);
x.rho = netcdf.getVar(ncid,11);x
x.b_prime = netcdf.getVar(ncid,12);
x.tracer = netcdf.getVar(ncid,13);
x.geost = netcdf.getVar(ncid,14);
x.hydro = netcdf.getVar(ncid,15);
x.energy = netcdf.getVar(ncid,16);
x.rho0 = netcdf.getVar(ncid,17);



