%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Objective function for 'SustDiscSolverAll.m', which explores all
%  foams in CES EduPack.
%  Neel Le Penru, 12/12/2019
function CO2est = CO2est(h,r,sigma,rho,v0,m,CO2,CO2est)
CO2est = (2/3)*rho*pi*h*(h^2+3*r*h+3*r^2)*(CO2 + CO2est); %as per formulation in report.
end
