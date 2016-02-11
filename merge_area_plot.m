function [handle] = merge_area_plot(varargin)
    %%This funcion will merge data from the input and output structures and
    %%display them as a mean and +/- std. It is important to split input
    %%into control and experiment images.
    %I and O are the standard input/ouput structures from LoadEdgeData. You
    %may also include y-axis definition by adding ymin and ymax at the end 
    %of the input argument.
    
    
    switch nargin
        case 3
            disp('No Y-axis Specification')
            I = varargin{1}
            O = varargin{2}
            offset = varargin{3}
        case 7
            disp('Y-axis Specified')
            I = varargin{1}
            O = varargin{2}
            offset = varargin{3}
            xmin = varargin{4}
            xmax = varargin{5}
            ymin = varargin{6}
            ymax = varargin{7}
        otherwise
            error('Unexpected number of inputs')
    end
imnum = length(I)

%% Prepping Data
for i = 1:imnum
    
    xstart(i) = floor((I(i).injection)*I(i).timestep-offset); %sets the beginning of the movie 10 seconds before injection. 
    
    %normalize to area or signal level at time of injection
    areanorm = O(i).Area_interp - nanmean(O(i).Area_interp(xstart(i),:)); 
    
    %chopping data at the injection time point 
    [t c] = size(areanorm);
    areanormchopped{i} = areanorm(xstart(i):t,:);
    maxind(i) = length(areanormchopped{i}); %measures the maximum time length (maxind) and the number of cells (cellind)
end

xend = min(maxind) %chopping data at the last common time point to all images
merge = [];
for i = 1:imnum
    chop = areanormchopped{i}(1:xend,:);
    merge = cat(2,merge,chop); 
end

%% Plotting Data
timelabel = [1:1:xend]
meanarea = nanmean(merge,2)

shadedErrorBar(timelabel,meanarea,nanstd(merge,0,2));
hold on
plot([offset,offset],[-10000,10000])

if nargin == 7                  %if you include ymin and ymax axis, use them to specify axes. Otherwise calculate good 
    axis([xmin xmax ymin ymax])
else
    ymax = max(max(merge))
    ymin = min(min(merge))
    axis([0 xend ymin ymax])
end





end

