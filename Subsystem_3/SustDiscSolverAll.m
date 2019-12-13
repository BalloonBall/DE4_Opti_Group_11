%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Complete Discrete Solution, v2.0
%  Neel Le Penru, 12/12/2019

% This code computes the helmet thicknesses for each foam in the CES
% Edupack Database and then calculates the objective function for each
% material, from which it selects the minimum that satisfies the constraint(s).

clear all
close all
tic %start timing

%% Read Data and Set Parameters, Variables etc.

materialData = csvread('materialData.csv');
matlength = length(materialData);
allData = [materialData zeros(matlength,3)]; %take data and add columns for additional values calculated for each
[~,txtData]  = xlsread('materialNames.xlsx','A1:A37');
names = string(txtData);

h_0 = 0.001; %initial value of helmet thickness
step = 0.0001; %step size for iterative solver implemented below
min_error = 0.0001; %for iterative solver implemented below
dh = 0; %initial value of delta h, liner compression a.k.a. deceleration distance
m_head = 5; %head mass
v0 = 6; %initial velocity of helmeted head
r = 0.0825; %head readius
g = 9.81; %accel. due to gravity

results = zeros(matlength,1);
newRes = []; %to store results that do meet constraints
newRes2 = [];
badRes = []; %to store results that don't meet constraints
badRes2 = [];
safeData = []; %to store all material properties (incl. results) of materials that do meet constraints
%% Calculate Helmet Thickness
for i = 1:matlength
    h = h_0;
    while abs(dh - 0.8*h) > min_error
        h = h + step;
        dh = deltah(h,r,allData(i,3),allData(i,2),v0,m_head); %using function 'deltah' to caluclate delta h
    end
    allData(i,7) = h;
end

% The same results are also obtained with fsolve:
% for i = 1:matlength
%     new_h = @(h) v0*((m_head + (2/3)*allData(i,2)*pi*h*(h^2+3*r*h+3*r^2))/(2*pi*(r+h)*allData(i,3)))^0.5 - 0.8*h;
% fsolve(new_h,0.001);
% newAccel(i) = ans;
% end

%% Variable Linking: CO2 and EE

EE = allData(:,5); %Extract from imported data
CO2 = allData(:,6);

%Format for, fit, and plot linear model:
TBL = array2table([EE CO2], 'Variable', {'Embodied Energy (J/kg)','CO2 Footprint (kg/kg)'});
MDL = fitlm(TBL,'linear');
plot(MDL)
%ployfit is also used - initially to see if coefficients are different.
coeff = polyfit(EE, CO2,1); %coeff's are easier to extract from polyfit.
allData(:,8) = allData(:,5).*coeff(1,1) + coeff(1,2); %add transformed EE to database


for i = 1:matlength

    results(i) = CO2est(allData(i,7),r,allData(i,3),allData(i,2),v0,...
        m_head, allData(i,6),allData(i,8)); %using function 'CO2est' -- the objective function

    a_max = amax(allData(i,7),r,allData(i,3),allData(i,2),v0,m_head); %using function to recompute the max. acceleration
    allData(i,9) = a_max;
end

%% Initial Plotting of All Data

figure
plot3(allData(:,7),allData(:,6),results,'.b')
grid on
title('Equivalent CO2 Footprints for all Foams in CES Edupack, and Helmet Thickness Constraint')
xlabel('Helmet Liner Minimum Thickness')
ylabel('Material CO2 Footprint (kg/kg)')
zlabel('Helmet Equivalent CO2 Footprint (kg)')
hold on
[y z] = meshgrid(linspace(0,30),linspace(0,8));
x = (9/(50*9.81)).*ones(size(y,1),size(y,2));
c_h = surf(x,y,z,'FaceAlpha',0.3);
colormap winter
c_h.EdgeColor = 'none';

%% Check results pass safety (min. thickness) constraint
for i=1:matlength
    if allData(i,7)>(9/(50*9.81))
        newRes = [newRes; results(i),i];
        plot3(allData(i,7),allData(i,6),results(i),'or') %circle results that are above min. thickness in red
        safeData = [safeData; allData(i,:),results(i),i]; %add material properties, result, and numerical index of 'safe' materials to matrix
    else badRes = [badRes; results(i),i]; %if results do not pass constraint, add them to 'badRes' array
    end
    if allData(i,9)<(250*9.81) %Double check by also looking at the acceleration (the max. value of which determines the min. thickness constraint)
        newRes2 = [newRes2; results(i),i];
    else badRes2 = [badRes2; results(i),i];
    end
end

%Check for inconsistencies between materials that have passed both checks 
if length(newRes) ~= length(newRes2)
    fprintf('\nInconsistency in number of materials determined to be safe.\n')
end
for i=1:length(newRes)
    if newRes(i,2) - newRes2(i,2) > 0
        fprintf('\nInconsistency found between max. accel. safety checks for material no. = %g\n', i)
    end
end

%% Find, Plot and Display Minimum
[newmin,index] = min(newRes(:,1));
a = newRes(index,2); %index of the optimimum in the original dataset of all materials (incl. initial 'results' array)
plot3(allData(a,7),allData(a,6),results(a),'og')
hold off
optimum = [names(a) results(a) allData(a,7) allData(a,2) allData(a,3) allData(a,6) allData(a,5)];
optimum = array2table(optimum);
optimum.Properties.VariableNames = {'Optimum Material' 'Equivalent CO2 footprint (kg)' 'Thickness (m)' 'Density (kg/m^3)' 'Yield Stress (Pa)' 'CO2 Footprint (kg/kg)' 'Embodied Energy (J/kg)'}
display(optimum)
%% End Timing and Write Data to .csv for use in other scripts
toc
csvwrite('allData.csv',allData)
csvwrite('safeData.csv',safeData)