# /bin/usr/sh

# Driver to run ABC model code:

echo =================================
echo PERFORMING SETUP COMMANDS
echo

# setup and export commands
setup studio12
# Export netcdf library as Ruth's profile doesn't work right...
#export LD_LIBRARY_PATH=$LIBRARY_PATH:/opt/graphics/64/lib

# Export nag license
export NAG_KUSARI_FILE=/opt/compilers/NAG/license.dat

# ensure clean which is system independent
rm -rf *.o *.out *.mod

echo 
echo SET UP COMPLETE
echo =================================


# Compile using make file
# system can be 'linux', 'carrot', or 'ubuntu'
#system=linux

#make -f makefile_linux
f90 Main.f90 DefConsTypes.f90 UM_data_proc.f90 Functions.f90  Diagnostics.f90  Boundaries.f90 BoundaryMod.f90 Forcings.f90 Initialise.f90 Model.f90 ReadWrite_data.f90  Linear_Analysis.f90 -I/opt/graphics/64/include -M/opt/graphics/64/include -L/opt/graphics/64/lib -R/opt/graphics/64/lib -lnetcdf-4.0 -lhdf5_hl -lhdf5 -M/opt/compilers/NAG/fnl6a04ddl/nagfl90_modules -L/opt/compilers/NAG/fnl6a04ddl/lib -R/opt/compilers/NAG/fnl6a04ddl/lib -lnagfl90_spl -xlic_lib=sunperf  -o Main.out


f90 Main.f90 DefConsTypes.f90 UM_data_proc.f90 Functions.f90  Diagnostics.f90  Boundaries.f90 BoundaryMod.f90 Forcings.f90 Initialise.f90 Model.f90 ReadWrite_data.f90  Linear_Analysis.f90 -I/opt/graphics/64/include -M/opt/graphics/64/include -L/opt/graphics/64/lib -R/opt/graphics/64/lib -lnetcdf-4.0 -lhdf5_hl -lhdf5 -M/opt/compilers/NAG/fnl6a04ddl/nagfl90_modules -L/opt/compilers/NAG/fnl6a04ddl/lib -R/opt/compilers/NAG/fnl6a04ddl/lib -lnagfl90_spl -xlic_lib=sunperf  -o Main.out

# Run the model
Main.out
