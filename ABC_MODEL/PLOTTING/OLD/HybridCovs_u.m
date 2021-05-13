%% Hybrids
%%
%% HybridCovs

c = 251

%% LOAD DATA
ens = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_25_covars.nc');
imp = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_25_full.nc');

%% SET UP AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end


%% CALCULATE SCALES

uabs_ens = max(max(abs(ens.u)))
uabs_imp = max(max(abs(imp.u)))
uabs = max(uabs_ens,uabs_imp); 
uscale = [-uabs uabs]

%% CALCULATE HYBRIDS

hb1 = 0.5 * imp.u + 0.5 * ens.u;
hb2 = 0.25 * imp.u + 0.75 * ens.u;
hb3 = 0.75 * imp.u + 0.25 * ens.u;



%% MAKE PLOTS
figure
pcolor(xax, yax, imp.u), caxis(uscale), shading flat, 
colormap(redblue),colorbar, 
title('Implied covariances u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

figure
pcolor(ens.u), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title(' Ensemble covariances u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)


figure
pcolor(hb1), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 1 50-50 u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

figure
pcolor(hb2), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 2 75% ens - u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

figure
pcolor(hb3), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, 
title('Hybrid 3 75% imp u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)


