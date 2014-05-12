function [ O ] = LoadEdgeDataFun(I,type)
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
             
        %type is either 1 if the image is a still, or 2 if the image is a
        %movie.
%% Extracting Image-specific Data from InputStruct
timestep = I.timestep;
xydim = I.z; %this is the xy dimension from the metadata, where xydim = microns/pixel. This number needs to be the same as was used in 
                %Edge, which can be verified by looking at the .csv file in Matlab/EDGE-1.06/
    conv_fact = (1/xydim); % pixels/micron
if I.zslice < 10
    zkeep = strcat('_z00',num2str(I.zslice)); %zslice to keep
else 
    zkeep = strcat('_z0',num2str(I.zlice));
end

memchannel = strcat('_c00',num2str(I.memchannel));
signalchannel = strcat('_c00',num2str(I.signalchannel)); %Rok (or other signal) channel

%% File Names
rokfileRoot = strcat(I.Root,I.Filename,'/Myosin/',I.Filename,'_t');
membraneRoot = strcat(I.Root,I.Filename,'/Membranes/Raw/', I.Filename,'_t') ;%make this the file used for Edge membrane segmentation
measdir = strcat(I.Root,I.Filename,'/Measurements/');
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
    
    slice = I.edgedslice; %IMPORTANT. This specifies that the appropriate slice of data is drawn from the Edge data set.
    
Centy = load(strcat(measdir,measCenty));
    O.Centy = squeeze(Centy.data(:,slice ,:));
    
Centx = load(strcat(measdir,measCentx));
    O.Centx = squeeze(Centx.data(:,slice,:));
   
Verty = load(strcat(measdir,measVerty));
    O.Verty = squeeze(Verty.data(:,slice,:));
   
Vertx = load(strcat(measdir,measVertx));
    O.Vertx = squeeze(Vertx.data(:,slice,:));
   
Area = load(strcat(measdir,measArea));
     O.Area = squeeze(cell2mat(Area.data(:,slice,:)));
     
Perim = load(strcat(measdir,measPerim));
    O.Perim = squeeze(Perim.data(:,slice,:));
   
SigInt = load(strcat(measdir,myoInt));
    O.SigInt = squeeze(cell2mat(SigInt.data(:,slice,:)));
    
O.SigInt_areanorm = O.SigInt./O.Area; %generates an area-normalized signal intensity

    
%% Determine framenum and cellnum
switch type
    case 1
        O.frame_num = 1
        O.cell_num = length(O.Area)
    case 2
        [frame_num,cell_num] = size(O.Area);
        O.frame_num = frame_num;
        O.cell_num = cell_num;
end
%% Convert from microns to pixels
    % all the above cells are in microns. Multiply each cell by the
    % conversion factor (above) to convert to pixels
    O.Centy_pix = gmultiply(O.Centy,conv_fact);
    O.Centx_pix = gmultiply(O.Centx,conv_fact);
    O.Verty_pix = gmultiply(O.Verty,conv_fact);
    O.Vertx_pix = gmultiply(O.Vertx,conv_fact);
    O.Perim_pix = gmultiply(O.Perim,conv_fact);

%% Load Membrane and Rok movie
    %loads tif image sequences from Edge analysis into time stacks (3d) 
%imread(strcat(membraneRoot,'001_z005_c002.tif'));   %declaring membranestack matrix
%[m,n] = size(ans); %this size is in pixels, not microns
%membranestack = zeros(m,n,frame_num); %x position is frame 
%rokstack = zeros(m,n,frame_num);

switch type
    case 1
        membranestack(:,:,1) = imread(mem_file);
        signalstack1(:,:,1) = imread(
        
    case 2

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
        

end

O.membranestack = membranestack
O.signal = rokstack

    
end


