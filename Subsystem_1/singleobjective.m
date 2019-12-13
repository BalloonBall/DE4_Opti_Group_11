tic
clc
clear

%% Exploration of the problem space

% Relationship between partial vapour pressure and inner radius
M = [];
R = linspace(0.08,0.1);

Re = 1200;      %Reynold's number
nu = 0.001;     %Kinematic viscosity of air
dens_a = 1.2;   %Density of air

M = 0.5*dens_a*((Re*nu)./(2*R)).^2;

figure('Name','Pressure vs Radius','NumberTitle','off')
plot(R,M)
xlabel('Inner radius (m)')
ylabel('Partial vapour pressure gradient (Pa)')
title('Pressure against Radius')


%Relationship between helmet mass and inner radius
M = [];
R = linspace(0.08,0.1);

dens_h = 175;   %Average density across material layers.
th = 0.04;      %Upper bound of thickness

M = dens_h*(2*pi/3)*((R+th).^3 - R.^3);

figure('Name','Mass vs Radius','NumberTitle','off')
plot(R,M)
xlabel('Inner radius (m)')
ylabel('Mass (kg)')
title('Mass against Radius')


%% Single-objective optimisation of heat transfer

% Setting up the variables:
% x(1) is inner radius
% x(2) is helmet velocity
% x(3) is temperature gradient
% x(4) is material thermal conductivity
% x(5) is material thickness

x0 = [0.085,1,10,0.1,0.035];    %initial values
lb=[0.08,0,10,0.12,0.02];       %lower bounds
ub=[0.1,7.5,17,0.44,0.04];      %upper bounds
A =[]; b=[]; Aeq=[]; beq=[];


%% Algorithm 1: Interior-Point
%tic
options1 = optimoptions('fmincon','Algorithm','interior-point','plotfcn','optimplotfval');
[x,fval,ef,output,lambda]=fmincon(@objective,x0,A,b,Aeq,beq,lb,ub,@constraint,options1);
%toc

%Optimum values of each variable:
disp(table(x(1),x(2),x(3),x(4),x(5),'VariableNames',{'Ri', 'v', 'dT', 'k', 'th'}))

%Maximum heat transfer using these new variable values:
disp(['Final Objective Interior-Point: ' num2str(objective(x))])


%% Algorithm 2: SQP
%tic
options2 = optimoptions('fmincon','Algorithm','sqp','plotfcn','optimplotfval');
[x,fval,ef,output,lambda]=fmincon(@objective,x0,A,b,Aeq,beq,lb,ub,@constraint,options2);
%toc

%Optimum values of each variable:
disp(table(x(1),x(2),x(3),x(4),x(5),'VariableNames',{'Ri', 'v', 'dT', 'k', 'th'}))

%Maximum heat transfer using these new variable values:
disp(['Final Objective SQP: ' num2str(objective(x))])


%% Algorithm 3: Active-Set
%tic
options3 = optimoptions('fmincon','Algorithm','active-set','plotfcn','optimplotfval');
[x,fval,ef,output,lambda]=fmincon(@objective,x0,A,b,Aeq,beq,lb,ub,@constraint,options3);
%toc

%Optimum values of each variable:
disp(table(x(1),x(2),x(3),x(4),x(5),'VariableNames',{'Ri', 'v', 'dT', 'k', 'th'}))

%Maximum heat transfer using these new variable values:
disp(['Final Objective Active-Set: ' num2str(objective(x))])


%% Algorithm 4: Global Search
rng default

%tic
problem = createOptimProblem('fmincon','x0',x0,'objective',@objective,'nonlcon',@constraint,'lb',lb,'ub',ub);
x = run(GlobalSearch,problem);
%toc

%Optimum values of each variable:
disp(table(x(1),x(2),x(3),x(4),x(5),'VariableNames',{'Ri', 'v', 'dT', 'k', 'th'}))

%Maximum heat transfer using these variable values:
disp(['Final Objective Global Search: ' num2str(objective(x))])

toc


%% Objective Function & Non-linear Constraints

function f=objective(x)

Re = 2100;      %Reynold's number
nu = 0.001;     %kinematic viscosity of air
dens_a = 1.2;   %density of air

vel_a = (Re*nu)/(2*x(1));       %air velocity
delP = 0.5*dens_a*(vel_a)^2;    %pressure gradient

%Heat transfer through convection:
q_cv = ((2*pi*(x(1))^2)*(10.45-(x(2)^2)+10*(x(2)^0.5))*x(3));

%Heat transfer through evaporation:
q_ev = ((2*pi*(x(1))^2)*16.5*(10.45-(x(2)^2)+10*(x(2)^0.5))*delP);

%Heat transfer through conduction:
q_cd = ((x(4)*(2*pi*(x(1))^2)*x(3))/x(5));

%Maximise total heat transfer (negative null):
f = -(q_cv + q_ev + q_cd);

end

function [c, ceq] = constraint(x)

Re = 2100;
nu = 0.001;
dens_a = 1.2;

ceq = [];
c = x(2)-(Re*nu)/(2*x(1))-3;

end