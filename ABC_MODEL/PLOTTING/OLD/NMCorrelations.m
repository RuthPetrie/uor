%% CORRELATION OF NORMAL MODES

% NMCorrelations
load_data = 1
plot_k_correlations = 1
plot_init_cor_comp = 0
plot_all_nms = 0
k1 = 2;
k2 = 10;
k3 = 20;
axis_scale =[-1.0 1.0];
for i = 1:360
  xax(i) = i;
end

nm_i= 60

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT CORRELATIONS OF HORIZONTAL WAVENUMBERS
if load_data == 1
 
%nmcor_k3 = load('/export/carrot/raid2/wx019276/DATA/CVT/CORRELATIONS/nm_cor_60_020_t_3hrs.dat');
%nmcor_k3 = reshape(nmcor_k3,179,300,300);
nmcor_k2 = load('/export/carrot/raid2/wx019276/DATA/CVT/CORRELATIONS/nm_cor_60_020_t_3hrs.dat');
nmcor= reshape(nmcor_k1,179,300,300);
nmcor2= reshape(nmcor_k1,180,300,300);
%nmcor_k1 = reshape(nmcor_k1,180,300,300);

%nmcor= reshape(nmcor_k1,179,300,300);

nmcor_k3 = load('/export/carrot/raid2/wx019276/DATA/CVT/CORRELATIONS/nm_cor_60_183_t0.dat');
nmcor_k3 = reshape(nmcor_k3,180,300,300);

%nm_diff = nmcor_k1 - nmcor_k1_ics;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

range = xax(2:180);
range = xax(1:180);

if plot_init_cor_comp == 1


nrows = 2;
ncols = 2; 
%Select gravity mode


h=figure; set(h,'Position',[94 144 1047 624])
mu = 58; mustr = '\mu = 2'
axis_scale =[-1.0 1.0];
subplot(nrows, ncols, 1),plot(xax(range),(squeeze(nmcor_k1(:,mu,mu))),'k'), hold on
plot(xax(range),(squeeze(nmcor_k3(:,mu,mu))),'r')
axis tight, ylim(axis_scale)
l = legend('t = 3 hrs','t = 0 hrs'); set(l, 'Box','off'), title('Correlations of k = 2, m=2; gravity modes')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')

mu = 2; mustr = '\mu = 2'
subplot(nrows, ncols, 2),plot(xax(range),(squeeze(nmcor_k1(:,mu,mu))),'k'), hold on
plot(xax(range),(squeeze(nmcor_k3(:,mu,mu))),'r')
axis tight, ylim(axis_scale)
l = legend('t = 3 hrs','t = 0 hrs'); set(l, 'Box','off'), title('Correlations of k = 2, m=2; balanced')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')

mu = 118 ; mustr = '\mu = 58'
axis_scale =[-1.0 1.0];
subplot(nrows, ncols, 3),plot(xax(range),(squeeze(nmcor_k1(:,mu,mu))),'k'), hold on
plot(xax(range),(squeeze(nmcor_k3(:,mu,mu))),'r')
axis tight, ylim(axis_scale)
l = legend('t = 3 hrs','t = 0 hrs'); set(l, 'Box','off'), title('Correlations of k = 2, m=58; gravity modes')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')

mu = 178; mustr = '\mu = 58'
subplot(nrows, ncols, 4),plot(xax(range),(squeeze(nmcor_k1(:,mu,mu))),'k'), hold on
plot(xax(range),(squeeze(nmcor_k3(:,mu,mu))),'r')
axis tight, ylim(axis_scale)
l = legend('t = 3 hrs','t = 0 hrs'); set(l, 'Box','off'), title('Correlations of k = 2, m=58; balanced')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')


end


%mu = 62; mustr = 'm = 2'
%plot(squeeze(nmcor_k1(:,mu,mu)),'k'), hold on, plot(squeeze(nmcor_k2(:,mu,mu)),'r'),  
%plot(squeeze(nmcor_k3(:,mu,mu)),'b'),   ylim(axis_scale)
%l = legend('k=2', 'k=3','k=4'); set(l, 'Box','off'), 
%title('Correlations of m=2 for three other k for gravity mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')

%mu = 58; mustr = 'm = 2'
%mu2 = 30; mu2str = 'm = 30'
%mu3 = 2; mu3str = 'm = 58'
%nrows = 3;
%ncols = 1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT CORRELATIONS OF HORIZONTAL WAVENUMBERS
if plot_k_correlations == 1

% set eigenindex
axis_scale =[-1.0 1.0];
%mu = 58; mustr = 'm = 2'
%mu2 = 30; mu2str = 'm = 30'
%mu3 = 2; mu3str = 'm = 58'
nrows = 2;
ncols = 2; 
%Select gravity mode
mu = 62; mustr = '\mu = 2'
mu2 = 90; mu2str = '\mu = 30'
mu3 = 118; mu3str = '\mu = 58'

continuer =444

% gravity mode correlations
h=figure; set(h,'Position',[94 144 1047 624])
subplot(nrows, ncols, 1), plot(xax(range),(squeeze(nmcor_k1(:,mu,mu))),'k'), axis tight, ylim(axis_scale)
l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 178 with other k for gravity mode')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
subplot(nrows, ncols, 2), plot(xax(range),(squeeze(nmcor_k1(:,mu3,mu3))),'k--'), axis tight, ylim(axis_scale)
xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')
subplot(nrows, ncols, 3), plot(xax(range),(squeeze(nmcor_k3(:,mu,mu))),'k'), axis tight, ylim(axis_scale)
l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 160 at initial time')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
subplot(nrows, ncols, 4), plot(xax(range),(squeeze(nmcor_k3(:,mu3,mu3))),'k--'), axis tight, ylim(axis_scale)
xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')


% Select balanced mode
mu = 122; mustr = '\mu = 2'
mu3 = 178; mu3str = '\mu = 58'

% Balanced mode correlations
h=figure; set(h,'Position',[94 144 1047 624])
subplot(nrows, ncols, 1), plot(xax(range),(squeeze(nmcor_k1(:,mu,mu))),'k'), axis tight, ylim(axis_scale)
l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 178 with other k for balanced mode')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
subplot(nrows, ncols, 2), plot(xax(range),(squeeze(nmcor_k1(:,mu3,mu3))),'k--'), axis tight, ylim(axis_scale)
xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')
subplot(nrows, ncols, 3), 

mu = 178; mustr = '\mu = 58'
mu3 = 118; mu3str = '\mu = 58'
plot(xax(range),flipud(squeeze(nmcor_k1(:,mu,mu))),'k'), axis tight, ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 20')
xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 4), 
hold on
plot(xax(range),flipud(squeeze(nmcor_k1(:,mu3,mu3))),'m'), axis tight, ylim(axis_scale)
xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend('Balanced mode','Gravity mode'); set(l, 'Box','off')



%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k2(:,mu,mu)),'k'), ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 10 with other k for acoustic mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k2(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k2(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')

%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k3(:,mu,mu)),'k'), ylim(axis_scale)
% = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 20 with other k for acoustic mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k3(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k3(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')


%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k1(:,mu,mu)),'k'), ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 1 with other k for gravity mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k1(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k1(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')


%figure
%mu = 62; mustr = 'm = 2'
%mu4 = 71, mu4str = 'm = 10' 
%plot(squeeze(nmcor_k1(:,mu,mu)),'k'), hold on,plot(squeeze(nmcor_k1(:,mu4,mu4)),'r'),  ylim(axis_scale)
%l = legend(mustr, mu4str); set(l, 'Box','off'), title('Correlations of k = 1 with other k for gravity mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')

axis_scale =[-1.0 1.0];


%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k2(:,mu,mu)),'k'), ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 10 with other k for gravity mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k2(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k2(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')

%figure, 
%ubplot(nrows, ncols, 1), plot(squeeze(nmcor_k3(:,mu,mu)),'k'), ylim(axis_scale)
% = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 20 with other k for gravity mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k3(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k3(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')



%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k1(:,mu,mu)),'k'), ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 1 with other k for balanced mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k1(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k1(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')

%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k2(:,mu,mu)),'k'), ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 10 with other k for balanced mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k2(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k2(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')

%figure, 
%subplot(nrows, ncols, 1), plot(squeeze(nmcor_k3(:,mu,mu)),'k'), ylim(axis_scale)
%l = legend(mustr); set(l, 'Box','off'), title('Correlations of k = 20 with other k for balanced mode')
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation')
%subplot(nrows, ncols, 2), plot(squeeze(nmcor_k3(:,mu2,mu2)),'k-.'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu2str); set(l, 'Box','off')
%subplot(nrows, ncols, 3), plot(squeeze(nmcor_k3(:,mu3,mu3)),'k--'), ylim(axis_scale)
%xlabel('Horizontal wavenumber, k'), ylabel('Correlation'), l = legend(mu3str); set(l, 'Box','off')



end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xstop = 1
if xstop == 0 


k1=  2
k3 = 20
%k1 = 1  
%k2 = 10
%k3 = 20
% horizontal wavenumber
%k = 2
%kval = 'k = 20'
% eigenmode index

 nmcors(1:300,1:300) = squeeze(nmcor(60,:,:));
 %nmcor2(1:300,1:300) = squeeze(nmcor_k1(k3,:,:));

 nmcors(1:60,:) = flipud(squeeze(nmcor(60,1:60,:)));
 nmcors(181:240,:) = flipud(squeeze(nmcor(60,181:240,:)));
 nmcors(:,1:60) = fliplr(nmcors(:,1:60));
 nmcors(:,181:240) = fliplr(nmcors(:,181:240));


% nmcor2(1:60,:) = flipud(squeeze(nmcor_k1(k3,1:60,:)));
% nmcor2(181:240,:) = flipud(squeeze(nmcor_k1(k3,181:240,:)));
% nmcor2(:,1:60) = fliplr(nmcor2(:,1:60));
% nmcor2(:,181:240) = fliplr(nmcor2(:,181:240));

axis_scale =[-1.0 1.0];

h= figure; set(h, 'Position',[360 216 759 644])
pcolor(nmcor(:,:)), caxis(axis_scale),colormap(redblue), shading flat, colorbar, axis ij
xlabel('\mu - eigenindex'), ylabel('\mu - eigenindex')

%plot(nmcor(58,:)), ylim([-1.0 1.0])
%figure,pcolor(nmcor2(:,:)), caxis(axis_scale),colormap(redblue), shading flat, colorbar, axis ij

%figure,pcolor(squeeze(nmcor_k3(k,:,:))), caxis(axis_scale),colormap(redblue), shading flat, colorbar, axis ij
end


if plot_all_nms == 1

%===================================================================================================  
%% correlation with same k and all other mu
nrows = 3
ncols = 2
modes = ['60';'120';'180';'240';'300'];
modes2= [0 60 120 180 240 300];
h = figure
set(h, 'Position',[128 77 769 760])%[101 213 1032 579])
%
annotation(h,'textbox',...
     [0.571871261378413 0.234210526315789 0.265579973992198 0.0947368421052631],...
    'String',{'Correlation point',kval,'mu = 122 := balanced mode ; m = ? '},...
    'FitBoxToText','off',...
    'LineStyle','none');
   %[0.688984496124031 0.143350604490501 0.213147286821705 0.305699481865285],...
%    [0.406721716514954 0.0105263157894737 0.307062418725618 0.0618421052631579],...

subplot(nrows, ncols, 1), 
plot(flipud(squeeze(nmcor_k3(k,mu,1:60))),'k'), ylim(axis_scale),
title('acoustic; (60:1)'), xlabel('Vertical wave number, m'),ylabel('Correlation')
%hold on
%plot(flipud(squeeze(nmcor_k2(k2,mu,1:60))),'r'), ylim(axis_scale),
%plot(flipud(squeeze(nmcor_k3(k3,mu,1:60))),'b'), ylim(axis_scale),
%
subplot(nrows, ncols, 2), 
plot(squeeze(nmcor_k3(k,mu,241:300)),'k'),  ylim(axis_scale),
title('acoustic; (241:300)'), xlabel('Vertical wave number, m'),ylabel('Correlation')
hold on
%plot((squeeze(nmcor_k2(k2,mu,241:300))),'r'), ylim(axis_scale),
%plot((squeeze(nmcor_k3(k3,mu,241:300))),'b'), ylim(axis_scale),
%
subplot(nrows, ncols, 3), 
plot(squeeze(nmcor_k3(k,mu,61:120)),'k'),  ylim(axis_scale),
title('gravity; (61:120)'), xlabel('Vertical wave number, m'),ylabel('Correlation')
hold on
%plot((squeeze(nmcor_k2(k2,mu,61:120))),'r'), ylim(axis_scale),
%plot((squeeze(nmcor_k3(k3,mu,61:120))),'b'), ylim(axis_scale),
%
subplot(nrows, ncols, 4), 
plot(flipud(squeeze(nmcor_k3(k,mu,181:240))),'k'),  ylim(axis_scale),
title('gravity; (240:181)'), xlabel('Vertical wave number, m'),ylabel('Correlation')
hold on
%plot(flipud(squeeze(nmcor_k2(k2,mu,181:240))),'r'), ylim(axis_scale),
%plot(flipud(squeeze(nmcor_k3(k3,mu,181:240))),'b'), ylim(axis_scale),
%
subplot(nrows, ncols, 5), 
plot(squeeze(nmcor_k3(k,mu,121:180)),'k'),  ylim(axis_scale),
title('balanced; (121:180)'), xlabel('Eigenindex, \mu'),ylabel('Correlation')
hold on
%plot(flipud(squeeze(nmcor_k2(k2,mu,121:180))),'r'), ylim(axis_scale),
%plot(flipud(squeeze(nmcor_k3(k3,mu,121:180))),'b'), ylim(axis_scale),
%
%subplot(nrows, ncols, 6), 
%plot((squeeze(nmcor_k1(:,mu,mu))),'k'),  ylim(axis_scale),
%title('Correlation with other wavenumbers'), xlabel('Horizontal wavenumber, k'),ylabel('Correlation')
%hold on
%plot((squeeze(nmcor_k2(:,mu,mu))),'r'), ylim(axis_scale),
%plot((squeeze(nmcor_k3(:,mu,mu))),'b'), ylim(axis_scale),

%l = legend('k=10','k=50','k=100')
%set(l,'Box','off','Position',[0.5755 0.1949 0.0803 0.0252])%[0.6914 0.3301 0.0598 0.0331])
%
 
%===================================================================================================  
end
