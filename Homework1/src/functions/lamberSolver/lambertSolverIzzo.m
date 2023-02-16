function [terminalVelocityVectors] = lambertSolverIzzo(body1Position, body2Position, timeOfFlight, gravitationalParameter)
    
    % Make Assertions
    assert(timeOfFlight > 0, 'Time must be greater than 0')
    assert(gravitationalParameter > 0, 'Gravitational Parameter must be greater than 0')
    
    % Unpack Inputs 
    t = timeOfFlight;
    mu = gravitationalParameter;
    r1 = body1Position;
    r2 = body2Position; 
    r1mag = norm(r1); 
    r2mag = norm(r2); 
    
    % Compute Chord
    c = r2 - r1; 
    cmag = norm(c);
    
    % Compute the Semiparameter    
    s = 1/2*(r1mag + r2mag + cmag); 
    
    % Compute Unit Vectors 
    i_r1 = r1/r1mag; 
    i_r2 = r2/r2mag; 
    i_h = cross(i_r1, i_r2); % Angular Momentum Unit Vector 
    
    % Compute Lambda 
    lambdaSquared = 1-cmag/s;
    lambda = sqrt(lambdaSquared); 
    
    % Check
    r11 = r1(1); r12 = r1(2); r21 = r2(1); r22 = r2(2); % get x and y coordinates of the position vectors
    if (r11*r22 - r12*r21) < 0 
        lambda = -lambda; 
        i_t1 = cross(i_r1, i_h); 
        it_2 = cross(i_r2, i_r2); 
    else 
        it_1 = cross(i_h, i_r1); 
        it_2 = cross(i_h, i_h); 
    end 
    
    % Compute T 
    T = sqrt(2*mu/s^3)*t; 
    
    % Find the x and y values 
    [xlist,ylist] = findxy(lambda, T); 
    
    % Common Terms
    gamma = sqrt(mu*s/2); 
    rho = (r1-r2)/cmag; 
    sigma = sqrt(1-rho^2); 
    
    % Compute Terminal Velocity Vectors 
    terminalVelocityVectors = cell(1,length(xlist)); 
    for i = 1:length(xlist)
        V_r1 = gamma*((lambda*y(i) - x(i)) - rho*(lambda*y(i) + x(i)))/r1; 
        V_r2 = -gamma*((lambda*y(i) - x(i)) + rho*(lambda*y(i) + x(i)))/r2;
        V_t1 = gamma*sigma*(y(i) + lambda*x(i))/r1; 
        V_t2 = gamma*sigma*(y(i) + lambda*x(i))/r2;
        
        % Compute Terminal Velocity Vectors
        v1 = V_r1*i_r1 + V_t1*i_t1; 
        v2 = V_r2*i_r2 + V_t2*i_t2;
    
        % Build Output 
        terminalVelocityVectors{i} = [v1;v2]; 
    end 

end