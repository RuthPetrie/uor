 ! Compile Statement
 !===================
 
  ! Compile Statement
 !===================
 
 ! Out of bounds checking: debug mode
 !------------------------------------
 ! f90 -C -dalign -I/opt/graphics/include Main.f90 DefConsType.f90 CVT.f90 Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

 ! Standard
 !-----------
 ! f90 -dalign -I/opt/graphics/include Main.f90 DefConsType.f90 CVT.f90  Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

 ! Optimized
 !------------
 ! f90  -fast -I/opt/graphics/include Main.f90 DefConsType.f90 CVT.f90 Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 
