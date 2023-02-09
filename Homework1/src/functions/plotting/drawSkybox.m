function [] = drawSkybox(figureHandle)

    % Open figure
    if nargin == 0
        figureHandle = gcf;
    end

    % Set current figure
    set(0, 'CurrentFigure', figureHandle)

    % This creates the 'background' axes
    ha = axes('units','normalized', 'position', [0 0 1 1]);
    
    % Move the background axes to the bottom
    uistack(ha,'bottom');
    
    % Get current path
    currentFile = mfilename('fullpath');
    [currentPath] = fileparts( currentFile );

    % Load in a background image and display it using the correct colors
    texturePath = fullfile(currentPath, '..', '..', '..', 'assets', 'textures', 'galaxy.jpg');
    texture = imread(texturePath);
    %background = imagesc(texture);
    
    % Turn the handlevisibility off so that we don't inadvertently plot into the axes again
    % Also, make the axes invisible
    set(ha,  'handlevisibility', 'off',  'visible', 'off')
    %set(background, 'alphadata', .9)
end