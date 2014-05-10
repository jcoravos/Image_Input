%% Master Script for Edge Data Import and Analysis
    %follow these directions for using the scripts in this package
    
%% 1. Open LoadEdgeDataConfig.m
    % Open this script, read the directions, and provide the requested
    % information to generate the Input structure
    
%% 2. Generate Output Function
    %You will have to change the names of the Input and Output structures

Output_Image1_011113 = LoadEdgeDataFun(Input_Image1_011113);

%% 3. Generate average area plot

handle = area_plot(Input_Image1_011113,Output_Image1_011113,70,'Image1_011113')