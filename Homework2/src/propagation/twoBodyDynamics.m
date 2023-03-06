function [statePerturbation] = twoBodyDynamics(~,state,mu)

r = norm(state(1:3));
statePerturbation = [state(4); ...
                     state(5); ...
                     state(6); ...
                     -(mu*state(1)/r^3) 
                     -(mu*state(2)/r^3) 
                     -(mu*state(3)/r^3)] ;
 
end 