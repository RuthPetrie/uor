%% PROGRAM TO CALCULATE EFFECTIVE BUOYANCY

% EffectiveBuoyancy

cont = 81

%% LOAD FILE
[stable, nlongs, nlevs, ntimes] = load_netcdf_struct...
    ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_86.nc');
[convect, nlongs, nlevs, ntimes] = load_netcdf_struct...
    ('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_85.nc');

%% DEFINE PARAMETERS
t = 7
dz = 256.7;
dx = 1500;
Asq_stable = 1E-4;
Asq_convect = 1E-5;
BV = 1E-4
recipa = 1/BV;
B = 0.01;
C = 1E4;

%% SET PLOTTING AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

%% CALCULATE EFFECTIVE BUOYANCY
 for k = 1:nlevs-1
  for i = 1:nlongs
    eff_buoy_stable(k,i) = (((squeeze(stable.b_prime(t,k+1,i)) ...
             - squeeze(stable.b_prime(t,k,i)) ) /dz) + Asq_stable)*recipa;
  end
 end
 for k = 1:nlevs-1
  for i = 1:nlongs
    eff_buoy_convect(k,i) = (((squeeze(convect.b_prime(t,k+1,i)) ...
             - squeeze(convect.b_prime(t,k,i)) ) /dz) + Asq_convect)*recipa;
  end
 end

% CALCULATE COLOURSCALE
max_ebs = max(max(abs(eff_buoy_stable(1:59,:))));
max_ebc = max(max(abs(eff_buoy_convect(1:59,:))));
max_eb = max(max_ebs,max_ebc);

eb_ax = [-max_eb max_eb]

lin1 =  linspace(-max_eb, 0, 4);
lin2 = linspace(0, max_eb,5);
levs = [lin1 lin2(2:5)]

max_ws = max(max(abs(stable.w(t,:,:))));
max_wc = max(max(abs(convect.w(t,:,:))));
max_w = max(max_ws,max_wc);
w_ax = [-max_w max_w]

%% PLOT EFFECTIVE BUOYANCY

figure
[cout, h] = contourf(xax,yax(1:59), eff_buoy_stable(1:59,:)); caxis(eb_ax), colormap(redblue), 
colorbarf(cout,h)
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})
figure
[cout, h] = contourf(xax,yax(1:59), eff_buoy_convect(1:59,:)); caxis(eb_ax), colormap(redblue), 
colorbarf(cout,h)
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})


figure
pcolor(xax,yax, squeeze(stable.w(t,:,:))), caxis(w_ax), colormap(redblue), 
shading flat,xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})

figure
pcolor(xax,yax, squeeze(convect.w(t,:,:))), caxis(w_ax), colormap(redblue), 
shading flat,
xlabel({'Longitudinal distance';'km'}), ylabel({'Height','m'})

%% calculate compressibility term


for k = 1:60
 for  i = 1:359
  dudx_stable(k,i) = (squeeze(stable.u(t, k, i+1)) - squeeze(stable.u(t,k,i)) )/ dx; 
  dudx_convect(k,i) = (squeeze(convect.u(t, k, i+1)) - squeeze(convect.u(t,k,i)) )/ dx; 
 end
end

for k = 1:59
 for  i = 1:360
  dwdz_stable(k,i) = (squeeze(stable.w(t, k+1, i)) - squeeze(stable.w(t,k,i)))/dz; 
  dwdz_convect(k,i) = (squeeze(convect.w(t, k+1, i)) - squeeze(convect.w(t,k,i)))/dz; 
 end
end

for k = 1:59
 for i = 1:359
   dupdw_stable(k,i) = dudx_stable(k,i) + dwdz_stable(k,i);
   dupdw_convect(k,i) = dudx_convect(k,i) + dwdz_convect(k,i);
 end
end

for k = 1:58
 for i = 1:359
   comp_stable(k,i) =-B*C*( (dupdw_stable(k+1,i) - dupdw_stable(k,i)) /dz);
   comp_convect(k,i) =-B*C*( (dupdw_convect(k+1,i) - dupdw_convect(k,i)) /dz);
 end
end

figure
subplot(1,2,1)
pcolor(comp_stable), shading flat, colorbar, title('Compressibility stable')
subplot(1,2,2)
pcolor(comp_convect), shading flat, colorbar, title('Compressibility convective')

for k = 1:58
 for i = 1:359
   buoy_stable(k,i) = Asq_stable*(squeeze(stable.w(t,k,i)));
   buoy_convect(k,i) = Asq_convect*(squeeze(convect.w(t,k,i)));
 end
end

figure
subplot(1,2,1)
pcolor(comp_stable), shading flat, colorbar, title('Buoyancy stable')
subplot(1,2,2)
pcolor(comp_convect), shading flat, colorbar, title('Buoyancy stable')

for k = 1:58
 for i = 1:359
   domin_stable(k,i) = comp_stable(k,i)/buoy_stable(k,i);
   domin_convect(k,i) = comp_convect(k,i)/buoy_convect(k,i);
 end
end

figure
subplot(1,2,1)
pcolor(domin_stable), shading flat, colorbar, title('Ratio compressibility/buoyant stable')
subplot(1,2,2)
pcolor(domin_convect), shading flat, colorbar, title('Ratio compressibility/buoyant stable')


%max_1 = max(max(abs(dcomp)));
%max_2 = max(max(abs(temp)));

%ax1 = [-max_1 max_1]
%ax2 = [-max_2 max_2]

%for k = 1:58
% for i = 1:359
%   temp2(k,i) = dcomp(k,i)/temp(k,i);
% end
%end




%annotation(figure(1),'textbox',...
%    [0.00842358604091457 0.880354505169867 0.108303249097473 0.102397341211228],...
%    'String',{'Contour levels','',num2str(levs(:))},...
%    'FitBoxToText','off',...
%    'LineStyle','none');
%===================================================================================================


%g1 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/eff_stab_10.nc' );
%g2 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/eff_stab_11.nc' );

%g1 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_50.nc');
%g2 = load_nc_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/UnbalReg_02.nc');


% for k = 1:59
%  for i = 1:360
%    b_eff_nonc(k,i) = (((squeeze(g1.b_prime(t,k+1,i)) - squeeze(g1.b_prime(t,k,i)) ) /dz) + Asq_nonc);
%    b_eff_conv(k,i) = (((squeeze(g2.b_prime(t,k+1,i)) - squeeze(g2.b_prime(t,k,i)) ) /dz) + Asq_conv);
%  end
% end

 %for k = 1:nlevs-1
 % for i = 1:nlongs
 %   m_eff_nonc(k,i) = (((squeeze(m.b_prime(t,k+1,i)) - squeeze(m.b_prime(t,k,i)) ) /dz) + Asq);
 % end
 %end

%max_b_n = max(max(abs(m_eff_nonc(1:59,:))));
%max_b_c = max(max(abs(m_eff_conv(1:59,:))));

%b_n_ax = [-max_b_n max_b_n]
%b_c_ax = [-max_b_c max_b_c]
%pcolor( m_eff_nonc(1:59,:)), shading flat, caxis(b_n_ax), colormap(redblue), colorbar



%b_n_ax = [-0.0005 0.0005]
%b_c_ax = [-0.0005 0.0005]

%figure
%subplot(2,1,1)
%pcolor(xax, yax(1:59), b_eff_nonc(1:59,:)), shading flat
%caxis(b_n_ax), 
%colormap(redblue), colorbar

%subplot(2,1,2)
%pcolor(xax, yax(1:59), b_eff_conv(1:59,:)), shading flat
%caxis(b_n_ax), 
%colormap(redblue), colorbar

%[c,g] = contourf(xax, yax(1:59), b_eff_nonc(1:59,:)); colormap(gray);
%colorbarf(c,g);




% calculate compressibility term


%for k = 1:60
% for  i = 1:359
%  drdx(k,i) = squeeze(g2.u(t,k,i))* ...
%             ((squeeze(g2.rho(t, k, i+1)) - squeeze(g2.rho(t,k,i)))/ dx); 
% end
%end

%for k = 1:59
% for  i = 1:359
%  ddrdx(k,i) = B*C*(( drdx(k+1,i) - drdx(k,i) )/ dz);
% end
%end

%for k = 1:59
% for  i = 1:360
%  drdz(k,i) = squeeze(g2.u(t,k,i))*...
%             ((squeeze(g2.rho(t, k+1, i)) - squeeze(g2.rho(t,k,i)) )/ dz); 
% end
%end

%for k = 1:58
% for  i = 1:359
%  ddrdz(k,i) = B*C*(( drdz(k+1,i) - drdz(k,i) )/ dz);
% end
%end


%max_1 = max(max(abs(ddrdx)));
%max_2 = max(max(abs(ddrdz)));

%ax1 = [-max_1 max_1]
%ax2 = [-max_2 max_2]

%figure
%subplot(2,1,1)
%pcolor(ddrdx), caxis(ax1), colormap(redblue), shading flat, colorbar, title('C * term 1')

%subplot(2,1,2)
%pcolor(ddrdz), caxis(ax2), colormap(redblue), shading flat, colorbar, title('C * term 2')


%for k = 1:60
% for  i = 1:359
%  du(k,i) = (squeeze(g2.u(t, k, i+1)) - squeeze(g2.u(t,k,i)) )/ dx; 
% end
%end

%for k = 1:59
% for  i = 1:360
%  dw(k,i) = (squeeze(g2.w(t, k+1, i)) - squeeze(g2.w(t,k,i)))/dz; 
% end
%end

%for k = 1:59
% for i = 1:359
%   dupdw(k,i) = du(k,i) + dw(k,i);
% end
%end


%for k = 1:58
% for i = 1:359
%   dcomp(k,i) =-B*C*( (dupdw(k+1,i) - dupdw(k,i)) /dz);
% end
%end

%for k = 1:58
% for i = 1:359
%   temp(k,i) = Asq_conv*(squeeze(g2.w(11,k,i)));
% end
%end


%max_1 = max(max(abs(dcomp)));
%max_2 = max(max(abs(temp)));

%ax1 = [-max_1 max_1]
%ax2 = [-max_2 max_2]

%for k = 1:58
% for i = 1:359
%   temp2(k,i) = dcomp(k,i)/temp(k,i);
% end
%end


 
%figure
%subplot(2,1,1)
%levs = [0 1];
%[c,h] = contourf(dcomp, levs); shading flat, colorbar;
%pcolor(xax(1:359), yax(1:58), dcomp), caxis(ax1), colormap(redblue), shading flat, colorbar
%xlabel(['Longitudinal distance',10,'(km)'],'FontSize',10), 
%ylabel(['Height',10,'(m)'],'FontSize',10, 'Rotation',0 )

%for k = 1:60
% for  i = 1:359
%  du(k,i) = (squeeze(g1.u(t, k, i+1)) - squeeze(g1.u(t,k,i)) )/ dx; 
% end
%end

%for k = 1:59
% for  i = 1:360
%  dw(k,i) = (squeeze(g1.w(t, k+1, i)) - squeeze(g1.w(t,k,i)))/dz; 
% end
%end

%for k = 1:59
% for i = 1:359
%   dupdw(k,i) = du(k,i) + dw(k,i);
% end
%end


%for k = 1:58
% for i = 1:359
%   dcomp(k,i) =-B*C*( (dupdw(k+1,i) - dupdw(k,i)) /dz);
% end
%end


%max_1 = max(max(abs(dcomp)));

%ax1 = [-max_1 max_1]



%subplot(2,1,2)
%pcolor(dcomp), caxis(ax1), colormap(redblue), shading flat, colorbar, title('Comp -nonconv')

%figure
%levs = [0 0.5 1 1.5 2];
%[c, g] = contourf(abs(temp2), levs); shading flat, colorbarf(c,g);


%load b_0.mat;%

%Asq_nonc = 0.0004;
%Asq_conv = 0.00004;
%B = 0.01;
%C = 100000;
%dz2 = 2*256.7;
%dz = 256.7;
%% AXES
%for i = 1:360
%  xax(i) = i * 1.5;
%end

%for i = 1:60
%  j = i + 1;
%  yax(i) = j * 256.7;
%end


% for k = 1:59
%  for i = 1:360
%    b_eff_nonc(k,i) = (((squeeze(g1.b_prime(t,k+1,i)) - squeeze(g1.b_prime(t,k,i)) ) /dz) + Asq_nonc);
%    b_eff_conv(k,i) = (((squeeze(g2.b_prime(t,k+1,i)) - squeeze(g2.b_prime(t,k,i)) ) /dz) + Asq_conv);
%  end
% end


%max_b_n = max(max(abs(b_eff_nonc(1:59,:))));
%max_b_c = max(max(abs(b_eff_conv(1:59,:))));

%b_n_ax = [-max_b_n max_b_n]
%b_c_ax = [-max_b_c max_b_c]

%b_n_ax = [-0.0005 0.0005]
%b_c_ax = [-0.0005 0.0005]



%figure
%subplot(2,1,1)
%pcolor(xax, yax(1:59), b_eff_nonc(1:59,:)), shading flat
%caxis(b_n_ax), colormap(redblue), colorbar

%subplot(2,1,2)
%pcolor(xax, yax(1:59), b_eff_conv(1:59,:)), shading flat
%caxis(b_c_ax), colormap(redblue), colorbar

%[c,g] = contourf(xax, yax(1:59), b_eff_nonc(1:59,:)); colormap(gray);
%colorbarf(c,g);


%figure
%subplot(2,1,1)
%pcolor(xax, yax(1:59), b_eff_nonc(1:59,:)), shading flat, colormap((gray))
%contour(xax,yax(1:59), b_eff_nonc(1:59,:),[-max_b_n:0], 'k'); hold on
%contour(xax,yax(1:59), b_eff_nonc(1:59,:),[0:max_b_n], '-k');
%set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
%caxis(b_n_ax)%, colormap(redblue)
%colorbar
%xlabel(['Longitudinal distance',10, '(km)'],'FontSize',10), 
%ylabel(['Height',10, '(m)'],'FontSize',10,'Rotation',00)
%title('Effective stability stable regime A=10^{-4}')

%figure
%subplot(2,1,2)
%pcolor(xax, yax(1:59), b_eff_conv(1:59,:)), shading flat,colormap((gray))
%[c, g] = contour(xax, yax(1:59), 5*b_eff_conv(1:59,:), 20); hold on,colormap((gray))
%set(g,'Color','k','LineStyle','-')
%set(g,'ShowText','on','TextStep',get(g,'LevelStep')*1)
%contour(xax, yax(1:59), 5*b_eff_conv(1:59,:),[-max_b_n:0], '-k'); hold on
%contour(xax, yax(1:59), 5*b_eff_conv(1:59,:),[0:max_b_n], 'k');
%, colormap(redblue)
%colorbar,
%xlabel(['Longitudinal distance',10, '(km)'],'FontSize',10), 
%ylabel(['Height',10, '(m)'],'FontSize',10,'Rotation',00)
%title('Effective stability convective regime A=10^{-5}')

% %% PLOT w
% max_w = max(max(abs(g1.w(t,:,:))));
% w_ax = [-max_w max_w];

%figure, 
%subplot(2,2,3)
%pcolor(squeeze(g1.w(t,:,:))), shading flat, caxis(w_ax), colormap(redblue), colorbar
%title('w - stable regime A=10^{-4}')


%% PLOT w
%max_w = max(max(abs(g2.w(t,:,:))));
%w_ax = [-max_w max_w];

%figure,
%subplot(2,2,4)
%pcolor(squeeze(g2.w(t,:,:))), shading flat, caxis(w_ax), colormap(redblue), colorbar
%title('w - convective regime A=10^{-5}')


%ABC = A * B *C

%temp = 2

%for i = 1:60
% for j = 1:360
%   b6(i,j) = (squeeze(g6.b_prime(11,i,j))/ABC + b_0(i));
% end
%end

%A = 0.00004;
%B = 0.001;
%C = 100000;

%ABC = A * B *C

%for i = 1:60
% for j = 1:360
%   b7(i,j) = (squeeze(g7.b_prime(11,i,j))/ABC + b_0(i)  );
% end
%end
%0.006324555;

%V=[0 5]

%figure
%subplot(2,1,1), contourf(b6,30), caxis(V), shading flat,colorbar
%subplot(2,1,2), contourf(b7,30), caxis(V), shading flat, colorbar


%t_sum = 0;
%for i = 1:60
% for j = 1:360
%   t_sum = t_sum + theta(i,j) ;
% end3
% theta_z(i) = t_sum / 360;
% t_sum = 0;
%end

%for k = 1:59
%dtheta(k) = (theta_z(k+1)- theta_z(k))/250;
%end

%for k = 1:60
%b_0(k) = 9.81 * theta_z(k) / 273;
%end

%for i = 1:60
% for j = 1:360
%   b1(i,j) = (10*squeeze(g1.b_prime(11,i,j)) + b_0(i))/0.0004;
% end
%end


%for i = 1:60
% for j = 1:360
%   b2(i,j) = (10*squeeze(g2.b_prime(11,i,j)) + b_0(i))/0.00004;
% end
%end

%for k = 1:60
%  theta_z(k) = theta_z(k) - 273
%end
  
  
%figure
%subplot(3,1,1), pcolor(squeeze(g1.w(11,:,:))), shading flat, colorbar  
%subplot(3,1,2), pcolor(squeeze(g2.w(11,:,:))), shading flat, colorbar  
%subplot(3,1,3), pcolor(squeeze(g3.w(11,:,:))), shading flat, colorbar  




