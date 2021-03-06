% MATLAB CODE TO CALCULATE BALANCE RESIDUALS
%================================================
% ModelBalance
xcontinue = 2
% LOAD DATA
%-------------------------------------------------------------------
b = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/balance_001.nc');
%m = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convection1.nc');
n = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convection2.nc'); 
%'/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convection1.nc'
%wmax = max(max(max(abs(m.w(:,:,:)))))
%waxis = [-wmax wmax]
m = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/coriolis_11.nc');

% SET PARAMETERS
%------------------------
time = 21
nlevels = 60

% MAKE FIGURES
%--------------
% HYDROSTATIC BALANCE RESIDUAL
%---------------------------------------------
%V= [-0.2  0.2];
%figure,pcolor(squeeze(d.w(time, 2:nlevels,:))), caxis(V), colormap(redblue), shading flat, colorbar
%caxis(v), shading flat, colorbar
%caxis(-0.1632 0.1443);

for k = 1: 60
 height(k) = k * 256.7;
end

for l = 1:360
 long(l) = l * 1.5;
end


t = 11

hlevels = [0.0 0.1 0.5 1.5 20.0];
figure
contourf(long, height(2:59), abs(squeeze(m.hydro(t,2:60,:)))/rms(squeeze(m.b_prime(t,:,:))), hlevels), 
colormap(flipud(gray)),colorbar
xlabel(['Longitudinal distance',10,'(km)'],'FontSize',10), ylabel(['Height',10,'(m)'],'FontSize',10, 'Rotation',0 )


glevels = [0.0 0.1 0.5 1.5 10.0];
figure
contourf(long, height(2:59), abs(squeeze(m.geost(t,2:60,:)))/(0.0001 * rms(squeeze(m.v(t,:,:)))), glevels), 
colormap(flipud(gray)),colorbar
xlabel(['Longitudinal distance',10,'(km)'],'FontSize',10), ylabel(['Height',10,'(m)'],'FontSize',10, 'Rotation',0 )

t = 4

wmax = max(max(abs(squeeze(b.w(6,:,:)))));
wscale = [-wmax wmax]
figure
pcolor(long, height, (squeeze(b.w(t,:,:)))), 
shading flat, caxis(waxis), colormap(redblue),colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )
t=1 
figure
pcolor(long, height,(squeeze(b.w(t,:,:)))), 
shading flat, caxis(waxis), colormap(redblue),colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )


t = 5
figure
pcolor(long, height,(squeeze(n.w(t,:,:)))), 
shading flat, caxis(waxis), colormap(redblue),colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )


t = 5
for k = 1: 60
 height(k) = k * 256.7;
end

for l = 1:360
 long(l) = l * 1.5;
end


figure
pcolor(long, height,(squeeze(m.w(t,:,:)))), 
shading flat, caxis(waxis), colormap(redblue),colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12, 'Rotation',0 )


t = 5

hmax1 = max(max(abs(n.hydro(t,:,:)/ (rms(squeeze(n.b_prime(t,:,:)))* 0.00004))))
hmax2 = max(max(abs(m.hydro(t,:,:)/ (rms(squeeze(m.b_prime(t,:,:)))* 0.00004))))
hmax = max(hmax1, hmax2)

hscale = [-hmax hmax]



figure
pcolor( squeeze( abs( n.hydro(t, 2:60,:) ) /  ( rms(squeeze(n.b_prime(t,:,:))) *0.4 ) ) )
%caxis(hscale),
%caxis( [0 1200])
%colormap(flipud(gray))
shading flat, colorbar 
title('hydrostatic imbalance, convective regime')



figure
pcolor( squeeze( abs( m.hydro(t, 2:60,:) ) /  (rms(squeeze(m.b_prime(t,:,:))) * 4 ) ) )
%caxis( [0 1200])
%caxis(hscale),  
%colormap(flipud(gray))
shading flat, colorbar 
title('hydrostatic imbalance, non convective regime')

















