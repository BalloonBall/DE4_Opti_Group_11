%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  GA on Safe Materials, v2.0
%  Neel Le Penru, 12/12/2019

% IMPORTANT: the globaloptimisation toolbox must be installed to run this
% code (and open the example it is based on).
% NB. Results may vary from those quoted in report due to stochastic nature
% of GA.
% The following code is adapted from the matlab example:
%   'Solving a Mixed Integer Engineering Design Problem Using the Genetic
%   Algorithm'
% This can be opened with the following command:
%   openExample('globaloptim/steppedCantileverExample')
% It is also explained online: 
%   https://uk.mathworks.com/help/gads/examples/solving-a-mixed-integer-engineering-design-problem-using-the-genetic-algorithm.html
tic
%% Import Datasheet - Useful For Identifying Materials
matdata = csvread('safeData.csv');
[~,txtData]  = xlsread('materialNames.xlsx','A1:A37');
names = string(txtData);
%% Set the Options and Upper & Lower Bounds for Discrete Variables

%Options are kept the same as in the original MATLAB example, except
%'MaxGenerations', which is reduced to reflect the smaller number of
%generations taken to reach an optimal solution.
opts = optimoptions(@ga, ...
                    'PopulationSize', 150, ... 
                    'MaxGenerations', 80, ...
                    'EliteCount', 10, ...
                    'FunctionTolerance', 1e-8, ...
                    'PlotFcn', @gaplotbestf);

lb = [1 1 1 1]; 
ub = [24 24 24 24]; %upper bound is number of materials - but now 24 corresponding to number of 'safe' materials
%GA will pick integers between 1 and 24 for each material property.
%These integers correspond to indices of the discrete material properties

%% Run GA with cost (objective) function 'CO2Safe'
rng(0, 'twister'); %set random number generator to appropriate values (purely to 'reset' as if they happen to set strangely, it will cause issues for ga.
[xbestDisc, fbestDisc, exitflagDisc] = ga(@CO2Safe, ...
    4, [], [], [], [], lb, ub, [], 1:4, opts); %since our constraints are inherent to the dataset, not are set here

%% Displaying Results
fprintf('\nOptimal Sustainability of hypothetical composite using SAFE foam in CES = %g kg CO2 equivalent.\n', fbestDisc);

density = [names(xbestDisc(1)) matdata(xbestDisc(1),2)];
density = array2table(density);
density.Properties.VariableNames = {'Material in Optimal Composite' 'Selected for: Density (kg/m^3)'};

sigma = [names(xbestDisc(2)) matdata(xbestDisc(2),3)];
sigma = array2table(sigma);
sigma.Properties.VariableNames = {'Material in Optimal Composite' 'Selected for: Yield Stress (Pa)'};

CO2 = [names(xbestDisc(1)) matdata(xbestDisc(1),6)];
CO2 = array2table(CO2);
CO2.Properties.VariableNames = {'Material in Optimal Composite' 'Selected for: CO2 Footprint (kg/kg)'};

CO2EE = [names(xbestDisc(1)) matdata(xbestDisc(1),8)];
CO2EE = array2table(CO2EE);
CO2EE.Properties.VariableNames = {'Material in Optimal Composite' 'Selected for: EE CO2 Equivalent (kg/kg)'};

display(density)
display(sigma)
display(CO2)
display(CO2EE)
%%
toc