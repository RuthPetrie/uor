modes2= [0 60 120 180 240 300];
temp = 2
k=  2

 nmcors(1:300,1:300) = squeeze(nmcor(k,:,:));

 nmcors(1:60,:) = flipud(squeeze(nmcor(k,1:60,:)));
 nmcors(181:240,:) = flipud(squeeze(nmcor(k,181:240,:)));
 nmcors(:,1:60) = fliplr(nmcors(:,1:60));
 nmcors(:,181:240) = fliplr(nmcors(:,181:240));

 axis_scale =[-1.0 1.0];

 h= figure; set(h, 'Position',[360 216 759 644])
 pcolor(abs(nmcors(:,:))), caxis(axis_scale),colormap(redblue), shading flat, colorbar, axis ij
 xlabel('\mu - eigenindex','FontSize',14), ylabel('\mu - eigenindex','FontSize',14)
set(gca,'XTick',modes2, 'YTick',modes2)

%plot(abs(nmcors(:,122)))

k=  2
mu = 182
h = figure
set(h, 'Position',[199 535 794 307])
plot(abs(squeeze(nmcor(:,mu,mu))),'k'), hold on
plot(abs(squeeze(nmcor3(:,mu,mu))),'r')
legend('Forecast data','Initial conditions')
%set(gca,'XTick',modes2)
xlabel('Horizontal wavenumber, k','FontSize',14), ylabel('Correlation','FontSize',14)
axis tight

h = figure
set(h, 'Position',[199 535 794 307])
k=  2
mu = 122
plot(abs(squeeze(nmcor(k,:,mu))),'k'),
xlabel('\mu - eigenindex','FontSize',14), ylabel('Correlation','FontSize',14)
axis tight,set(gca,'XTick',modes2)


figure
mu = 182
plot(abs(flipud(squeeze(nmcor2(:,mu,mu)))),'k'),
xlabel('Horizontal wavenumber, k','FontSize',14), ylabel('Correlation','FontSize',14)
axis tight
