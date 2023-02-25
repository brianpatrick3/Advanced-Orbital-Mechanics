function [v1, v2, exit] = lambertSolverCurtis(initialPosition, finalPosition, timeOfFlight, gravitationalParameter, transferType)

    assert(strcmpi(transferType, 'prograde') || strcmpi(transferType, 'retrograde'), 'transferType should be either "prograde" or "retrograde"'); 
    
    % Unpack Inputs 
    r1 = initialPosition; r1mag = norm(r1); 
    r2 = finalPosition; r2mag = norm(r2); 
    dt = timeOfFlight; 
    mu = gravitationalParameter; 
    
    % Compute Angular Momentum 
    h = cross(r1, r2); h_k = h(3); 
    
    % Compute theta 
    switch transferType 
        case 'prograde'
            if h_k >= 0 
                theta = acos(dot(r1,r2)/(r1mag*r2mag)); 
            else 
                theta = 2*pi - acos(dot(r1,r2)/(r1mag*r2mag)); 
            end 
        case 'retrograde'
            if h_k < 0 
                theta = acos(dot(r1,r2)/(r1mag*r2mag)); 
            else 
                theta = 2*pi - acos(dot(r1,r2)/(r1mag*r2mag)); 
            end 
    end 

    %% TOF Check 

    % Compute Chord 
    c = sqrt(r1mag^2 + r2mag^2 - 2*r1mag*r2mag*cos(theta)); 

    % Compute SemiParameter
    s = (r1mag + r2mag + c)/2; 

    % Compute minimum TOF transfer 
    Tmin = sqrt(2)/3/sqrt(mu)*(s^(3/2) - sign(sin(theta))*(s-c)^(3/2));

%     if dt < Tmin
%         v1 = NaN*ones(1,3); v2 = NaN*ones(1,3);
%         exit = 2; % Output flag to denote that dt < Tmin 
%         return 
%     end

    if dt < 0
        v1 = NaN*ones(1,3); v2 = NaN*ones(1,3);
        exit = 2; % Output flag to denote that dt < Tmin 
        return 
    end

    %% CONTINUE 
    % Compute A  
    A = sin(theta)*sqrt((r1mag*r2mag)/(1-cos(theta))); 
    
    % Initialize newtonMethod 
    initialGuess = 0; % From Curtis pg. 207
    eval = 0; 
    tolerance = 1e-10; 

    % Compute Better Initial Guess 
    while eval <= 0 
        eval = evaluateF(initialGuess,r1mag, r2mag, A,dt,mu);
        initialGuess = initialGuess + 0.1;
    end

%% REMOVE AFTER USE
% z = 0:.00001:10; 
% for i = 1:length(z) 
%     eval(i) = evaluateF(z(i), r1mag, r2mag, A, dt, mu); 
% end
% 
% xx = sign(eval); 
% idx = find(xx == 1, 1, 'first');
% 
% figure()
% hold on 
% grid minor 
% plot(z, eval, 'LineWidth', 2) 
% plot(z(idx),eval(idx), 'k.', 'MarkerSize',40, 'LineWidth', 2) 
% plot([min(xlim()),max(xlim())],[0,0], 'k--', 'LineWidth', 1.2)
% xlabel('z', Interpreter='latex') 
% ylabel('F(z)', Interpreter='latex')
% set(findall(gca, '-property', 'fontsize'), 'fontsize', 16)


%%

    % Compute z using newtonMethod
    [z, y, C, S, exit] = newtonMethod(A, dt, mu, r1mag, r2mag, initialGuess, tolerance);

    if exit == 1 
        v1 = NaN*ones(1,3); v2 = NaN*ones(1,3);
        exit = 1; 
        return  
    end
    
    % Compute the Lagrange Coefficients: f(z) and g(z) 
    f = 1 - y/r1mag; 
    g = A*sqrt(y/mu); 
    
    % Compute fdot(z) and gdot(z) 
    fdot = sqrt(mu)/r1mag/r2mag*sqrt(y/C)*(z*S - 1); % NOT USED IN V2 SIMPLIFIED FORM, COULD DELETE IF WANTED
    gdot = 1 - y/r2mag; 
    
    % Compute the Terminal Velocity Vectors 
    v1 = 1/g*(r2 - f*r1); 
    v2 = 1/g*(gdot*r2 - r1); 
    
    %% Helper Function
    function [z, y, C, S, exit] = newtonMethod(A, dt, mu, r1mag, r2mag, initialGuess, tolerance) 
        
        % Initialize counter and exit statement
        counter = 0; 
        exit = 0; 

        % Initialize z and ratio 
        z = initialGuess;
        ratio = 1; 
        
        while abs(ratio) > tolerance

            % Update Counter 
            counter = counter + 1; 

            % Compute C and S
            [S,C] = stumpffFunctions(z); 
    
            % Compute y(z) 
            y = r1mag + r2mag + A*(z*S - 1)/sqrt(C);

            % Form function to find the root of: F(z) 
            F = (y/C)^(3/2)*S + A*sqrt(y) - sqrt(mu)*dt;

            % Compute Derivative of F: F'(z) 
            if z == 0
                dF = sqrt(2)/40*y^(3/2) + A/8*(sqrt(y) + A*sqrt(1/(2*y))); 
            else 
                dF = (y/C)^(3/2)*(1/(2*z)*(C - 3*S/(2*C)) + 3*S^2/(4*C)) + A/8*(3*S/C*sqrt(y) + A*sqrt(C/y)); 
            end

            % Update value of z
            ratio = F/dF; 
            z = z - ratio;
            
            % Stop solver if greater than 10 iterations reached 
            if counter > 10000
                exit = 1;
                break 
            end 
        end 
    end

end