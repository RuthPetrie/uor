%% Hybrids
%%
%% HybridCovs

c = 61

%% LOAD DATA
ens = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_60_covars.nc');
imp = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_60_full.nc');

%% SET UP AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

make_v_plots = 0
make_b_plots = 1

if make_b_plots == 1

%% CALCULATE SCALES

rabs_ens = max(max(abs(ens.v)))
rabs_imp = max(max(abs(imp.v)))
rabs = max(rabs_ens,rabs_imp); 
rscale = [-rabs rabs]

%% CALCULATE HYBRIDS

hb1 = 0.5 * imp.v + 0.5 * ens.v;
hb2 = 0.25 * imp.v + 0.75 * ens.v;
hb3 = 0.75 * imp.v + 0.25 * ens.v;



%% MAKE PLOTS
figure
pcolor(xax, yax, imp.v), caxis(rscale), shading flat, 
colormap(redblue),colorbar, 
title('Implied covariances \rho`', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

figure
pcolor(xax,yax,ens.v), 
caxis(rscale), 
shading flat, colormap(redblue),colorbar, 
title(' Ensemble covariances \rho`', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )


figure
pcolor(xax,yax,hb1), 
caxis(rscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 1', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14),
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

figure
pcolor(xax,yax,hb2), 
caxis(rscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 2', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

figure
pcolor(xax,yax,hb3), 
caxis(rscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 3', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )
end

if make_v_plots == 1

%% u
uabs_ens = max(max(abs(ens.v)))
uabs_imp = max(max(abs(imp.v)))
uabs = max(uabs_ens,uabs_imp); 
uscale = [-uabs uabs]

%% CALCULATE HYBRIDS

hb1 = 0.5 * imp.v + 0.5 * ens.v;
hb2 = 0.25 * imp.v + 0.75 * ens.v;
hb3 = 0.75 * imp.v + 0.25 * ens.v;



%% MAKE PLOTS
figure
pcolor(xax, yax, imp.v), caxis(uscale), shading flat, 
colormap(redblue),colorbar, 
title('Implied covariances v', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

figure
pcolor(xax,yax,ens.v), 
caxis(uscale/10), 
shading flat, colormap(redblue),colorbar, 
title(' Ensemble covariances v', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )


figure
pcolor(xax,yax,hb1), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 1', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14)
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

figure
pcolor(xax,yax,hb2), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 2', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14),
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

figure
pcolor(xax,yax,hb3), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 3', 'FontSize', 16)
xlabel(['Longitudinal distance  (km)'],'FontSize',14), 
ylabel(['Height    ',10,'(m)   '],'FontSize',14, 'Rotation',0 )

end 
