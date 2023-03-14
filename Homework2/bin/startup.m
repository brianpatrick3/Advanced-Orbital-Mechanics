%%% File Name: startup.m 
% Written By: Brian Patrick 
% Date Written: 2.6.2023 
% Description: Startup file that should be run before running the main.m
%              script that performs the necessary calculations/work for the
%              assignment. 
%  ========================================================================
function [] = startup()

% Get current path
currentPath = fileparts(mfilename('fullpath'));

% Add folders to search path
addpath(genpath(fullfile(currentPath, '..', '..', 'Homework2')));

end








