%% EXAMINE IMPLIED COVARIANCES
%
% EnsCovars

% LOAD DATA
%-------------------------------------------------------------------

CONT = 62

%covs = load_nc_struct('/home/wx019276/DATA/ENSEMBLE/STATS/structfun_r_180_30_10.nc');
%covs = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/ens_10_covars.nc');
%covs = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Ensm_averag6.nc');
%covs = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/ens_10_correlations.nc');
covs = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_62_covars.nc');
impcovs = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_62_full.nc');
ensemble = 'Ensemble 33'
uabs1 = max(max(abs(covs.u)))
vabs1 = max(max(abs(covs.v)))
wabs1 = max(max(abs(covs.w)))
rabs1 = max(max(abs(covs.rho_prime)))
babs1 = max(max(abs(covs.b_prime)))

uabs2 = max(max(abs(impcovs.u)))
vabs2 = max(max(abs(impcovs.v)))
wabs2 = max(max(abs(impcovs.w)))
rabs2 = max(max(abs(impcovs.rho_prime)))
babs2 = max(max(abs(impcovs.b_prime)))

uabs = max(uabs1, uabs2)
vabs = max(vabs1, vabs2)
wabs = max(wabs1, wabs2)
rabs = max(rabs1, rabs2)
babs = max(babs1, babs2)


uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]
scale = [-1.0 1.0]
%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

h = figure

%set(h, 'Position',  [360 346 881 542])
%set(h, 'Position', [360 77 744 783])
set(h, 'Position', [118 65 762 787])%[79 198 1025 584])

cross(1:360,1:60) = 0;
cross(180,30)  = 30;
rows = 5;
columns = 2;

subplot(rows,columns,1)
%figure
pcolor(covs.rho_prime), 
hold on, plot(cross, 'kx')
caxis(rscale), 
shading flat, colormap(redblue),colorbar, title('\rho`', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,2)
%figure
pcolor(impcovs.rho_prime), 
hold on, plot(cross, 'kx')
caxis(rscale), 
shading flat, colormap(redblue),colorbar, title('\rho`', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,3)
%figure
pcolor(covs.v), 
hold on, plot(cross, 'kx')
caxis(vscale), 
shading flat,colormap(redblue),colorbar, title('v', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,4)
%figure
pcolor(impcovs.v), 
hold on, plot(cross, 'kx')
caxis(vscale), 
shading flat,colormap(redblue),colorbar, title('v', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,5)
%figure
pcolor(covs.b_prime), 
hold on, plot(cross, 'kx')
caxis(bscale), 
shading flat,colormap(redblue),colorbar, title('b`', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,6)
%figure
pcolor(impcovs.b_prime), 
hold on, plot(cross, 'kx')
caxis(bscale), 
shading flat,colormap(redblue),colorbar, title('b`', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,7)
%figure
pcolor(covs.u), shading flat, colorbar
hold on, plot(cross, 'kx'),
caxis(uscale), 
shading flat, colormap(redblue),colorbar, title('u', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,8)
%figure
pcolor(impcovs.u), shading flat, colorbar
hold on, plot(cross, 'kx'),
caxis(uscale), 
shading flat, colormap(redblue),colorbar, title('u', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,9)
%figure
pcolor(covs.w), 
hold on, plot(cross, 'kx')
caxis(wscale), 
shading flat,colormap(redblue),colorbar, title('w', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,10)
%figure
pcolor(impcovs.w), 
hold on, plot(cross, 'kx')
caxis(wscale), 
shading flat,colormap(redblue),colorbar, title('w', 'FontSize', 12)
%xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )











tot = 3
subplot(rows,columns,6)
%figure
pcolor(covs.b_prime), 
hold on, plot(cross, 'kx')
caxis([-1E-4 1E-4]), 
shading flat,colormap(redblue),colorbar, title('b`', 'FontSize', 12)

% Create textbox
%  'Position',[0.6799 0.3202 0.0996 0.1213],...
%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.709 0.092 0.134 0.346],...%[0.5821 0.0214 0.2446 0.3143],...
%  'LineStyle','none',...
%  'FitHeightToText','off',...
%  'String',{'Ensemble covariances',...
%   ensemble,...
%  '3 hour forecasts'});


