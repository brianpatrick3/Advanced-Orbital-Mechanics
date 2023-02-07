%%% File Name: homework1.m 
%  Written By: Brian Patrick 
%  Date Written: 2.6.2023 
%  Description: This file is used to complete the assigned work for
%               homework 1 in AE 502 - Advanced Orbital Mechanics 
%  ========================================================================
close all; clear; clc;

% Recrod Program Runtime
tic; 

%% Options 
plotOrbit = true; 

%% Define Constants 
MU = GravitationalParameter.SUN;
LU = PhysicalConstants.ASTRONOMICAL_UNIT; 
TU = sqrt(LU^3/MU);
VU = LU/TU;

%% 'Oumouamoua 
initialPosition = [3.515868886595499e-2, -3.162046390773074, 4.493983111703389]; 
initialVelocity = [-2.317577766980901e-3, 9.843360903693031e-3, -1.541856855538041e-2]; 
% Build initialState 
initialState = [initialPosition, initialVelocity]';

% Timespan 
timespan = linspace(0, PhysicalConstants.JULIAN_YEAR*2/TU, 5000); 

% Obtain state at specified epochs
trajectory = zeros(6, length(timespan)); 
for i = 1: length(timespan)
%     trajectory(:,i) = universalVariablePropagator(initialState, timespan(i), MU)./[LU;LU;LU;VU;VU;VU];
    trajectory(:,i) = universalVariablePropagator(initialState, timespan(i), 1)./[LU;LU;LU;VU;VU;VU];

end

% % solve once
% finalState = universalVariablePropagator(initialState, timespan, constants); 

%% Convert States to Keplerian Elements 
epochs = timespan; 
stateKeplerian = convertCartesianToKeplerian(trajectory, epochs, 1);

% Find Periapsis 
% periapsisID = find(abs(stateKeplerian(6,:)) < 1e-3, 1, 'first'); 

%% Plot Results
if plotOrbit == true
    figure() 
    hold on 
    axis equal 
    grid minor
    plot3(trajectory(1,:), trajectory(2,:), trajectory(3,:), 'LineWidth', 1.5); 
    plot3(trajectory(1,1), trajectory(2,1), trajectory(3,1), 'k.','LineWidth', 2, 'MarkerSize', 15)
%     plot3(finalState(1,periapsisID), finalState(2,periapsisID), finalState(3, periapsisID), 'r.', 'LineWidth', 2, 'MarkerSize', 15)
    drawPlanet(Body.SUN, [0,0,0], 1); 
    legend('Trajectory', 'Initial State', '', '')
    
    % Figure Settings 
    title(sprintf('Universal Variable Orbit Propagation'), 'Interpreter','latex') 
    xlabel('X Axis (AU)') 
    ylabel('Y Axis (AU)') 
    zlabel('Z Axis (AU)')
end 
%% Runtime 
runtime = toc; 
fprintf('Program Runtime %0.4f s \n', runtime)






















