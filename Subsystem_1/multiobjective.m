tic
clc
clear

%% Multi-objective optimisation of heat transfer and weight

heatweightfunc = @multiobj;
n=8; %number of variables

% x(1) is inner radius
% x(2) is helmet velocity
% x(3) is temperature gradient
% x(4) is foam thermal conductivity
% x(5) is foam thickness
% x(6) is foam density
% x(7) is shell thickness
% x(8) is shell density

lb=[0.08,0,10,0.12,0.02,20,0.003,1000];    %lower bounds
ub=[0.1,7.5,17,0.44,0.04,70,0.006,1300];   %upper bounds
A =[]; b=[]; Aeq=[]; beq=[];

options = optimoptions(@gamultiobj,'PlotFcn',{@gaplotpareto});
[x, fval] = gamultiobj(heatweightfunc,n,A,b,Aeq,beq,lb,ub,@constraint,options);


%% Weighting the Functions 

%Normalise the function
fnorm = mapstd(fval');

%Weighted objective function:
weighted = 0.6*fnorm(1,:)+0.3*fnorm(2,:) +0.1*fnorm(3,:);

%Find the point where the objectives are at their minimum:
minimum = find(weighted==min(weighted));

X = x(minimum,:);
F = fval(minimum,:);

disp(table(X(1),X(4),X(5),X(6),X(7),X(8),'VariableNames',{'Ri', 'k', 'th_f','rho_f', 'th_s', 'rho_s'}))
disp(['Maximum Heat Transfer: ' num2str(-F(1)) 'W'])
disp(['Minimum Shell Weight: ' num2str(F(2)) 'kg'])
disp(['Minimum Foam Weight: ' num2str(F(3)) 'kg'])

toc


%% Objective Function & Non-linear Constraints

function f = multiobj(x)

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
f(1) = -(q_cv + q_ev + q_cd);

%Minimise the weight:
%m_shell 
f(2) = (x(8)*((2*pi/3)*((x(1)+x(5)+x(7))^3 - (x(1)+x(5))^3)));

%m_foam
f(3) = (x(6)*((2*pi/3)*((x(1)+x(5))^3 - (x(1))^3)));

end

function [c, ceq] = constraint(x) 

Re = 2100;
nu = 0.001;
dens_a = 1.2;

ceq = [];
c = x(2)-(Re*nu)/(2*x(1))-3;

end