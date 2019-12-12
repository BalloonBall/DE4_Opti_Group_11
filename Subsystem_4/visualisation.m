Material_Liner = readmatrix('material_liner.csv','Range','B2:G38');
Manufacture_data = readmatrix('manufacture_data','Range','B2:G38');
[~,idx] = sort(Material_Liner(:,2)); 
Material_Liner = Material_Liner(idx,:);
[~,idx] = sort(Manufacture_data(:,1)); 
Manufacture_data = Manufacture_data(idx,:);


MatPrice = Material_Liner(:,1);
rho = Material_Liner(:,2);%density
sigma = Material_Liner(:,3);%
EE = Material_Liner(:,5);
CO2e = Material_Liner(:,6);
capacity = Manufacture_data(:,1);
va = Manufacture_data(:,2);
%%


Beta1 = polyfit(rho,sigma,2);
Beta2 = polyfit(rho,EE,1);
Beta3 = polyfit(rho,CO2e,1);
Beta4 = polyfit(rho,MatPrice,2); 
Beta5 = polyfit(capacity,va,2);

%Calculated Price of Material
p_x=linspace(10,900,50);
P1 = polyval(Beta4,p_x);

%Calculated variable cost
capa = [80000:1000:210000];
P2 = polyval(Beta5,capa);
%%
%objective function
R1 = 0.08+0.02;
r = 0.08;
[N,p] = meshgrid(capa,p_x);
M = 2/3*pi.*p.*(R1.^3-r^3);
% P1 is material price(GBP/kg), p_xis material density
P1 = Beta4(1).*p.^2+Beta4(2).*p+Beta4(3);
% P3 is variable cost of each helmet, x(1) is the production size.
P3 = Beta5(1).*N.^2+Beta5(2).*N+Beta5(3);
%P3 = Beta5(1).*x(1).^5+Beta5(2).*x(1).^4+Beta5(3).*x(1).^3+Beta5(4).*x(1).^2+Beta5(5).*x(1)+Beta5(6);
Cost = N.*((M.*P1)+P3)-600;
profit = N.*25 - Cost;

%%
figure(1)
plot(rho,MatPrice,'o')
hold on
plot(p_x,P1);
hold off
title('Liner density v.s. Material price')
xlabel('rho(kg/m^3)')
ylabel('Material price(GBP/kg)')

figure(2)
plot(capacity,va,'o')
hold on
plot(capa,P2);
hold off
title('Factory capacity v.s.Variable cost')
xlabel('Factory Annual Capacity')
ylabel('Variavle Cost(GBP/unit)')

%%

figure;
surf(capa,p_x,profit);
colorbar
grid on
title('Annual profit v.s. Material density v.s Factory capacity')
xlabel('Factory capacity)');
ylabel('Material density(GBP/kg)');
%fsurf(C,[0,50],'ShowContours','on')

% relationship of profit,density, and 
%y = annualprofit();
