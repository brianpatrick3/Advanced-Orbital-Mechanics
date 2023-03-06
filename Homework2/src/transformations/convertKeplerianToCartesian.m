function [stateCartesian] = convertKeplerianToCartesian(stateKeplerian, epoch, gravitationalParameter)  

% Unpack Keplerian State
semimajorAxis = stateKeplerian(1); 
eccentricity = stateKeplerian(2); 
inclination = stateKeplerian(3); 
RAAN = stateKeplerian(4); 
argumentOfPeriapse = stateKeplerian(5); 
trueAnomaly = stateKeplerian(6); 
perifocalDistance = semimajorAxis*(1-eccentricity); 

% Compute Eccentric Anomaly from True Anomaly
eccentricAnomaly = 2*atan(sqrt((1-eccentricity)/(1+eccentricity))*tan(trueAnomaly/2)); 

% Solve Kepler's equation for Mean anomaly
meanAnomaly = eccentricAnomaly - eccentricity*sin(eccentricAnomaly); 

% Orbital Elements input for cspice_conics 
SPICEorbitalElements = [perifocalDistance, eccentricity, inclination, RAAN, argumentOfPeriapse, meanAnomaly, epoch, gravitationalParameter]';

% Call cspice conics to obtain Cartesian state 
stateCartesian = cspice_conics(SPICEorbitalElements, epoch); 

end