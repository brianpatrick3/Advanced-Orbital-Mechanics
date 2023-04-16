function [stateCartesian] = convertKeplerianToCartesian_meanAnomaly(stateKeplerian, epoch, gravitationalParameter)  

% Unpack Keplerian State
semimajorAxis = stateKeplerian(1); 
eccentricity = stateKeplerian(2); 
inclination = stateKeplerian(3); 
RAAN = stateKeplerian(4); 
argumentOfPeriapse = stateKeplerian(5); 
meanAnomaly = stateKeplerian(6); 
perifocalDistance = semimajorAxis*(1-eccentricity);  

% Orbital Elements input for cspice_conics 
SPICEorbitalElements = [perifocalDistance, eccentricity, inclination, RAAN, argumentOfPeriapse, meanAnomaly, epoch, gravitationalParameter]';

% Call cspice conics to obtain Cartesian state 
stateCartesian = cspice_conics(SPICEorbitalElements, epoch); 

end