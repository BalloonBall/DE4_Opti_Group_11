clc;clear;
close all;
%% Data import
% import dataset from csv
Material_Liner = readmatrix('material_liner.csv','Range','B2:G38');
Material_Shell = readmatrix('material_shell.csv','Range','B2:G17');
%% Data processing
% sort dataset by density in asending order
[~,idx] = sort(Material_Liner(:,2)); 
Material_Liner = Material_Liner(idx,:);
[~,idx] = sort(Material_Shell(:,2)); 
Material_Shell = Material_Shell(idx,:);

% import material properties of liner and shell into arrays
C_l = Material_Liner(:,1);
rho_l = Material_Liner(:,2);
sigma_l = Material_Liner(:,3);
EE_l= Material_Liner(:,5);
CO2e_l= Material_Liner(:,6);
C_s = Material_Shell(:,1);
rho_s = Material_Shell(:,2);
ESE_s= Material_Shell(:,4);
CO2e_s = Material_Shell(:,6);
EE_s= Material_Shell(:,5);
%% Plot
% plot to find correlation between density and other properties
figure(1)
plot(rho_l,sigma_l,'o')
title('Liner density v.s. Liner yield stress')
xlabel('Liner density')
ylabel('Liner yield stress')
figure(2)
plot(rho_l,CO2e_l,'o')
title('Liner density v.s. CO2e_l')
xlabel('Liner density')
ylabel('CO2e_l')
figure(3)
plot(rho_l,EE_l,'o')
title('Liner density v.s. Liner embodied energy')
xlabel('Liner density')
ylabel('Liner embodied energy')
figure(4)
plot(rho_s,ESE_s,'o')
title('Shell density v.s. ESE_s')
xlabel('Shell density')
ylabel('ESE_s')
figure(5)
plot(rho_s,CO2e_s,'o')
title('rho_s v.s. CO2e_s')
xlabel('rho_s')
ylabel('CO2e_s')
figure(6)
plot(rho_s,EE_s,'o')
title('rho_s v.s. EE_s')
xlabel('rho_s')
ylabel('EE_s')

figure(7)
plot(EE_l,C_l,'o')
title('Liner embodied energy v.s. Liner cost')
xlabel('Liner embodied energy')
ylabel('Liner cost')
figure(8)
plot(C_s,EE_s,'o')
title('C_s v.s. EE_s')
xlabel('C_s')
ylabel('EE_s')