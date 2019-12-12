function x = MapVars(x)
%cantileverMapVariables Map integer variables to a discrete set
%
%   V = cantileverMapVariables(x) maps the integer variables in the second
%   problem solved in the "Solving a Mixed Integer Engineering Design
%   Problem Using the Genetic Algorithm" example to the required discrete
%   values.

%   Copyright 2012 The MathWorks, Inc.

matdata = csvread('ProductionData.csv');

% The possible values for x(3) and x(5)
Capacity = matdata(:,1);
Va = matdata(:,2);
rho = matdata(:,3);
Pm = matdata(:,4);


% Map x(3), x(4), x(5) and x(6) from the integer values used by GA to the
% discrete values required.
x(1) = Capacity(x(1));
x(2) = Va(x(2));
x(3) = Pm(x(3));
x(4) = rho(x(4));