%% EXAMINE IMPLIED COVARIANCES

% LOAD DATA
%-------------------------------------------------------------------
u = load('/home/wx019276/DATA/CVT/BalTest_u.dat');
v = load('/home/wx019276/DATA/CVT/BalTest_v.dat');
w = load('/home/wx019276/DATA/CVT/BalTest_w.dat');
r = load('/home/wx019276/DATA/CVT/BalTest_r.dat');
b = load('/home/wx019276/DATA/CVT/BalTest_b.dat');
g = load('/home/wx019276/DATA/CVT/BalTest_g.dat');
h = load('/home/wx019276/DATA/CVT/BalTest_h.dat');

uabs = (max(max(abs(u))))*1.1
vabs = (max(max(abs(v))))*1.1
wabs = (max(max(abs(w))))*1.1
rabs = (max(max(abs(r))))*1.1
babs = (max(max(abs(b))))*1.1
gabs = (max(max(abs(g))))*1.1
habs = (max(max(abs(h))))*1.1

uscale = [-uabs uabs]
vscale = [-vabs vabs]
wscale = [-wabs wabs]
rscale = [-rabs rabs]
bscale = [-babs babs]
gscale = [-gabs gabs]
hscale = [-habs habs]
scale = [-1.0 1.0]
f = figure

%set(f, 'Position', [360 99 762 825])

subplot(3,3,1)
pcolor(u), 
caxis(uscale), 
shading flat, colormap(redblue),colorbar, title('u')

subplot(3,3,2)
pcolor(v), caxis(vscale), shading flat,colormap(redblue),colorbar, title('v')


subplot(3,3,3)
pcolor(w), caxis(wscale), shading flat,colormap(redblue),colorbar, title('w')


subplot(3,3,4)
pcolor(r), caxis(rscale), shading flat, colormap(redblue),colorbar, title('\rho`')


subplot(3,3,5)
pcolor(b), 
caxis(bscale), 
shading flat,colormap(redblue),colorbar, title('b`')

subplot(3,3,7)
pcolor(g), 
caxis(gscale), 
shading flat,colormap(redblue),colorbar, title('geostrophic imblance`')

subplot(3,3,8)
pcolor(h), 
caxis(hscale), 
shading flat,colormap(redblue),colorbar, title('hydrostatic imblance`')

% Create textbox
%annotation1 = annotation(...
%  h,'textbox',...
%  'Position',[0.5866 0.2697 0.2133 0.03576],...
%  'LineStyle','none',...
%  'String',{'Structure function of \rho`(180, 30)',...
%  'Full response'});%,...
 % 'ensemble 6''});
%  'Acoustic response',...
%  'truncation', ...
%  'p1 <20  = 0 (small ei large m)',...
 % 'p5 all  = 0 '});
%  'FitHeightToText','on');

