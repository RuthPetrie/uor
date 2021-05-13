d = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/geost_adjmt.nc');

Vax = [0 0.01];
%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

for k = 1:20
  k * 3;
 for i = 1:36
     i * 10;
   X(k, i) = xax(i);
   Y(k, i) = yax(k);
 end 
end


for i = 1:36
 for k = 1:20
    U(k,i) = squeeze(d.u(2,k*3,i*10));
    V(k,i) = squeeze(d.v(2,k*3,i*10));
 end
end

%for i = 1:36
% for k = 1:20
%  for t = 1:13
%    U(t,k,i) = squeeze(d.u(t,k*3,i*10));
%    V(t,k,i) = squeeze(d.v(t,k*3,i*10));
%end
%end
%end

for k = 1:20
  k * 3;
 for i = 1:36
     i * 10;
   X(k, i) = xax(i);
   Y(k, i) = yax(k);
 end 
end
 
 ii = 100 ;
 kk = 20;
 for k = 1:7
  for i = 1:17
    Xq(k,i) = xax(ii);
    Yq(k,i) = yax(kk);
    ii = ii + 10;
   end
   ii = 100;
   kk = kk +3;
 end


figure
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(3,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(3,20:3:40,100:10:260)), squeeze(d.v(3,20:3:40,100:10:260)),   'k' )
axis tight


figure
subplot(3,2,1), 
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(1,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(1,20:3:40,100:10:260)), squeeze(d.v(1,20:3:40,100:10:260)), 0.25, 'k' )
axis tight

subplot(3,2,2), 
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(2,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(2,20:3:40,100:10:260)), squeeze(d.v(2,20:3:40,100:10:260)), 0.25,  'k' )
axis tight

subplot(3,2,3), 
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(3,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(3,20:3:40,100:10:260)), squeeze(d.v(3,20:3:40,100:10:260)), 0.25,  'k' )
axis tight

subplot(3,2,4), 
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(4,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(4,20:3:40,100:10:260)), squeeze(d.v(4,20:3:40,100:10:260)), 0.25,  'k' )
axis tight

subplot(3,2,5), 
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(5,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(5,20:3:40,100:10:260)), squeeze(d.v(5,20:3:40,100:10:260)), 0.25, 'k' )
axis tight

subplot(3,2,6), 
contour(xax(100:260), yax(20:40), squeeze(d.rho_prime(6,20:40,100:260))), 
shading flat, caxis(Vax), colormap(flipud(gray)), hold on
quiver(Xq, Yq, squeeze(d.u(6,20:3:40,100:10:260)), squeeze(d.v(6,20:3:40,100:10:260)), 0.25,  'k' )
axis tight


%quiver(X,Y,U,V,3, 'k'), axis tight




%figure
%pcolor(squeeze(d.rho_prime(5,20:40,100:260))), hold on, caxis(Vax), colormap(autumn), shading flat, colorbar, hold on
%quiver(squeeze(d.u(5,20:40,100:260)), squeeze(d.v(5,20:40,100:260)),3), axis tight



%figure
%subplot(3,3,1), 
%pcolor(squeeze(d.rho_prime(1,20:40,100:260))), hold on, caxis(Vax), colormap(autumn), shading flat, colorbar
%quiver(squeeze(d.u(3,20:40,100:240)), squeeze(d.v(3,20:40,100:240)),10), axis tight
%figure
%subplot(3,3,2), 
%pcolor(squeeze(d.rho_prime(3,20:40,100:240))), hold on, caxis(Vax), colormap(flipud(autumn)),shading flat, colorbar
%quiver( squeeze(d.u(3,20:40,100:240)), squeeze(d.v(3,20:40,100:240)),0), axis tight
%figure
%subplot(3,3,3), 
%pcolor(squeeze(d.rho_prime(3,10:40,100:240))), hold on, caxis(Vax), colormap(flipud(autumn)),shading flat, colorbar
%quiver(squeeze(d.u(3,10:40,100:240)), squeeze(d.v(3,10:40,100:240)),3), axis tight
%figure
%subplot(3,3,4), 
%pcolor(squeeze(d.rho_prime(5,20:40,100:240))), hold on, caxis(Vax), colormap(flipud(autumn)), shading flat, colorbar
%quiver(squeeze(d.u(5,20:40,100:240)), squeeze(d.v(5,20:40,100:240)),2), axis tight
%figure
%%subplot(3,3,5), 
%pcolor(squeeze(d.rho_prime(7,10:40,100:240))), hold on, caxis(Vax), colormap(flipud%(autumn)), shading flat, colorbar
%quiver(squeeze(d.u(7,10:40,100:240)), squeeze(d.v(7,10:40,100:240))), axis tight
%figure
%subplot(3,3,6), 
%pcolor(squeeze(d.rho_prime(9,10:40,100:240))), hold on, caxis(Vax), colormap(flipud(autumn)),shading flat, colorbar
%quiver(squeeze(d.u(9,10:40,100:240)), squeeze(d.v(9,10:40,100:240))), axis tight
%figure
%subplot(3,3,7), 
%pcolor(squeeze(d.rho_prime(11,:,100:240))), hold on, caxis(Vax), colormap(flipud(autumn)), shading flat, colorbar
%quiver(squeeze(d.u(11,:,100:240)), squeeze(d.v(11,:,100:240))), axis tight
%figure
%subplot(3,3,8), 
%pcolor(squeeze(d.rho_prime(13,:,100:240))), hold on, caxis(Vax), colormap(flipud(autumn)), shading flat, colorbar
%quiver(squeeze(d.u(13,:,100:240)), squeeze(d.v(13,:,100:240))), axis tight


