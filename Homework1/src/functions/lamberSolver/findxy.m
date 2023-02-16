function [xlist,ylist] = findxy(lambda, T) 

    assert(abs(lambda) < 1, 'Absolute value of lambda must be < 1') 
    assert(T < 0, 'T must be < 0') 
    
    Mmax = floor(T/pi); 
    T_inf = arccos(lambda) + lambda*sqrt(1 - lambda^2); 
    
    if T < T_inf + Mmas*pi && Mmax > 0 
     % START HALLEY ITERATIONS FROM X = 0, T = T0 AND FIND Tmin(Mmax) 
        if Tmin > T 
            Mmax = Mmax - 1; 
        end
    end 
    T1 = 2/3*(1 - lambda^3);

    % COMPUTE X0 FROM EQUATION 30
    X0 = getX0(T0, T1, T); 
    
    % START HOUSHOLDER ITERATIONS FROM X0 AND FIND X,Y 
    while Mmax > 0 
        % COMPUTE X0l and X0r FROM EQ 31 with M = Mmax 
        X0l = (((Mmax*pi + pi)/(8*T))^(2/3) - 1) / (((Mmax*pi + pi)/(8*T))^(2/3)) + 1; 
        X0r = ((8*T/(Mmax*pi))^(2/3) - 1) / (((8*T/(Mmax*pi))^(2/3) + 1)) + 1; 

        % START HOUSEHOLDER ITERATIONS FROM X0l and find xr, yr 
        % START HOUSEHOLDER ITERATIONS FROM X0r and find xl,yl
        
        Mmax = Mmax - 1; 
    end 
    
%% Helper Functions

    % Compute X0 (Equation 30)
    function X0 = getX0(T0, T1, T)
        if T>= T0 
            X0 = (T0/T)^(2/3) - 1;
        elseif  T<T1 
            X0 = 2*(T1/T) - 1; 
        elseif (T1 < T) && (T < T0) 
            X0 = (T0/T)^(log2(T1/T0)) - 1; 
        end
    end

end