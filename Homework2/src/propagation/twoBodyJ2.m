%%% Function Name: twoBodyJ2.m 
% Written by: Brian Patrick 
% Date Written: 3/6/2023 
% Description: Two body dynamics + J2 perturbation function to perform
%              numerical integration
% =========================================================================

function stateDerivative = twoBodyJ2(~,initialState, gravitationalParameter, centralBodyRadius, J2)

% Unpack Inputs 
x = initialState; 
mu = gravitationalParameter; 
R = centralBodyRadius;

% Compute Position magnitude
r = norm(initialState(1:3));

% Compute J2 Perturbation Magnitude
I = [1 0 0]; J = [0 1 0]; K = [0 0 1]; 
pJ2 = ((1.5*J2*mu*(R^2))/(r^4))*((x(1)/r)*(5*((x(3)/r)^2) - 1)*I + (x(2)/r)*(5*((x(3)/r)^2) - 1)*J + (x(3)/r)*(5*((x(3)/r)^2) - 3)*K);

% Compute State Derivative 
stateDerivative(1) = x(4);
stateDerivative(2) = x(5); 
stateDerivative(3) = x(6); 
stateDerivative(4) = -(mu*x(1)/r^3) + pJ2(1);
stateDerivative(5) = -(mu*x(2)/r^3) + pJ2(2);
stateDerivative(6) = -(mu*x(3)/r^3) + pJ2(3);

stateDerivative = stateDerivative'; 

end

