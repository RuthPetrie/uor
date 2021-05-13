%% SpectraAnalysis

cont = 36


%% SET AXES
temp = -181
for i = 1:360
xax(i) = temp +i;
end

for i = 1:300
muax(i) = i;
end

load_data = 1

if load_data == 1

%% LOAD DATA
spect_ng = load ('/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_62.dat');
spect_ng= reshape(spect_ng, [360 300]);
spect_ng = spect_ng.^2;  % variance

spect_nhng = load ('/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_63.dat');
spect_nhng= reshape(spect_nhng, [360 300]);
spect_nhng = spect_nhng.^2;  % variance

spect_nh = load ('/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_61.dat');
spect_nh= reshape(spect_nh, [360 300]);
spect_nh = spect_nh.^2;  % variance

spect_bal = load ('/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_60.dat');
spect_bal= reshape(spect_bal, [360 300]);
spect_bal = spect_bal.^2;  % variance

end


plot_fn_k = 0

if plot_fn_k == 1

%%% Calculate total variances
for k = 1: 360
 ac_ng(k) = 0; grav_ng(k) = 0; bal_ng(k) = 0;
 ac_nhng(k) = 0; grav_nhng(k) = 0; bal_nhng(k) = 0;
 ac_nh(k) = 0;  grav_nh(k) = 0;  bal_nh(k) = 0;
 ac_bal(k) = 0; grav_bal(k) = 0;  bal_bal(k) = 0;

 for m = 1:60
  ac_ng(k) = ac_ng(k) + spect_ng(k,m);
  ac_nhng(k) = ac_nhng(k) + spect_nhng(k,m);
  ac_nh(k) = ac_nh(k) + spect_nh(k,m);
  ac_bal(k) = ac_bal(k) + spect_bal(k,m);
 end

 for m = 241:300
  ac_ng(k) = ac_ng(k) + spect_ng(k,m);
  ac_nhng(k) = ac_nhng(k) + spect_nhng(k,m);
  ac_nh(k) = ac_nh(k) + spect_nh(k,m);
  ac_bal(k) = ac_bal(k) + spect_bal(k,m);
 end

 for m = 61:120
  grav_ng(k) = grav_ng(k) + spect_ng(k,m);
  grav_nhng(k) = grav_nhng(k) + spect_nhng(k,m);
  grav_nh(k) = grav_nh(k) + spect_nh(k,m);
  grav_bal(k) = grav_bal(k) + spect_bal(k,m);
 end

for m = 181:240
  grav_ng(k) = grav_ng(k) + spect_ng(k,m);
  grav_nhng(k) = grav_nhng(k) + spect_nhng(k,m);
  grav_nh(k) = grav_nh(k) + spect_nh(k,m);
  grav_bal(k) = grav_bal(k) + spect_bal(k,m);
 end

 for m = 121:180
  bal_ng(k) = bal_ng(k) + spect_ng(k,m);
  bal_nhng(k) = bal_nhng(k) + spect_nhng(k,m);
  bal_nh(k) = bal_nh(k) + spect_nh(k,m);
  bal_bal(k) = bal_bal(k) + spect_bal(k,m);
 end
 
end

max_ng = max(max(bal_ng));
max_nhng = max(max(bal_nhng));
max_nh = max(max(bal_nh));
max_bal = max(max(bal_bal));

maxval = max(max_ng,max(max_nhng,max(max_nh,max_bal)))*1.1

%%%%%%
%PLOT

nrows = 2
ncols = 2
range = 182:360;

figure, semilogy(xax(range),bal_bal(range),'k'), hold on
semilogy(xax(range),bal_ng(range),'b'), semilogy(xax(range),bal_nh(range),'r')
axis tight, Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Balanced mode regime comparison'})
l = legend('Acoustic','Gravity','Balanced'); set(l, 'Box','off')

figure, semilogy(xax(range),ac_bal(range),'k'), hold on
semilogy(xax(range),ac_ng(range),'b'), semilogy(xax(range),ac_nh(range),'r')
axis tight, Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Acoustic mode regime comparison'})
l = legend('Acoustic','Gravity','Balanced'); set(l, 'Box','off')

figure, semilogy(xax(range),grav_bal(range),'k'), hold on
semilogy(xax(range),grav_ng(range),'b'), semilogy(xax(range),grav_nh(range),'r')
axis tight, Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Gravity mode regime comparison'})
l = legend('Balanced','Non-geostrophic','Non-hydrostatic'); set(l, 'Box','off')


end

plot_fn_m = 1

if plot_fn_m == 1

% Calculate total variances for each physical mode type for each vertical waveno. m

for mu = 1:300
 spect_mu_ng(mu) = 0;
 spect_mu_nhng(mu) = 0;
 spect_mu_nh(mu) = 0;
 spect_mu_bal(mu) = 0;
 for k = 1:360
  spect_mu_ng(mu) = spect_mu_ng(mu) + spect_ng(k,mu);
  spect_mu_nhng(mu) = spect_mu_nhng(mu) + spect_nhng(k,mu);
  spect_mu_nh(mu) = spect_mu_nh(mu) + spect_nh(k,mu);
  spect_mu_bal(mu) = spect_mu_bal(mu) + spect_bal(k,mu);
 end
end

%calculate total gravity and acoustic

 acoustic_ng(1:60) = 0; acoustic_nh(1:60) = 0; acoustic_bal(1:60) = 0;
 grav_ng(1:60) = 0; grav_nh(1:60) = 0; grav_bal(1:60) = 0;
 bal_ng(1:60) = 0; bal_nh(1:60) = 0; bal_bal(1:60) = 0;

 
for k = 1:60
  acoustic_ng(k) = acoustic_ng(k) + spect_mu_ng(61-k);
  acoustic_nh(k) = acoustic_nh(k) + spect_mu_nh(61-k); 
  acoustic_bal(k) = acoustic_bal(k) + spect_mu_bal(61-k);
end

for j = 1:60
  k = 240+j;
  acoustic_ng(j) = acoustic_ng(j) + spect_mu_ng(k);
  acoustic_nh(j) = acoustic_nh(j) + spect_mu_nh(k); 
  acoustic_bal(j) = acoustic_bal(j) + spect_mu_bal(k);
end

for j = 1:60
  k = 60+j;
  grav_ng(j) = grav_ng(j) + spect_mu_ng(k);
  grav_nh(j) = grav_nh(j) + spect_mu_nh(k); 
  grav_bal(j) = grav_bal(j) + spect_mu_bal(k);
end

for j = 1:60
  k = 180+j;
  grav_ng(j) = grav_ng(j) + spect_mu_ng(241-j);
  grav_nh(j) = grav_nh(j) + spect_mu_nh(241-j); 
  grav_bal(j) = grav_bal(j) + spect_mu_bal(241-j);
end

for j = 1:60
  k = 120+j;
  bal_ng(j) = bal_ng(j) + spect_mu_ng(k);
  bal_nh(j) = bal_nh(j) + spect_mu_nh(k); 
  bal_bal(j) = bal_bal(j) + spect_mu_bal(k);
end


nrows = 3
ncols = 2

range = 1:60;
ymin = 1E5;
ymax = 1E15;

plot_mode_com  = 0

plot_regm_com  = 1

if  plot_mode_com  == 1
x = 4
figure
semilogy((bal_bal(range)),'k'); hold on, 
semilogy((grav_bal(range)),'b'),
semilogy((acoustic_bal(range)),'r')
axis tight;ylim([ymin ymax]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Balanced regime mode comparison'})
l = legend('Balanced','Gravity','Acoustic'); set(l, 'Box','off')

figure,
semilogy((bal_ng(range)),'k'); hold on, 
semilogy((grav_ng(range)),'b'),
semilogy((acoustic_ng(range)),'r')
axis tight;ylim([ymin ymax]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Non-geosrtrophic regime mode comparison'})
l = legend('Balanced','Gravity','Acoustic'); set(l, 'Box','off')

figure,
semilogy((bal_nh(range)),'k'); hold on, 
semilogy((grav_nh(range)),'b'),
semilogy((acoustic_nh(range)),'r')
axis tight;ylim([ymin ymax]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Non-hydrostatic regime mode comparison'})
l = legend('Balanced','Gravity','Acoustic'); set(l, 'Box','off')
end

if  plot_regm_com  == 1

figure
semilogy((bal_bal(range)),'k'); hold on, 
semilogy((bal_ng(range)),'b'),
semilogy((bal_nh(range)),'r')
axis tight;ylim([ymin ymax]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Balanced mode'})
l = legend('Balanced','Non-geostrophic','Non-hydrostatic');set(l, 'Box','off')

figure,
semilogy((grav_bal(range)),'k'); hold on, 
semilogy((grav_ng(range)),'b'),
semilogy((grav_nh(range)),'r')
axis tight;ylim([ymin ymax]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Gravity mode'})
l = legend('Balanced','Non-geostrophic','Non-hydrostatic');set(l, 'Box','off')

figure,
semilogy((acoustic_bal(range)),'k'); hold on, 
semilogy((acoustic_ng(range)),'b'),
semilogy((acoustic_nh(range)),'r')
axis tight;ylim([ymin ymax]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Acoustic mode'})
l = legend('Balanced','Non-geostrophic','Non-hydrostatic');set(l, 'Box','off')

end

end
