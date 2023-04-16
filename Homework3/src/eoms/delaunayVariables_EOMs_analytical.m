function [stateDerivative] = delaunayVariables_EOMs_analytical(~, state)  

    % Unpack State 
    [L,G,H,l,g,h] = deal(state(1), state(2), state(3), state(4), state(5), state(6)); 

    % Compute Derivatives 
    stateDerivative(1:3) = 0; 
    stateDerivative(4) = 1/(2*L^2); 
    stateDerivative(5:6) = 0; 

    % Assign output 
    stateDerivative = stateDerivative'; 
end