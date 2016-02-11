%% Master Script for Edge Data Import and Analysis
    %follow these directions for using the scripts in this package
    
%% 1. Open LoadEdgeDataConfig.m
    % Open this script, read the directions, and provide the requested
    % information to generate the Input structure
    
    
    
%% 2. Generate Output Function
    %You will have to change the names of the Input and Output structures
    imnum = length(I);
for i = 1:imnum
    O(i) = LoadEdgeDataFun(I(i));
end
    
    %% Append Output Structure to include interpolated data for merging
for i = 1:imnum
    Ii = I(i);
    Oi = O(i);
    [a,b,c] = interpEdge(Ii,Oi); 
    O(i).SigInt_interp = a
    O(i).SigInt_areanorm_interp = b
    O(i).Area_interp = c
    clear Ii Oi a b
end    
    


%% 3. Generate average area plot
    %Determining the dimesions of the subplot
    plotcols = ceil(sqrt(imnum))
    plotrows = ceil(imnum/plotcols)
    
    %plotting individual cells
    figure
for i = 1:imnum
   subplot(plotrows,plotcols,i) 
   h1 = area_plot(I(i),O(i),70,I(i).Filename)
end

    figure
for i = 1:imnum
    subplot(plotrows,plotcols,i) 
    h2 = sig_plot(I(i),O(i),10000,I(i).Filename)
end

%% 4. Generating Interpolated and merged data
    %First, split Input and Ouput Structures into Control and Experiment
    %Then, use the merge plot functions to merge the data and display them.
Icontrol(1) = I(1)
Icontrol(2) = I(2)
Iexp(1) = I(3)
Iexp(2) = I(4)
Iexp(3) = I(5)

Ocontrol(1) = O(1)
Ocontrol(2) = O(2)
Oexp(1) = O(3)
Oexp(2) = O(4)
Oexp(3) = O(5)

figure
subplot(2,2,1)
merge_area_plot(Icontrol,Ocontrol,20,-30,30) % I, O inputs, followed by number of seconds to include before injection, and yaxis limits
title('Control Injection, Area vs Time')
xlabel('Time (seconds)')
ylabel('Area (microns)')

subplot(2,2,2)
merge_sig_plot(Icontrol,Ocontrol,20,-750,2500)
title('Control Injection, Signal vs Time')
xlabel('Time (seconds)')
ylabel('Signal (microns)')

subplot(2,2,3)
merge_area_plot(Iexp,Oexp,20,-30,30)
title('Y27632 Injection, Area vs Time')
xlabel('Time (seconds)')
ylabel('Area (microns)')

subplot(2,2,4)
merge_sig_plot(Iexp, Oexp, 20,-750,2500)
title('Y27632 Injection, Signal vs Time')
xlabel('Time (seconds)')
ylabel('Signal (microns)')
