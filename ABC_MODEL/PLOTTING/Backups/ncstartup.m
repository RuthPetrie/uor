function ncstartup

% ncstartup -- Startup script for the NetCDF Toolbox.
%  ncstartup (no argument) adjusts the Matlab path
%   to include the components of the NetCDF Toolbox.
%
%   A call to this "ncstartup" script should be made
%   during Matlab startup, such as from within the
%   "startup" script that is reserved for just such
%   purposes.  Adjust the path below as needed.
%
%   Alternatively, place the appropriate "addpath"
%   commands directly in the "startup.m" file.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 03-Jul-1997 09:09:29.
% Updated    12-Apr-2000 13:26:34.

% These statements assume that the NetCDF Toolbox is
%  located in the conventional Matlab "toolbox" area.
%  Adjust as needed.

  
%%-- Path for netcdf mex file

% v = version;
% if eval(v(1)) == 7
%   % Test for matlab 7.2
%   if eval(v(3)) == 2
%     fcn = 'mexcdf72';
%     path(path, '/home/radar/src/mexnc.save')
%   else
%     path(path, '/home/radar/src/mexnc')
%   end
% else
%   path(path, '/home/radar/src/mexnc')
% end
  
%toolbox_area = 'toolbox';

%path(path, fullfile(matlabroot, toolbox_area, 'netcdf', ''))
%path(path, fullfile(matlabroot, toolbox_area, 'netcdf', 'nctype', ''))
%path(path, fullfile(matlabroot, toolbox_area, 'netcdf', 'ncutility', ''))
%path(path, fullfile(matlabroot, toolbox_area, 'netcdf', 'ncfiles', ''))

path_to_nctoolbox = '/home/wx019276/MODELLING/PLOTTING/netcdf_toolbox' ;

path(path, fullfile(path_to_nctoolbox, 'netcdf', ''))
path(path, fullfile(path_to_nctoolbox, 'netcdf', 'nctype', ''))
path(path, fullfile(path_to_nctoolbox, 'netcdf', 'ncutility', ''))
