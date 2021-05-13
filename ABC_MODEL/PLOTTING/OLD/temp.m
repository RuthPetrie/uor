g1 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/grav_wave_1.nc' );
g2 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/grav_wave_2.nc' );
g3 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/grav_wave_3.nc' );
g4 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/grav_wave_4.nc' );
g5 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/grav_wave_5.nc' );

t_sum = 0;
for i = 1:60
 for j = 1:360
   t_sum = t_sum + theta(i,j) ;
 end
 theta_z(i) = t_sum / 360;
 t_sum = 0;
end

for k = 1:59
dtheta(k) = (theta_z(k+1)- theta_z(k))/250;
end

for k = 1:60
b_0(k) = 9.81 * theta_z(k) / 273;
end

for i = 1:60
 for j = 1:360
   b1(i,j) = (10*squeeze(g1.b_prime(11,i,j)) + b_0(i))/0.0004;
 end
end


for i = 1:60
 for j = 1:360
   b2(i,j) = (10*squeeze(g2.b_prime(11,i,j)) + b_0(i))/0.00004;
 end
end

for k = 1:60
  theta_z(k) = theta_z(k) - 273
end
  
  
figure
subplot(3,1,1), pcolor(squeeze(g1.w(11,:,:))), shading flat, colorbar  
subplot(3,1,2), pcolor(squeeze(g2.w(11,:,:))), shading flat, colorbar  
subplot(3,1,3), pcolor(squeeze(g3.w(11,:,:))), shading flat, colorbar  




