%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCTION TO LOAD A NETCDF FILE OF TOY MODEL OUTPUT
%
% Version
% 2.0 R. Petrie: 29-10-2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declare function
%------------------
function [x] = load_nc_struct(filename)
%======================================

% Open file
%------------------
ncid=netcdf.open(filename,'nowrite');

% Allocate variables
%--------------------

% Dimensions
%------------
x.longs_u = netcdf.getVar(ncid,0);
x.longs_v = netcdf.getVar(ncid,1);
x.full_level = netcdf.getVar(ncid,2);
x.half_level = netcdf.getVar(ncid,3);
x.time = netcdf.getVar(ncid,4);


%
x.u = netcdf.getVar(ncid,5);
x.v = netcdf.getVar(ncid,6);
x.w = netcdf.getVar(ncid,7);
x.rho_prime = netcdf.getVar(ncid,8);
x.b_prime = netcdf.getVar(ncid,9);

%
x.rho = netcdf.getVar(ncid,10);
x.beff = netcdf.getVar(ncid,11);
x.tracer = netcdf.getVar(ncid,12);
x.hydro = netcdf.getVar(ncid,13);
x.geost = netcdf.getVar(ncid,14);

% 
x.rho0 = netcdf.getVar(ncid,15);
x.b0 = netcdf.getVar(ncid,16);
x.Ek = netcdf.getVar(ncid,17);
x.Eb = netcdf.getVar(ncid,18);
x.Ee = netcdf.getVar(ncid,19);
x.Et = netcdf.getVar(ncid,20);


