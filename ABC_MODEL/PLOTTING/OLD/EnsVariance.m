%% PROGRAM TO LOAD IN ENSEMBLE VARIANCE FILE AND PLOT RESULTS

%% EnsVariance


[var, nlongs, nlevs, ntimes] = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_42_variances.nc');

conte =301

%h = figure
%set(h, 'Position', [360 99 762 825])
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

std_u = sqrt(var.u);
std_v = sqrt(var.v);
std_w = sqrt(var.w);
std_r = sqrt(var.rho_prime);
std_b = sqrt(var.b_prime);

rmsu = 1/rms(std_u);
rmsv = 1/rms(std_v);
rmsw = 1/rms(std_w);
rmsr = 1/rms(std_r);
rmsb = 1/rms(std_b);

min(min(var.u));
min(min(var.v));
min(min(var.w));
min(min(var.rho_prime));
min(min(var.b_prime));
levs = [0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.5 3.0] 

%subplot(2,3,1), pcolor(xax,yax,sqrt(var.u)/rmsu), shading flat, colormap(hot), colorbar, title('u')
%subplot(2,3,2), pcolor(xax,yax,sqrt(var.v)/rmsv), shading flat, colormap(hot), colorbar, title('v')
%subplot(2,3,3), pcolor(xax,yax,sqrt(var.w)/rmsw), shading flat, colormap(hot), colorbar, title('w')
%subplot(2,3,4), pcolor(xax,yax,sqrt(var.rho_prime)/rmsr), shading flat, colormap(hot), colorbar, title('\rho`')
%subplot(2,3,5), pcolor(xax,yax,sqrt(var.b_prime)/rmsb), shading flat, colormap(hot), colorbar, title('b`')

figure, 
nrows = 3
ncols = 2

subplot(nrows, ncols,1) 
contourf(xax,yax,(std_u*rmsu)), colormap(hot), colorbar, shading flat
title({['rms u: ', num2str(rmsu)]})
%figure, 
subplot(nrows, ncols,2) 
contourf(xax,yax,(std_v*rmsv)), colormap(hot), colorbar, shading flat
title({['rms v: ', num2str(rmsv)]})
%figure, 
subplot(nrows, ncols,3) 
contourf(xax,yax,(std_w*rmsw)), colormap(hot), colorbar, shading flat
title({['rms w: ', num2str(rmsw)]})
%figure, 
subplot(nrows, ncols,4) 
contourf(xax,yax,(std_r*rmsr)), colormap(hot), colorbar, shading flat
title({['rms r: ', num2str(rmsr)]})
%figure, 
subplot(nrows, ncols,5) 
contourf(xax,yax,(std_b*rmsb)), colormap(hot), colorbar, shading flat
title({['rms b: ', num2str(rmsb)]})

figure

subplot(nrows, ncols,1) 
pcolor(xax,yax,(std_u*rmsu)), colormap(hot), colorbar, shading flat
title({['rms u: ', num2str(rmsu)]})
%figure, 
subplot(nrows, ncols,2) 
pcolor(xax,yax,(std_v*rmsv)), colormap(hot), colorbar, shading flat
title({['rms v: ', num2str(rmsv)]})
%figure, 
subplot(nrows, ncols,3) 
pcolor(xax,yax,(std_w*rmsw)), colormap(hot), colorbar, shading flat
title({['rms w: ', num2str(rmsw)]})
%figure, 
subplot(nrows, ncols,4) 
pcolor(xax,yax,(std_r*rmsr)), colormap(hot), colorbar, shading flat
title({['rms r: ', num2str(rmsr)]})
%figure, 
subplot(nrows, ncols,5) 
pcolor(xax,yax,(std_b*rmsb)), colormap(hot), colorbar, shading flat
title({['rms b: ', num2str(rmsb)]})




%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.6821 0.1214 0.2446 0.3143],...
%  'LineStyle','none',...
%  'FitHeightToText','off',...
%  'String',{'normalised by rms values','', ...
%  ['u = ',num2str(rmsu)], ...
%  ['v = ',num2str(rmsv)], ...
%  ['w = ',num2str(rmsw)], ...
%  ['\rho` = ',num2str(rmsr)], ...
%  ['b` = ',num2str(rmsb)],'','', ...
%   '40 +1 member ensemble','','A = 4 . 10^{-5}', ...
%   'B = 10^{-2}','C = 10^4.', ...
%   'Ensemble members from','different latitude'});
 

