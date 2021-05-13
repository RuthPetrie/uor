% MATLAB CODE TO CALCULATE BALANCE RESIDUALS
%================================================
% ModelBalance
xcontinue = 10

% LOAD DATA
%-------------------------------------------------------------------
%[ctrl, nlongs, nlevs, ntimes] = load_netcdf_struct...
%    ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_60.nc');

%[con, nlongs, nlevs, ntimes] = load_netcdf_struct...
%    ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_61.nc');

%[bal, nlongs, nlevs, ntimes] = load_netcdf_struct...
%    ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_62.nc');

bal = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_82.nc');
con = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_81.nc');
ctrl = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_80.nc');
nlongs = 360;
nlevs = 60;
ntimes = 37;


%t = 6
%for k = 1: 60
% yax(k) = k * 256.7;
%end

%for l = 1:360
% xax(l) = l * 1.5;
%end
%anorm = 1/4E-4
%aconv = 1/4E-5
%hlevels = [0.0 0.5 1.0];
%glevels = [0.0 0.5 1.0];
%figure
%[coutg,G] = contourf(xax, yax(2:60), abs(squeeze(bal.geost(t,2:60,:))), glevels); 
%colormap(flipud(gray)),colorbarf(coutg,G)
%xlabel(['Longitudinal distance  (km)'],'FontSize',12), 
%ylabel(['Height    ',10,'(m)   '],'FontSize',12, 'Rotation',0 )
%title('bal geost imbalance')
%figure
%Caxis = [-1.0 1.0];
%pcolor(xax,yax,X), shading flat, colorbar
%xlabel(['Longitudinal distance  (km)'],'FontSize',12), 
%ylabel(['Height    ',10,'(m)   '],'FontSize',12, 'Rotation',0 )


%% SET PARAMETERS
%------------------------
t = 37
% MAKE FIGURES
%--------------
% HYDROSTATIC BALANCE RESIDUAL
%---------------------------------------------
%V= [-0.2  0.2];
%figure,pcolor(squeeze(d.w(time, 2:nlevels,:))), caxis(V), colormap(redblue), shading flat, colorbar
%caxis(v), shading flat, colorbar
%caxis(-0.1632 0.1443);

%% SET AXES
for k = 1: 60
 yax(k) = k * 256.7;
end

for l = 1:360
 xax(l) = l * 1.5;
end

anorm = 1/4E-4
aconv = 1/4E-5
hlevels = [0.0 0.5 1.0];
glevels = [0.0 0.5 1.0];

figure
[cout,H] = contourf(xax, yax(2:60), abs(squeeze(ctrl.hydro(t,2:60,:))), hlevels); 
colormap(flipud(gray)),colorbarf(cout,H)
xlabel(['Longitudinal distance (km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
title('ctrl hydro imbalance')

figure
[coutg,G] = contourf(xax, yax(2:60), abs(squeeze(ctrl.geost(t,2:60,:))), glevels); 
colormap(flipud(gray)),colorbarf(coutg,G)
xlabel(['Longitudinal distance (km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
title('ctrl geost imbalance')

figure
[cout,H] = contourf(xax, yax(2:60), abs(squeeze(con.hydro(t,2:60,:))), hlevels); 
colormap(flipud(gray)),colorbarf(cout,H)
xlabel(['Longitudinal distance (km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
title('convect hydro imbalance')

%figure
%[coutg,G] = contourf(xax, yax(2:60), abs(squeeze(con.geost(t,2:60,:))), glevels); 
%colormap(flipud(gray)),colorbarf(coutg,G)
%xlabel(['Longitudinal distance (km)'],'FontSize',12), 
%ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
%title('convect geost imbalance')

%figure
%[cout,H] = contourf(xax, yax(2:60), abs(squeeze(bal.hydro(t,2:60,:))), hlevels); 
%colormap(flipud(gray)),colorbarf(cout,H)
%xlabel(['Longitudinal distance (km)'],'FontSize',12), 
%ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
%title('bal hydro imbalance')

figure
[coutg,G] = contourf(xax, yax(2:60), abs(squeeze(bal.geost(t,2:60,:))), glevels); 
colormap(flipud(gray)),colorbarf(coutg,G)
xlabel(['Longitudinal distance (km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
title('bal geost imbalance')













