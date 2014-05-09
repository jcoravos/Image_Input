function [ data,filetype ] = area_plot(area_array,timestep,injection,titlestring)
    %This function takes as an input the area array generated by
    %LoadEdgeData and plots area(�m) vs time (seconds). There is also a
    %commented section that will draw a line on the plot, which is useful
    %if you are plotting data from a live perturbation
    
    [frames,cells] = size(area_array);
    
    meanarea = nanmean(area_array,2); %finds the mean at each time point
    time = (0:1:frames-1);
    timelabel = (0:timestep:timestep*(frames-1));
    
    figure
    shadedErrorBar(timelabel,meanarea,nanstd(area_array,0,2));
    
    if nargin == 3|4
        hold on
        xline = timestep*(injection-1);
        plot([xline xline],[0 1000])
    end
    
    xlabel('Time (seconds)')
    ylabel('Cell Area (microns)')
    axis([0 max(timelabel) 0 70])
    
    if nargin == 4
        title(titlestring)
    end

end