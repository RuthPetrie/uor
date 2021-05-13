 x = 180;
 z = 30;
 xScale = 2*(40.0^2)
 zScale = 2*(7.0^2)
 recipf = 1/0.0001;
 recipL = 1/xScale;
 recipH = 1/zScale;
 C = 1E5
%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

 %% auto correlations
 
 for i = 1:360
   for k = 1:60
    temp1 = (i - x) * (i - x);
    temp2 = (k - z) * (k - z);
    mu(k,i) = 1.0 * exp(-(temp1/xScale) - (temp2/zScale) ) ;
   end
 end
 
 %% Geostrophic balance correlations
 
 for i = 1:360
   for k = 1:60
    temp1 = (i - x);
    vr(k,i) = - 1.0 * temp1 * mu(k,i) * recipL * recipf * C;
   end
 end
 
 %% hydrostatic balance correlations
 
  for i = 1:360
   for k = 1:60
    temp2 = (k - z);
    br(k,i) = - 1.0 * temp2 * mu(k,i) * recipH* C;
   end
  end
 
 %% Plotting
 
 % Axes
 maxvr = max(max(abs(vr)));
 Vvr =[-maxvr maxvr]
 V = [-1.0 1.0]
 maxbr = max(max(abs(br)));
 Vbr =[-maxbr maxbr]

 nrows = 1
 ncols = 3
 
 figure
% subplot(nrows, ncols,1)
 pcolor(xax,yax,mu), shading flat,  caxis(V), colormap(redblue), colorbar
% title('Auto correlation') 
 xlabel(['Longitudinal distance',10,'(km)'],'FontSize',14), 
 ylabel(['Height',10,'(m)'],'FontSize',14 )

 figure
 %subplot(nrows, ncols,2)
 pcolor(xax,yax,vr), shading flat,   caxis(Vvr), colormap(redblue), colorbar
% title('Geostrophic correlation in v')
 xlabel(['Longitudinal distance',10,'(km)'],'FontSize',14), 
 ylabel(['Height',10,'(m)'],'FontSize',14 )

 figure
% subplot(nrows, ncols,3)
 pcolor(xax,yax,br), shading flat,  caxis(Vbr), colormap(redblue), colorbar
% title('Hydrostatic correlation in b')
 xlabel(['Longitudinal distance',10,'(km)'],'FontSize',14), 
 ylabel(['Height',10,'(m)'],'FontSize',14 )

 
