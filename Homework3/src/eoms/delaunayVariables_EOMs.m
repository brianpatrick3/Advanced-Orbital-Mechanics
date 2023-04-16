function [stateDerivative] = delaunayVariables_EOMs(~, state, frameRotation)  

    % Unpack State 
    [L,G,H,l,g,h] = deal(state(1), state(2), state(3), state(4), state(5), state(6)); 

    % Compute Derivatives 
    stateDerivative(1:3) = 0; 
    stateDerivative(4) = 1/(L^3); 
    stateDerivative(5) = 0; 
    stateDerivative(6) = frameRotation; 

    % Assign output 
    stateDerivative = stateDerivative'; 
end