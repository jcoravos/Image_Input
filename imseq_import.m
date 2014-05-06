function [ data,filetype ] = imseq_import(sourcedir,sourcefile)
%{ 
imports tif files of a multichannel, multi or single z-slice movie.
    %inputs:
        %sourcedir = the filepath for the file to be imported
        %sourcefile = the filename up to but not including the underscore
            %preceding the t field.
     
    %The function first uses strread to determine from the filename the 
    %following parameters:
        %time
        %z slices
        %channels
        %
     %the function first determines whether the source directory and file
     %root include multiple z slices, or constitute a single z slice. Then
     %the function imports the tif image sequence and stores is at as stack
     
     %Output is in the format of a matrix where the dimensions are
     %(row dim, column dim,time,zslice,channel). If your image has a
     %singleton dimension (e.g. only one z-slice), then that dimension will
     %be removed from  the data output (e.g. row,col,time,channel) If your
     %source file
     
%}

%% Determine the features of the file
     list = ls(sourcedir); %reads the filenames from the sourcefile
     list2 = textscan(list,'%s');
     celllist = cell(list2{:}); %converts list2 into a cell array of strings
     listsort = sort(celllist);
     [m,n] = size(listsort);
     str = listsort{m};

     formatSpec = strcat('%*[', sourcefile, '] %c %s %c %s %c %s');
     C = textscan(str,formatSpec,'delimiter','_.');
        p = length(C);
        
       if p == 8
            t = str2num(cell2mat(C{2})); %final timepoint
            z = str2num(cell2mat(C{4})); %number of z slices
            c = str2num(cell2mat(C{6})); %number of channels
            filetype = [1,1,1];
        elseif C{1} == 't' & C{3} == 'c'
            t = str2num(cell2mat(C{2}));
            c = str2num(cell2mat(C{4}));
            filetype = [1,0,1];
        elseif C{1} == 't' & C{3} == 'z'
            t = str2num(cell2mat(C{2}));
            z = str2num(cell2mat(C{4}));
            filetype = [1,1,0];
        elseif C{1} == 'z' & C{3} == 'c'
            z = str2num(cell2mat(C{2}));
            c = str2num(cell2mat(C{4}));
            filetype = [0,1,1];
       end
        
      %filetype[t,z,c], where 1 = true (this field exists), and 0 = false
      %(this field does not exist)
        
%%  Read image
if filetype == [1,1,1] %tzc
    for i_c = 1:c %loop through channels
         c_str = strcat('00',num2str(i_c));
        for i_z = 1:z %loop through z slices
            if i_z < 10
                z_str = strcat('00',num2str(i_z));
            else
                z_str = strcat('0',num2str(i_z));
            end
            
            for i_t = 1:t %loop through all timesteps
                if i_t < 10
                    t_str = strcat('00',num2str(i_t));
                else
                    t_str = strcat('0',num2str(i_t));
                end
                filename = strcat(sourcefile,'_t',t_str,'_z',z_str,'_c',c_str,'.tif');
                filepath = strcat(sourcedir,'/',filename);
                data(:,:,i_t,i_z,i_c) = imread(filepath,'tiff');
            end
        end
    end  
end


if filetype == [1,0,1] %tc
    for i_c = 1:c %loop through channels
         c_str = strcat('00',num2str(i_c));
            
            for i_t = 1:t %loop through all timesteps
                if i_t < 10
                    t_str = strcat('00',num2str(i_t));
                else
                    t_str = strcat('0',num2str(i_t));
                end
                filename = strcat(sourcefile,'_t',t_str,'_c',c_str,'.tif');
                filepath = strcat(sourcedir,'/',filename);
                data(:,:,i_t,i_c) = imread(filepath,'tiff');
            end
    end  
end

if filetype == [1,1,0] %tz
    for i_z = 1:z %loop through z slices
            if i_z < 10
                z_str = strcat('00',num2str(i_z));
            else
                z_str = strcat('0',num2str(i_z));
            end
            
            for i_t = 1:t %loop through all timesteps
                if i_t < 10
                    t_str = strcat('00',num2str(i_t));
                else
                    t_str = strcat('0',num2str(i_t));
                end
                filename = strcat(sourcefile,'_t',t_str,'_z',z_str,'.tif');
                filepath = strcat(sourcedir,'/',filename);
                data(:,:,i_t,i_z) = imread(filepath,'tiff');
            end
        end
end

if filetype == [0,0,1] %zc
    for i_c = 1:c %loop through channels
         c_str = strcat('00',num2str(i_c));
        for i_z = 1:z %loop through z slices
            if i_z < 10
                z_str = strcat('00',num2str(i_z));
            else
                z_str = strcat('0',num2str(i_z));
            end
            
                filename = strcat(sourcefile,'_z',z_str,'_c',c_str,'.tif');
                filepath = strcat(sourcedir,'/',filename);
                data(:,:,i_z,i_c) = imread(filepath,'tiff');
         end
     end
end  
end