function [stateKeplerian] = convertCartesianToKeplerian(stateCartesian, epochs, gravitationalParameter) 
    
    % Compute Angular Momentum vector and magnitude at each epoch 
    position = stateCartesian(1:3,:);
    positionMagnitude = vecnorm(position); 
    velocity = stateCartesian(4:6,:); 
    velocityMagnitude = vecnorm(velocity); 
    angularMomentum = cross(position, velocity); 
    angularMomentumMagnitude = vecnorm(angularMomentum); 

    % call cspice_oscelt to obtain osculating Keplerian elements from Cartesian state
    stateKeplerianSPICE = cspice_oscelt(stateCartesian, epochs, gravitationalParameter);
    
    %% Compute keplerian elements at each epoch 
    stateKeplerian = zeros(6, size(stateKeplerianSPICE,2)); 
    for i = 1:size(stateKeplerianSPICE,2) 
    % Unpack relevant osculating elements
    perifocalDistance = stateKeplerianSPICE(1,i);
    eccentricity = stateKeplerianSPICE(2,i); 
    inclination = stateKeplerianSPICE(3,i);
    RAAN = stateKeplerianSPICE(4,i); 
    argumentOfPeriapse = stateKeplerianSPICE(5,i); 
   
    % Compute semimajor Axis 
    semimajorAxis = perifocalDistance/(1-eccentricity);

    % Compute True Anomaly from polar equation of conic sections 
    rhs = (angularMomentumMagnitude(i)^2/(gravitationalParameter*positionMagnitude(i)) - 1)/eccentricity; 
    trueAnomaly = acos(rhs); 
    
    % Check quadrant for correct sign of true anomaly 
    Phi = acosd(dot(position(:,i), velocity(:,i))/(positionMagnitude(i)*velocityMagnitude(i)));
    if Phi > 90 
        trueAnomaly = trueAnomaly*(-1); 
    end 

    % Combine keplerian state vector 
    stateKeplerian(:,i) = [semimajorAxis, eccentricity, inclination, RAAN, argumentOfPeriapse, trueAnomaly]'; 
    end
end