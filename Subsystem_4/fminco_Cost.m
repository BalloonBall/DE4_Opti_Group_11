clear;
close all;
tic

Material_Liner = readmatrix('material_liner.csv','Range','B2:G38');
Manufacture_data = readmatrix('manufacture_data','Range','B2:G38');
[~,idx] = sort(Material_Liner(:,2)); 
Material_Liner = Material_Liner(idx,:);
[~,idx] = sort(Manufacture_data(:,1)); 
Manufacture_data = Manufacture_data(idx,:);

%Get rid off outliers
TF1 = Material_Liner(:,5)>1.5e8;
TF2 = Material_Liner(:,6)>10;
TFall1 = TF1 & TF2;
Material_Liner(TFall1,:)=[];
%%
MatPrice = Material_Liner(:,1);
rho = Material_Liner(:,2);%density
sigma = Material_Liner(:,3);%
EE = Material_Liner(:,5);
CO2e = Material_Liner(:,6);
capacity = Manufacture_data(:,1);
%capacity = normalize(Manufacture_data(:,1));
va = Manufacture_data(:,2);
%va = normalize(Manufacture_data(:,2));

%%
global Beta1 Beta2 Beta3 Beta4 Beta5
Beta1 = polyfit(rho,sigma,2);
Beta2 = polyfit(rho,EE,1);
Beta3 = polyfit(rho,CO2e,1);
Beta4 = polyfit(rho,MatPrice,2); 
Beta5 = polyfit(capacity,va,2);%polyfit of capacity-variable cost

global r Pfix rh
%v0 = 5;
rh = 0.02;%radius of helmet
r = 0.08;%radius of head
Pfix = 600;
%ESE = 1130;


%%

%visualise the relationship of profit,density, and price
%C = N.*(25 - ((2/3).*3.14.*p.*(0.09^3-(0.09-h_x).^3).*(P1)+P3))-P2;

%figure;
%surf(N,p,C)
%colorbar
%grid on
%xlabel('Factory Capacity)');
%ylabel('Material density(GBP/kg)');
%fsurf(C,[0,50],'ShowContours','on')
%%

x0 = [80000 22];%[Capacity,Va,rho,Pm]
A = [];
b = [];
Aeq = [];
beq = [];
lb = [80000 22];
ub = [210000 860];
options = optimoptions('fmincon','Display','iter','Algorithm','sqp','Plotfcn','optimplotfval');
[xbest,fval] = fmincon(@totalProfit,x0,A,b,Aeq,beq,lb,ub,@constraint,options);
toc

%%

function profit= totalProfit(x)
global r Pfix Beta4 Beta5 rh
R1 = r+rh;

M = 2/3*pi.*x(2).*(R1.^3-r^3);
% P1 is material price(GBP/kg), x(2)is material density
P1 = Beta4(1).*x(2).^2+Beta4(2).*x(2)+Beta4(3);
% P3 is variable cost of each helmet, x(1) is the production size.
P3 = Beta5(1).*x(1).^2+Beta5(2).*x(1)+Beta5(3);
%P3 = Beta5(1).*x(1).^5+Beta5(2).*x(1).^4+Beta5(3).*x(1).^3+Beta5(4).*x(1).^2+Beta5(5).*x(1)+Beta5(6);
Cost = x(1).*((M.*P1)+P3)-Pfix;
%profit = x(1).*25 - Cost;
profit = -x(1).*25 + Cost;%Negative null form
%profit = x(1).*(25 - ((M.*P1)+P3))-Pfix;
%profit = -x(1).*(25 - ((M.*P1)+P3))+Pfix; %Negative null form
end

%%

function [c,ceq] = constraint(x)
global Beta2 Beta3 r Pfix rh Beta4 Beta5
R1 = r+rh;

%sigma = Beta1(1).*x(2).^2+Beta1(2).*x(2)+Beta1(3);
EE = Beta2(1).*x(2)+Beta2(2);
CO2e = Beta3(1).*x(2)+Beta3(2);
M= 2/3*pi.*x(2).*(R1.^3-r^3);
%velocity
%v1 = (v0^2-(4.*ESE.*pi^3.*R2.^2.*x(3).^2.*x(3))./M).^0.5;
P1 = Beta4(1).*x(2).^2+Beta4(2).*x(2)+Beta4(3);
P3 = Beta5(1).*x(1).^2+Beta5(2).*x(1)+Beta5(3);
Cost = x(1).*((M.*P1)+P3)-Pfix;
%PLA
%c(1) = v1.*(M./(2.*pi.*R1.*sigma)).^0.5 - 0.05;
%mass
%c(1) = M-0.5;
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
c(5) = 2.32- P1;
ceq = [];
end


