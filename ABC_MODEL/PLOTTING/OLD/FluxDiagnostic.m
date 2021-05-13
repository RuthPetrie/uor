%% FluxDiagnostic

cont = 0

% LOAD DATA
%===========
n = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convect_004.nc');
c = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convect_005.nc');

% SET PARAMETERS
%=================
B = 0.1
dz = 267
t = 31
dx = 1500

% CALCULATE DIAGNOSTICS
%=======================

% Hydrostatic component
%-------------------------
for i = 1:360
 for k = 1:59 
  hyd_n(k,i) = - n.rho_prime(t,k,i) * ( ( ( n.rho_prime(t,k+1,i) - n.rho_prime(t,k,i) ) / dz )...
                                        - n.b_prime(t,k,i) ) ;
  hyd_c(k,i) = - c.rho_prime(t,k,i) * ( ( ( c.rho_prime(t,k+1,i) - c.rho_prime(t,k,i) ) / dz )...
                                        - c.b_prime(t,k,i) ) ;
 end
end

% Momentum flux component
%-------------------------
% Interpolations
%----------------
for i = 1:360
 for k = 1:59
   n_p_int(k,i) = 0.5 * ( n.rho_prime(t,k+1,i) + n.rho_prime(t,k,i) );
   c_p_int(k,i) = 0.5 * ( c.rho_prime(t,k+1,i) + c.rho_prime(t,k,i) );
 end
end

for i = 1:359
 for k = 1:59
  n_u_int(k,i) = 0.25 * ( n.u(t,k+1,i+1) + n.u(t,k+1,i) + n.u(t,k,i+1) + n.u(t,k,i));
  c_u_int(k,i) = 0.25 * ( c.u(t,k+1,i+1) + c.u(t,k+1,i) + c.u(t,k,i+1) + c.u(t,k,i));
 end
end

i = 360
 for k = 1:59
  n_u_int(k,i) = 0.25 * ( n.u(t,k+1,1) + n.u(t,k+1,i) + n.u(t,k,1) + n.u(t,k,i));
  c_u_int(k,i) = 0.25 * ( c.u(t,k+1,1) + c.u(t,k+1,i) + c.u(t,k,1) + c.u(t,k,i));
 end
 
for i = 1:360
 for k = 1:59
  n_flux_prod(k,i) = n_p_int(k,i) * n_u_int(k,i) * n.w(t,k,i);
  c_flux_prod(k,i) = c_p_int(k,i) * c_u_int(k,i) * c.w(t,k,i);
 end
end
 
for i = 1:359
 for k = 1:58 
  flux_n(k,i) = -B * ( ((n_flux_prod(k,i+1) - n_flux_prod(k,i) )/dx) ...
                   + (( n_flux_prod(k+1,i) - n_flux_prod(k,i) )/dz) ) ;
  flux_c(k,i) = -B * ( ((c_flux_prod(k,i+1) - c_flux_prod(k,i) )/dx) ...
                   + (( c_flux_prod(k+1,i) - c_flux_prod(k,i) )/dz) ) ;
 end
end



% CALCULATE PLOTTING AXES
%========================
max_hyd_n = max(max(abs(hyd_n(1:59,:))));
max_hyd_c = max(max(abs(hyd_c(1:59,:))));
hyd_n_ax = [-max_hyd_n max_hyd_n];
hyd_c_ax = [-max_hyd_c max_hyd_c];
max_w_n = max(max(abs(n.w(t,:,:))));
max_w_c = max(max(abs(c.w(t,:,:))));
w_n_ax = [-max_w_n max_w_n];
w_c_ax = [-max_w_c max_w_c];
max_flux_n = max(max(abs(flux_n(:,:))));
max_flux_c = max(max(abs(flux_c(:,:))));
flux_n_ax = [-max_flux_n max_flux_n];
flux_c_ax = [-max_flux_c max_flux_c];

% PLOT DIGNOSTICS
%================
figure
nrows = 3
ncolumns = 2
%------------------------------------------------------------------------------------------
subplot(nrows, ncolumns,1), pcolor(squeeze(n.w(t,:,:))), caxis(w_n_ax), colormap(redblue),
shading flat, colorbar, 
title('Stable regime'), ylabel('w - vertical wind')
%------------------------------------------------------------------------------------------
subplot(nrows, ncolumns,2), pcolor(squeeze(c.w(t,:,:))), caxis(w_c_ax), colormap(redblue),
shading flat, colorbar, 
title('Unstable regime')
%------------------------------------------------------------------------------------------
subplot(nrows, ncolumns,3), pcolor(hyd_n), caxis(hyd_n_ax), colormap(redblue),
shading flat, colorbar, 
ylabel('hydrostatic component')
%------------------------------------------------------------------------------------------
subplot(nrows, ncolumns,4), pcolor(hyd_c), caxis(hyd_c_ax), colormap(redblue),
shading flat, colorbar
%------------------------------------------------------------------------------------------
subplot(nrows, ncolumns,5), pcolor(flux_n), caxis(flux_n_ax), colormap(redblue),
shading flat, colorbar, 
ylabel('momentum flux component')
%------------------------------------------------------------------------------------------
subplot(nrows, ncolumns,6), pcolor(flux_c), caxis(flux_c_ax), colormap(redblue),
shading flat, colorbar












