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

% exclude materials with significant outlier properties(embodied energy &
% CO2 footprint)
TF1 = Material_Liner(:,5)>1.5e8;
TF2 = Material_Liner(:,6)>10;
TFall1 = TF1 & TF2;
Material_Liner(TFall1,:)=[];

% import material properties of liner and shell into arrays
% Liner
C_l = Material_Liner(:,1);
rho_l = Material_Liner(:,2);
sigma_l = Material_Liner(:,3);
EE_l = Material_Liner(:,5);
% Shell
C_s = Material_Shell(:,1);
rho_s = Material_Shell(:,2);
ESE_s = Material_Shell(:,3);
EE_s = Material_Shell(:,5);

% Variable linking:
% link yeild stress, elastic absorbed energy, embodied energy and cost 
% with density, using PRS method
global Beta1 Beta2 Beta3 Beta4 Beta5 Beta6
% Liner
Beta1 = polyfit(rho_l,sigma_l,2);
Beta2 = polyfit(rho_l,EE_l,1);
Beta3 = polyfit(EE_l,C_l,1);
% Shell
Beta4 = polyfit(rho_s,ESE_s,2);
Beta5 = polyfit(rho_s,EE_s,2);
Beta6 = polyfit(EE_s,C_s,1);
%% Define parameters
global v0 mh r
v0 = 5.52;
mh = 4.54;
r = 0.078;
%%
xi = linspace(0,1,28);
yi = Material_Liner(:,2)';
[X,Y] = meshgrid(xi,yi);
Z = v_PLA([X(:),Y(:)]);
Z = reshape(Z,size(X));
surf(X,Y,Z,'MeshStyle','none')
xlabel('Liner thickness(m)')
ylabel('Liner density(kgm^-3)')
title('Peak linear acceleration(g)')

function pla = v_PLA(x)
global Beta1 v0 mh r
for i = 1:size(x,1)
pla(i) = v0./(mh+x(i,2).*(2/3.*pi.*((r+x(i,1))^3-r^3))).^0.5.*(2.*pi.*(r+x(i,1)).*(Beta1(1).*x(i,2).^2+Beta1(2).*x(i,2)+Beta1(3))).^0.5/9.81;
end
end