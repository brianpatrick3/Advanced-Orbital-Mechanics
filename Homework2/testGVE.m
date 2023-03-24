close all; clear; clc; 

% Define initial elements 
a = 26600; 
e = 0.74; 
i = 1.10654; 
RAAN = deg2rad(90); 
w = deg2rad(5); 
M0 = deg2rad(10); 

% Solve Modified Keplers Equation for Eccentric Anomaly 
[eccentricAnomaly, counter, exit] = solveEccentricAnomaly(M0, e, M0, 1e-10);

% Solve True Anomaly 
f = 2*atan(sqrt((1+e)/(1-e))*tan(eccentricAnomaly/2));

% Build initial state 
initialState = [a,e,i,RAAN,w,f]'; 

% Specify time span for integration 
tspan = [0 100*PhysicalConstants.JULIAN_DAY]; 

% Specify Perturbations 
perturbations.J2 = true; 

% Specify central body 
centralBody = 'EARTH'; 

odeopts = odeset('RelTol', 1e-10, 'AbsTol', 1e-12); 
[time, traj] = ode89(@gaussVariationalEquations, tspan, initialState, odeopts, perturbations, centralBody); 





