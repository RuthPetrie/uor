
%% Page size

%% portrait
h = figure
set(h, 'Position', [360 99 762 825])


%% landscape
h = figure
set(h, 'Position', [360 346 881 542])

annotation1 = annotation(...
  freq,'textbox',...
%  portrait position
  'Position',[0.7799 0.3202 0.0996 0.1213],...
%  landscape position
  'Position',[0.6799 0.3202 0.0996 0.1213],...
  'LineStyle','none',...
  'Fontsize',14,...
  'String',{'Parameters',...
  'A = 4 x 10^{-4}',...
  'B = 10^{-2}',...
  'C = 10^4'},...
  'FitHeightToText','on');

%% AXES
for i = 1:360
  xax(i) = i * 1.5;
end

for i = 1:60
  j = i + 1;
  yax(i) = j * 256.7;
end

