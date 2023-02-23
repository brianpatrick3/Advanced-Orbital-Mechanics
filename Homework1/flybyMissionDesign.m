%%% File Name: flybyMissionDesign.m 
% Written By: Brian Patrick 
% Date Written: 2.19.2023 
% Description: This file will be used to compute the DV's and pork chop
%              plots for a flyby (intersection) from Earth to 'Oumuamua and
%              Borisov for the AE 502 Homework assignment. 
% ===============================================================================
close all; clear; clc; 
% Record Runtime 
tic 

%% Setup 

% Load SPICE KERNELS 
furnsh_c(Ephemeris.DE440S, Ephemeris.NAIF0012); 

% Constants 
MU = GravitationalParameter.SUN; 
LU = PhysicalConstants.ASTRONOMICAL_UNIT;
TU = sqrt(LU^3/MU);

%% Earth Coordinates: 2017-Jan-01 00:00:00.0000 UTC  
initialEarthPosition = [-1.796136509111975e-1, 9.667949206859814e-1,-3.668681017942158e-5].*LU;
initialEarthVelocity = [-1.720038360888334e-2, -3.211186197806460e-3, 7.927736735960840e-7]*LU/86400;
initialEarthState = [initialEarthPosition, initialEarthVelocity]; 

%% Options 
asteroid = 'Oumuamua'; 
transferType = 'prograde'; 

%% Choose Asteroid Case
switch asteroid 

    case 'Oumuamua'
        % 'Oumuamua Coordinates: 2017-Jan-01 00:00:00.0000 UTC 
        asteroidPosition = [3.515868886595499e-2, -3.162046390773074, 4.493983111703389].*LU; 
        asteroidVelocity = [-2.317577766980901e-3, 9.843360903693031e-3, -1.541856855538041e-2]*LU/86400; 
        
        % Build InitialState 
        initialAsteroidState = [asteroidPosition, asteroidVelocity];

        % Specify First Departure Date 
        initialDeparture = datetime('2017-Jan-01 00:00:00.0000');
        finalDeparture = datetime('2017-Dec-31 00:00:00.0000');
        departureDuration = days(finalDeparture - initialDeparture);
        departureTimes = 0:1:departureDuration; % Days past initial departure 
        
        % Specify Arrival Dates 
        initialArrival = datetime('2017-Aug-01 00:00:00.0000'); 
        finalArrival = datetime('2019-Jan-31 00:00:00.0000');
        arrivalDuration = days(finalArrival - initialArrival); % Days past initialArrival
        arrivalTimes = 0:1:arrivalDuration;
        
        % Time Between initial departure and initial arrival 
        waitTime = days(initialArrival - initialDeparture);
                
    case 'Borisov'
        % Borisov Coordinates: 2017-Jan-01 00:00:00.0000 UTC 
        asteroidPosition = [7.249472033259724, 14.61063037906177, 14.24274452216359].*LU; 
        asteroidVelocity = [-8.241709369476881e-3, -1.156219024581502e-2, -1.317135977481448e-2]*LU/86400; 
        
        % Build InitialState 
        initialAsteroidState = [asteroidPosition, asteroidVelocity];

        % Specify First Departure Date 
        initialDeparture = datetime('2017-Jan-01 00:00:00.0000');
        finalDeparture = datetime('2020-Jul-31 00:00:00.0000');
        departureDuration = days(finalDeparture - initialDeparture);
        departureTimes = 0:1:departureDuration; % Days past initial departure 
        
        % Specify Arrival Dates 
        initialArrival = datetime('2019-Jun-01 00:00:00.0000'); 
        finalArrival = datetime('2022-Jan-31 00:00:00.0000');
        arrivalDuration = days(finalArrival - initialArrival); % Days past initialArrival
        arrivalTimes = 0:1:arrivalDuration;
        
        % Time Between initial departure and initial arrival 
        waitTime = days(initialArrival - initialDeparture);

end

%% Setup Analysis (Flyby) 

% Compute Earth State at each epoch
earthState = zeros(length(departureTimes), length(initialEarthState)); 
for i = 1: length(departureTimes) 
    earthState(i,:) = universalVariablePropagator(initialEarthState, departureTimes(i)*PhysicalConstants.JULIAN_DAY, MU); 
end

% Compute Asteroid State at each epoch
asteroidState = zeros(length(arrivalTimes), length(initialEarthState)); 
for i = 1: length(arrivalTimes) 
    asteroidState(i,:) = universalVariablePropagator(initialAsteroidState, (arrivalTimes(i) + waitTime)*PhysicalConstants.JULIAN_DAY, MU); 
end

%% Compute Transfer DV's 
% Initialize square DV matrix for contour plot 
DV_flyby = zeros(arrivalDuration, departureDuration);
DV_rendezvous = zeros(arrivalDuration, departureDuration);
exitList = zeros(arrivalDuration, departureDuration);
for i = 1: length(departureTimes)
    % Specify Departure Epoch 
    departure = initialDeparture + departureTimes(i); 

    for j = 1: length(arrivalTimes)
        % Specify Arrival Epoch 
        arrival = initialArrival + arrivalTimes(j); 

        % Specify Timespan 
        Timespan = seconds(arrival - departure); 

        % Compute terminal velocity vectors using lambert solver 
        [v1, v2, exit] = lambertSolverCurtis(earthState(i,1:3), asteroidState(j,1:3), Timespan, MU, transferType); 
        
        % Compute DV's 
        DV_rendezvous(j,i) = norm(v1 - earthState(i,4:6)) + norm(asteroidState(j,4:6) - v2);
        DV_flyby(j,i) = norm(v1 - earthState(i,4:6)); 
        exitList(j,i) = exit; 

    end

end

%% Filter Data 

% Filter out DV's for Flyby 
idx = find(DV_flyby > 20); 
DV_flyby(idx) = NaN;
% 
% Filter out DV's for Rendezvous
if strcmpi(asteroid, 'Oumuamua')
    iidx = find(DV_rendezvous > 50);
else 
    iidx = find(DV_rendezvous > 60);
end
DV_rendezvous(iidx) = NaN;

%% Plot Solutions 

% Convert Data for Plotting 
departureTimes = departureTimes + initialDeparture;
arrivalTimes = arrivalTimes + waitTime;

figure(1)
surf(departureTimes, arrivalTimes, DV_flyby, 'EdgeColor', 'interp', 'FaceColor','interp')
title(sprintf('%s Flyby', asteroid))
colormap('jet')
cb = colorbar; 
title(cb,'\DeltaV (km/s)', 'Fontweight', 'bold')

xlabel('Departure', 'FontWeight','bold')
ylabel('Time of Flight (days)', 'FontWeight','bold')
view([0 90])

% Plot Rendezvous
figure(2)
surf(departureTimes, arrivalTimes, DV_rendezvous, 'EdgeColor', 'interp', 'FaceColor','interp')
title(sprintf(' %s Rendezvous', asteroid))
colormap('jet')
cb = colorbar; 
title(cb,'\DeltaV (km/s)', 'Fontweight', 'bold')

xlabel('Departure', 'FontWeight','bold')
ylabel('Time of Flight (days)', 'FontWeight','bold')
view([0 90])


%% Output Runtime 
runtime = toc; 
fprintf('Program Runtime: %f s \n', runtime)





 


