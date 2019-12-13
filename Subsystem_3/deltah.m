%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Function to calculated 'delta h' - compression / crushing distance of
%  helmet liner foam in collision (also deceleration distance and max.
%  displacement in SHM model of collision dynamics).
%  Neel Le Penru, 12/12/2019

function deltah = deltah(h,r,sigma,rho,v0,m)
mass = m + (2/3)*rho*pi*h*(h^2+3*r*h+3*r^2);
deltah = v0*(mass/(2*pi*(r+h)*sigma))^0.5;
end
