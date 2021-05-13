function V=rmsd(A,B)
%% Calculate Root mean square difference 
%% of two fields of dimensions (1:nlevs, 1:nlongs)

 nlongs = 360;
 nlevs  = 60;
 %% calculated the sum of the squared difference
 sum_sq_diff = 0;
 for x = 1, nlongs;
   for z = 1, nlevs;
     sum_sq_diff = sum_sq_diff + (A(z,x) - B(z,x))^2;
   end
 end
 
 % Find mean
 sum_sq_diff = sum_sq_diff / (nlongs * nlevs);
 
 % Find root
 V = sqrt(sum_sq_diff) ;
 
