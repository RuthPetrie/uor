%% Anal_grav_wavespeeds

%% Define key parameters
Lx      = 540000.0;
Lz      = 14862.01;
BP0     = 100000.0;
BP02    = BP0 * BP0;
AA      = 0.0004;
A       = sqrt(AA);
m       = 3;
pi      = 3.14159264 ;
vertwn  = pi * m / Lz;

%% Calculate the wave frequencies (as a function of horiz wn)
 
 for k = 1:360
   horwn               = 2.0 * pi * k / Lx;
   horwn2              = horwn * horwn;
   totwnSq             = horwn2 + (vertwn * vertwn);
   horizwn(k)          = horwn;
   omegasq = BP0 * ( AA/BP0 + totwnSq + A * ...
     sqrt( AA/BP02 +  totwnSq * totwnSq / AA + 2.0 * totwnSq / BP0 - 4.0 * horwn2 / BP0 )) / 2.0;
   omega(k) = sqrt(omegasq);
 end


%% Differentiate for wave group speed

 for k = 1:359
 % k = k - 181
  speed(k) = ( omega(k+1) - omega(k) ) / ( horizwn(k+1) - horizwn(k) );
 end

