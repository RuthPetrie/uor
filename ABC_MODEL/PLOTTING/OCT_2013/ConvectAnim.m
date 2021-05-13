%% Make animation of convection

cont = 91

%m = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/eff_stab_11.nc');
%m = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convect_004.nc');
[m, nlongs, nlevs, ntimes] = load_netcdf_struct...
                           ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_93.nc');
 % ('/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_50000.nc');
[time,t1] = size(m.time);
% Allocate time array
timemins(1) = 0;
for i = 2:ntimes
timemins(i) = (i-1) * 5;
end
%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

wmax = max(max(max(abs(m.w(:,:,:)))))
waxis = [-wmax wmax];
%waxis = [-0.45 0.45];

for t = 1:ntimes
    t
    h=figure('Visible','off');
    pcolor(xax,yax,squeeze(m.w(t,:,:))), shading flat, caxis(waxis), colormap(redblue), 
    colorbar,
    title(['t = ',num2str(timemins(t)), ' mins'], 'FontSize',16) 
    xlabel(['Longitude',10,'(km)'],'FontSize',12), ylabel(['Height',10,'(m)'],'FontSize',12 )
   
    if t < 10
       filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/convect_test_0%d',t);
      else
       filename = sprintf('/export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/convect_test_%d',t);
    end    
    print('-dpng', filename);
  

close

end

% cd /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/
% export COUNTER="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37" 
% for i in ${COUNTER}; do
% echo $i
% convert convect_test_$i.png convect_test_$i.gif
% done
% convert -loop 50 -delay 40 convect_test_*.png /home/wx019276/public_html/images/convect_test_lat_144_7.gif


%  system('convert /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/conv_unstable_B_B_$i.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/convect_stable_$i.gif')
%  system('convert -loop 50 -delay 40 /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/convect_test_*.png /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/convect_test_lat_144.gif')
   %system('rm -f /export/carrot/raid2/wx019276/IMAGES/ANIMS/*png')
   %system('rm -f /export/carrot/raid2/wx019276/IMAGES/ANIMS/anim*gif')
%  system('xanim /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/conv_unstable_B_B_anim.gif')
  
%  cp /export/carrot/raid2/wx019276/IMAGES/ANIMS/CONV/conv_unstable_B_B_anim.gif /home/wx019276/public_html/images/conv_unstable_B_anim.gif
  
