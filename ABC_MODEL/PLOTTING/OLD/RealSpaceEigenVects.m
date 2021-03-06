% RealSpaceEigenVects

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end


cont = 4

%% LOAD FILES
efs1 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_057.nc');
efs2 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_058.nc');
efs3 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_059.nc');
nrows = 5;
ncolumns = 3;
k = 2

% Make plot

h = figure
set(h, 'Position', [360 44 700 835])%[360 346 881 542])

subplot(nrows,ncolumns,1),hold on
norm_fact = max(max(abs(efs1.u(:,k))), max(max(abs(efs2.u(:,k))),max(abs(efs3.u(:,k)))));
plot(efs3.u(:,k), 'k'), plot(efs2.u(:,k), 'k--'), plot(efs1.u(:,k), 'k:')
shading flat,  view(90, -90), %title(['acoustic',10,'u-component'])
xlabel('Vertical level')
title('Acoustic modes')


subplot(nrows,ncolumns,4),hold on
norm_fact = max(max(abs(efs1.v(:,k))), max(max(abs(efs2.v(:,k))),max(abs(efs3.v(:,k)))));
plot(efs3.v(:,k), 'k'), plot(efs2.v(:,k), 'k--'), plot(efs1.v(:,k), 'k:')
shading flat,  view(90, -90)%, title('v-component')
xlabel('Vertical level')

subplot(nrows,ncolumns,7),hold on
norm_fact = max(max(abs(efs1.w(:,k))), max(max(abs(efs2.w(:,k))),max(abs(efs3.w(:,k)))));
plot(efs3.w(:,k), 'k'), plot(efs2.w(:,k), 'k--'), plot(efs1.w(:,k), 'k:')
shading flat,  view(90, -90)%, title('w-component')
xlabel('Vertical level')

subplot(nrows,ncolumns,10),hold on
norm_fact = max(max(abs(efs1.rho_prime(:,k))), max(max(abs(efs2.rho_prime(:,k))),max(abs(efs3.rho_prime(:,k)))));
plot(efs3.rho_prime(:,k), 'k'), plot(efs2.rho_prime(:,k), 'k--'), plot(efs1.rho_prime(:,k), 'k:')
shading flat,  view(90, -90)%, title('\rho`-component')
xlabel('Vertical level')

subplot(nrows,ncolumns,13),hold on
norm_fact = max(max(abs(efs1.b_prime(:,k))), max(max(abs(efs2.b_prime(:,k))),max(abs(efs3.b_prime(:,k)))));
plot(efs3.b_prime(:,k), 'k'), plot(efs2.b_prime(:,k), 'k--'), plot(efs1.b_prime(:,k), 'k:')
shading flat,  view(90, -90)%, title('b`-component')
xlabel('Vertical level')

l = legend('\mu = 59','\mu = 58', '\mu = 57','Location', 'South')

%% LOAD FILES
efs1 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_062.nc');
efs2 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_063.nc');
efs3 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_064.nc');

subplot(nrows,ncolumns,2),hold on
norm_fact = max(max(abs(efs1.u(:,k))), max(max(abs(efs2.u(:,k))),max(abs(efs3.u(:,k)))));
plot(efs1.u(:,k), 'k'), plot(efs2.u(:,k), 'k--'), plot(efs3.u(:,k), 'k:')
shading flat,  view(90, -90),% title(['gravity',10, 'u-component'])
%xlabel('level')
title('Gravity modes')

subplot(nrows,ncolumns,5),hold on
norm_fact = max(max(abs(efs1.v(:,k))), max(max(abs(efs2.v(:,k))),max(abs(efs3.v(:,k)))));
plot(efs1.v(:,k), 'k'), plot(efs2.v(:,k), 'k--'), plot(efs3.v(:,k), 'k:')
shading flat,  view(90, -90)%, title('v-component')

subplot(nrows,ncolumns,8),hold on
norm_fact = max(max(abs(efs1.w(:,k))), max(max(abs(efs2.w(:,k))),max(abs(efs3.w(:,k)))));
plot(efs1.w(:,k), 'k'), plot(efs2.w(:,k), 'k--'), plot(efs3.w(:,k), 'k:')
shading flat,  view(90, -90)%, title('w-component')

subplot(nrows,ncolumns,11),hold on
norm_fact = max(max(abs(efs1.rho_prime(:,k))), max(max(abs(efs2.rho_prime(:,k))),max(abs(efs3.rho_prime(:,k)))));
plot(efs1.rho_prime(:,k), 'k'), plot(efs2.rho_prime(:,k), 'k--'), plot(efs3.rho_prime(:,k), 'k:')
shading flat,  view(90, -90)%, title('\rho`-component')

subplot(nrows,ncolumns,14),hold on
norm_fact = max(max(abs(efs1.b_prime(:,k))), max(max(abs(efs2.b_prime(:,k))),max(abs(efs3.b_prime(:,k)))));
plot(efs1.b_prime(:,k), 'k'), plot(efs2.b_prime(:,k), 'k--'), plot(efs3.b_prime(:,k), 'k:')
shading flat,  view(90, -90)%, title('b`-component')
l = legend('\mu = 62','\mu = 63', '\mu = 64','Location', 'South')

%% LOAD FILES
efs1 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_177.nc');
efs2 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_178.nc');
efs3 = load_netcdf_struct ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_ref_179.nc');


subplot(nrows,ncolumns,3),hold on
norm_fact = max(max(abs(efs1.u(:,k))), max(max(abs(efs2.u(:,k))),max(abs(efs3.u(:,k)))));
plot(efs3.u(:,k), 'k'), hold on, plot(efs2.u(:,k), 'k--'), plot(efs1.u(:,k), 'k:')
shading flat,   
view(90, -90), 
title(['Balanced modes']) 
%xlabel('level')%,title('u-component')

subplot(nrows,ncolumns,6),hold on
norm_fact = max(max(abs(efs1.v(:,k))), max(max(abs(efs2.v(:,k))),max(abs(efs3.v(:,k)))));
plot(efs3.v(:,k), 'k'), plot(efs2.v(:,k), 'k--'), plot(efs1.v(:,k), 'k:')
shading flat,  view(90, -90), 
%title('v-component')

subplot(nrows,ncolumns,9),hold on
norm_fact = max(max(abs(efs1.w(:,k))), max(max(abs(efs2.w(:,k))),max(abs(efs3.w(:,k)))));
plot(efs3.w(:,k), 'k'), %plot(efs2.w(:,k), 'k--'), plot(efs3.w(:,k), 'k:')
shading flat,view(90, -90), 
%title('w-component')

subplot(nrows,ncolumns,12),hold on
norm_fact = max(max(abs(efs1.rho_prime(:,k))), max(max(abs(efs2.rho_prime(:,k))),max(abs(efs3.rho_prime(:,k)))));
plot(efs3.rho_prime(:,k), 'k'), plot(efs2.rho_prime(:,k), 'k--'), plot(efs1.rho_prime(:,k), 'k:')
shading flat,  view(90, -90), 
%title('\rho`-component')

subplot(nrows,ncolumns,15),hold on
norm_fact = max(max(abs(efs1.b_prime(:,k))), max(max(abs(efs2.b_prime(:,k))),max(abs(efs3.b_prime(:,k)))));
plot(efs3.b_prime(:,k), 'k'), plot(efs2.b_prime(:,k), 'k--'), plot(efs1.b_prime(:,k), 'k:')
shading flat,  view(90, -90), 
%title('b`-component')
l= legend('\mu = 179','\mu = 178', '\mu = 177','Location', 'South')
