classdef CelestialBodyConstants
   properties (Constant)
        EARTH_RADIUS = 6378.1366
        MOON_RADIUS = 1737.4
        SUN_RADIUS = 696000
        SUN_TEMPERATURE_AT_SURFACE = 5777
        SUN_SOLAR_FLUX_AT_SURFACE = PhysicalConstants.STEFAN_BOLTZMANN_CONSTANT*(CelestialBodyConstants.SUN_TEMPERATURE_AT_SURFACE)^4
   end
end