%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Function to calculate maximum acceleration of helmeted head in
%  collision.
%  Neel Le Penru, 12/12/2019

function amax = amax(h,r,sigma,rho,v0,m)
mass = m + (2/3)*rho*pi*h*(h^2+3*r*h+3*r^2);
amax = v0*((2*pi*(r+h)*sigma)/mass)^0.5;
end