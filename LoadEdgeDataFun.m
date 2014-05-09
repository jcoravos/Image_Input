function [ OutputStruct ] = LoadEdgeDataFun(InputStruct)
    %This function takes an input structure where the fields include the
    %following information:
        %timestep: self explanatory (in seconds)
        %xy: the xy pixel resolution, should be the same as was provided to Edge
        %z: z resolution (currently not used -- JSC 5/9/14)
        %zslice: the slice number to keep (just the number, i.e. "5", not "z005"
        %Filename: 'Image1_011113'. Don't include slashes or file suffix
        %memchannel: which number channel. Don't include _c00
        %signalchannel: same, but for Rok or Myosin channel
        %Root: File directory up to 'DATA_GUI/', e.g.
             %'/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/'.
             %Everything following ~/DATA_GUI/' is provided in the script
%% Extracting Image-specific Data from InputStruct
timestep = InputStruct.timestep;
xydim = InputStruct.z; %this is the xy dimension from the metadata, where xydim = microns/pixel. This number needs to be the same as was used in 
                %Edge, which can be verified by looking at the .csv file in Matlab/EDGE-1.06/
    conv_fact = (1/xydim); % pixels/micron
if InputStruct.zslice < 10
    zkeep = strcat('_z00',num2str(InputStruct.zslice)); %zslice to keep
else 
    zkeep = strcat('_z0',num2str(InputStruct.zlice));
end

memchannel = strcat('_c00',num2str(InputStruct.memchannel));
signalchannel = strcat('_c00',num2str(InputStruct.signalchannel)); %Rok (or other signal) channel

%% File Names
rokfileRoot = strcat(InputStruct.Root,InputStruct.Filename,'/Myosin/',InputStruct.Filename,'_t');
membraneRoot = strcat(InputStruct.Root,InputStruct.Filename,'/Membranes/Raw/', InputStruct.Filename,'_t') ;%make this the file used for Edge membrane segmentation
measdir = strcat(InputStruct.Root,InputStruct.Filename,'/Measurements/');
    measCenty = 'Membranes--basic_2d--Centroid-y.mat';
    measCentx = 'Membranes--basic_2d--Centroid-x.mat';
    measVerty = 'Membranes--vertices--Vertex-y.mat';
    measVertx = 'Membranes--vertices--Vertex-x.mat';
    measArea =  'Membranes--basic_2d--Area.mat';
    measPerim = 'Membranes--basic_2d--Perimeter.mat';
    myoInt = 'Myosin--myosin_intensity--Myosin intensity.mat';
    
    
%% Load Measurements
    % this section extracts a single slice (specified by the y coordinate in .data(...).
    % the x coordinate is the cell index, and the y coordinate is time step.
    
    slice = InputStruct.edgedslice; %IMPORTANT. This specifies that the appropriate slice of data is drawn from the Edge data set.
    
Centy = load(strcat(measdir,measCenty));
    OutputStruct.Centy = squeeze(Centy.data(:,slice ,:));
    
Centx = load(strcat(measdir,measCentx));
    OutputStruct.Centx = squeeze(Centx.data(:,slice,:));
   
Verty = load(strcat(measdir,measVerty));
    OutputStruct.Verty = squeeze(Verty.data(:,slice,:));
   
Vertx = load(strcat(measdir,measVertx));
    OutputStruct.Vertx = squeeze(Vertx.data(:,slice,:));
   
Area = load(strcat(measdir,measArea));
     OutputStruct.Area = squeeze(cell2mat(Area.data(:,slice,:)));
     
Perim = load(strcat(measdir,measPerim));
    OutputStruct.Perim = squeeze(Perim.data(:,slice,:));
   
OutputStruct.RokInt = load(strcat(measdir,myoInt));
%% Determine framenum and cellnum
    [frame_num,cell_num] = size(OutputStruct.Area);
OutputStruct.frame_num = frame_num;
OutputStruct.cell_num = cell_num;
%% Convert from microns to pixels
    % all the above cells are in microns. Multiply each cell by the
    % conversion factor (above) to convert to pixels
    OutputStruct.Centy_pix = gmultiply(OutputStruct.Centy,conv_fact);
    OutputStruct.Centx_pix = gmultiply(OutputStruct.Centx,conv_fact);
    OutputStruct.Verty_pix = gmultiply(OutputStruct.Verty,conv_fact);
    OutputStruct.Vertx_pix = gmultiply(OutputStruct.Vertx,conv_fact);
    OutputStruct.Perim_pix = gmultiply(OutputStruct.Perim,conv_fact);

%% Load Membrane and Rok movie
    %loads tif image sequences from Edge analysis into time stacks (3d) 
%imread(strcat(membraneRoot,'001_z005_c002.tif'));   %declaring membranestack matrix
%[m,n] = size(ans); %this size is in pixels, not microns
%membranestack = zeros(m,n,frame_num); %x position is frame 
%rokstack = zeros(m,n,frame_num);

for frame = 1:frame_num;
    if frame < 10
        timestep = strcat('00',num2str(frame));
    else
        timestep = strcat('0',num2str(frame));
    end
    mem_file = strcat(membraneRoot,timestep,zkeep,memchannel,'.tif');
    rok_file = strcat(rokfileRoot, timestep, zkeep,signalchannel,'.tif');
    
    membranestack(:,:,frame) = imread(mem_file);
    rokstack(:,:,frame) = imread(rok_file);

end

OutputStruct.membranestack = membranestack
OutputStruct.rokstack = rokstack

    
end


