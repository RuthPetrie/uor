function V=rmse(T,P)
%% Calculate Root mean square error where T is target and P is prediction
%% V is root mean square error
V=T-P;
V=V.^2;
V=mean(V);
V=sqrt(V);


