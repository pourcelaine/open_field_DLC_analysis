
function [norm_trajectory] = read_DLC_output(subject_dir, subject_ID, timepoints, bodypart_to_track, freq, LPfreq)

DLC_dir = fullfile(subject_dir, strcat(subject_ID, '_OF_', timepoints))
DLC_data = readtable(string(fullfile(DLC_dir, strcat(subject_ID, '_OF_', timepoints, 'DLC_resnet50_LAMuOR_OF_v2Jan19shuffle1_500000_filtered.csv'))))

select_xy = DLC_data{1:end, bodypart_to_track};


% Low pass filter
select_xy_filtered = lowpass(double(select_xy(1:end,2:3)), LPfreq, freq);

% Downsample
select_xy_length = length(select_xy);
select_xy_filtered_downsampled = interp1(1:select_xy_length, select_xy_filtered, linspace(1,select_xy_length,40000));
norm_trajectory = select_xy_filtered_downsampled

% save mat files
save(strcat(DLC_dir,  '/', subject_ID, '_OF_', timepoints, '_select_xy.mat'), 'select_xy');
save(strcat(DLC_dir,  '/', subject_ID, '_OF_', timepoints, '_select_xy_filtered.mat'), 'select_xy_filtered');
save(strcat(DLC_dir,  '/', subject_ID, '_OF_', timepoints, '_select_xy_filtered_downsampled.mat'), 'select_xy_filtered_downsampled');
