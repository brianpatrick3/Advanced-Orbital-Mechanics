%%% This file downloads the MICE toolkit necessary for running
%%% the 502 homework code 

 % Get local path
    localPath = pwd;

    % Get script path
    currentFile = mfilename('fullpath');
    currentPath = fileparts( currentFile );
    externalFolder = fullfile(currentPath, '..', 'external');

% Create output folder
    if ~isfolder(externalFolder)
        mkdir(externalFolder)
    end

    % Add folders to search path
    startup()

    % Create websave options
    options = weboptions('CertificateFilename', getenv("SSL_CERTIFICATE_PATH"));

    if ismac
        % Download mice archive
        miceDownloadPath = fullfile(externalFolder, 'mice.tar.Z');
        url = 'https://naif.jpl.nasa.gov/pub/naif/toolkit//MATLAB/MacIntel_OSX_AppleC_MATLAB9.x_64bit/packages/mice.tar.Z';
        websave(miceDownloadPath, url, options);
        
        % Download mice installation script
        scriptDownloadPath = fullfile(externalFolder, 'importMice.csh');
        url = 'https://naif.jpl.nasa.gov/pub/naif/toolkit//MATLAB/MacIntel_OSX_AppleC_MATLAB9.x_64bit/packages/importMice.csh';
        websave(scriptDownloadPath, url, options);
        
        % Run installation script
        cd(externalFolder)
        system('chmod +x importMice.csh');
        system('./importMice.csh');
        delete('mice.tar', 'importMice.csh');
        cd(localPath)

        % Delete downloaded files
%         delete(miceDownloadPath)
%         delete(scriptDownloadPath)

    elseif isunix
        % Download mice archive
        miceDownloadPath = fullfile(externalFolder, 'mice.tar.Z');
        url = 'https://naif.jpl.nasa.gov/pub/naif/toolkit//MATLAB/PC_Linux_GCC_MATLAB9.x_64bit/packages/mice.tar.Z';
        websave(miceDownloadPath, url, options);
        
        % Download mice installation script
        scriptDownloadPath = fullfile(externalFolder, 'importMice.csh');
        url = 'https://naif.jpl.nasa.gov/pub/naif/toolkit//MATLAB/PC_Linux_GCC_MATLAB9.x_64bit/packages/importMice.csh';
        websave(scriptDownloadPath, url, options);
        
        % Run installation script
        cd(externalFolder)
        system('chmod +x importMice.csh');
        system('./importMice.csh');
        delete('mice.tar', 'importMice.csh');
        cd(localPath)

    elseif ispc
        % Download mice archive
        downloadPath = fullfile(externalFolder, 'mice.zip');
        url = 'https://naif.jpl.nasa.gov/pub/naif/toolkit//MATLAB/PC_Windows_VisualC_MATLAB9.x_64bit/packages/mice.zip';
        websave(downloadPath, url, options);
        
        % Unzip archive
        unzip(downloadPath, externalFolder)
        delete(downloadPath)

    else
        disp('Platform not supported')
    end


    