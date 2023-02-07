function [universalAnomaly, S, C] = solveUniversalAnomaly(r0, v_r0, timespan, alpha, mu, tolerance)
    
    % Universal Anomaly initial guess 
    X0 = sqrt(mu)*abs(alpha)*timespan;

    % Newton's Method -- Solve for Universal Anomaly
    done = false; 
    while ~ done
        % Compute z 
        z = alpha*X0^2; 
    
        % Compute S and C from Stumpff Functions 
        [S, C] = stumpffFunctions(z); 
        
        % Function to find root of
        f = r0 * v_r0/sqrt(mu) * X0^2 * C + (1 - alpha * r0) * X0^3 * S + r0 * X0 - sqrt(mu) * timespan; 
        df = r0 * v_r0/sqrt(mu) * X0 * (1 - alpha * X0^2 * S) + (1 - alpha * r0) * X0^2 * C + r0; 
    
        % Compute Ratio 
        ratio = f/df;
        
        % Check stopping criterion
        done = abs(ratio) < tolerance; 
        
        if ~ done 
            % Update Chi 
            X0 = X0 - ratio;
        else 
            universalAnomaly = X0; 
            break 
        end
      
    end
end