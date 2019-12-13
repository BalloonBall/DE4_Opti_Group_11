%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Function that calls function for GA on All Materials to perform mapping 
%  from GA integer variable to material data values, and then calls 
%  objective function. 
%  Neel Le Penru, 12/12/2019
function CO2 = CO2All(x)

x = helmetSustMapVarsAll(x);%Map integer indices in GA to discrete material values from relevant dataset

%Objective Function is still the same:
CO2 = CO2estGa(x);


