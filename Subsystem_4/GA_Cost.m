clear;
close all;
tic

Linerproperty = readmatrix('material_liner.csv','Range','B2:G38');
Manufacture_data = readmatrix('manufacture_data','Range','B2:G38');
[~,idx] = sort(Linerproperty(:,2)); 
Linerproperty = Linerproperty(idx,:);
[~,idx] = sort(Manufacture_data(:,1)); 
Manufacture_data = Manufacture_data(idx,:);

%Get rid off outliers
TF1 = Linerproperty(:,5)>1.5e8;
TF2 = Linerproperty(:,6)>10;
TFall1 = TF1 & TF2;
Linerproperty(TFall1,:)=[];
%%
MatPrice = Linerproperty(:,1);
rho = Linerproperty(:,2);
sigma = Linerproperty(:,3);%
EE = Linerproperty(:,5);
CO2e = Linerproperty(:,6);
capacity = Manufacture_data(:,1);
%capacity = normalize(Manufacture_data(:,1));
va = Manufacture_data(:,2);
%va = normalize(Manufacture_data(:,2));

%%
global Beta1 Beta2 Beta3 Beta4 
Beta1 = polyfit(rho,sigma,2);
Beta2 = polyfit(rho,EE,1);
Beta3 = polyfit(rho,CO2e,1);
Beta4 = polyfit(rho,MatPrice,2); 
%Beta5 = polyfit(capacity,va,2);%polyfit of capacity-variable cost

global r Pfix rh
%v0 = 5;
rh = 0.02;
r = 0.08;%radius of head
Pfix = 600;
%ESE = 1130;

%%

x0 = [1 1 1 1];%[ Capacity,Va,rho,Pm]
A = [];
b = [];
Aeq = [];
beq = [];
lb = [1 1 1 1];
ub = [12 12 28 28];
options = optimoptions(@ga,...
                    'PopulationSize', 150,...
                    'MaxGenerations', 200, ...
                    'EliteCount', 10, ...
                    'FunctionTolerance', 1e-8, ...
                    'PlotFcn', @gaplotbestf);
rng(0, 'twister');
%Impeliment of GA algorithm, 'bestx' provides the combanation of value in..
%table 'ProductionData'.
[bestx, bestProfit, exitflagDisc] = ga(@AnnualProfit, ...
    4, [], [], [], [], lb, ub, @Helmetconstraints,1:4,options);
display(bestx)
toc
%%

function profit= CalculateP(x)
global r Pfix rh
R1 = r+rh;%total radius of helmet+head
M = 2/3*pi.*x(3).*(R1.^3-r^3);
Cost = x(1).*(M.*x(4)+x(2))-Pfix;
%profit = x(1).*25 - Cost;
profit = -x(1).*25 + Cost;%Negative null form
end

%%
function profit = AnnualProfit(x)

x = MapVars(x);

% Volume of cantilever beam
profit = CalculateP(x);
end

%%
function [c, ceq] = Helmetconstraints(x)

x = MapVars(x);

[c, ceq] = constraint(x);

end
%%
function [c,ceq] = constraint(x)
global Beta2 Beta3 r Pfix 
R1 = r+x(3);

%sigma = Beta1(1).*x(2).^2+Beta1(2).*x(2)+Beta1(3);
EE = Beta2(1).*x(2)+Beta2(2);
CO2e = Beta3(1).*x(2)+Beta3(2);
M= 2/3*pi.*x(2).*(R1.^3-r^3);
%velocity
%v1 = (v0^2-(4.*ESE.*pi^3.*R2.^2.*x(3).^2.*x(3))./M).^0.5;
Cost = x(1).*(M.*x(4)+x(2))-Pfix;
%PLA
%c(1) = v1.*(M./(2.*pi.*R1.*sigma)).^0.5 - 0.05;
%mass
c(1) = 0.150-M;
%embodied energy
%c(3) = M.*EE-21.9e6; 
c(2) = 4.2e6-M.*EE; 
%CO2 foot print
%c(5) = M.*CO2e-29.1;
c(3) = 0.211 - M.*CO2e;
%constrain on budget
c(4) = Cost-1000000;
%constrain on capacity
%c(8) = 130000 - x(1);
c(5) = 2.32- x(4);
ceq = [];
end


