 %% Routine to generate perturbation to look at geostrophic response
 
 %% perturb  
   
   xcontinue = 5
   
   nlongs = 360;
   nlevs = 60;
%% SET LOCATION OF PERTURBATION

     i = 180;
     k = 30;
%% SET SCALE OF PERTURBATION
 
     x_scale = (100)^2;  % * dx (1.5km) for meters if C = f this is the scale length
     z_scale = (3)^2    % * dz (~250) for meters
     H = 9

%% GENERATE PERTURBATION
     for x = 1: nlongs
       for z = 1: nlevs
         temp1 = (i - x) * (i - x);
         temp2 = (k - z) * (k - z);
         pert(z,x) = 1 * exp(- (temp1/x_scale) - (temp2/z_scale)  );
       end 
     end
     
%% PLOT PERTURBATION

 pcolor(pert), shading flat, colorbar
     
