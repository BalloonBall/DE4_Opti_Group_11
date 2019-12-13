%% DE4 Optimisation Group 11 - Sustainability Subsystem
%  Objective Function for GA
%  Neel Le Penru, 12/12/2019
function CO2 = CO2estGa(x)

%Same iterative method for finding helmet thickness 'h' as in
%'SustDiscSolverAll.m' - please see this for more detailed explanation:
r = 0.0825;
h_0 = 0.001;
step = 0.0001;
min_error = 0.0001;
dh = 0;
m_head = 5;
v0 = 6;
r = 0.0825;
h = h_0;
while abs(dh - 0.8*h) > min_error
    h = h + step;
    dh = deltah(h,r,x(2),x(1),v0,m_head);
end

%Objective Function:
CO2 = (2/3)*x(1)*pi*h*(h^2+3*r*h+3*r^2)*(x(3) + x(4));
