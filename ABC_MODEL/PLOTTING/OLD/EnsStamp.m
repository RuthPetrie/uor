%% Stamp plot of enesmble members

%% Load ensemble members
cont = 41

%en0 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41000.nc');
%en1 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41022.nc');
%en2 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41029.nc');
%en3 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41030.nc');
%en4 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41032.nc');
%en5 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41040.nc');
%en6 = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_41041.nc');
%en7 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_12042.nc');
%en8 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_12048.nc');
[en0, nlongs, nlevs, ntimes] = load_netcdf_struct...
  ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50000.nc');
[en1, nlongs, nlevs, ntimes] = load_netcdf_struct...
  ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50001.nc');
[en2, nlongs, nlevs, ntimes] = load_netcdf_struct...
  ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50002.nc');
[en3, nlongs, nlevs, ntimes] = load_netcdf_struct...
  ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50003.nc');
[en4, nlongs, nlevs, ntimes] = load_netcdf_struct...
  ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50004.nc');
[en5, nlongs, nlevs, ntimes] = load_netcdf_struct...
  ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50005.nc');

t =11
%h = figure
%set(h, 'Position', [360 99 762 825])
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

wax = 1.1 * max(max(max(abs(en0.u(:,:,:)))));
waxis = [-wax wax]
figure
nrows = 3
ncols = 2

subplot(nrows, ncols,1) 
pcolor(xax, yax, squeeze(en0.w(t,:,:))), colormap(redblue), caxis(waxis), shading flat, colorbar
title('Ens average (control)')

subplot(nrows, ncols,2) 
pcolor(xax, yax, squeeze(en1.w(t,:,:))), colormap(redblue), caxis(waxis), shading flat, colorbar
title('en1')

subplot(nrows, ncols,3) 
pcolor(xax, yax, squeeze(en2.w(t,:,:))), colormap(redblue), caxis(waxis), shading flat, colorbar
title('en2')

subplot(nrows, ncols,4) 
pcolor(xax, yax, squeeze(en3.w(t,:,:))), colormap(redblue), caxis(waxis), shading flat, colorbar
title('en3')

subplot(nrows, ncols,5) 
pcolor(xax, yax, squeeze(en4.w(t,:,:))), colormap(redblue), caxis(waxis), shading flat, colorbar
title('en4')

subplot(nrows, ncols,6) 
pcolor(xax, yax, squeeze(en5.u(t,:,:))), colormap(redblue), caxis(waxis), shading flat, colorbar
title('en5')

%subplot(nrows, ncols,1) 
%pcolor(xax, yax, en6.w(:,:)), colormap(redblue), caxis(waxis), shading flat, colorbar

%subplot(nrows, ncols,1) 
%figure
%pcolor(xax, yax, en7.w(:,:)), colormap(redblue), caxis(waxis), shading flat, colorbar

%subplot(nrows, ncols,1) 
%figure
%pcolor(xax, yax, en8.w(:,:)), colormap(redblue), caxis(waxis), shading flat, colorbar



%pcolor(en5.u - en0.u), shading flat, colorbar



