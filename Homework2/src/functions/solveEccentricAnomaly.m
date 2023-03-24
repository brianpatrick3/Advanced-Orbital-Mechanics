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
