
%filename = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_30_covars.nc'

function [x, nlongs, nlevs, ntimes] = load_nc_struct(filename)

ncid=netcdf.open(filename,'nowrite');

x.longs_u = netcdf.getVar(ncid,0);
[nlongs, l1] = size(x.longs_u);
x.longs_v = netcdf.getVar(ncid,1);
x.full_level = netcdf.getVar(ncid,2);
x.full_level_1 = netcdf.getVar(ncid,3);
[nlevs, h1] = size(x.full_level_1);
x.half_level = netcdf.getVar(ncid,4);
x.time = netcdf.getVar(ncid,5);
[ntimes,t1] = size(x.time);
x.energydim = netcdf.getVar(ncid,6);

x.u = netcdf.getVar(ncid,7);
%x.u = reshape(x.u, [ntimes nlevs nlongs])

x.v = netcdf.getVar(ncid,8);
%x.v = reshape(x.v, [ntimes nlevs nlongs])

x.w = netcdf.getVar(ncid,9);
%x.w = reshape(x.w, [ntimes nlevs nlongs])

x.rho_prime = netcdf.getVar(ncid,10);
%x.rho_prime = reshape(x.rho_prime, [ntimes nlevs nlongs])

x.rho = netcdf.getVar(ncid,11);

x.b_prime = netcdf.getVar(ncid,12);
%x.b_prime = reshape(x.b_prime, [ntimes nlevs nlongs])

x.tracer = netcdf.getVar(ncid,13);
%x.tracer = reshape(x.tracer, [ntimes nlevs nlongs])

x.geost = netcdf.getVar(ncid,14);
%x.geost = reshape(x.geost, [ntimes nlevs nlongs])

x.hydro = netcdf.getVar(ncid,15);
%x.hydro = reshape(x.hydro, [ntimes nlevs nlongs])

x.energy = netcdf.getVar(ncid,16);

x.rho0 = netcdf.getVar(ncid,17);


if ntimes == 1

   for k = 1:nlevs
    for i = 1:nlongs
      u_temp(k,i)         = x.u(i,k);
      v_temp(k,i)         = x.v(i,k);
      w_temp(k,i)         = x.w(i,k);
      rho_prime_temp(k,i) = x.rho_prime(i,k);
      b_prime_temp(k,i)   = x.b_prime(i,k);
      hydro_temp(k,i)     = x.hydro(i,k);
      geost_temp(k,i)     = x.geost(i,k);
    end
   end
 else

  for t = 1:ntimes
   for k = 1:nlevs
    for i = 1:nlongs
      u_temp(t,k,i)         = x.u(i,k,t);
      v_temp(t,k,i)         = x.v(i,k,t);
      w_temp(t,k,i)         = x.w(i,k,t);
      rho_prime_temp(t,k,i) = x.rho_prime(i,k,t);
      b_prime_temp(t,k,i)   = x.b_prime(i,k,t);
      hydro_temp(t,k,i)     = x.hydro(i,k,t);
      geost_temp(t,k,i)     = x.geost(i,k,t);
    end
   end
  end
end
clear x.u;
clear x.v;
clear x.w;
clear x.rho_prime;
clear x.b_prime;
clear x.hydro;
clear x.geost;

x.u         = u_temp;
x.v         = v_temp;
x.w         = w_temp;
x.rho_prime = rho_prime_temp;
x.b_prime   = b_prime_temp;
x.hydro     = hydro_temp;
x.geost     = geost_temp;


clear u_temp;
clear v_temp;
clear w_temp;
clear rho_prime_temp;
clear b_prime_temp;
clear hydro_temp;
clear geost_temp;


