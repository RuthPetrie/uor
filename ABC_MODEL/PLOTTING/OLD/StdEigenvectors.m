%% Spectrum plots
% StdEigenvectors
cont = 33

ensemble = 'Ensemble 33'
spect = load ('/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_33.dat');
spect=reshape(spect, [360 300]);
spect = spect';
%spect = load ('/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_large_f_13.dat');

scale = [0.0 1000.0]

plot = 31

h = figure
%set(h, 'Position', [360 346 881 542])
set(h, 'Position', [79 198 1025 584])
k1 = 182;
k2 = 220;
k3 = 300;
for i = 1:60
xax(i) = i;
end

yaxscale = [10E0 10E15];
nrows = 2;
ncolumns = 3;
subplot(nrows,ncolumns,1)
semilogy(xax(2:60),(flipud(spect(1:59,k1).^2)), 'k'), hold on, dd = caxis
semilogy(xax(2:60),(flipud(spect(1:59,k2).^2)), 'r--')
semilogy(xax(2:60),(flipud(spect(1:59,k3).^2)), 'k-.')
axis([1 60 1 10E15])
title('physical mode 1: acoustic')
xlabel('m - vertical wave no.'), ylabel('variance')

subplot(nrows,ncolumns,2)
semilogy((spect(61:120,k1).^2), 'k'), hold on 
semilogy((spect(61:120,k2).^2), 'r--')
semilogy((spect(61:120,k3).^2), 'k-.')
title('physical mode 2: gravity')
axis([1 60 1 10E15])
xlabel('m - vertical wave no.'), ylabel('variance')

subplot(nrows,ncolumns,3)
semilogy((spect(121:180,k1).^2), 'k'), hold on, V = caxis
semilogy((spect(121:180,k2).^2), 'r--')
semilogy((spect(121:180,k3).^2), 'k-.')
title('physical mode 3: balanced')
%xlabel('n - eigenvector index'), ylabel('variance')
xlabel('m - vertical wave no.'), ylabel('variance')
axis([1 60 1 10E15])


subplot(nrows,ncolumns,5)
semilogy(flipud(spect(181:240,k1).^2), 'k'), hold on 
semilogy(flipud(spect(181:240,k2).^2), 'r--')
semilogy(flipud(spect(181:240,k3).^2), 'k-.')
title('physical mode 4: gravity')
xlabel('m - vertical wave no.'), ylabel('variance')
axis([1 60 1 10E15])

subplot(nrows,ncolumns,4)
semilogy(xax(2:60),(spect(242:300,k1).^2), 'k'), hold on 
semilogy(xax(2:60),(spect(242:300,k2).^2), 'r--')
semilogy(xax(2:60),(spect(242:300,k3).^2), 'k-.')
title('physical mode 5: acoustic')
xlabel('m - vertical wave no.'), ylabel('variance')
axis([1 60 1 10E15])

legend('k = 1', 'k = 40','k = 80')

annotation1 = annotation(...
  h,'textbox',...
  'Position',[0.7799 0.3202 0.0996 0.1213],...%[0.5821 0.0214 0.2446 0.3143],...
  'LineStyle','none',...
  'FitHeightToText','off',...
  'String',{'Variance spectra',...
   ensemble,...
  'actually variances'});



%legend(['k = ',num2str(k1)],['k = ',num2str(k2)],['k = ',num2str(k3)])

%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.7799 0.3202 0.0996 0.1213],...
%  'LineStyle','none',...
%  'Fontsize',14,...
%  'String',{'Parameters',...
%  'A = 4 x 10^{-4}',...
%  'B = 10^{-2}',...
%  'C = 10^4'},...
%  'FitHeightToText','on');

if plot == 1 
h = figure
set(h, 'Position', [360 99 762 825])

subplot(3,2,1), colormap(flipud(hot)),  logzplot(spect(2:60, :),'pcolor','colorbar'), axis ij
%caxis(scale), 
xlabel('k - horizontal wave no.'), ylabel('\mu - verical wave no.','Interpreter','tex')
shading flat, title('Physical mode:p1 accoustic')

subplot(3,2,3), colormap(flipud(hot)), logzplot(spect(62:121, :),'pcolor','colorbar'),
shading flat, title('p2: gravity')

subplot(3,2,5), colormap(flipud(hot)),  logzplot(spect(122:180, :),'pcolor','colorbar'),
%caxis(scale),  
shading flat,  title('p3: balanced')

subplot(3,2,4), colormap(flipud(hot)),  logzplot(spect(182:240, :),'pcolor','colorbar'), axis ij
%caxis(scale),  
shading flat,  title('p4: gravity')

subplot(3,2,2), colormap(flipud(hot)),  logzplot(spect(242:300, :),'pcolor','colorbar'),
%caxis(scale),  
shading flat,  title('p5: acoustic')

annotation1 = annotation(...
  h,'textbox',...
  'Position',[0.5821 0.0214 0.2446 0.3143],...
  'LineStyle','none',...
  'FitHeightToText','off',...
  'String',{'Variance spectra',...
   ensemble,...
  'actually standard deviations'});
end 















