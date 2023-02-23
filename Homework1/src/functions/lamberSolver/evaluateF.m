function F = evaluateF(z,r1mag, r2mag, A, dt, mu)
    % Compute C and S
    [S,C] = stumpffFunctions(z);
    
    % Compute y(z) 
    y = r1mag + r2mag + A*(z*S - 1)/sqrt(C);

    % Form function to find the root of: F(z) 
    F = (y/C)^(3/2)*S + A*sqrt(y) - sqrt(mu)*dt;
end