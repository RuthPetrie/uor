%% Program to plot the eigenvalues and eigenvectors of the 
%  system matrix
%  EigValuesVectsofSystemMatrix

cont = 1

%% OPTIONS
%--------------
pl_evals = 0
pl_evecs = 1

%===================================================================================================
% EIGENVALUES
%===================================================================================================
 if pl_evals == 1

  evals = load('/export/carrot/raid2/wx019276/DATA/CVT/EigVals_ref.dat');
  % scale frequencies
  f = 0.0001
  evals = f*evals;

 makeplot_m = 1

 if makeplot_m == 1  
 
  nrows = 3
  ncols = 2 
% freq = figure
%  set(freq, 'Position',[360 136 756 724])
  % set k
  k = 182; k1 = 211; k2 = 241; k3 = 301
  k1val = 'k = 1'
  k2val = 'k = 30'
  k3val = 'k = 60'
  k4val = 'k = 120'
  
 % subplot(nrows, ncols,1), 
 figure
  plot((evals(k, 1:60)),  'k:'), hold on, title(['p1 (\mu  = 1:60)- acoustic'], 'Fontsize',12), 
  plot((evals(k1, 1:60)), 'k-.'),
  plot((evals(k2, 1:60)), 'k--'), 
  plot((evals(k3, 1:60)), 'k-')
  xlabel(['\mu - eigenindex'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  axis tight, 
  l = legend(k1val, k2val, k3val, k4val)
  set(l, 'Box', 'off')
 % subplot(nrows, ncols,2),
 figure
  plot(evals(k,  61:120), 'k:'),  title(['p2 (\mu  = 61:120)- gravity'], 'Fontsize',12), hold on 
  plot(evals(k1, 61:120), 'k-.'),
  plot(evals(k2, 61:120), 'k--'), 
  plot(evals(k3, 61:120), 'k-')
  xlabel(['\mu - eigenindex'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  axis tight, 
  l = legend(k1val, k2val, k3val, k4val)
  set(l, 'Box', 'off')
  
 % subplot(nrows, ncols,3), 
for i = 1:60
  xax(i) = 180+i;
end
 figure
  plot(xax,evals(k,  121:180), 'k:'), title(['p3 (\mu  = 121:180)- balanced'], 'Fontsize',12), hold on, 
  plot(xax,evals(k1, 121:180), 'k-.'),
  plot(xax,evals(k2, 121:180), 'k--'), 
  plot(xax,evals(k3, 121:180), 'k-')
%  xlabel(['n - eigenmode index'],'FontSize',12)
  xlabel(['\mu - eigenindex'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  axis tight, 
  ylim([-0.1 0.1])
  l = legend(k1val, k2val, k3val, k4val)
  set(l, 'Box', 'off')
  
%  subplot(nrows, ncols,5), 
 figure
  plot((evals(k,  181:240)), 'k:'), title(['p4 (\mu  = 181:240)- gravity'], 'Fontsize',12), hold on
  plot((evals(k1, 181:240)), 'k-.'),
  plot((evals(k2, 181:240)), 'k--'), 
  plot((evals(k3, 181:240)), 'k-')
  xlabel(['\mu - eigenindex'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  axis tight, 
  l = legend(k1val, k2val, k3val, k4val)
  set(l, 'Box', 'off')
  
%  subplot(nrows, ncols,4), 
figure
  plot(evals(k,  241:300), 'k:'), title(['p5 (\mu  = 241:300)- acoustic'], 'Fontsize',12), hold on
  plot(evals(k1, 241:300), 'k-.'),
  plot(evals(k2, 241:300), 'k--'), 
  plot(evals(k3, 241:300), 'k-')
  xlabel(['\mu - eigenindex'],'FontSize',12)
  ylabel(['Frequency',10,'s^{-1}'],'FontSize',12)
  axis tight, 
  l = legend(k1val, k2val, k3val, k4val)
  set(l, 'Box', 'off')
  
  %c={'k = ' num2str(k1),'This is plot 2','And this is the last plot'}
%  legend(['k = ' num2str(k)], ...
%         ['k = ' num2str(k1)],...
%         ['k = ' num2str(k2)],...
%         ['k = ' num2str(k3)])
%   legend('k = 1', 'k = 50','k = 80' , 'k =130')
%annotation1 = annotation(...
%  freq,'textbox',...
%  'Position',[0.596 0.0884 0.269 0.131],...%[0.7799 0.3202 0.0996 0.1213],...
%  'LineStyle','none',...
%  'Fontsize',14,...
%  'String',{'Parameters',...
%  'A = 4 x 10^{-4}',...
%  'B = 10^{-1}',...
%  'C = 10^4'},...
%  'FitHeightToText','on');
 end
%%======================================================================================
%%======================================================================================



 makeplot = 0
 
 if makeplot == 1
  % Load data
   
   
  %% Plot as a function of horizontal wavenumber
  freq = figure
  set(freq, 'Position',  [360 346 881 542])

  subplot(3,2,1), 

  % set mode index, mi
  mi1 = 1; mi2 = 10; mi3 = 20; mi4 = 30; mi5 = 40; mi6 = 50;

  plot(evals(:, mi1), 'b'), hold on, title('p1'), 
  plot(evals(:, mi2), 'r'),
  plot(evals(:, mi3), 'g'), 
  plot(evals(:, mi4), 'k'),
  plot(evals(:, mi5), 'c'),
  plot(evals(:, mi6), 'm'), axis tight

  subplot(3,2,2),
  mi1 = mi1 + 60; mi2 = mi2 + 60; mi3 = mi3 + 60; mi4 = mi4 + 60; mi5 = mi5 + 60; mi6 = mi6 + 60;
  plot(evals(:, mi1), 'b'),  title('p2'), hold on 
  plot(evals(:, mi2), 'r'),
  plot(evals(:, mi3), 'g'), 
  plot(evals(:, mi4), 'k'),
  plot(evals(:, mi5), 'c'),
  plot(evals(:, mi6), 'm'), axis tight

  subplot(3,2,3), 
  mi1 = mi1 + 60; mi2 = mi2 + 60; mi3 = mi3 + 60; mi4 = mi4 + 60; mi5 = mi5 + 60; mi6 = mi6 + 60;
  plot(evals(:, mi1), 'b'), title('p3'), hold on, axis([1 360 -0.1 0.1])
  plot(evals(:, mi2), 'r'),
  plot(evals(:, mi3), 'g'), 
  plot(evals(:, mi4), 'k'),
  plot(evals(:, mi5), 'c'),
  plot(evals(:, mi6), 'm'), axis tight, axis([1 360 -0.1 0.1])

  subplot(3,2,4), 
  mi1 = mi1 + 60; mi2 = mi2 + 60; mi3 = mi3 + 60; mi4 = mi4 + 60; mi5 = mi5 + 60; mi6 = mi6 + 60;
  plot(evals(:, mi1), 'b'), title('p4'), hold on
  plot(evals(:, mi2), 'r'),
  plot(evals(:, mi3), 'g'), 
  plot(evals(:, mi4), 'k'),
  plot(evals(:, mi5), 'c'),
  plot(evals(:, mi6), 'm'), axis tight

  subplot(3,2,5), 
  mi1 = mi1 + 60; mi2 = mi2 + 60; mi3 = mi3 + 60; mi4 = mi4 + 60; mi5 = mi5 + 60; mi6 = mi6 + 60;
  plot(evals(:, mi1), 'b'), title('p5'), hold on
  plot(evals(:, mi2), 'r'),
  plot(evals(:, mi3), 'g'), 
  plot(evals(:, mi4), 'k'),
  plot(evals(:, mi5), 'c'),
  plot(evals(:, mi6), 'm'), axis tight


  legend(['mode index = ' num2str(mi1-240)], ...
         ['mode index = ' num2str(mi2-240)],...
         ['mode index = ' num2str(mi3-240)],...
         ['mode index = ' num2str(mi4-240)],...
         ['mode index = ' num2str(mi5-240)],...
         ['mode index = ' num2str(mi6-240)])

% Create textbox
annotation1 = annotation(...
  freq,'textbox',...
  'Position',[0.5199 0.3202 0.0996 0.1213],...
  'LineStyle','none',...
  'Fontsize',14,...
  'String',{'Eigenvalues of system matrix',...
  'dimensional frequencies scaled by f',...
  'for A = 4 \times 10^{-4}, B = 10^{-2}, C = 10^4'},...
  'FitHeightToText','on');
 end

%%======================================================================================
 
 if makeplot == 1
 
  %% Plot as a function of mode index
  h = figure
  set(h, 'Position', [360 99 762 825])
  % set k
  k = 180; k1 = 181; k2 = 200; k3 = 240; k4 = 300; k5 = 360;

  subplot(3,2,1), 

  plot(evals(k, 1:60), 'b+'), hold on, title('p1'), 
  plot(evals(k1, 1:60), 'r+'),
  plot(evals(k2, 1:60), 'g+'), 
  plot(evals(k3, 1:60), 'k+'),
  plot(evals(k4, 1:60), 'c+'),
  plot(evals(k5, 1:60), 'm+')

  subplot(3,2,2),
  plot(evals(k,  61:120), 'b+'),  title('p2'), hold on 
  plot(evals(k1, 61:120), 'r+'),
  plot(evals(k2, 61:120), 'g+'), 
  plot(evals(k3, 61:120), 'k+'),
  plot(evals(k4, 61:120), 'c+'),
  plot(evals(k5, 61:120), 'm+')

  subplot(3,2,3), 
  plot(evals(k,  121:180), 'b+'), title('p3'), hold on, axis([1 60 -0.1 0.1])
  plot(evals(k1, 121:180), 'r+'),
  plot(evals(k2, 121:180), 'g+'), 
  plot(evals(k3, 121:180), 'k+'),
  plot(evals(k4, 121:180), 'c+'),
  plot(evals(k5, 121:180), 'm+')

  subplot(3,2,4), 
  plot(evals(k,  181:240), 'b+'), title('p4'), hold on
  plot(evals(k1, 181:240), 'r+'),
  plot(evals(k2, 181:240), 'g+'), 
  plot(evals(k3, 181:240), 'k+'),
  plot(evals(k4, 181:240), 'c+'),
  plot(evals(k5, 181:240), 'm+')

  subplot(3,2,5), 
  plot(evals(k,  241:300), 'b+'), title('p5'), hold on
  plot(evals(k1, 241:300), 'r+'),
  plot(evals(k2, 241:300), 'g+'), 
  plot(evals(k3, 241:300), 'k+'),
  plot(evals(k4, 241:300), 'c+'),
  plot(evals(k5, 241:300), 'm+')
  %c={'k = ' num2str(k1),'This is plot 2','And this is the last plot'}
  legend(['k = ' num2str(k)], ...
         ['k = ' num2str(k1)],...
         ['k = ' num2str(k2)],...
         ['k = ' num2str(k3)],...
         ['k = ' num2str(k4)],...
         ['k = ' num2str(k5)])
     
 end

 end

%===================================================================================================
% EIGENVECTORS
%===================================================================================================

 if pl_evecs == 1
 
%  evecs_52 = load('/export/carrot/raid2/wx019276/DATA/CVT/EVecs52.dat');
%vecs = load('/export/carrot/raid2/wx019276/DATA/CVT/EigVecs_ref.dat');
%vecs = reshape(evecs, 300, 360, 300);
  % first dimension is row index
  % second dimension is horizontal wavenumber
  % third dimension is column index (eigenvectors)
  % set horizontal wavenumber
  hn = 181+160
 % k = 182; k1 = 211; k2 = 241; k3 = 301

  maxval = max(max(abs(evecs(:,hn,:))));   
  scale = [-maxval maxval]
  scale = [-0.01 0.01]
  h = figure, set(h, 'Position', [171 155 861 712])
  pcolor(squeeze(evecs(:,hn,:))),shading flat 
  set(gca, 'YTick',[1 61 121 181 241 300])
 set(gca, 'XTick',[1 61 121 181 241 300])
  caxis(scale), colormap(redblue), colorbar, axis ij
  title({['EigenVectors of system matrix   ', 'k = ', num2str(hn-181)];})
  xlabel('\mu: eigenindex'), ylabel('\mu: eigenindex')
  
  
 end
















