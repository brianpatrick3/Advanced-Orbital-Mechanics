function figureHandle = drawPlanet(body, position, radius, figureHandle, numberOfPoints)
  
    % Check input arguments
    switch nargin
        case 1
            position = [0; 0; 0];
            radius = 1;
            figureHandle = gcf;
            numberOfPoints = 500;
        case 2
            radius = 1;
            figureHandle = gcf;
            numberOfPoints = 500;
        case 3
            figureHandle = gcf;
            numberOfPoints = 500;
        case 4
            numberOfPoints = 500;
    end

    % Set current figure
    set(0, 'CurrentFigure', figureHandle)

    % Get current path
    currentFile = mfilename('fullpath');
    [currentPath] = fileparts( currentFile );

    % Fetch texture
    bodyName = lower(string(body));
    texturePath = fullfile(currentPath, '..', '..', '..', 'assets', 'textures', bodyName + ".jpg");
    colorData = imread(texturePath);

    % Draw planet
    [X, Y, Z] = sphere(numberOfPoints); 
    x = radius*X + position(1);
    y = radius*Y + position(2);
    z = radius*Z + position(3);
    surface(x, y, z, 'FaceColor','texturemap', 'EdgeColor','none', 'cdata', flipud(colorData))

    % If body is Saturn, draw rings
    if contains(texturePath, 'saturn')
        [r, t] = meshgrid(linspace(radius*92000/71398, radius*226000/71398, numberOfPoints), linspace(0, 2*pi, numberOfPoints));
        x = r.*cos(t);
        y = r.*sin(t);
        z = 0*x;
        texturePath = fullfile(currentPath, '..', '..', '..', 'assets', 'textures', 'saturn_rings.png');
        colorData = imread(texturePath);
        surface(x, y, z, 'FaceColor','texturemap', 'EdgeColor','none', 'cdata', flipud(colorData), 'Facealpha', 0.9)
    end
end