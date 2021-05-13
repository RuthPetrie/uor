%% TEST OF CVT
% CVT_inverse_test

cont = 0

%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end


%% LOAD DATA
u_o = load('/home/wx019276/DATA/CVT/orig_u.dat');
v_o = load('/home/wx019276/DATA/CVT/orig_v.dat');
w_o = load('/home/wx019276/DATA/CVT/orig_w.dat');
rp_o = load('/home/wx019276/DATA/CVT/orig_r.dat');
bp_o = load('/home/wx019276/DATA/CVT/orig_b.dat');

u_o_max = max(max(abs(u_o(:,2:361))));
u_o_axis = [-u_o_max u_o_max];
v_o_max = max(max(abs(v_o(:,2:361))));
v_o_axis = [-v_o_max v_o_max];
w_o_max = max(max(abs(w_o(:,2:361))));
w_o_axis = [-w_o_max w_o_max];
rp_o_max = max(max(abs(rp_o(:,2:361))));
rp_o_axis = [-rp_o_max rp_o_max];
bp_o_max = max(max(abs(bp_o(:,2:361))));
bp_o_axis = [-bp_o_max bp_o_max];


u_t = load('/home/wx019276/DATA/CVT/InvTest_u.dat');
v_t = load('/home/wx019276/DATA/CVT/InvTest_v.dat');
w_t = load('/home/wx019276/DATA/CVT/InvTest_w.dat');
rp_t = load('/home/wx019276/DATA/CVT/InvTest_r.dat');
bp_t = load('/home/wx019276/DATA/CVT/InvTest_b.dat');

u_t_max = max(max(abs(u_t(:,2:361))));
u_t_axis = [-u_t_max u_t_max];
v_t_max = max(max(abs(v_t(:,2:361))));
v_t_axis = [-v_t_max v_t_max];
w_t_max = max(max(abs(w_t(:,2:361))));
w_t_axis = [-w_t_max w_t_max];
rp_t_max = max(max(abs(rp_t(:,2:361))));
rp_t_axis = [-rp_t_max rp_t_max];
bp_t_max = max(max(abs(bp_t(:,2:361))));
bp_t_axis = [-bp_t_max bp_t_max];

%% CALCUCLATE RMS
usum = 0.0;
vsum = 0.0;
wsum = 0.0;
rpsum = 0.0;
bpsum = 0.0;

for i = 2:361
    for z = 1:60
        usum = usum   + (u_o(z,i)) ^2;
        vsum = vsum   + (v_o(z,i)) ^2;
        wsum = wsum   + (w_o(z,i)) ^2;
        rpsum = rpsum + (rp_o(z,i))^2;
        bpsum = bpsum + (bp_o(z,i))^2;
    end
end
     
urms = sqrt( usum / (360 * 60) );
vrms = sqrt( vsum / (360 * 60) );
wrms = sqrt( wsum / (360 * 60) );
rprms = sqrt( rpsum / (360 * 60) );
bprms = sqrt( bpsum / (360 * 60) );

h = figure, set(h, 'Position', [160 66 800 858]);

%-------------------------------------------------------------
subplot(5,3,1), pcolor(xax,yax,u_o(:,2:361)), 
caxis(u_o_axis), colormap(redblue), shading flat, colorbar, 
ylabel('u', 'Rotation', 0),title('original')
%-------------------------------------------------------------
subplot(5,3,4), pcolor(xax,yax,v_o(:,2:361)), 
caxis(v_o_axis), colormap(redblue), shading flat, colorbar, 
ylabel('v', 'Rotation', 0)
%-------------------------------------------------------------
subplot(5,3,7), pcolor(xax,yax,w_o(2:60, 2:361)), 
caxis(w_o_axis), colormap(redblue), shading flat, colorbar, 
ylabel('w', 'Rotation', 0)
%-------------------------------------------------------------
subplot(5,3,10), pcolor(xax,yax,rp_o(:,2:361)), 
caxis(rp_o_axis), colormap(redblue), shading flat, colorbar, 
ylabel('\rho', 'Rotation', 0)
%-------------------------------------------------------------
subplot(5,3,13), pcolor(xax,yax,bp_o(2:60, 2:361)), 
caxis(bp_o_axis), colormap(redblue), shading flat, colorbar, 
ylabel('b', 'Rotation', 0)
%-------------------------------------------------------------

%-------------------------------------------------------------
subplot(5,3,2), pcolor(xax,yax,u_t(:,2:361)), 
caxis(u_t_axis), colormap(redblue), shading flat, colorbar, 
title('transformed')
%-------------------------------------------------------------
subplot(5,3,5), pcolor(xax,yax,v_t(:,2:361)), 
caxis(v_t_axis), colormap(redblue), shading flat, colorbar, 
%-------------------------------------------------------------
subplot(5,3,8), pcolor(xax,yax,w_t(2:60, 2:361)), 
caxis(w_t_axis), colormap(redblue), shading flat, colorbar, 
%-------------------------------------------------------------
subplot(5,3,11), pcolor(xax,yax,rp_t(:,2:361)), 
caxis(rp_t_axis), colormap(redblue), shading flat, colorbar, 
%-------------------------------------------------------------
subplot(5,3,14), pcolor(xax,yax,bp_t(2:60,2:361)), 
caxis(bp_t_axis), colormap(redblue), shading flat, colorbar, 


%% errors

u_err = abs((u_o(:,2:361) - u_t(:,2:361)))/urms;
v_err = abs((v_o(:,2:361) - v_t(:,2:361)))/vrms;
w_err = abs((w_o(2:60,2:361) - w_t(2:60,2:361)))/wrms;
r_err = abs((rp_o(:,2:361) - rp_t(:,2:361)))/rprms;
b_err = abs((bp_o(2:60,2:361) - bp_t(2:60,2:361)))/bprms;

u_e_max = max(max(abs(u_err(:,2:361))));
u_e_axis = [-u_e_max u_e_max];
v_e_max = max(max(abs(v_err(:,2:361))));
v_e_axis = [-v_e_max v_e_max];
w_e_max = max(max(abs(w_err(:,2:361))));
w_e_axis = [-w_e_max w_e_max];
rp_e_max = max(max(abs(rp_err(:,2:361))));
rp_e_axis = [-rp_e_max rp_e_max];
bp_e_max = max(max(abs(bp_err(:,2:361))));
bp_e_axis = [-bp_e_max bp_e_max];


%-------------------------------------------------------------
subplot(5,3,3), pcolor(xax,yax,u_err), 
caxis(u_e_axis), colormap(redblue), shading flat, colorbar, 
title('Normalised difference')
%-------------------------------------------------------------
subplot(5,3,6), pcolor(xax,yax,v_err), 
caxis(v_e_axis), colormap(redblue), shading flat, colorbar, 
%-------------------------------------------------------------
subplot(5,3,9), pcolor(xax,yax,w_err), 
caxis(w_e_axis), colormap(redblue), shading flat, colorbar, 
%-------------------------------------------------------------
subplot(5,3,12), pcolor(xax,yax,r_err), 
caxis(rp_e_axis), colormap(redblue), shading flat, colorbar, 
%-------------------------------------------------------------
subplot(5,3,15), pcolor(xax,yax,b_err), 
caxis(bp_e_axis), colormap(redblue), shading flat, colorbar, 

    title(['t = ',num2str(timemins(t)), ' mins'], 'FontSize',16) 


annotation1 = annotation(...
  freq,'textbox',...
%  portrait position
  'Position',[0.7799 0.3202 0.0996 0.1213],...
  'LineStyle','none',...
  'Fontsize',14,...
  'String',{['Scaling factors',...
  'urms',num2str(urms)]},...
%  'B = 10^{-2}',...
%  'C = 10^4']},...
  'FitHeightToText','on');



