%% EXAMINE IMPLIED COVARIANCES
% ImpliedCovs

cont = 62

% LOAD DATA
%-------------------------------------------------------------------
%ics = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_28.nc');

%stdfull = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_14_full.nc');
%incfull = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_21_full.nc');
%decfull = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_23_full.nc');
%stdbal = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_14_balanced.nc');
%incbal= load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_21_balanced.nc');
%decbal = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_23_balanced.nc');

full = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_62_full.nc');
bal = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_62_bal.nc');
grav = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_62_grav.nc');
acc = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_62_ac.nc');


ensemble = 'Ensemble 53'
coriolis = 'f = 1.10^{-3}'
parA = 'A = 4.10^{-5} '
parB = 'B = 5.10^{-3} '
parC = 'C = 1.10^{5}'
%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

array_plot = 1

if array_plot == 1

uabs = (max(max(abs(full.u(:,:)))))%*1.1
vabs = (max(max(abs(full.v(:,:)))))%*1.1
wabs = (max(max(abs(full.w(:,:)))))%*1.1
rabs = (max(max(abs(full.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(full.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]


%figure, pcolor(xax, yax, full.rho_prime), caxis(rscale), shading flat, colormap(redblue), colorbar
%xlabel(['Longitude',10,'(km)'],'FontSize',14), 
%ylabel(['Height',10,'(m)'],'FontSize',14 )

%figure, pcolor(xax, yax, full.v), caxis(vscale), shading flat, colormap(redblue), colorbar
%xlabel(['Longitude',10,'(km)'],'FontSize',14), 
%ylabel(['Height',10,'(m)'],'FontSize',14 )

%figure, pcolor(xax, yax, full.b_prime), caxis(bscale), shading flat, colormap(redblue), colorbar
%xlabel(['Longitude',10,'(km)'],'FontSize',14), 
%ylabel(['Height',10,'(m)'],'FontSize',14 )

%figure, pcolor(xax, yax, full.u), caxis(uscale), shading flat, colormap(redblue), colorbar
%xlabel(['Longitude',10,'(km)'],'FontSize',14), 
%ylabel(['Height',10,'(m)'],'FontSize',14 )

%figure, pcolor(xax, yax, full.w), caxis(wscale), shading flat, colormap(redblue), colorbar
%xlabel(['Longitude',10,'(km)'],'FontSize',14), 
%ylabel(['Height',10,'(m)'],'FontSize',14 )


h = figure
set(h, 'Position',[301 47 795 810])
nrows = 5;
ncols = 4;

subplot(nrows,ncols,1), pcolor(xax, yax, full.rho_prime), caxis(rscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[]) 
%title({'Total','implied covariance'},'FontSize',14), ylabel('\rho`', 'Rotation',0,'FontSize',14)
subplot(nrows,ncols,5), pcolor(xax, yax, full.v), caxis(vscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,9), pcolor(xax, yax, full.b_prime), caxis(bscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,13), pcolor(xax, yax, full.u), caxis(uscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,17), pcolor(xax, yax, full.w), caxis(wscale), shading flat, colormap(redblue)

subplot(nrows,ncols,2), pcolor(xax, yax, bal.rho_prime), caxis(rscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
%title({'Balanced','mode only'})
subplot(nrows,ncols,6), pcolor(xax, yax, bal.v), caxis(vscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,10), pcolor(xax, yax, bal.b_prime), caxis(bscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,14), pcolor(xax, yax, bal.u), caxis(uscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,18), pcolor(xax, yax, bal.w), caxis(wscale), shading flat, colormap(redblue)
AX = gca; set(AX,'YTick',[]) 

subplot(nrows,ncols,3), pcolor(xax, yax, grav.rho_prime), caxis(rscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
%title({'Gravity','modes only'})
subplot(nrows,ncols,7), pcolor(xax, yax, grav.v), caxis(vscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,11), pcolor(xax, yax, grav.b_prime), caxis(bscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,15), pcolor(xax, yax, grav.u), caxis(uscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,19), pcolor(xax, yax, grav.w), caxis(wscale), shading flat, colormap(redblue)
AX = gca; set(AX,'YTick',[]) 

subplot(nrows,ncols,4), pcolor(xax, yax, acc.rho_prime), caxis(rscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
%title({'Acoustic','modes only'})
subplot(nrows,ncols,8), pcolor(xax, yax, acc.v), caxis(vscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,12), pcolor(xax, yax, acc.b_prime), caxis(bscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,16), pcolor(xax, yax, acc.u), caxis(uscale), shading flat, colormap(redblue)
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,20), pcolor(xax, yax, acc.w), caxis(wscale), shading flat, colormap(redblue)
AX = gca; set(AX,'YTick',[]) 

h2 = figure
set(h2, 'Position',[301 47 795 810])

subplot(nrows,ncols,1), pcolor(xax, yax, full.rho_prime), caxis(rscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,5), pcolor(xax, yax, full.v), caxis(vscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,9), pcolor(xax, yax, full.b_prime), caxis(bscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,13), pcolor(xax, yax, full.u), caxis(uscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[]) 
subplot(nrows,ncols,17), pcolor(xax, yax, full.w), caxis(wscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[100 300 500])

uabs = (max(max(abs(bal.u(:,:)))))%*1.1
vabs = (max(max(abs(bal.v(:,:)))))%*1.1
wabs = (max(max(abs(bal.w(:,:)))))%*1.1
rabs = (max(max(abs(bal.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(bal.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]

subplot(nrows,ncols,2), pcolor(xax, yax, bal.rho_prime), caxis(rscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,6), pcolor(xax, yax, bal.v), caxis(vscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,10), pcolor(xax, yax, bal.b_prime), caxis(bscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,14), pcolor(xax, yax, bal.u), caxis(uscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,18), pcolor(xax, yax, bal.w), caxis(wscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[100 300 500],'YTick',[]) 

uabs = (max(max(abs(grav.u(:,:)))))%*1.1
vabs = (max(max(abs(grav.v(:,:)))))%*1.1
wabs = (max(max(abs(grav.w(:,:)))))%*1.1
rabs = (max(max(abs(grav.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(grav.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]

subplot(nrows,ncols,3), pcolor(xax, yax, grav.rho_prime), caxis(rscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,7), pcolor(xax, yax, grav.v), caxis(vscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,11), pcolor(xax, yax, grav.b_prime), caxis(bscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,15), pcolor(xax, yax, grav.u), caxis(uscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,19), pcolor(xax, yax, grav.w), caxis(wscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[100 300 500],'YTick',[]) 

uabs = (max(max(abs(acc.u(:,:)))))%*1.1
vabs = (max(max(abs(acc.v(:,:)))))%*1.1
wabs = (max(max(abs(acc.w(:,:)))))%*1.1
rabs = (max(max(abs(acc.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(acc.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]

subplot(nrows,ncols,4), pcolor(xax, yax, acc.rho_prime), caxis(rscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,8), pcolor(xax, yax, acc.v), caxis(vscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,12), pcolor(xax, yax, acc.b_prime), caxis(bscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,16), pcolor(xax, yax, acc.u), caxis(uscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[],'YTick',[]) 
subplot(nrows,ncols,20), pcolor(xax, yax, acc.w), caxis(wscale), shading flat, colormap(redblue),colorbar,
AX = gca; set(AX,'XTick',[100 300 500],'YTick',[]) 

end
plotting = 0

if plotting == 1

%%%% FULL COVS %%%%%

uabs = (max(max(abs(full.u(:,:)))))%*1.1
vabs = (max(max(abs(full.v(:,:)))))%*1.1
wabs = (max(max(abs(full.w(:,:)))))%*1.1
rabs = (max(max(abs(full.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(full.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]
scale = [-1.0 1.0]
h = figure

set(h, 'Position', [79 198 1025 584])%[360 77 744 783])


rows = 2;
columns = 3;
subplot(rows,columns,1)
%figure
pcolor(xax, yax, full.u), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar,% title('u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )

subplot(rows,columns,2)
%figure
pcolor(xax, yax, full.v), caxis(vscale), shading flat,
colormap(redblue),colorbar, %title('v' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,3)
%figure
pcolor(xax, yax, full.w), caxis(wscale), shading flat,
colormap(redblue),colorbar, %title('w', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,4)
%figure
pcolor(xax, yax, full.rho_prime), caxis(rscale), shading flat, 
colormap(redblue),colorbar, %title('\rho`', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

subplot(rows,columns,5)
%figure
pcolor(xax, yax, full.b_prime), 
caxis(bscale), 
shading flat,colormap(redblue),colorbar,% title('b`' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )

% Create textbox
%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.709 0.092 0.134 0.346],...%[0.592 0.179 0.295 0.137],...
%  'LineStyle','none',...
%  'String',[{'Structure function of \rho`(180, 30)',...
%  'positive perturbation',...
%   ensemble,'All modes',...
%   parA,parB, parC,...
%   coriolis}]);
%  'Acoustic response',...
%  'truncation', ...
%  'p1 <20  = 0 (small ei large m)',...
 % 'p5 all  = 0 '});
%  'FitHeightToText','on');

%   filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/temp');
%   print('-dpng', filename);

%%%% END OF FULL COVS %%%%%

%%%% BALANCED COVS %%%%%

uabs = (max(max(abs(bal.u(:,:)))))%*1.1
vabs = (max(max(abs(bal.v(:,:)))))%*1.1
wabs = (max(max(abs(bal.w(:,:)))))%*1.1
rabs = (max(max(abs(bal.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(bal.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]
%scale = [-1.0 1.0]
h = figure

set(h, 'Position',[79 198 1025 584])%[360 77 744 783])


subplot(rows,columns,1)
%figure
pcolor(xax, yax, bal.u), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, %title('u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,2)
%figure
pcolor(xax, yax, bal.v), caxis(vscale), shading flat,
colormap(redblue),colorbar, %title('v' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,3)
%figure
pcolor(xax, yax, bal.w), caxis(wscale), shading flat,
colormap(redblue),colorbar, %title('w', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,4)
%figure
pcolor(xax, yax, bal.rho_prime), caxis(rscale), shading flat, 
colormap(redblue),colorbar,% title('\rho`', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

subplot(rows,columns,5)
%figure
pcolor(xax, yax, bal.b_prime), 
caxis(bscale), 
shading flat,colormap(redblue),colorbar,% title('b`' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )

% Create textbox
%annotation1 = annotation(...
%  h,'textbox',...
% 'Position',[0.709 0.092 0.134 0.346],...%[0.592 0.179 0.295 0.137],...
% 'LineStyle','none',...
%  'String',[{'Structure function of \rho`(180, 30)',...
%  'positive perturbation',...
%   ensemble,'Balanced modes',...
%   parA,parB, parC,...
%   coriolis}]);
%  'Acoustic response',...
%  'truncation', ...
%  'p1 <20  = 0 (small ei large m)',...
 % 'p5 all  = 0 '});
%  'FitHeightToText','on');

%   filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/temp');
%   print('-dpng', filename);

%%%% END OF BALANCED COVS %%%%%

%%%% GRAVITY COVS %%%%%

uabs = (max(max(abs(grav.u(:,:)))))%*1.1
vabs = (max(max(abs(grav.v(:,:)))))%*1.1
wabs = (max(max(abs(grav.w(:,:)))))%*1.1
rabs = (max(max(abs(grav.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(grav.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]
%scale = [-1.0 1.0]
h = figure

set(h, 'Position', [79 198 1025 584])%[360 77 744 783])


subplot(rows,columns,1)
%figure
pcolor(xax, yax, grav.u), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, %title('u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,2)
%figure
pcolor(xax, yax, grav.v), caxis(vscale), shading flat,
colormap(redblue),colorbar, %title('v' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,3)
%figure
pcolor(xax, yax, grav.w), caxis(wscale), shading flat,
colormap(redblue),colorbar, %title('w', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,4)
%figure
pcolor(xax, yax, grav.rho_prime), caxis(rscale), shading flat, 
colormap(redblue),colorbar, %title('\rho`', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

subplot(rows,columns,5)
%figure
pcolor(xax, yax, grav.b_prime), 
caxis(bscale), 
shading flat,colormap(redblue),colorbar,% title('b`' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )

% Create textbox
%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.709 0.092 0.134 0.346],...%[0.592 0.179 0.295 0.137],...
%  'LineStyle','none',...
% 'String',[{'Structure function of \rho`(180, 30)',...
% 'positive perturbation',...
%   ensemble,'Gravity modes',...
%   parA,parB, parC,...
%   coriolis}]);
%  'Acoustic response',...
%  'truncation', ...
%  'p1 <20  = 0 (small ei large m)',...
 % 'p5 all  = 0 '});
%  'FitHeightToText','on');

%   filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/temp');
%   print('-dpng', filename);

%%%% END OF GRAVITY COVS %%%%%

%%%% ACOUSTIC COVS %%%%%

uabs = (max(max(abs(acc.u(:,:)))))%*1.1
vabs = (max(max(abs(acc.v(:,:)))))%*1.1
wabs = (max(max(abs(acc.w(:,:)))))%*1.1
rabs = (max(max(abs(acc.rho_prime(:,:)))))%*1.1
babs = (max(max(abs(acc.b_prime(:,:)))))%*1.1
uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]
%scale = [-1.0 1.0]
h = figure; set(h, 'Position', [79 198 1025 584])%[360 77 744 783])


subplot(rows,columns,1)
%figure
pcolor(xax, yax, acc.u), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar,% title('u', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',12), 
ylabel(['Height',10,'(m)'],'FontSize',12 )

subplot(rows,columns,2)
%figure
pcolor(xax, yax, acc.v), caxis(vscale), shading flat,
colormap(redblue),colorbar,% title('v' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,3)
%figure
pcolor(xax, yax, acc.w), caxis(wscale), shading flat,
colormap(redblue),colorbar,% title('w', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )


subplot(rows,columns,4)
%figure
pcolor(xax, yax, acc.rho_prime), caxis(rscale), shading flat, 
colormap(redblue),colorbar,% title('\rho`', 'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14)

subplot(rows,columns,5)
%figure
pcolor(xax, yax, acc.b_prime), 
caxis(bscale), 
shading flat,colormap(redblue),colorbar, %title('b`' ,'FontSize', 16)
xlabel(['Longitude',10,'(km)'],'FontSize',14), 
ylabel(['Height',10,'(m)'],'FontSize',14 )

% Create textbox
%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.709 0.092 0.134 0.346],...%[0.592 0.179 0.295 0.137],...
%  'LineStyle','none',...
%  'String',[{'Structure function of \rho`(180, 30)',...
%  'positive perturbation',...
%   ensemble,'Acoustic modes',...
%   parA,parB, parC,...
%   coriolis}]);
%  'Acoustic response',...
%  'truncation', ...
%  'p1 <20  = 0 (small ei large m)',...
 % 'p5 all  = 0 '});
%  'FitHeightToText','on');

%   filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/temp');
%   print('-dpng', filename);

%%%% END OF ACOUSTIC COVS %%%%%


end


comparison = 0

if comparison == 1

h = figure
scale = [-0.005 0.005]
set(h, 'Position', [360 99 762 825])
nrows = 3;
ncols = 2;

subplot(nrows,ncols,1)
pcolor(xax,yax,stdfull.v), shading flat, caxis(scale), colormap(redblue), colorbar
title('regular - v - all modes')

subplot(nrows,ncols,3)
pcolor(xax,yax,incfull.v), shading flat, caxis(scale), colormap(redblue), colorbar
title('increased f - v - all modes')

subplot(nrows,ncols,5)
pcolor(xax,yax,decfull.v), shading flat, caxis(scale), colormap(redblue), colorbar
title('decreased f - v - all modes')

subplot(nrows,ncols,2)
pcolor(xax,yax,stdbal.v), shading flat, caxis(scale), colormap(redblue), colorbar
title('regular - v - balanced mode')

subplot(nrows,ncols,4)
pcolor(xax,yax,incbal.v), shading flat, caxis(scale), colormap(redblue), colorbar
title('increased f - v - balanced mode')

subplot(nrows,ncols,6)
pcolor(xax,yax,decbal.v), shading flat, caxis(scale), colormap(redblue), colorbar
title('decreased f - v - balanced mode')


end

