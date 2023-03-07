%%% File Name: homework02.m 
% Written by: Brian Patrick 
% Date Written: 03/05/2023 
% Description: This file is used to perform the necessary work for the
%              homework 02 assignment for Advanced Orbital Mechanics 
% =========================================================================
% Clear Environment 
close all; clear; clc; 
% Record Program Runtime
tic

%% Setup 

% Options 
solveEarthMolniyaOrbit = true; 
solveMarsMolniyaOrbit = false; 
analyzeMolniyaOrbitalElements = false; 

% Constants
MU = GravitationalParameter.EARTH; 
LU = CelestialBodyConstants.EARTH_RADIUS; 
TU = sqrt(LU^3/MU); 
J2 = 0.00108263;

%% Question 1 
if solveEarthMolniyaOrbit == true
    % Compute SMA knowing that P must be 1/3 day
    P = PhysicalConstants.JULIAN_DAY/3; 
    SMA = ((P/2/pi)^2 * MU)^(1/3);
    
    % Compute eccentricity of Molniya orbit knowing that the perigee distance must be > 600km 
    rp = 600 + LU; 
    eccentricity =  1 - rp/SMA;
    
    % Compute Mean Motion 
    n = sqrt(MU/SMA^3); 
    
    % Find roots of equation Symbollicaly
    syms x 
    perigeeRateOfChange = 3/4*n*J2*(LU/SMA)^2*((5*(cos(x))^2 - 1)/(1-eccentricity^2)^2); 
    [roots, parameters, conditions] = solve(perigeeRateOfChange == 0, x, "PrincipalValue",false, 'ReturnConditions',true);
    k = [0 1 2]; roots = eval(roots);
    idx = [find(roots<0), find(roots>2*pi)];
    % Roots of the rate of change equation for the Argument of Perigee between 0 and 2pi
    roots(idx) = []; 
    % Choose first root
    i = roots(1);
    
    % Compute the rates of change
    perigeeRateOfChange = 3/4*n*J2*(LU/SMA)^2*((5*(cos(i))^2 - 1)/(1-eccentricity^2)^2);
    nodalRateOfChange = -3/2*n*J2*(LU/SMA)^2*(cos(i)/(1-eccentricity^2)^2);

    % Assign Proper Inclination
    inclination = rad2deg(i); 

    % Output Orbital Parameters for Molniya Orbit 
    sprintf('Molniya Orbit Parameters: \n a = %f (km) \n e = %f \n i = %.4f (deg) \n Nodal Drift Rate = %s (rad/s)', SMA, eccentricity, inclination, num2str(nodalRateOfChange))    
end 

%% Question 2 
if solveMarsMolniyaOrbit == true 
    % MARS Constants 
    MU = 4.282e4; 
    LU = 3390;
    J2 = 0.00196; 
    
    % Compute SMA for P = 24:39:35 hh:mm:ss 
    P = 88775; 
    SMA = ((P/2/pi)^2 * MU)^(1/3);
    
    % Compute eccentricity of Molniya orbit knowing that the perigee distance must be > 600km 
    rp = 400 + LU; 
    eccentricity =  1 - rp/SMA;
    
    % Compute Mean Motion 
    n = sqrt(MU/SMA^3);
    
    % Roots of the equation for rate of change of the Argument of Perigee 
    roots = [acos(sqrt(1/5)), acos(-sqrt(1/5))]; 
    i = roots(1);
    
    % Compute the rates of change
    perigeeRateOfChange = 3/4*n*J2*(LU/SMA)^2*((5*(cos(i))^2 - 1)/(1-eccentricity^2)^2);
    nodalRateOfChange = -3/2*n*J2*(LU/SMA)^2*(cos(i)/(1-eccentricity^2)^2);
    
    % Assign correct inclination
    inclination = rad2deg(i);
    
    % Output Orbital Parameters for Molniya Orbit 
    sprintf('Molniya Orbit Parameters: \n a = %f (km) \n e = %f \n i = %.4f (deg) \n Nodal Drift Rate = %s (rad/s)', SMA, eccentricity, inclination, num2str(nodalRateOfChange))
end

%% Question 3
if analyzeMolniyaOrbitalElements == true
       % Orbital Parameters 
    a = 26600; 
    e = 0.74; 
    i = 1.10544;
    w = deg2rad(5); 
    RAAN = deg2rad(90); 
    M = deg2rad(10); 
    
    % Solve Modified Keplers Equation for Eccentric Anomaly 
    [eccentricAnomaly, counter, exit] = solveEccentricAnomaly(M, e, M, 1e-10); 
    
    % Solve True Anomaly 
    trueAnomaly = 2*tanh(sqrt((1-e)/(1+e))*tan(eccentricAnomaly/2)); 
    
    % Build Orbital Elements 
    stateKeplerian = [a, e, i, RAAN, w, trueAnomaly]'; 
    
    %% Propagate Molniya Orbit 
    stateCartesian = convertKeplerianToCartesian(stateKeplerian, 0, MU); 
    
    % Compute Molniya Orbital Period 
    P = 2*pi*sqrt(a^3/MU); 
    
    % Propagate Keplerian State 
    odeopts = odeset('RelTol', 1e-10, 'AbsTol', 1e-12);
    tspan = [0 PhysicalConstants.JULIAN_DAY*100]; 
    [time, trajCartesian] = ode89(@twoBodyJ2, tspan, stateCartesian, odeopts, MU, LU, J2); 
    trajCartesian = trajCartesian'; % Transpose trajectory output
    
    %% Analyze Orbital Elements 
    trajKeplerian = convertCartesianToKeplerian(trajCartesian, time', MU);
    time = time/PhysicalConstants.JULIAN_DAY; % Convert Time to Days 
    
    % Convert angles to degrees 
    trajKeplerian(3:6,:) = rad2deg(trajKeplerian(3:6,:));
    
    % Unpack Elements 
    [a, e, i, RAAN, w, f] = deal(trajKeplerian(1,:), trajKeplerian(2,:), trajKeplerian(3,:), trajKeplerian(4,:), trajKeplerian(5,:), trajKeplerian(6,:)); 
    
    %% Plot Results 
    
    % Plot Orbital Elements 
    fig2 = tiledlayout(3,2);
    nexttile 
    xa = plot(time, a/LU); 
    ylabel('a (Earth Radii)')
    nexttile 
    xe = plot(time, e); 
    ylabel('e')
    nexttile 
    xi = plot(time, i);
    ylabel('i (deg)')
    nexttile 
    xRAAN = plot(time, RAAN); 
    ylabel('\Omega (deg)')
    nexttile 
    xw = plot(time, w);
    ylabel('\omega (deg)')
    nexttile 
    xf = plot(time, f);
    ylabel('f (deg)')
    
    % Axes Settings
    grid minor 
    xlabel(fig2, 'Time (Days)', 'FontSize', 18);
    title(fig2, sprintf('Variation of Molniya Orbital Elements'),'FontSize', 18, Interpreter="latex")
    set(findobj(gcf, 'type', 'axes'), 'FontSize', 18)
    
    % Plot Trajectory 
    fig1 = figure();
    hold on 
    axis equal 
    grid minor
    plot3(trajCartesian(1,:)/LU, trajCartesian(2,:)/LU, trajCartesian(3,:)/LU, 'b-', 'LineWidth', 1.2)
    drawPlanet(Body.EARTH, [0 0 0], 1); 
    
    % Axis Settings
    xlabel('X Axis (km)') 
    ylabel('Y Axis (km)') 
    zlabel('Z Axis (km)') 
    title(sprintf('Perturbed Molniya Orbit'), Interpreter="latex")
    set(findall(gca, '-Property', 'FontSize'), 'FontSize', 16)
end

%% Display Program Runtime 
runtime = toc; 
fprintf('\n Program Runtime: %.2f (seconds) \n', runtime)

%% Helper Functions
function [eccentricAnomaly, counter, exit] = solveEccentricAnomaly(initialGuess, eccentricity, meanAnomaly, tolerance)
    
    % Initialize Loop 
    counter = 1;
    done = false;
    exit = 0; 
    E = initialGuess; 
    e = eccentricity; 
    M = meanAnomaly;
    while ~ done 
        
        % Find Roots of Keplers Equation 
        g = E - e*sin(E) - M;
        dG = 1-e*cos(E); 
                
        % Compute Ratio
        ratio = g/dG;  
        
        % Update Eccentric Anomaly
        E = E - ratio; 
        
        % Check if done
        done = abs(ratio) < tolerance;
        counter = counter + 1;
        
        % Break loop if no convergence 
        if counter > 1000
            exit = 1; 
            break 
        end 
    end 

    % Assign output 
    eccentricAnomaly = E;
end


