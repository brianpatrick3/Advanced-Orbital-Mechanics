%%% File Name: testUniversalVariablePropagator.m
%  Written By: Brian Patrick 
%  Date Written: 2.6.2023 
%  Description: This file is used to test the universal variable propagator 
%  ========================================================================
close all; clear; clc;

% Recrod Program Runtime
tic; 

%% Options 
plotOrbit = true; 

%% Example 3.7 Curtis -- Universal Variable Orbit Propagator 

initialPosition = [7000, -12124, 0]; 
initialVelocity = [2.6679, 4.6210, 0]; 

% Build Initial State
initialState = [initialPosition, initialVelocity]';

% Define timespan 
timespan = 3600*5; % seconds

% Define Constants 
MU = GravitationalParameter.EARTH;
LU = CelestialBodyConstants.EARTH_RADIUS; 
TU = sqrt(LU^3/MU);
VU = LU/TU; 

% Obtain state at specified epochs
finalState = zeros(6, timespan); 
for i = 1: timespan 
    timespan = i;
    finalState(:,i) = universalVariablePropagator(initialState, timespan, MU)./[LU;LU;LU;VU;VU;VU];
end

% % solve once
% finalState = universalVariablePropagator(initialState, timespan, constants); 

%% Convert States to Keplerian Elements 
epochs = 1:timespan; 
stateKeplerian = convertCartesianToKeplerian(finalState, epochs, 1);

% Find Periapsis 
periapsisID = find(abs(stateKeplerian(6,:)) < 1e-3, 1, 'first'); 

%% Plot Results
if plotOrbit == true
    figure() 
    hold on 
    axis equal 
    grid minor
    plot3(finalState(1,:), finalState(2,:), finalState(3,:), 'LineWidth', 1.5); 
    plot3(finalState(1,1), finalState(2,1), finalState(3,1), 'k.','LineWidth', 2, 'MarkerSize', 15)
    plot3(finalState(1,periapsisID), finalState(2,periapsisID), finalState(3, periapsisID), 'r.', 'LineWidth', 2, 'MarkerSize', 15)
    drawPlanet(Body.EARTH, [0,0,0], 1); 
    legend('Trajectory', 'Initial State', 'Periapsis', '')
    
    % Figure Settings 
    title(sprintf('Universal Variable Orbit Propagation'), 'Interpreter','latex') 
    xlabel('X Axis (Earth Radii)') 
    ylabel('Y Axis (Earth Radii)') 
    zlabel('Z Axis (Earth Radii)')
end 
%% Runtime 
runtime = toc; 
fprintf('Program Runtime %0.4f s \n', runtime)

