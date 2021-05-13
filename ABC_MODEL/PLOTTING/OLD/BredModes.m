%% Ensemble

%% LOAD DATA
% BRED MODES

cont = 2

plot_ctrl = 0


if (plot_ctrl == 1) 
 
 tm = 25
 % load
 %ctrl = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Control12.nc');

 figure
 subplot(3,2,1), pcolor(squeeze(ctrl.u(tm,:,:))), shading flat, colorbar
 subplot(3,2,2), pcolor(squeeze(ctrl.v(tm,:,:))), shading flat, colorbar
 subplot(3,2,3), pcolor(squeeze(ctrl.w(tm,:,:))), shading flat, colorbar
 subplot(3,2,4), pcolor(squeeze(ctrl.rho_prime(tm,:,:))), shading flat, colorbar
 subplot(3,2,5), pcolor(squeeze(ctrl.b_prime(tm,:,:))), shading flat, colorbar

end

[b, nlongs, nlevs, ntimes] = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred_42_01_001.nc');
%b2 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred09001.nc');

%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

t1 = 21
t2 = 20

tmax = 11


umax = max(max(squeeze(b.u(t1,:,:))));
vmax = max(max(squeeze(b.v(t1,:,:))));
wmax = max(max(squeeze(b.w(t1,:,:))));
rmax = max(max(squeeze(b.rho_prime(t1,:,:))));
bmax = max(max(squeeze(b.b_prime(t1,:,:))));

umin = min(min(squeeze(b.u(t1,:,:))));
vmin = min(min(squeeze(b.v(t1,:,:))));
wmin = min(min(squeeze(b.w(t1,:,:))));
rmin = min(min(squeeze(b.rho_prime(t1,:,:))));
bmin = min(min(squeeze(b.b_prime(t1,:,:))));


rms_r = rms(squeeze(b.rho_prime(t1,:,:)));
rms_w = rms(squeeze(b.w(t1,:,:)));
rms_v = rms(squeeze(b.v(t1,:,:)));
rms_u = rms(squeeze(b.u(t1,:,:)));
rms_b = rms(squeeze(b.b_prime(t1,:,:)));

umaxabs = max(max(abs(squeeze(b.u(t1,:,:)))));
vmaxabs = max(max(abs(squeeze(b.v(t1,:,:)))));
wmaxabs = max(max(abs(squeeze(b.w(t1,:,:)))));
rmaxabs = max(max(abs(squeeze(b.rho_prime(t1,:,:)))));
bmaxabs = max(max(abs(squeeze(b.b_prime(t1,:,:)))));

Vu = [-umaxabs umaxabs]
Vv = [-vmaxabs vmaxabs]
Vw = [-wmaxabs wmaxabs]
Vr = [-rmaxabs rmaxabs]
Vb = [-bmaxabs bmaxabs]

figure
%subplot(3,2,1),
pcolor(xax, yax, squeeze(b.u(t1,:,:))),
caxis(Vu), colormap(redblue), shading flat, colorbar
figure
%subplot(3,2,2),
pcolor(xax, yax, squeeze(b.v(t1,:,:))),
caxis(Vv), colormap(redblue), shading flat, colorbar
figure
%subplot(3,2,3),
pcolor(xax, yax, squeeze(b.w(t1,:,:))),
caxis(Vw), colormap(redblue), shading flat, colorbar
figure
%subplot(3,2,4),
pcolor(xax, yax, squeeze(b.rho_prime(t1,:,:))),
caxis(Vr), colormap(redblue), shading flat, colorbar
figure
%subplot(3,2,5),
pcolor(xax, yax, squeeze(b.b_prime(t1,:,:))),
caxis(Vb), colormap(redblue), shading flat, colorbar

terminate = 1

if terminate == 0

% Calculate the mean squared difference
ud = rmsd(squeeze(b.u(t1,:,:)), squeeze(b.u(t2,:,:)));
vd = rmsd(squeeze(b.v(t1,:,:)), squeeze(b.v(t2,:,:)));
wd = rmsd(squeeze(b.w(t1,:,:)), squeeze(b.w(t2,:,:)));
rd = rmsd(squeeze(b.rho_prime(t1,:,:)), squeeze(b.rho_prime(t2,:,:)));
bd = rmsd(squeeze(b.b_prime(t1,:,:)), squeeze(b.b_prime(t2,:,:)));
ud/(umax-umin)
vd/(vmax-vmin)
wd/(wmax-wmin)
rd/(rmax-rmin)
bd/(bmax-bmin)

u_tmp = squeeze(b.u(t1,:,:) - b.u(t2,:,:))/rms_u;
v_tmp = squeeze(b.v(t1,:,:) - b.v(t2,:,:))/rms_v;
w_tmp = squeeze(b.w(t1,:,:) - b.w(t2,:,:))/rms_w;
r_tmp = squeeze(b.rho_prime(t1,:,:) - b.rho_prime(t2,:,:))/rms_r;
b_tmp = squeeze(b.b_prime(t1,:,:) - b.b_prime(t2,:,:))/rms_b;

max_u = max(max(abs(u_tmp)));
max_v = max(max(abs(v_tmp)));
max_w = max(max(abs(w_tmp)));
max_r = max(max(abs(r_tmp)));
max_b = max(max(abs(b_tmp)));
Vu = [-max_u max_u];
Vv = [-max_v max_v];
Vw = [-max_w max_w];
Vr = [-max_r max_r];
Vb = [-max_b max_b];




figure
subplot(3,2,1), pcolor(xax, yax, squeeze(b.u(t1,:,:) - b.u(t2,:,:))/rms_u),
caxis(Vu), colormap(redblue), shading flat, colorbar, title('u')
subplot(3,2,2), pcolor(xax, yax, squeeze(b.v(t1,:,:) - b.v(t2,:,:))/rms_v),
caxis(Vv), colormap(redblue), shading flat, colorbar, title('v')
subplot(3,2,3), pcolor(xax, yax, squeeze(b.w(t1,:,:) - b.w(t2,:,:))/rms_w),
caxis(Vw), colormap(redblue), shading flat, colorbar, title('w')
subplot(3,2,4), pcolor(xax, yax, squeeze(b.rho_prime(t1,:,:) - b.rho_prime(t2,:,:))/rms_r),
caxis(Vr), colormap(redblue), shading flat, colorbar, title('\rho')
subplot(3,2,5), pcolor(xax, yax, squeeze(b.b_prime(t1,:,:) - b.b_prime(t2,:,:))/rms_b),
caxis(Vb), colormap(redblue), shading flat, colorbar, title('b')

c_levs = [0 0.05 0.1 0.2 0.5 1.0 2.0]
figure
subplot(3,2,1), contourf(xax, yax, abs(squeeze(b.u(t1,:,:) - b.u(t2,:,:)))/rms_u, c_levs),
caxis([0 2]), colormap(flipud(hot)),colorbar, title('u')
subplot(3,2,2), contourf(xax, yax, abs(squeeze(b.v(t1,:,:) - b.v(t2,:,:)))/rms_v, c_levs),
caxis([0 2]), colormap(flipud(hot)), colorbar, title('v')
subplot(3,2,3), contourf(xax, yax, abs(squeeze(b.w(t1,:,:) - b.w(t2,:,:)))/rms_w, c_levs),
caxis([0 2]), colormap(flipud(hot)),  colorbar, title('w')
subplot(3,2,4), contourf(xax, yax, abs(squeeze(b.rho_prime(t1,:,:) - b.rho_prime(t2,:,:)))/rms_r, c_levs),
caxis([0 2]), colormap(flipud(hot)), colorbar, title('\rho')
subplot(3,2,5), contourf(xax, yax, abs(squeeze(b.b_prime(t1,:,:) - b.b_prime(t2,:,:)))/rms_b, c_levs),
caxis([0 2]), colormap(flipud(hot)), colorbar, title('b')


max_u = max(max(abs(squeeze(b.u(tmax,:,:)))));
max_v = max(max(abs(squeeze(b.v(tmax,:,:)))));
max_w = max(max(abs(squeeze(b.w(tmax,:,:)))));
max_r = max(max(abs(squeeze(b.rho_prime(tmax,:,:)))));
max_b = max(max(abs(squeeze(b.b_prime(tmax,:,:)))));

Vu = [-max_u max_u];
Vv = [-max_v max_v];
Vw = [-max_w max_w];
Vr = [-max_r max_r];
Vb = [-max_b max_b];



figure
subplot(5,4,1),pcolor(xax, yax, squeeze(b.u(tmax-3 ,:,:))),caxis(Vu), colormap(redblue),shading flat, colorbar
subplot(5,4,2),pcolor(xax, yax, squeeze(b.u(tmax-2 ,:,:))),caxis(Vu), colormap(redblue),shading flat, colorbar
subplot(5,4,3),pcolor(xax, yax, squeeze(b.u(tmax-1,:,:))),caxis(Vu), colormap(redblue),shading flat, colorbar
subplot(5,4,4),pcolor(xax, yax, squeeze(b.u(tmax,:,:))),caxis(Vu), colormap(redblue),shading flat, colorbar



subplot(5,4,5),pcolor(xax, yax, squeeze(b.v(tmax-3 ,:,:))),caxis(Vv), colormap(redblue),shading flat, colorbar
subplot(5,4,6),pcolor(xax, yax, squeeze(b.v(tmax-2 ,:,:))),caxis(Vv), colormap(redblue),shading flat, colorbar
subplot(5,4,7),pcolor(xax, yax, squeeze(b.v(tmax-1,:,:))),caxis(Vv), colormap(redblue),shading flat, colorbar
subplot(5,4,8),pcolor(xax, yax, squeeze(b.v(tmax,:,:))),caxis(Vv), colormap(redblue),shading flat, colorbar


subplot(5,4,9),pcolor(xax, yax, squeeze(b.w(tmax-3 ,:,:))),caxis(Vw), colormap(redblue),shading flat, colorbar
subplot(5,4,10),pcolor(xax, yax, squeeze(b.w(tmax-2 ,:,:))),caxis(Vw), colormap(redblue),shading flat, colorbar
subplot(5,4,11),pcolor(xax, yax, squeeze(b.w(tmax-1,:,:))),caxis(Vw), colormap(redblue),shading flat, colorbar
subplot(5,4,12),pcolor(xax, yax, squeeze(b.w(tmax,:,:))),caxis(Vw), colormap(redblue),shading flat, colorbar


subplot(5,4,13),pcolor(xax, yax, squeeze(b.rho_prime(tmax-3 ,:,:))),caxis(Vr), colormap(redblue),shading flat, colorbar
subplot(5,4,14),pcolor(xax, yax, squeeze(b.rho_prime(tmax-2 ,:,:))),caxis(Vr), colormap(redblue),shading flat, colorbar
subplot(5,4,15),pcolor(xax, yax, squeeze(b.rho_prime(tmax-1,:,:))),caxis(Vr), colormap(redblue),shading flat, colorbar
subplot(5,4,16),pcolor(xax, yax, squeeze(b.rho_prime(tmax,:,:))),caxis(Vr), colormap(redblue),shading flat, colorbar


subplot(5,4,17),pcolor(xax, yax, squeeze(b.b_prime(tmax-3 ,:,:))),caxis(Vb), colormap(redblue),shading flat, colorbar
subplot(5,4,18),pcolor(xax, yax, squeeze(b.b_prime(tmax-2 ,:,:))),caxis(Vb), colormap(redblue),shading flat, colorbar
subplot(5,4,19),pcolor(xax, yax, squeeze(b.b_prime(tmax-1,:,:))),caxis(Vb), colormap(redblue),shading flat, colorbar
subplot(5,4,20),pcolor(xax, yax, squeeze(b.b_prime(tmax,:,:))),caxis(Vb), colormap(redblue),shading flat, colorbar



% INITIAL CONDITIONS
ic = load_nc_struct('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_0447.nc');

%% SWITCHES
plotbred = 1
plotinitconds = 0

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT BRED MODES 
 if plotbred == 1
   maxu = max(max(abs(squeeze(b.u(11,:,:)))));
   maxv = max(max(abs(squeeze(b.v(11,:,:)))));
   maxw = max(max(abs(squeeze(b.w(11,:,:)))));
   maxr = max(max(abs(squeeze(b.rho_prime(11,:,:)))));
   maxb = max(max(abs(squeeze(b.b_prime(11,:,:)))));

   uscale = [-maxu maxu]
   vscale = [-maxv maxv]
   wscale = [-maxw maxw] 
   rscale = [-maxr maxr]
   bscale = [-maxb maxb]

   figure, pcolor(xax, yax, squeeze(b.u(11,:,:))), caxis(uscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, squeeze(b.v(11,:,:))), caxis(vscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, squeeze(b.w(11,:,:))), caxis(wscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, squeeze(b.rho_prime(11,:,:))), caxis(rscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, squeeze(b.b_prime(11,:,:))), caxis(bscale), colormap(redblue), shading flat, colorbar
   
 end  
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT INITAL CONDITIONS

 if plotinitconds == 1
   maxu = max(max(abs((ic.u(:,:)))));
   maxv = max(max(abs((ic.v(:,:)))));
   maxw = max(max(abs((ic.w(:,:)))));
   maxr = max(max(abs((ic.rho_prime(:,:)))));
   maxb = max(max(abs((ic.b_prime(:,:)))));

   uscale = [-maxu maxu]
   vscale = [-maxv maxv]
   wscale = [-maxw maxw] 
   rscale = [-maxr maxr]
   bscale = [-maxb maxb]

   figure, pcolor(xax, yax, (ic.u(:,:))), caxis(uscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, (ic.v(:,:))), caxis(vscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, (ic.w(:,:))), caxis(wscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, (ic.rho_prime(:,:))), caxis(rscale), colormap(redblue), shading flat, colorbar
   figure, pcolor(xax, yax, (ic.b_prime(:,:))), caxis(bscale), colormap(redblue), shading flat, colorbar
   
 end  
 
end 

