function Y=rms(X)
%% Calculate Root mean square error where T is target and P is prediction
%% V is root mean square error
Y = 0;
[dim1 dim2] = size(X);
for i = 1:dim1
 for j = 1:dim2
   Y = Y + X(i,j)^2;
 end
end

Y = sqrt(Y / (dim1*dim2));

