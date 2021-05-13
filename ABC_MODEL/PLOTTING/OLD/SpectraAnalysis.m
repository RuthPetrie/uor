%% SpectraAnalysis

cont = 36

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

max_ng = max(max(spect_ng))
max_nhng = max(max(spect_nhng))
max_nh = max(max(spect_nh))
max_bal = max(max(spect_bal))

maxval = max(max_ng,max(max_nhng,max(max_nh,max_bal)));


%% SET AXES
temp = -181
for i = 1:360
xax(i) = temp +i;
end

for i = 1:300
muax(i) = i;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeplot_total_variance_m = 0

if makeplot_total_variance_m == 1

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


nrows = 3
ncols = 2
ac1range = 1:60;
ac2range = 241:300;
gv1range = 61:120;
gv2range = 181:240;
balrange = 121:180;

figure
%subplot(nrows,ncols,1)
semilogy(fliplr(spect_mu_bal(ac1range)),'k')
hold on
semilogy(fliplr(spect_mu_nh(ac1range)),'b'),
semilogy(fliplr(spect_mu_ng(ac1range)),'r'), 
semilogy(fliplr(spect_mu_nhng(ac1range)),'g'),
axis tight
Ylim([1E6 1E13]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
%title({'Covariance spectrum','Accoustic mode (60:1)'})
l = legend('Balanced','Non-hydrostatic','Non-geostrophic',...
           'Non-hydrostatic, non-geostrophic');set(l, 'Box','off')

%subplot(nrows,ncols,2)
figure,semilogy(spect_mu_bal(ac2range),'k')
hold on
semilogy(spect_mu_nh(ac2range),'b'),
semilogy(spect_mu_ng(ac2range),'r'), 
semilogy(spect_mu_nhng(ac2range),'g'),
axis tight
Ylim([1E6 1E13]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
%title({'Covariance spectrum','Accoustic mode (241:300)'})
l = legend('Balanced','Non-hydrostatic','Non-geostrophic',...
           'Non-hydrostatic, non-geostrophic');set(l, 'Box','off')

%subplot(nrows,ncols,3)
figure,semilogy(spect_mu_bal(gv1range),'k')
hold on
semilogy(spect_mu_nh(gv1range),'b'),
semilogy(spect_mu_ng(gv1range),'r'), 
semilogy(spect_mu_nhng(gv1range),'g'),
axis tight
Ylim([1E6 1E13]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
%title({'Covariance spectrum','Gravity mode (61:120)'})
l = legend('Balanced','Non-hydrostatic','Non-geostrophic',...
           'Non-hydrostatic, non-geostrophic');set(l, 'Box','off')

%subplot(nrows,ncols,4)
figure,semilogy(fliplr(spect_mu_bal(gv2range)),'k')
hold on
semilogy(fliplr(spect_mu_nh(gv2range)),'b'),
semilogy(fliplr(spect_mu_ng(gv2range)),'r'), 
semilogy(fliplr(spect_mu_nhng(gv2range)),'g'),
axis tight
Ylim([1E6 1E13]) 
xlabel(['m: vertical wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
%title({'Covariance spectrum','Gravity mode (240:181)'})
l = legend('Balanced','Non-hydrostatic','Non-geostrophic',...
           'Non-hydrostatic, non-geostrophic');set(l, 'Box','off')

%subplot(nrows,ncols,5)
figure,semilogy(spect_mu_bal(balrange),'k')
hold on
semilogy(spect_mu_nh(balrange),'b'),
semilogy(spect_mu_ng(balrange),'r'), 
semilogy(spect_mu_nhng(balrange),'g'),
axis tight
Ylim([1E10 3E14]) 
xlabel(['\mu: eigenindex'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
%title({'Covariance spectrum','Balanced mode (121:180)'})
l = legend('Balanced','Non-hydrostatic','Non-geostrophic',...
           'Non-hydrostatic, non-geostrophic');set(l, 'Box','off')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure, semilogy(fliplr(spect_mu_bal(ac1range)),'r'), hold on
semilogy(spect_mu_bal(gv1range),'b'),semilogy(spect_mu_bal(balrange),'k'),axis tight, Ylim([1E5 maxval]) 
xlabel(['m: vertical wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
l = legend('Acoustic','Gravity','Balanced');set(l, 'Box','off')

figure, semilogy(fliplr(spect_mu_nh(ac1range)),'r'), hold on
semilogy(spect_mu_nh(gv1range),'b'),semilogy(spect_mu_nh(balrange),'k'),axis tight, Ylim([1E5 maxval]) 
xlabel(['m: vertical wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
l = legend('Acoustic','Gravity','Balanced');set(l, 'Box','off')

figure, semilogy(fliplr(spect_mu_nhng(ac1range)),'r'), hold on
semilogy(spect_mu_nhng(gv1range),'b'),semilogy(spect_mu_nhng(balrange),'k'),axis tight, Ylim([1E5 maxval]) 
xlabel(['m: vertical wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
l = legend('Acoustic','Gravity','Balanced');set(l, 'Box','off')

figure, semilogy(fliplr(spect_mu_ng(ac1range)),'r'), hold on
semilogy(spect_mu_ng(gv1range),'b'),semilogy(spect_mu_ng(balrange),'k'),axis tight, Ylim([1E5 maxval]) 
xlabel(['m: vertical wavenumber'],'FontSize',12), ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
l = legend('Acoustic','Gravity','Balanced');set(l, 'Box','off')


%%%%%%%%%%%%%%%%%%%%%%

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeplot_total_variance = 1

if makeplot_total_variance == 1

% Calculate total variances for each physical mode type for each horizontal waveno. k


for k = 1: 360
 a1_ng(k) = 0;
 a2_ng(k) = 0;
 g1_ng(k) = 0;
 g2_ng(k) = 0;
 bal_ng(k) = 0;
 a1_nhng(k) = 0;
 a2_nhng(k) = 0;
 g1_nhng(k) = 0;
 g2_nhng(k) = 0;
 bal_nhng(k) = 0;
 a1_nh(k) = 0;
 a2_nh(k) = 0;
 g1_nh(k) = 0;
 g2_nh(k) = 0;
 bal_nh(k) = 0;
 a1_bal(k) = 0;
 a2_bal(k) = 0;
 g1_bal(k) = 0;
 g2_bal(k) = 0;
 bal_bal(k) = 0;

 for m = 1:60
  a1_ng(k) = a1_ng(k) + spect_ng(k,m);
  a1_nhng(k) = a1_nhng(k) + spect_nhng(k,m);
  a1_nh(k) = a1_nh(k) + spect_nh(k,m);
  a1_bal(k) = a1_bal(k) + spect_bal(k,m);
 end

 for m = 241:300
  a1_ng(k) = a1_ng(k) + spect_ng(k,m);
  a1_nhng(k) = a1_nhng(k) + spect_nhng(k,m);
  a1_nh(k) = a1_nh(k) + spect_nh(k,m);
  a1_bal(k) = a1_bal(k) + spect_bal(k,m);
 end

 for m = 61:120
  g1_ng(k) = g1_ng(k) + spect_ng(k,m);
  g1_nhng(k) = g1_nhng(k) + spect_nhng(k,m);
  g1_nh(k) = g1_nh(k) + spect_nh(k,m);
  g1_bal(k) = g1_bal(k) + spect_bal(k,m);
 end

 for m = 181:240
  g1_ng(k) = g1_ng(k) + spect_ng(k,m);
  g1_nhng(k) = g1_nhng(k) + spect_nhng(k,m);
  g1_nh(k) = g1_nh(k) + spect_nh(k,m);
  g1_bal(k) = g1_bal(k) + spect_bal(k,m);
 end

% for m = 181:240
%  g2_ng(k) = g2_ng(k) + spect_ng(k,m);
% end

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



nrows = 2
ncols = 2
range = 230:360;
figure
maxval = 1E6
%spectrum_ng = figure
%subplot(nrows,ncols,4)
semilogy(xax(range),a1_ng(range),'r'), hold on
%semilogy(xax,a2_ng,'r--'),hold on
semilogy(xax(range),g1_ng(range),'b'),
%semilogy(xax,g1_ng,'b--'),
semilogy(xax(range),bal_ng(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','36: Geostrophically unstable'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')


%spectrum_nhng = figure
%subplot(nrows,ncols,3)
figure
semilogy(xax(range),a1_nhng(range),'r'), hold on
%semilogy(xax,a2_nhng,'r--'),hold on
semilogy(xax(range),g1_nhng(range),'b'),
%semilogy(xax,g1_nhng,'b--'),
semilogy(xax(range),bal_nhng(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','35: Hydrostatically and Geostrophically unstable'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')

%spectrum_nh = figure
%subplot(nrows,ncols,2)

figure
semilogy(xax(range),a1_nh(range),'r'), hold on
%semilogy(xax,a2_nh,'r--'),hold on
semilogy(xax(range),g1_nh(range),'b'),
%semilogy(xax,g1_nh,'b--'),
semilogy(xax(range),bal_nh(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','34: Hydrostatically unstable'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')

%spectrum_bal = figure
%subplot(nrows,ncols,1)
figure
semilogy(xax(range),a1_bal(range),'r'), hold on
%semilogy(xax,a2_bal,'r--'),hold on
semilogy(xax(range),g1_bal(range),'b'),
%semilogy(xax,g1_bal,'b--'),
semilogy(xax(range),bal_bal(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','33: Balanced regime'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')

%%%%%%%^^^^^^^^^^^^^^^%%%%%%%%%
range = (150:180)
%maxval = 2E4
figure
plot(xax(range),a1_ng(range),'r'), hold on
plot(xax(range),g1_ng(range),'b'),
plot(xax(range),bal_ng(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','36: Geostrophically unstable'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')

figure
plot(xax(range),a1_nhng(range),'r'), hold on
plot(xax(range),g1_nhng(range),'b'),
plot(xax(range),bal_nhng(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','35: Hydrostatically and Geostrophically unstable'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')

figure
plot(xax(range),a1_nh(range),'r'), hold on
plot(xax(range),g1_nh(range),'b'),
plot(xax(range),bal_nh(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','34: Hydrostatically unstable'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')

figure
plot(xax(range),a1_bal(range),'r'), hold on
plot(xax(range),g1_bal(range),'b'),
plot(xax(range),bal_bal(range),'k')
axis tight
Ylim([0 maxval]) 
xlabel(['k: horizontal wavenumber'],'FontSize',12)
ylabel([{'Total','Variance'}],'FontSize',12)%,'Rotation',00)
title({'Covariance spectrum','33: Balanced regime'})
l = legend('Acoustic','Gravity','Balanced');
set(l, 'Box','off')



end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeplot_spect = 0

if makeplot_spect == 1

spectrum = figure

nrows = 3
ncols = 2
k1 = 1
k2 = 10
k3 = 50
k1s = '1'
k2s = '10'
k3s = '50'

set(spectrum, 'Position',[128 77 769 760])%[101 213 1032 579])
%
subplot(nrows,ncols,1)
plot(fliplr(spect(k1, 1:60)),  'k'), hold on, 
plot(fliplr(spect(k2, 1:60)),  'k:'),
plot(fliplr(spect(k3, 1:60)),  'k-'),
title(['Acoustic; (60:1)'], 'Fontsize',12)
xlabel(['m - vertical wavenumber'],'FontSize',12)
ylabel(['\sigma^2  '],'FontSize',12,'Rotation',00)

subplot(nrows,ncols,2)
plot((spect(k1, 241:300)),  'k'), hold on, 
plot((spect(k2, 241:300)),  'k:'),
plot((spect(k3, 241:300)),  'k-'),
title(['Acoustic; (241:300)'], 'Fontsize',12)
xlabel(['m - vertical wavenumber'],'FontSize',12)
ylabel(['\sigma^2  '],'FontSize',12,'Rotation',00)

subplot(nrows,ncols,3)
plot((spect(k1, 61:121)),  'k'), hold on, 
plot((spect(k2, 61:121)),  'k:'),
plot((spect(k3, 61:121)),  'k-'),axis tight
title(['Gravity; (61:121)'], 'Fontsize',12)
xlabel(['m - vertical wavenumber'],'FontSize',12)
ylabel(['\sigma^2  '],'FontSize',12,'Rotation',00)

subplot(nrows,ncols,4)
plot(fliplr(spect(k1, 181:240)),  'k'), hold on, 
plot(fliplr(spect(k2, 181:240)),  'k:'),
plot(fliplr(spect(k3, 181:240)),  'k-'),
title(['Gravity; (240:181)'], 'Fontsize',12)
xlabel(['m - vertical wavenumber'],'FontSize',12)
ylabel(['\sigma^2  '],'FontSize',12,'Rotation',00)

subplot(nrows,ncols,5)
plot(fliplr(spect(k1, 121:180)),  'k'), hold on, 
plot(fliplr(spect(k2, 121:180)),  'k:'),
plot(fliplr(spect(k3, 121:180)),  'k-'),
title(['Balanced; (121:180)'], 'Fontsize',12)
xlabel(['\mu - Eigenindex'],'FontSize',12)
ylabel(['\sigma^2  '],'FontSize',12,'Rotation',00)

l = legend(k1s,k2s,k3s)
set(l,'Box','off','Position',[0.5755 0.1949 0.0803 0.0252])%[0.6914 0.3301 0.0598 0.0331])

annotation(spectrum,'textbox',...
    [0.572 0.234 0.266 0.095],...
    'String',{'Covariance spectrum','Geostrophically unbalanced','Ens 36'},...
    'FitBoxToText','off',...
    'LineStyle','none');
 


end

makeplot_k0 = 0

if makeplot_k0 == 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT standard deviation as a function of k
figure

% set parameters
mu1 = 10;
mu2 = 160;
range1 = 171:191;

%plot
subplot(2,2,1), semilogy(xax,spect(mu1, :),'k')          
axis tight,xlabel('k'),ylabel('std'),title(['mu = ', num2str(mu1)]) 

subplot(2,2,2), plot(xax(range1),spect(mu1, range1),'k')
axis tight,xlabel('k'),ylabel('std'),title(['mu = ', num2str(mu1)]) 

subplot(2,2,3), semilogy(xax,spect(mu2, :),'k')
axis tight,xlabel('k'),ylabel('std'),title(['mu = ', num2str(mu2)]) 
 
subplot(2,2,4), plot(xax(range1),spect(mu2, range1),'k')
axis tight,xlabel('k'),ylabel('std'),title(['mu = ', num2str(mu2)]) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT standard deviation as a function of mu

figure

subplot(2,1,1)
plot(spect(:,181),'k'), xlabel('mu'), ylabel('std'), title('k = 0')

subplot(2,2,3)
plot(muax(1:60),spect(121:180,181),'k'), 
xlabel('mu'), ylabel('std'), title('k = 0')

subplot(2,2,4)
plot(muax(241:300),spect(241:300,181),'k'), 
xlabel('mu'), ylabel('std'), title('k = 0')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT FREQUENCIES

makeplot_freq = 0
 if makeplot_freq == 1  

evals = load('/export/carrot/raid2/wx019276/DATA/CVT/EigVals_ref.dat');
% scale frequencies
f = 0.0001
evals = f*evals;
nrows = 3
ncolumns = 2
 
 freq = figure
 set(freq, 'Position',  [360 346 881 542])
 % set k
 kval = 181
 subplot(nrows,ncolumns,1), 
  plot(fliplr(evals(kval, 1:60)),  'k'), hold on, 
  title(['p1 - acoustic'], 'Fontsize',12)
  xlabel(['m - vertical wavenumber'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  
 subplot(nrows,ncolumns,2),
  plot(evals(kval,  61:120), 'k'),  
  title(['p2 - gravity'], 'Fontsize',12), hold on 
 % plot(evals(k1, 61:120), 'k-.'),
 % plot(evals(k2, 61:120), 'k--'), 
 % plot(evals(k3, 61:120), 'k-')
  xlabel(['m - vertical wavenumber'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  
 subplot(nrows,ncolumns,3), 
  plot(evals(kval,  121:180), 'k'), 
  title(['p3 - balanced'], 'Fontsize',12), hold on, 
  axis([1 60 -0.1 0.1])
%  plot(evals(k1, 121:180), 'k-.'),
%  plot(evals(k2, 121:180), 'k--'), 
%  plot(evals(k3, 121:180), 'k-')
  xlabel(['n - eigenmode index'],'FontSize',12)
% xlabel(['m - vertical wavenumber'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  
 subplot(nrows,ncolumns,5), 
  plot(fliplr(evals(kval,  181:240)), 'k'), 
  title(['p4 - gravity'], 'Fontsize',12), hold on
 % plot(fliplr(evals(k1, 181:240)), 'k-.'),
 % plot(fliplr(evals(k2, 181:240)), 'k--'), 
 % plot(fliplr(evals(k3, 181:240)), 'k-')
  xlabel(['m - vertical wavenumber'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  
 subplot(nrows,ncolumns,4), 
  plot(evals(kval,  241:300), 'k'), 
  title(['p5 - acoustic'], 'Fontsize',12), hold on
 % plot(evals(k1, 241:300), 'k-.'),
 % plot(evals(k2, 241:300), 'k--'), 
 % plot(evals(k3, 241:300), 'k-')
  xlabel(['m - vertical wavenumber'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  
  %c={'k = ' num2str(k1),'This is plot 2','And this is the last plot'}
%  legend(['k = ' num2str(k)], ...
%         ['k = ' num2str(k1)],...
%         ['k = ' num2str(k2)],...
%         ['k = ' num2str(k3)])
   legend('k = 0')
annotation1 = annotation(...
  freq,'textbox',...
  'Position',[0.5799 0.1802 0.0996 0.1213],...
  'LineStyle','none',...
  'Fontsize',14,...
  'String',{'Parameters',...
  'A = 4 x 10^{-4}',...
  'B = 10^{-1}',...
  'C = 10^4'},...
  'FitHeightToText','on');
 end

