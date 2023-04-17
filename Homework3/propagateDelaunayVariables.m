% File name: propagateDelaunayVariables.m 
% Written by: Brian Patrick 
% Date written: 04/15/2023 
% Description: This script is used to analyze the EOMs for the Delaunay
%              variables given in Homework 03 for AE 502. 
% =========================================================================

% Clear environment 
close all; clear; clc; 

% Record program runtime 
tic; 

%% Setup 
% Define constants 
a = 1; 
e = 0.5; 
i = deg2rad(45); 
frameRotation = 0.01;

% Compute Delaunay Variables 
n = sqrt(1/a^3); 
L = n*a^2; 
G = L*sqrt((1-e^2)); 
H = G*cos(i); 
l = 0; 
g = 0; 
h = 0; 

% Define initial state 
initialState = [L,G,H,l,g,h]'; 

% Define timespan 
tspan = linspace(0,100, 100000); 

%% Propagate state 
odeopts = odeset(RelTol= 1e-10, AbsTol= 1e-12); 
[time, traj] = ode89(@delaunayVariables_EOMs, tspan, initialState, odeopts, frameRotation);

%% Compute Keplerian elements 

% Unpack traj 
[L,G,H,l,g,h] = deal(traj(:,1), traj(:,2), traj(:,3), traj(:,4), traj(:,5), traj(:,6)); 

% Convert to Keplerian elements 
a = sqrt(L/n); 
e = sqrt(1-(G./L).^2); 
i = acos(H./G); 
w = g; 
RAAN = h - w; 
M = l; 

%% Convert elements to Cartesian state 

% Build Keplerian state 
stateKeplerian = [a, e, i, RAAN, w, M]; 

% Convert to Cartesian state
stateCartesian = zeros(6, length(stateKeplerian)); 
for i = 1:length(stateKeplerian)
    % Get Cartesian state
    stateCartesian(:,i) = convertKeplerianToCartesian_meanAnomaly(stateKeplerian(i,:), 0, 1);
end 

% Plot Trajectory 
figure(1) 
hold on 
axis equal 
grid minor 
plot3(stateCartesian(1,:), stateCartesian(2,:), stateCartesian(3,:))
drawPlanet(Body.EARTH, [0 0 0], 0.2);

% Figure Settings
title(sprintf('Perturbed Trajectory'), 'Interpreter','latex')
xlabel('X (DU)') 
ylabel('Y (DU)') 
zlabel('Z (DU)') 
legend('Trajectory', 'Earth (not to scale)')
set(findall(gca, '-property', 'fontsize'), 'fontsize', 18);










