%%% File Name: homework1.m 
%  Written By: Brian Patrick 
%  Date Written: 2.6.2023 
%  Description: This file is used to complete the assigned work for
%               homework 1 in AE 502 - Advanced Orbital Mechanics 
%  ========================================================================
close all; clear; clc;

% Recrod Program Runtime
tic; 

%% Load SPICE KERNELS 
furnsh_c(Ephemeris.DE440S, Ephemeris.NAIF0012); 

%% Options 
asteroid = 'Borisov'; 
plotOrbit = true;

%% Define Constants 
MU = GravitationalParameter.SUN;
LU = PhysicalConstants.ASTRONOMICAL_UNIT; 
TU = sqrt(LU^3/MU);
VU = LU/TU;

%% Choose Asteroid Case
switch asteroid 

    case 'Oumuamua'
        initialPosition = [3.515868886595499e-2, -3.162046390773074, 4.493983111703389].*LU; 
        initialVelocity = [-2.317577766980901e-3, 9.843360903693031e-3, -1.541856855538041e-2]*LU/86400; 
        
        % Build InitialState 
        initialState = [initialPosition, initialVelocity]';

        % Timespan
        initialEpochET = str2et_c('2017-Jan-01 00:00:00.0000'); %%% SOMETHING GOING ON WITH THE PROPAGATION WHEN USING THE ET FOR THE INITIAL EPOCH
        initialEpoch = 0; 
        finalEpoch = initialEpoch + PhysicalConstants.JULIAN_YEAR; 
        timespan = linspace(initialEpoch, finalEpoch, 5000);
        
        % % Convert state to keplerian 
        stateKeplerian = convertCartesianToKeplerian(initialState, 0, MU);  
        % stateKeplerian = rv2elm(initialPosition, initialVelocity, MU, 1e-10)'

    case 'Borisov'
        initialPosition = [7.249472033259724, 14.61063037906177, 14.24274452216359].*LU; 
        initialVelocity = [-8.241709369476881e-3, -1.156219024581502e-2, -1.317135977481448e-2]*LU/86400; 
        
        % Build InitialState 
        initialState = [initialPosition, initialVelocity]';

        % Timespan 
        initialEpochET = str2et_c('2017-Jan-01 00:00:00.0000');
        initialEpoch = 0; 
        finalEpoch = initialEpoch + PhysicalConstants.JULIAN_YEAR*5; 
        timespan = linspace(initialEpoch, finalEpoch, 5000);
        
        % Convert state to keplerian
        stateKeplerian = convertCartesianToKeplerian(initialState, 0, MU);
end

%% Propagation 

% Obtain state at specified epochs
trajectory = zeros(6, length(timespan)); 
for i = 1: length(timespan)
    trajectory(:,i) = universalVariablePropagator(initialState, timespan(i), MU);
end
% Convert to Canonical Units
trajectory(1:3,:) = trajectory(1:3,:)/LU; 

%% Propagate using ODE45
% tspan = [0 PhysicalConstants.JULIAN_YEAR*4]; 
% odeopts = odeset('RelTol', 1e-10, 'AbsTol', 1e-12); 
% [time, trajectory] = ode45(@two_body_PR, tspan, initialState, odeopts, MU); 
% trajectory = trajectory'; 
% trajectory(1:3,:) = trajectory(1:3,:)/LU; 

%% Convert Trajectory to Keplerian Elements 
epochs = timespan; 
stateKeplerian = convertCartesianToKeplerian(trajectory, epochs, 1);

% Find Periapsis 
periapsisID = find(abs(stateKeplerian(6,:)) < 1e-3, 1, 'first'); 

%% Plot Trajectory
if plotOrbit == true
    figure() 
    hold on 
    axis equal 
    grid minor
    plot3(trajectory(1,:), trajectory(2,:), trajectory(3,:), 'LineWidth', 1.5); % Plot Asteroid Trajectory 
    plot3(trajectory(1,1), trajectory(2,1), trajectory(3,1), 'k.','LineWidth', 2, 'MarkerSize', 15) % Plot Initial State
    plot3(trajectory(1,periapsisID), trajectory(2,periapsisID), trajectory(3, periapsisID), 'm^', 'LineWidth', 2, 'MarkerSize', 8) % Plot Closest Approach 
    drawPlanet(Body.SUN, [0,0,0], CelestialBodyConstants.SUN_RADIUS/LU); % Plot Sun 
    legend('Trajectory', 'Initial State','Closest Approach', 'Sun' )
    
    % Figure Settings 
    title(sprintf('%s Trajectory', asteroid), 'Interpreter','latex') 
    xlabel('X Axis (AU)') 
    ylabel('Y Axis (AU)') 
    zlabel('Z Axis (AU)')
end 

%% Runtime 
runtime = toc; 
fprintf('Program Runtime %0.4f s \n', runtime)














