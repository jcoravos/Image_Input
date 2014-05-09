%% Script for importing tif image sequence files into matlab
    %This script takes as inputs the file path and the file name of the
    %projections you want to load in. The example here imports three
    %control (HHO) and three experimental (Y27) embryos that have been
    %projected in FIJI using the MIP2 macro. The output of the script is a
    %data structure named for the experimental condition, with a field
    %"raw" for the raw image data. Each imported file gets its own cell.
    %The idea with this structure is that further analysis of the data can
    %be stored in the same structure under different fields. The imported
    %data is stored in a matrix with the following dimensions:
    %xdim, ydim, tdim, zdim. cdim. If the imported image sequence lacks one
    %of the t, z, or c dimensions, the output matrix will omit that
    %dimension. 
    
    %The second data output in the field "datatype" indicates what
    %information is stored in dimensions 3,4, and 5. The number in this
    %field corresponds to the following:
       %datatype = [t,z,c], where t = 1 means that the t dimension exists.
    %see comments in script for more details.
    
    %this script requires the function importprojection.m 


%% Building an array of strings for importprojection input
%Control set of embryos. Include the full file path up to but not including
    %the file name (in this case the file name root and the folder name are the
    %same).
Control_sourcedirs = {'/Volumes/CORAVOS/LSM Microscopy/H2O Injections/SqhCh_+;UbiRokGFP_Dr/MAX_Image1_011514'; 
                  '/Volumes/CORAVOS/LSM Microscopy/H2O Injections/SqhCh_+;UbiRokGFP_Dr/MAX_Image8_011514'; 
                  '/Volumes/CORAVOS/LSM Microscopy/H2O Injections/SqhCh;RokGFP/MAX_Image10_072513'}
              
Control_sourcefiles = {'MAX_Image1_011514';
                  'MAX_Image8_011514';
                  'MAX_Image10_072513';
                  }
Filenum_Control = length(Control_sourcedirs);
              
%Experimental set

Exp_sourcedirs = {'/Volumes/CORAVOS/LSM Microscopy/Y27632 Injection/Live/SqhCh_+;UbiRokGFP_Dr/MAX_Image4_011614';
                 '/Volumes/CORAVOS/LSM Microscopy/Y27632 Injection/Live/SqhCh_+;UbiRokGFP_Dr/MAX_Image7_011614';
                 '/Volumes/CORAVOS/LSM Microscopy/Y27632 Injection/Live/SqhCh_+;UbiRokGFP_Dr/MAX_Image9_011514'
                 }

Exp_sourcefiles = {'MAX_Image4_011614';
                 'MAX_Image7_011614';
                 'MAX_Image9_011514'
                 }
Filenum_Exp = length(Exp_sourcedirs);
             
%% Data Import
    %Using the strings specified above, the function importprojection will
    %import the image sequence files and dump them into data structures in
    %the "raw" field.

for i = 1:Filenum_Control %for loop to repeat the function for each of the files specified above
    control_dir = Control_sourcedirs{i}; %extracts the string contents of the cell
    control_file = Control_sourcefiles{i};
    [Control{i}.raw Control{i}.datatype] = imseq_import(control_dir,control_file); %runs the function and stores the imported sequence
    display(i,'Control') %displays index
    
end

for i = 1:Filenum_Exp
    Exp_dir = Exp_sourcedirs{i};
    Exp_file = Exp_sourcefiles{i};
    [Exp{i}.raw Exp{i}.datatype] = imseq_import(Exp_dir,Exp_file);
    display(i,'Exp')
end

%% ImHist calculation

n = 255 %number of bins for histogram. Max is 255, for 255 pixels
    
Control = imseq_imhist(Control,n)

Exp = imseq_imhist(Exp,n)

%% Appending the attributes field
    %These attributes are specific to this particular dataset. 

Control{1}.attributes(6) = [0.13] %xy resolution
Control{1}.attributes(7) = [0.88] %z slice resolution
Control{1}.attributes(8) = [11.1] %timestep
Control{1}.attributes(9) = [20] %injection frame

Control{2}.attributes(6) = [0.14] %xy resolution
Control{2}.attributes(7) = [0.88] %z slice resolution
Control{2}.attributes(8) = [10.1] %timestep
Control{2}.attributes(9) = [58] %injection frame

Control{3}.attributes(6) = [0.15] %xy resolution
Control{3}.attributes(7) = [1.5] %z slice resolution
Control{3}.attributes(8) = [10.2] %timestep
Control{3}.attributes(9) = [3] %injection frame

Exp{1}.attributes(6) = [0.13] %xy resolution
Exp{1}.attributes(7) = [0.89] %z slice resolution
Exp{1}.attributes(8) = [8.3] %timestep
Exp{1}.attributes(9) = [2] %injection frame

Exp{2}.attributes(6) = [0.12] %xy resolution
Exp{2}.attributes(7) = [0.88] %z slice resolution
Exp{2}.attributes(8) = [9.9] %timestep
Exp{2}.attributes(9) = [2] %injection frame

Exp{3}.attributes(6) = [0.13] %xy resolution
Exp{3}.attributes(7) = [0.89] %z slice resolution
Exp{3}.attributes(8) = [6.9] %timestep
Exp{3}.attributes(9) = [3] %injection frame

%% Determining and Subtracting cytoplasmic signal
   
for i = 1:Filenum_Control
    %Deteriming background by averaging over a roi
    BW_c001 = roipoly(Control{i}.raw(:,:,1,1)); %establish a mask with a user defined ROI
    MaskInt_c001 = BW_c001.*double(Control{i}.raw(:,:,1,1)); %determine the intensity values of the pixels contained under the mask
    BW_c002 = roipoly(Control{i}.raw(:,:,1,2)); %repeat for channel 2
    MaskInt_c002 = BW_c002.*double(Control{i}.raw(:,:,1,1));
    Control{i}.background(1) = sum(sum(MaskInt_c001))/sum(sum(BW_c001)); %the background subtraction will use the average pixel intensity.
    Control{i}.background(2) = sum(sum(MaskInt_c002))/sum(sum(BW_c002));
    clear BW_c001 BW_c003 MaskInt_c001 MaskInt_c002
        %subtracting background from all image frames
        max_t = Control{i}.attributes(3)
        for t = 1:max_t;
            Control{i}.bg_subtracted(:,:,t,1) = Control{i}.raw(:,:,t,1)-Control{i}.background(1)
            Control{i}.bg_subtracted(:,:,t,2) = Control{i}.raw(:,:,t,2)-Control{i}.background(2)
        end
end

for i = 1:Filenum_Exp %repeat for experimental dataset
    BW_c001 = roipoly(Exp{i}.raw(:,:,1,1));
    MaskInt_c001 = BW_c001.*double(Exp{i}.raw(:,:,1,1));
    BW_c002 = roipoly(Exp{i}.raw(:,:,1,2));
    MaskInt_c002 = BW_c002.*double(Exp{i}.raw(:,:,1,2));
    Exp{i}.background(1) = sum(sum(MaskInt_c001))/sum(sum(BW_c001));
    Exp{i}.background(2) = sum(sum(MaskInt_c002))/sum(sum(BW_c002));
    clear BW_c001 BW_c002 MaskInt_c001 MaskInt_c002
        max_t = Exp{i}.attributes(3)
        for t = 1:max_t;
            Exp{i}.bg_subtracted(:,:,t,1) = Exp{i}.raw(:,:,t,1)-Exp{i}.background(1)
            Exp{i}.bg_subtracted(:,:,t,2) = Exp{i}.raw(:,:,t,2)-Exp{i}.background(2)
        end
end
   

%% Generating a ratio of pixel intensity sums
    % a rough metric to determine the relationship between Rok:Myo
    % intensity ratios vs injection time.
    
for i = 1:Filenum_Control
    max_t = Control{i}.attributes(3)
    for t = 1:max_t;
        RokSum = sum(sum(Control{i}.raw(:,:,t,1)));
        MyoSum = sum(sum(Control{i}.raw(:,:,t,2)));
        Rok_Myo_Ratio = RokSum/MyoSum;
        Control{i}.RokSum(t) = RokSum;
        Control{i}.MyoSum(t) = MyoSum;
        Control{i}.Rok_Myo_Ratio(t) = Rok_Myo_Ratio;
    end
end

for i = 1:Filenum_Exp
    max_t = Exp{i}.attributes(3)
    for t = 1:max_t;
        RokSum = sum(sum(Exp{i}.raw(:,:,t,1)));
        MyoSum = sum(sum(Exp{i}.raw(:,:,t,2)));
        Rok_Myo_Ratio = RokSum/MyoSum;
        Exp{i}.RokSum(t) = RokSum;
        Exp{i}.MyoSum(t) = RokSum;
        Exp{i}.Rok_Myo_Ratio(t) = Rok_Myo_Ratio;
    end
end
   
    %% Generating the ratio with background subtraction
        
        for i = 1:Filenum_Control
        max_t = Control{i}.attributes(3);
            for t = 1:max_t;
            RokSum_bg = sum(sum(Control{i}.bg_subtracted(:,:,t,1)));
            MyoSum_bg = sum(sum(Control{i}.bg_subtracted(:,:,t,2)));
            Rok_Myo_Ratio_bg = RokSum_bg/MyoSum_bg;
            Control{i}.RokSum_bg(t) = RokSum_bg;
            Control{i}.MyoSum_bg(t) = MyoSum_bg;
            Control{i}.Rok_Myo_Ratio_bg(t) = Rok_Myo_Ratio_bg;
            end
        end

        for i = 1:Filenum_Exp
            max_t = Exp{i}.attributes(3);
            for t = 1:max_t;
                RokSum_bg = sum(sum(Exp{i}.bg_subtracted(:,:,t,1)));
                MyoSum_bg = sum(sum(Exp{i}.bg_subtracted(:,:,t,2)));
                Rok_Myo_Ratio_bg = RokSum_bg/MyoSum_bg;
                Exp{i}.RokSum_bg(t) = RokSum_bg;
                Exp{i}.MyoSum_bg(t) = RokSum_bg;
                Exp{i}.Rok_Myo_Ratio_bg(t) = Rok_Myo_Ratio_bg;
            end
        end
    

       %% Plotting Ratio vs Time
        
       %converting time step into seconds, with t = 1 --> 0 seconds
       for i = 1:Filenum_Control
           max_t = Control{i}.attributes(3)
           ind = find(ones(1,max_t));
           time_vector = Control{i}.attributes(8).*(ind-1)
           Control{i}.realtime = time_vector; 
       end
       
       for i = 1:Filenum_Exp
           max_t = Exp{i}.attributes(3)
           ind = find(ones(1,max_t));
           time_vector = Exp{i}.attributes(8).*(ind-1)
           Exp{i}.realtime = time_vector; 
       end
       %now we have normalized all the time axes by the time interval of
       %the image acquisition. All the y values are now superimposable.
      
       
       %pulling x and y data
       for i = 1:Filenum_Control
           Control_x{i} = Control{i}.realtime(:);
           Control_y{i} = Control{i}.Rok_Myo_Ratio(:); %raw data ratio
           Control_y_bg{i} = Control{i}.Rok_Myo_Ratio_bg(:); %ratio of background-subtracted data
       end
       
       for i = 1:Filenum_Exp
           Exp_x{i} = Exp{i}.realtime(:);
           Exp_y{i} = Exp{i}.Rok_Myo_Ratio(:);
           Exp_y_bg{i} = Exp{i}.Rok_Myo_Ratio_bg(:);
       end
       
      %plotting
      figure
       for i = 1:Filenum_Control
           subplot(3,1,i)
           hold on
            plot(Control_x{i},Control_y{i})
            title(strcat('Control', num2str(i)))
            xline = Control{i}.attributes(9)*Control{i}.attributes(8);
            plot([xline, xline],[0,5])
            
       end
       
       figure
       for i = 1:Filenum_Exp
           subplot(3,1,i)
           hold on
           plot(Exp_x{i},Exp_y{i})
           title(strcat('Exp', num2str(i)))
           xline = Exp{i}.attributes(9)*Exp{i}.attributes(8)
           plot([xline, xline],[0,5])
       end
      

       %% plotting w background subtraction
       %plotting
      figure
       for i = 1:Filenum_Control
           subplot(3,1,i)
           hold on
            plot(Control_x{i},Control_y_bg{i})
            title(strcat('Control BG sub', num2str(i)))
            xline = Control{i}.attributes(9)*Control{i}.attributes(8);
            plot([xline, xline],[0,50])
            
       end
       
       figure
       for i = 1:Filenum_Exp
           subplot(3,1,i)
           hold on
           plot(Exp_x{i},Exp_y_bg{i})
           title(strcat('Exp BG Sub', num2str(i)))
           xline = Exp{i}.attributes(9)*Exp{i}.attributes(8)
           plot([xline, xline],[0,50])
       end
       
        %% Plotting intensity sum vs time
       figure
        for i = 1:Filenum_Control
           subplot(3,1,i)
           hold on
            plot(Control_x{i},Control_y_bg{i})
            title(strcat('Control BG sub', num2str(i)))
            xline = Control{i}.attributes(9)*Control{i}.attributes(8);
            plot([xline, xline],[0,50])
            
       end
       
       figure
       for i = 1:Filenum_Exp
           subplot(3,1,i)
           hold on
           plot(Exp_x{i},Exp_y_bg{i})
           title(strcat('Exp BG Sub', num2str(i)))
           xline = Exp{i}.attributes(9)*Exp{i}.attributes(8)
           plot([xline, xline],[0,50])
       end