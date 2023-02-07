function [S, C] = stumpffFunctions(z) 
    % Compute the sign of z
    check = sign(z); 

    % Common Terms 
    sqrtz = sqrt(z);
    sqrtNegz = sqrt(-z); 

    % Compute S and C 
    if check > 0 
        S = (sqrtz - sin(sqrtz))/(sqrtz^3); 
        C = (1 - cos(sqrtz))/z; 
    elseif check < 0 
        S = (sinh(sqrtNegz) - sqrtNegz)/(sqrtNegz^3); 
        C = (cosh(sqrtNegz) - 1)/(-z); 
    elseif check == 0 
        S = 1/6; 
        C = 1/2; 
    end
end
