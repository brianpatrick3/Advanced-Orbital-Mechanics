function et = str2et_c(string)
    if coder.target('MATLAB')
        furnsh_c(Ephemeris.NAIF0012)
        et = cspice_str2et(string);
        unload_c(Ephemeris.NAIF0012)
    else
        % Include header
        coder.cinclude('SpiceUsr.h')

        % Load kernels
        et = 0;
        coder.ceval('str2et_c', cstring(string), coder.wref(et));

        % Check for errors
        if failed_c()
            message = getmsg_c();
            reset_c();
            error(message)
        end
    end
end