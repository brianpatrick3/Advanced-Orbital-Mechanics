function [finalState] = universalVariablePropagator(initialState, timespan, mu) 

% Unpack State
initialPos = initialState(1:3); 
initialVel = initialState(4:6); 

% Compute position and velocity norms 
posNorm = norm(initialPos); 
velNorm = norm(initialVel);
v_r0 = dot(initialPos, initialVel)/posNorm; 

% Compute variables 
alpha = 2/posNorm - velNorm^2/mu; % alpha = 1/semimajorAxis (sign of alpha determines type of orbit -- Elliptical, Parabolic, Hyperbolic) % 

% Solve for Universal Anomaly (and output S and C from Stumpff Functions)
[chi, S, C] = solveUniversalAnomaly(posNorm, v_r0, timespan, alpha, mu, 1e-3); 

% Compute f function
f = 1 - chi^2/posNorm * C;  
g = timespan - 1/sqrt(mu) * chi^3 * S; 

% Compute position 
r = f*initialPos + g*initialVel; 
rmag = norm(r); 

% Compute fdot and gdot 
fdot = sqrt(mu)/(rmag*posNorm) * (alpha * chi^3 * S - chi);  
gdot = 1 - chi^2/rmag * C; 

% Compute position and velocity 
position = initialPos*f + initialVel*g; 
velocity = initialPos*fdot + initialVel*gdot; 

% Build finalState
finalState = [position, velocity]; 

end