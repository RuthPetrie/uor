%% Plot numeric energy conservation
%%
%% ModelEnergy

%% Load file

 xcontinue = 6

%[file, nlongs, nlevs, ntimes] = load_netcdf_struct('/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/Energycons2.nc');

% file.energy is the energy array and is of dimension 4xntimes
% energy(1) is the kinetic energy
% energy(2) is the buoyant energy
% energy(3) is the elastic energy
% energy(4) is the total energy

 for t = 1:ntimes
   times(t) = (t-1) * 0.25;
 end
 
 plot(times, file.energy(4,:), 'k'), hold on
 plot(times, file.energy(3,:), 'r')
 plot(times, file.energy(2,:), 'b')
 plot(times, file.energy(1,:), 'g')
 h = legend('Total energy','Elastic energy','Buoyany energy','Kinetic')
 legend(h,'boxoff')
 axis tight
 xlabel({'Time','hrs'})
 ylabel({'Energy';'m^{2}s^{-2}'})
 
 
 % BLACK AND WHITE FOR PAPER
% plot(times, file.energy(4,:), 'k'), hold on
% plot(times, file.energy(3,:), 'k-.')
% plot(times, file.energy(2,:), 'k:')
% plot(times, file.energy(1,:), 'k-')
% legend('Total energy','Elastic energy','Buoyany energy','Kinetic')
 
