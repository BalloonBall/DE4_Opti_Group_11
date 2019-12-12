clc;clear;
close all;
%% Data import
% import dataset from csv
Material = readmatrix('safedata.csv','Range','A1:K24');
% import material properties into arrays
P = Material(:,1);
rho = Material(:,2);
S = Material(:,10);
h = Material(:,7);
% Calculate total cost of the helmet made of each material.
C_total = cost(h,rho,P)';
%% Data normalisation
% Normalise data of total cost, sustainable factor and thickness.
C_n = norm(C_total);
S_n = norm(S);
h_n = norm(h);
%% Plot
figure(1)
plot(C_n,S_n,'o')
xlabel('cost')
ylabel('sustainablity')
figure(2)
plot(C_n,h_n,'o')
xlabel('cost')
ylabel('thickness')
figure(3)
plot(S_n,h_n,'o')
xlabel('sustainablity')
ylabel('thickness')
%% Weighted
% obtain result from weighted objective function
w = weighted(C_n,h_n,S_n)';
% find the 3 best performed materials
[sortedw, sortedIdx] = sort(w(:),'Ascend');
top3 = sortedIdx(1:3)

%% Function
% Normalising function
function n = norm(x)
for i = 1:size(x)
    n(i) = (x(i) - min(x))/(max(x)-min(x));
end
end
% Weighted objective function
function w = weighted(x1,x2,x3)
for i = 1:size(x1,2)
    w(i) = 0.5*x1(i)+0.3*x2(i)+0.2*x3(i);
end
end
% Calculate total cost of the helmet
function c = cost(h,rho,P)
for i = 1:size(h)
    V = 2/3*pi*((0.08+h(i))^3-0.08^3);
    c(i) = P(i)*rho(i)*V;
end
end
