%%OrthogonalityTest
cont = 10
%orth_uv = load('/home/wx019276/Modelling/Matlab/Data/OrthTest_uv.dat');
%orth_wb = load('/home/wx019276/Modelling/Matlab/Data/OrthTest_wb.dat');
%orth_rhop= load ('/home/wx019276/Modelling/Matlab/Data/OrthTest_rho.dat');

orth_SbCa = load('/export/carrot/raid2/wx019276/ARCHIVE/MATLAB/DATA_ARCHIVE/OrthTest_SbCa.dat');
orth_SaCa = load('/export/carrot/raid2/wx019276/ARCHIVE/MATLAB/DATA_ARCHIVE/OrthTest_SaCa.dat');
orth_SaSb = load ('/export/carrot/raid2/wx019276/ARCHIVE/MATLAB/DATA_ARCHIVE/OrthTest_SaSb.dat');
orth_exp  = load ('/export/carrot/raid2/wx019276/ARCHIVE/MATLAB/DATA_ARCHIVE/OrthTest_exp.dat');

for i = 1:60
  j = i + 1;
  z(i) = j * 256.7;
end
dz = 256.7;
recip_ztop = 1/z(60);

pi = 3.1415926;
orth_ShC(1:60,1:60) = 0;
for i = 1:60
 for j = 1:60
  for k = 1:60
     nn = (i - 0.5);
     mm = (j - 0.5);
          orth_ShC(i,j) = orth_ShC (i,j) + ...
                      sin(  (  nn *  pi * recip_ztop * z(k) ) ) * ... 
                      cos(  (  j *  pi * recip_ztop * z(k) ) )  * dz  ;
       end
    end
 end
%DO i = 1:nlongs
%!    i = i - 1 - (nlongs/2)
%!    DO j = 1:nlongs
%!       j = j - 1 - (nlongs/2)
%!       DO k = 1, nlevels
%!         nn = (i - 0.5)
%!         mm = (j - 0.5)
%!        orth_rho(i,j) = orth_rho (i,j) +                                      &
%!                      COS(  (  i *  pi * ztop * Dims % half_levels(k) ) )  *      & 
%!                      COS(  (  j *  pi * ztop * Dims % half_levels(k) ) )  *      & 
%!                     ( Dims % full_levels(k) - Dims %  full_levels(k-1) )     
%!       ENDDO
%!        orth_rho(i,j) = 2 * ztop * orth_rho(i,j)    
%!    ENDDO
%! ENDDO


%figure

%subplot(1,3,1)
%pcolor(orth_SbCa), shading flat, colorbar, title('SbCa')

%subplot(1,3,2)
%pcolor(orth_SaCa), shading flat, colorbar, title('SaCa')

%subplot(1,3,3)
%pcolor(orth_SaSb), shading flat, colorbar, title('SaSb')

scale = [-1.0 1.0];
figure
pcolor(2*recip_ztop*orth_ShC), caxis(scale), colormap(redblue),shading flat, colorbar
axis ij, xlabel('Model level'), ylabel('Model level') 



