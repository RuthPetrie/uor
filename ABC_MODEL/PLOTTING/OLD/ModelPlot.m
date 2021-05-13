%% Program to read in a netcdf file
%  and output animated figures
%  March 2011
%  Ruth Petrie

% load file/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST
cont = 12
%m = load_nc_struct('/home/wx019276/DATA/MODEL/REGIME/convection101.nc');
m = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/Buoy_pert_1.nc');
%[m, nlongs, nlevs, ntimes] = load_netcdf_struct...
 %   ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_62000.nc');
%                           ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_93.nc');
%[n, nlongs, nlevs, ntimes] = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_81.nc');
%m = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_04.nc');
%n = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_07.nc');
% [time,t1] = size(m.time);
% % Allocate time array
% times(1) = 0;
% for t = 1: time
%     times(t) = m.time(t,1);
% end


%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

plotstills = 1
  plotw   = 0
make_animation = 0
estimate_lengthscales = 0

if estimate_lengthscales ==1
t = 11;
uabs = max(max(abs(m.u(t,:,:))))
vabs = max(max(abs(m.v(t,:,:))))
wabs = max(max(abs(m.w(t,:,:))))
rabs = max(max(abs(m.rho_prime(t,:,:))))
babs = max(max(abs(m.b_prime(t,:,:))))

uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]


figure,pcolor(squeeze(m.u(t,:,:))),shading flat, caxis(uscale), colormap(redblue), colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',14), ylabel(['Height',10,'(m)'],'FontSize',14 )
figure,pcolor(squeeze(m.v(t,:,:))),shading flat, caxis(vscale), colormap(redblue), colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',14), ylabel(['Height',10,'(m)'],'FontSize',14 )

figure,pcolor(squeeze(m.w(t,:,:))),shading flat, caxis(wscale), colormap(redblue), colorbar
xlabel(['Longitude',10,'(km)'],'FontSize',14), ylabel(['Height',10,'(m)'],'FontSize',14 )


end



if plotstills == 1
     
if plotw == 1      
     
ax_m = max(max(squeeze(m.w(7,:,:))));
ax_n = max(max(squeeze(n.w(7,:,:))));
waxis = [ -ax_m ax_m]
figure,t = 1, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 2, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 3, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 4, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 5, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 6, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 7, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
waxis = [ -ax_n ax_n]

figure,t = 7, pcolor(xax, yax, squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure,t = 7, pcolor(xax, yax, squeeze(n.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), colorbar
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})

end

umax = max(max(max(abs(m.u(:,:,:)))))
vmax = max(max(max(abs(m.v(:,:,:)))))
wmax = max(max(max(abs(m.w(:,:,:)))))
rmax = max(max(max(abs(m.rho_prime(:,:,:)))))
bmax = max(max(max(abs(m.b_prime(:,:,:)))))
hmax = max(max(max(abs(m.hydro(:,:,:)))))
gmax = max(max(max(abs(m.geost(:,:,:)))))
%tmax = max(max(abs(m.tracer(:,:,:))))
emax = max(max(m.energy));
emin = min(min(m.energy));

uaxis = [-umax umax];
vaxis = [-vmax vmax];
waxis = [-wmax wmax];
raxis = [-rmax rmax];
baxis = [-bmax bmax];
haxis = [0 2];
gaxis = [0 2];
%taxis = [-tmax tmax];
%timeax = [0 time];
eaxis = [emin emax];
bal_levs = [0 0.1 0.5 1.0]

nrows = 3
ncols = 3

t1 = 7
t2 = 13
t3 = 19
t4 = 25

%for t = 1:ntimes
%    t
%    h = figure('Visible','off')
%    set(h, 'Position', [360 66 856 858])
%    
%h = figure
%set(h, 'Position',[611 -351 914 870]);% [18 180 576 432])


    subplot(nrows,ncols,1), 
    pcolor(xax,yax, squeeze(m.b_prime(t1,:,:))), shading flat, caxis(baxis)
    colormap(redblue)
    ylabel({'Height','m'})

    subplot(nrows,ncols,2), 
    pcolor(xax, yax, squeeze(m.b_prime(t2,:,:))), shading flat, caxis(baxis)
    colormap(redblue)
 
    subplot(nrows,ncols,3), 
    pcolor(xax, yax, squeeze(m.b_prime(t3,:,:))), shading flat, caxis(baxis)
    colormap(redblue), colorbar
 
  %  subplot(nrows,ncols,10), 
  %  pcolor(xax, yax, squeeze(m.b_prime(t4,:,:))), shading flat, caxis(baxis)
  %  colormap(redblue), colorbar
 
    subplot(nrows,ncols,4), 
    pcolor(xax, yax, squeeze(m.w(t1,:,:))), shading flat, caxis(waxis)
    colormap(redblue)
    ylabel({'Height','m'})

    subplot(nrows,ncols,5), 
    pcolor(xax, yax, squeeze(m.w(t2,:,:))), shading flat, caxis(waxis)
    colormap(redblue)
 
    subplot(nrows,ncols,6), 
    pcolor(xax, yax, squeeze(m.w(t3,:,:))), shading flat, caxis(waxis)
    colormap(redblue), colorbar
 
  %  subplot(nrows,ncols,11), 
  %  pcolor(xax, yax, squeeze(m.w(t4,:,:))), shading flat, caxis(waxis)
  %  colormap(redblue)
 
    subplot(nrows,ncols,7), 
    pcolor(xax, yax, squeeze(m.rho_prime(t1,:,:))), shading flat, caxis(raxis)
    colormap(redblue)
    xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
    
    subplot(nrows,ncols,8), 
    pcolor(xax, yax, squeeze(m.rho_prime(t2,:,:))), shading flat, caxis(raxis)
    colormap(redblue)%, colorbar
     xlabel({'Longitudinal distance';'km'})
    subplot(nrows,ncols,9), 
    pcolor(xax, yax, squeeze(m.rho_prime(t3,:,:))), shading flat, caxis(raxis)
    colormap(redblue), colorbar
    xlabel({'Longitudinal distance';'km'})

  %  subplot(nrows,ncols,12), 
 %   pcolor(xax, yax, squeeze(m.rho_prime(t4,:,:))), shading flat, caxis(raxis)
  %  colormap(redblue)%, colorbar

end


if make_animation == 1 

% set make_anim
make_anim = 1

% Allocate axis scales

umax = max(max(max(abs(m.u(:,:,:)))))
vmax = max(max(max(abs(m.v(:,:,:)))))
wmax = max(max(max(abs(m.w(:,:,:)))))
rmax = max(max(max(abs(m.rho_prime(:,:,:)))))
bmax = max(max(max(abs(m.b_prime(:,:,:)))))
hmax = max(max(max(abs(m.hydro(:,:,:)))))
gmax = max(max(max(abs(m.geost(:,:,:)))))
%tmax = max(max(abs(m.tracer(:,:,:))))
emax = max(max(m.energy));
emin = min(min(m.energy));

uaxis = [-umax umax];
vaxis = [-vmax vmax];
waxis = [-wmax wmax];
raxis = [-rmax rmax];
baxis = [-bmax bmax];
haxis = [0 2];
gaxis = [0 2];
%taxis = [-tmax tmax];
%timeax = [0 time];
eaxis = [emin emax];
bal_levs = [0 0.1 0.5 1.0]

nrows = 2
ncols = 4

for t = 1:ntimes
    t
    h = figure('Visible','off')
%    set(h, 'Position', [360 66 856 858])
     set(h, 'Position', [18 180 576 432])


    subplot(nrows,ncols,1), 
    pcolor(squeeze(m.u(t,:,:))), shading flat, caxis(uaxis), colormap(redblue),
    colorbar
    
    %%%%,% title({['time = ', num2str(times(t)), 's']; 'u'})

    subplot(nrows,ncols,5), 
    pcolor(squeeze(m.v(t,:,:))), shading flat, caxis(vaxis), colormap(redblue), 
    colorbar, title('v')
    
    subplot(nrows,ncols,2), 
    pcolor(squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), 
    colorbar,title('w')   
    
    subplot(nrows,ncols,3), 
    pcolor(squeeze(m.rho_prime(t,:,:))), shading flat, caxis(raxis),colormap(redblue),  
    colorbar, title('\rho`')   
    
    subplot(nrows,ncols,6), 
    pcolor(squeeze(m.b_prime(t,:,:))), shading flat, caxis(baxis),colormap(redblue), 
    colorbar, title('b`')   

    subplot(nrows,ncols,4), 
    pcolor(abs(squeeze(m.hydro(t,:,:)))), shading flat, caxis(haxis),colormap(redblue), 
    colorbar, 
    rms_h = rms(squeeze(m.hydro(t,:,:)));
    title([{'Hydrostatic imbalance, rms: ',...
    num2str(rms_h)}])   
 
% t = 12
%   temp = abs(squeeze(m.geost(t,:,:))) - abs(squeeze(n.geost(t,:,:)));
%   pcolor(temp), colorbar, shading flat
  
    subplot(nrows,ncols,8), 
    pcolor(abs(squeeze(m.geost(t,:,:)))), shading flat, caxis(gaxis),colormap(redblue), 
    colorbar, 
    rms_g = rms(squeeze(m.geost(t,:,:)));
    title([{'Geostrophic imbalance, rms: ',...
    num2str(rms_g)}])   

   
%    subplot(3,2,6) 
%    pcolor(squeeze(m.tracer(t,:,:))), shading flat, caxis(tracer_axis_scale),colorbar
%    title('Tracer')   
 
    
%    subplot(3,3,9), plot(eaxis, timeaxis, m.energy(1:t,1), 'k'), hold on, plot(m.energy(1:t,2), 'b'),
%    plot(m.energy(1:t,3), 'r'), plot(m.energy(1:t,4), 'g'), axis tight
%    legend('Kinetic','Buoyant','Elastic','Total'), title('Energy')


%%% BALANCES
  
%t  = 20
%   bal_levs = [0 0.1 0.5 1.0 10]
%figure
%   [cout,s] = contourf(abs(squeeze(m.hydro(t,:,:)) / (rms(squeeze(m.b_prime(t,:,:))))), bal_levs);
%    colormap(redblue), 
%    colorbarf(cout,s), title('Hydrostatic imbalance')   
 
%figure
%    [coutg,sg] = contourf(abs(squeeze(m.geost(t,:,:)) / (f*(rms(squeeze(m.b_prime(t,:,:)))))), bal_levs);
%    colormap(redblue), 
%    colorbarf(coutg, sg), title('Geostrophic imbalance')   

 if make_anim == 1
     if t < 10
       filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-00%d',t);
       elseif t >= 100
         filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-%d',t);
       else
       filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-0%d',t);
     end    
    print('-dpng', filename);
 end

 close 
end

 if make_anim == 1

   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-001.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-001.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-002.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-002.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-003.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-003.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-004.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-004.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-005.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-005.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-006.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-006.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-007.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-007.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-008.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-008.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-009.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-009.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-010.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-010.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-011.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-011.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-011.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-011.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-012.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-012.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-013.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-013.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-014.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-014.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-015.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-015.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-016.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-016.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-017.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-017.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-018.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-018.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-019.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-019.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-020.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-020.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-021.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-021.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-022.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-022.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-023.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-023.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-024.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-024.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-025.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-025.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-026.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-026.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-027.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-027.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-028.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-028.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-029.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-029.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-030.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-030.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-031.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-031.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-032.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-032.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-033.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-033.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-034.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-034.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-035.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-035.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-036.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-036.gif')
   system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-037.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim-037.gif')
%   system('cd /export/carrot/raid2/wx019276/IMAGES/ANIMS/')
%  system('convert -loop 100 -delay 40 /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim*.gif Convect_90.gif')
%   system('cp Convect_90.gif /home/wx019276/public_html/images/Convect_90.gif')
%   system('beep')
% cp Spin_up_20.gif /home/wx019276/public_html/images/
   %system('rm -f /export/carrot/raid2/wx019276/IMAGES/ANIMS/*png')
   %system('rm -f /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim*gif')
%   system('xanim /export/carrot/raid2/wx019276/IMAGES/ANIMS/forecast_test.gif')
 
 end

end
