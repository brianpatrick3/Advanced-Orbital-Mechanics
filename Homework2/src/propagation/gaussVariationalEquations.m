function [stateDerivative] = gaussVariationalEquations(time, state, perturbations, centralBody)
    
    % Unpack Inputs 
    [a, e, i, RAAN, w, f] = deal(state(1), state(2), state(3), state(4), state(5), state(6)); 
    
    % Call Characteristics of Central Body 
    if strcmpi(centralBody, 'EARTH')
        mu = GravitationalParameter.EARTH; 
        R = CelestialBodyConstants.EARTH_RADIUS;
        J2 = 0.00108263;
    end 

    % Compute Common Terms 
    h = sqrt(mu*a*(1-e^2)); % Angular Momentum 
    n = sqrt(mu/a^3); % Mean Motion 
    p = a*(1-e^2); % Semi-Latus Rectum
    r = p/(1 + e*cos(f)); % Radial Distance
    C1 = sqrt(1-e^2); % Common Coefficient
    u = w + f; 
    alpha = sin(i)*sin(u); 

    % Compute Perturbing Acceleration from J2 in RSW Frame 
    if isfield(perturbations, 'J2') 
        % Evaluate Legendre Polynomial and its first Derivative 
        P2eval = legendre(2,alpha); 
        P2 = P2eval(1); % 1st element is the fn value for P(alpha) 
        dP2 = P2eval(2); % 2nd element is the first derivative of P at alpha
        
        % Compute Acceleration Components 
        Fr = mu/r^2*(J2*(3)*(R/r)^2*P2);
        Fs = -mu/r^2*sin(i)*cos(i)*(J2*(R/r)^2*dP2); 
        Fw = -mu/r^2*cos(i)*(J2*(R/r)^2*dP2);
    else 
        Fr = 0; Fs = 0; Fw = 0; 
    end 
   
    % Compute State Derivatives
    dadt = 2/(n*C1)*(e*sin(f)*Fr + p/r*Fs); % SMA Rate of Change
    dndt = -3/(2*a)*n*dadt; % Mean Motion Rate of Change  
    dedt = C1/(n*a)*(sin(f)*Fr + (cos(f) + (e + cos(f))/(1 + e*cos(f)))*Fs); % Eccentricity Rate of Change 
    didt = r*cos(u)/(n*a^2*C1)*Fw; % Inclination Rate of Change
    dRdt = r*sin(u)/(n*a^2*C1*sin(i))*Fw; % RAAN Rate of Change 
    dwdt = C1/(n*a*e)*(-cos(f)*Fr + sin(f)*(1 + r/p)*Fs) - r*cot(i)*sin(u)/h*Fw; % Arg of Perigee Rate of Change 
    dMdt = 1/(n*a^2*e)*((p*cos(f) - 2*e*r)*Fr - (p + r)*sin(f)*Fs) - dndt*time; % Mean Anomaly Rate of Change
    dvdt = h/r^2 + 1/(e*h)*(p*cos(f))*Fr - (p + r)*sin(f)*Fs; % True Anomaly Rate of Change 

    % Build Output 
    stateDerivative = [dadt, dedt, didt, dRdt, dwdt, dMdt]'; 
end
