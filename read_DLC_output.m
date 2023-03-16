
function [DLC_xy_filtered_downsampled] = read_DLC_output(subject_dir, subject_ID, timepoints, bodypart_to_track, LPfreq, downsample_number)

session_dir = fullfile(subject_dir, strcat(subject_ID, '_OF_', timepoints))
session_DLC_data = readtable(fullfile(session_dir, dir(fullfile(session_dir, '*filtered.csv')).name))
session_timestamps = readtable(fullfile(session_dir, dir(fullfile(session_dir, '*timestamp*.csv')).name))

session_length = (session_timestamps{end, 3} - session_timestamps{1, 3})
session_clocktime = ((session_timestamps{:,3} - session_timestamps{1,3})/60)

freq = length(session_timestamps{:,3})/session_length

% Low pass filter
DLC_xy_filtered(:,1) = session_clocktime(2:end,1)
DLC_xy = session_DLC_data{1:end, bodypart_to_track(:,2:3)};
DLC_xy_filtered(:,2:3) = lowpass(double(DLC_xy), LPfreq, freq);



% Downsample
DLC_xy_filtered_downsampled = interp1(1:length(DLC_xy_filtered), DLC_xy_filtered, linspace(1, length(DLC_xy_filtered), downsample_number));

% % % save mat files
save(strcat(session_dir,  '/', subject_ID, '_OF_', timepoints, '_DLC_xy.mat'), 'DLC_xy');
save(strcat(session_dir,  '/', subject_ID, '_OF_', timepoints, '_DLC_xy_filtered.mat'), 'DLC_xy_filtered');
save(strcat(session_dir,  '/', subject_ID, '_OF_', timepoints, '_DLC_xy_filtered_downsampled.mat'), 'DLC_xy_filtered_downsampled');
