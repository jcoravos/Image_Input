%% Configuration script for generating InputStruct
    %This structure includes all of the variables needed to extract and
    %interpret Edge data. It is designed to build the input for the
    %function, LoadEdgeDataFun.m.
    
    %IMPORTANT: In order for this workflow to succeed, all the original tif
    %image sequence files must be organized in the standard format, such
    %that if the Root directory is
    %/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/
    
    %the membrane directory is 
    %'/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/Image5_011113/Membranes/Raw/'
    %
    %and the Rok or Myosin directory is 
    %'/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/Image1_011113/Myosin/
    
%% Suggested Workflow
    %Populate Input for all Edged movies to be analyzed, and
    %save these Input structures as "InputStruct_Filename"
    %Next, feed all InputStruct into LoadEdgeDataFun, which will return an
    %output structure. This output structure contains the following
    %information:
        % micron based measurements of centroid, vertex, and perimeter 
    %     Centy: {48x55 cell}          
    %        Centx: {48x55 cell}
    %        Verty: {48x55 cell}
    %        Vertx: {48x55 cell}
    %         Area: [48x55 double]
    %        Perim: {48x55 cell}
    %       SigInt: {48x55 cell}  per cell signal intensity
    %    frame_num: 48     number of frames (time points)
    %     cell_num: 55     number of cells (including imperfect tracks)
    %    Centy_pix: {48x55 cell}   pixel-converted measurements
    %    Centx_pix: {48x55 cell}
    %    Verty_pix: {48x55 cell}
    %    Vertx_pix: {48x55 cell}
    %    Perim_pix: {48x55 cell}
    %membranestack: [545x1064x48 uint8]  membrane movie
    %       signal: [545x1064x48 uint8]  signal movie
    
%% Input
    % Fill in these fields with the relevant information. Leave unused channels blank.
    %NOTE: The .injection field is not necessary to populate if your movie 
    %does not contain a live perturbation.
    
I.timestep      = 1; %any number if not applicable
I.xy            = 0.10; 
I.z             = 1;
I.zslice        = 8; %the image slice you want keep
I.Filename      = '130614_RoksqhMBS_cont3';
I.signalchannel1 = 1;
I.sig1dir = 'RokProj'
I.signalchannel2 = 2;
I.sig2dir = 'MBSProj'
I.signalchannel3 = 3;
I.sig3dir = 'MyosinProj'
I.memchannel = 3;
I.memdir = 'CellsProj'
I.Root          = '/Users/jcoravos/Documents/MATLAB/Eesh/';
I.edgedslice    = 1;
I.injection     = 1; %this should be NaN if there is no live perturbation

%% Store data in separate cells of the structure named structure

I(1) = I; %change this number each time.
