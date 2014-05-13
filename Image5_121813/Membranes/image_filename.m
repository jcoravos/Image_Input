function data = image_filename(time_i, layer_i, src)
% ** This is an automatically generated function
% ** created at 4/18/2014, 2:05 PM by write_image_filename_function.m
% ** Inputs the time, layer, and source directory of a data set.
% ** Outputs the filename of that image.

% ** For data set: Image5_121813

filename = 'Image5_121813_t001_z005_c002.tif';

z_name = sprintf(strcat('%.', num2str(3), 'u'), layer_i);
filename(21:21+3-1) = z_name;

t_name = sprintf(strcat('%.', num2str(3), 'u'), time_i);
filename(16:16+3- 1) = t_name;

data = fullfile(src, filename);
