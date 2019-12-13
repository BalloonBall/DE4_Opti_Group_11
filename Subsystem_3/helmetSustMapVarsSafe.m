%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Function for GA on Safe Materials to perform mapping from GA integer 
%  variable to material data values. 
%  Neel Le Penru, 12/12/2019
function x = helmetSustMapVarsSafe(x)

matdata = csvread('safeData.csv'); %read material data

%Separate different material properties
rhoData = matdata(:,2);
sigmaData = matdata(:,3);
CO2Data = matdata(:,6);
CO2fromEEData = matdata(:,8);

% Mapping (re-writing function values from integer indices to discrete
% material data):
x(1) = rhoData(x(1));
x(2) = sigmaData(x(2));
x(3) = CO2Data(x(3));
x(4) = CO2fromEEData(x(4));