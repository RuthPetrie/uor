%% Plot geostrophic adjustment procedure

% GeoAdj


xcontinue = 681

%% LOAD DATA
d = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/GeoAdjst_68.nc');

params = 'A = 10^{-4}, B = 10^{-2}, C = 10^{4}, f = 10^{-4}'

[time,t1] = size(d.time);
times(1) = 0;
for t = 1: time
    times(t) = d.time(t,1);
end
for i = 1:time
timemins(i) = times(i) / 60;
end
Vax = [0 0.01];

 kk = 3;
 for k = 1:20
  for i = 1:36
    X2(k,i) = kk;
  end
   kk = kk +3;
 end
 
 ii = 10;
 for i = 1:36
  for k = 1:20
    Y2(k,i) = ii;
  end
 ii = ii + 10;
 end

%% AXES
for i = 1:360
  xax(i) = i;% * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j;% * 256.7;
end

%%
%figure

makeanim = 0;
plotstills = 1;

%%
 if plotstills == 1 

% h = figure
% set(h, 'Position', [360 80 762 825])
% annotation1 = annotation(...
%    h,'textbox',...
%   'Position',[0.3321 0.47 0.5 0.5],...
%   'LineStyle','none',...
%   'FitHeightToText','off',...
%   'String',{params});
%  
 
% time 1 is initial condition.
% each time increment is 6 mins 
% 1+10 is per hour

time1 = 1; 
time2 = 7;
time3 = 13;
time4 = 25;
time5 = 37;
figure
%subplot(2,2,1)
[ct,g] = contourf(xax(1:360), yax(1:60),squeeze(d.rho_prime(time1,1:60,1:360)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(Y2,X2,squeeze(d.u(time1,3:3:60,10:10:360)), squeeze(d.v(time1,3:3:60,10:10:360)),1, 'r' )
%title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

figure
%subplot(2,2,2)
[ct,g] = contourf(xax(1:360), yax(1:60),squeeze(d.rho_prime(time2,1:60,1:360)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(Y2,X2,squeeze(d.u(time2,3:3:60,10:10:360)), squeeze(d.v(time2,3:3:60,10:10:360)),1, 'r' )
%title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )
%%
figure
%subplot(2,2,3)
[ct,g] = contourf(xax(1:360), yax(1:60),squeeze(d.rho_prime(time3,1:60,1:360)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(Y2,X2,squeeze(d.u(time3,3:3:60,10:10:360)), squeeze(d.v(time3,3:3:60,10:10:360)),1, 'r' )
%title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )
%%
figure
%subplot(2,2,4)
[ct,g] = contourf(xax(1:360), yax(1:60),squeeze(d.rho_prime(time4,1:60,1:360)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(Y2,X2,squeeze(d.u(time4,3:3:60,10:10:360)), squeeze(d.v(time4,3:3:60,10:10:360)),1, 'r' )
%title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )
%%
figure
[ct,g] = contourf(xax(1:360), yax(1:60),squeeze(d.rho_prime(time5,1:60,1:360)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(Y2,X2,squeeze(d.u(time5,3:3:60,10:10:360)), squeeze(d.v(time5,3:3:60,10:10:360)),1, 'r' )
%title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )



 end
