%%%% TESTING THE LAMBERT SOLVER - CURTIS FORMULATION 
close all; clear; clc; 
%% SETUP 

% Constants; 
LU = CelestialBodyConstants.EARTH_RADIUS; 
MU = GravitationalParameter.EARTH;
dt = 3600; 
orbitType = 'retrograde'; 

r1 = [5000, 10000, 2100]; 
r2 = [-14600, 2500, 7000]; 

[v1, v2] = lambertSolverCurtis(r1, r2, dt, MU, orbitType)
