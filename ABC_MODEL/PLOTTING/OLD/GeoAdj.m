%% Plot geostrophic adjustment procedure

% GeoAdj


xcontinue = 11

%% LOAD DATA
d = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/GeoAdjst_10.nc');

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

 ii = 100 ;
 kk = 20;
 for k = 1:7
  for i = 1:17
    X2(k,i) = ii;
    Y2(k,i) = kk;
    ii = ii + 10;
   end
   ii = 100;
   kk = kk +3;
 end

%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

%%
plottemp = 0

if plottemp == 1

figure

%subplot(3,2,1)
[ct,g] = contourf(xax(100:260), yax(20:40),squeeze(d.rho_prime(1,20:40,100:260)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
 
end 

 for k = 1:60
 Yax(k) = k;
 end
 for i = 1:360
 Xax(i) = i;
 end

%%
%figure

makeanim = 0
plotstills = 1

%%
 if plotstills == 1 

h = figure
set(h, 'Position', [360 80 762 825])
annotation1 = annotation(...
   h,'textbox',...
  'Position',[0.3321 0.47 0.5 0.5],...
  'LineStyle','none',...
  'FitHeightToText','off',...
  'String',{params});
 
 
% time 1 is initial condition.
% each time increment is 6 mins 
% 1+10 is per hour

time1 = 1 
time2 = 2
time3 = 3
time4 = 4

subplot(2,2,1)
[ct,g] = contourf(Xax, Yax,squeeze(d.rho_prime(time1,:,:)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(X2,Y2, squeeze(d.u(time1,20:3:40,100:10:260)), squeeze(d.v(time1,20:3:40,100:10:260)),1, 'r' )
axis tight
title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

%figure
subplot(2,2,2)
[c,h] = contourf(Xax(100:260), Yax(20:40),squeeze(d.rho_prime(time2,20:40,100:260))); axis tight
caxis(Vax), colormap(flipud(gray)), colorbarf(ct,g), 
hold on
quiver(X2,Y2, squeeze(d.u(time2,20:3:40,100:10:260)), squeeze(d.v(time2,20:3:40,100:10:260)),1, 'r' )
axis tight
title('1 hour')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12)


%figure
subplot(2,2,3)
[c,h] = contourf(Xax(100:260), Yax(20:40),squeeze(d.rho_prime(time3,20:40,100:260)));axis tight
caxis(Vax), colormap(flipud(gray)), colorbarf(ct,g), 
hold on
quiver(X2,Y2, squeeze(d.u(time3,20:3:40,100:10:260)), squeeze(d.v(time3,20:3:40,100:10:260)),1, 'r' )
axis tight
title('2 hour')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12)

%subplot(3,2,4)
%[c,h] = contourf(Xax(100:260), Yax(20:40),squeeze(d.rho_prime(4,20:40,100:260)));axis tight
%caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g),  
%hold on
%quiver(X,Y, squeeze(d.u(4,20:3:40,100:10:260)), squeeze(d.v(4,20:3:40,100:10:260)),1, 'k' )
%axis tight

%subplot(3,2,5)
%[c,h] = contourf(Xax(100:260), Yax(20:40),squeeze(d.rho_prime(5,20:40,100:260)));axis tight
%caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g),  
%hold on
%quiver(X,Y, squeeze(d.u(5,20:3:40,100:10:260)), squeeze(d.v(5,20:3:40,100:10:260)),1, 'k' )
%axis tight

%figure
subplot(2,2,4)
[c,h] = contourf(Xax(100:260), Yax(20:40),squeeze(d.rho_prime(time4,20:40,100:260))); axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g),  
hold on
quiver(X2,Y2, squeeze(d.u(time4,20:3:40,100:10:260)), squeeze(d.v(time4,20:3:40,100:10:260)),1, 'r' )
axis tight
title('3 hours')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12)

%% show labels on contour plots
%set(g,'ShowText','on','TextStep',get(g,'LevelStep')*2)

%figure
%subplot(2,2,1)
%contourf(xax(100:260), yax(20:40),squeeze(d.rho_prime(1,20:40,100:260)))

%annotation1 = annotation(...
%   h,'textbox',...
%  'Position',[0.1821 0.0214 0.2446 0.3143],...
%  'LineStyle','none',...
%  'FitHeightToText','off',...
%  'String',[{params}]);

% ii = 100 ;
% kk = 20;
% for k = 1:7
%  for i = 1:17
%    X2(k,i) = ii;
%    Y2(k,i) = kk;
%    ii = ii + 10;
%   end
%   ii = 100;
%   kk = kk +3;
%end



%%% For quiver plots
 ii = 1;
 kk = 1;
 for k = 1:20
  for i = 1:36
    X(k,i) = ii;
    Y(k,i) = kk;
    ii = ii + 10;
   end
   ii = 1;
   kk = kk +3;
 end



h = figure
set(h, 'Position', [360 99 762 825])
annotation1 = annotation(...
   h,'textbox',...
  'Position',[0.3321 0.47 0.5 0.5],...
  'LineStyle','none',...
  'FitHeightToText','off',...
  'String',{params});
 
 
% time 1 is initial condition.
% each time increment is 6 mins 
% 1+10 is per hour

subplot(2,2,1)
[ct,g] = contourf(Xax, Yax,squeeze(d.rho_prime(time1,:,:)));axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g), 
hold on,
quiver(X,Y, squeeze(d.u(time1,1:3:60,1:10:360)), squeeze(d.v(time1,1:3:60,1:10:360)),1, 'r' )
axis tight
title('Initial condition')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )

%figure
subplot(2,2,2)
[c,h] = contourf(Xax, Yax,squeeze(d.rho_prime(time2,:,:))); axis tight
caxis(Vax), colormap(flipud(gray)), colorbarf(ct,g), 
hold on
quiver(X,Y, squeeze(d.u(time2,1:3:60,1:10:360)), squeeze(d.v(time2,1:3:60,1:10:360)),1, 'r' )
axis tight
title('1 hour')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12)


%figure
subplot(2,2,3)
[c,h] = contourf(Xax, Yax,squeeze(d.rho_prime(time3,:,:)));axis tight
caxis(Vax), colormap(flipud(gray)), colorbarf(ct,g), 
hold on
quiver(X,Y, squeeze(d.u(time3,1:3:60,1:10:360)), squeeze(d.v(time3,1:3:60,1:10:360)),1, 'r' )
axis tight
title('2 hour')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12)

subplot(2,2,4)
[c,h] = contourf(Xax, Yax,squeeze(d.rho_prime(time4,:,:))); axis tight
caxis(Vax), colormap(flipud(gray)),colorbarf(ct,g),  
hold on
quiver(X,Y, squeeze(d.u(time4,1:3:60,1:10:360)), squeeze(d.v(time4,1:3:60,1:10:360)),1, 'r' )
axis tight
title('3 hours')
xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12)



end


%% MAKE ANIMATION
 if makeanim == 1 
 
  for t = 1:time
    t
    h = figure(1)

   [ct,g] = contourf(Xax(100:260), Yax(20:40),squeeze(d.rho_prime(t,20:40,100:260)));
   colormap(flipud(gray)),caxis(Vax),axis tight
   colorbarf(ct,g), 
   hold on,
   quiver(X,Y, squeeze(d.u(t,20:3:40,100:10:260)), squeeze(d.v(t,20:3:40,100:10:260)),1, 'r' )
   axis tight
   title(['t = ',num2str(timemins(t)), ' mins'], 'FontSize',16)
   xlabel(['Longitude',10,'(km)'],'FontSize',16), ylabel(['Height',10,'(m)'],'FontSize',16 )
  
    
    if t < 10
    filename = sprintf('/export/carrot/raid2/wx019276/DATA/MODEL/ANIMS/geo_adj_anim_0%d',t);
    else
    filename = sprintf('/export/carrot/raid2/wx019276/DATA/MODEL/ANIMS/geo_adj_anim_%d',t);
    end    
    print('-dpng', filename);

    close %% close plot
  end

 
 end
 
