function spiceKernelFolder = getEphemerisFolder()
    currentFile = mfilename('fullpath');
    currentPath = fileparts( currentFile );
    spiceKernelFolder = [fullfile(currentPath, '..', '..', 'external', 'kernels') filesep];
    if ~isfolder(spiceKernelFolder)
        error('SPICE kernel folder not found')
    end
end