%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Basic Algebraic Model v1.1
%  Neel Le Penru, 12/12/2019

% This produces the graphs used for the Optimisation MidTerm Assessment...
% some of which are reused in the final report.
% Note that this code is largely unchanged from the interim, and thus...
% certain values are different to those used elsewhere in the final report.

%% Set Parameters, Create Variables

clear all
close all
h_l = 0.005; %helmet thickness lower bound
h_u = 0.03; %helment thickness upper bound
phi_l = 0.05; %CO2 footprint lower bound
phi_u = 1; %CO2 footprint upper bound
h_x = h_l:0.001:h_u; %create range of values for h between bounds
phi_x = phi_l:0.01:phi_u; %as above for Phi
[h,phi] = meshgrid(h_x,phi_x); %create appropriate matrix for 3D plotting with 'surf'
D = 200; %density of foam
r = 0.0825; %head radius
%% Compute Objective Function

% Note that this includes initial estimated linear relationship between CO2
% footprint and EE
f = (2/3).*pi.*D.*h.*(h.^2 + 3.*r.*h + 3*r^2).*(36.7.*phi);

%% Plotting

figure
res = surf(h,phi,f,'FaceAlpha',0.8) %plot 3d surface
grid on
xlabel('Foam thickness h (m)')
ylabel('Material CO2 Footprint (kg/kg)')
zlabel('Net Environmental Impact (kgCO2)')
colorbar
hold on %for constraints to be plotted

%Create and plot constraints (vertical planes)
[y z] = meshgrid(linspace(0,1,20),linspace(0,14,20));
x = (9/(50*9.81)).*ones(size(y, 1),size(y, 2));
c_h = surf(x,y,z,'FaceAlpha',0.3)
c_h.EdgeColor = 'none'; %for clarity
clear x y z C0
[x z] = meshgrid(linspace(0,0.03,20),linspace(0,14,20));
y = (0.211).*ones(size(x, 1),size(x, 2));
c_phi = surf(x,y,z,'FaceAlpha',0.3)
c_phi.EdgeColor = 'none';

