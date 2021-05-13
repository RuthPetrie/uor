%% REGIME WAVE SPEEDS
% WaveSpeeds
%% LOAD DATA

data = 61

file1 =['/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/hoz_grav_speed_c_'...
        num2str(data)...
        '.dat']
file2 =['/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/hoz_ac_speed_c_'...
        num2str(data)...
        '.dat']
file3 =['/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/vert_grav_speed_c_'...
        num2str(data)...
        '.dat']
file4 =['/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/vert_ac_speed_c_'...
        num2str(data)...
        '.dat']

hoz_grav = load(file1); %(60,359)
hoz_ac    = load(file2);%(60,359)
vert_grav = load(file3);%(360,59)
vert_ac   = load(file4);%(360,59)
%ac_freq   = load ('/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/acoustic_freq_c_00.dat');
%grav_freq = load ('/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/gravity_freq_c_00.dat');


%plot(grav_freq(:,3),'k')
%hold on
%plot(grav_freq(:,10),'k--'),plot(grav_freq(:,30),'k:'), plot(grav_freq(:,50),'k-.')
%axis tight
%xlabel(['l',10,'horizontal wavenumber index'],'FontSize',12),
%ylabel(['frequency        ',10,'s^{-1}         '],'FontSize',12, 'Rotation',0 )
%legend('n = 3','n = 10','n = 30','n = 50')


%k = 330
m = 3;
nrows = 1;
ncols = 2;
%% plot reference dispersion curves
figure
%subplot(nrows, ncols,1)
plot(hoz_grav(m, :), 'k')
hold on
plot(hoz_ac(m, :), 'k--')
axis tight
legend('gravity', 'acoustic')
set(legend,'EdgeColor','white','FontSize',14)
xlabel(['l',10,'horizontal wavenumber index'],'FontSize',12),
ylabel(['speed         ',10,'ms^{-1}         '],'FontSize',12, 'Rotation',0 )
%title('Horizontal wave speeds, when m=3', 'FontSize',14)
ylabel(['frequency        ',10,'s^{-1}         '],'FontSize',12, 'Rotation',0 )


k = 30
figure
%subplot(nrows, ncols,2)
plot(vert_grav(k, :), 'k')
hold on
plot(vert_ac(k, :), 'k--')
axis tight
legend('gravity', 'acoustic')
set(legend,'EdgeColor','white','FontSize',14)
xlabel(['n',10,'vertical wavenumber index'],'FontSize',12),
ylabel(['speed         ',10,'ms^{-1}         '],'FontSize',12, 'Rotation',0 )
%title('Vertical wave speeds k = 30', 'FontSize',14)

 

