% % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% OPEN FIELD ASSAY  - DLC Data Analysis                 %
% Sjulson Lab - Albert Einstein College of Medicine     %
% Kelly Clemenza - kelly.clemenza@einseteinmed.edu      %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% First set static definitions for ALL hardcoded variables required by script
% STATIC VARIABLES MUST NOT BE ADDED OR CHANGED BEYOND THIS POINT
cohort_name = 'LAMUOR-COHORT102';
format longG
bodypart_to_track = [1,11,12]
LPfreq = 20
downsample_number = 36000 % For 36000 frames in 30 min recorder, 1 min = 1200, 15 min = 18000, 10 min = 12000, 5 min = 6000,
analysis_window = [1 36000]

base_dir = fullfile('/home/kelly/Documents/LAMUOR_PROJECT-DATA/Open_Field_Assay/', cohort_name, '/');
analysis_dir= fullfile('/home/kelly/Documents/LAMUOR_PROJECT-Analysis/Open_Field_Assay/', cohort_name, '/')

load(fullfile(base_dir, 'experiment_info.mat'));
load(fullfile(base_dir, 'cohort_summary.mat'));

% Iterate over data files for each subject
for i = 1:12(experiment_info.subject_ID);
    subject_dir = fullfile(base_dir, experiment_info(i).subject_ID);
    subject_summary = {experiment_info(i).subject_ID, experiment_info(i).tag_ID, experiment_info(i).tx, experiment_info(i).sex, experiment_info(i).DOB}
    
    for x = 1:5(experiment_info.timepoint_list);
        load(fullfile(subject_dir, strcat(experiment_info(i).subject_ID, '_OF_', experiment_info(x).timepoint_list, '/session_info.mat')))
      
        % check if raw data has already been extracted and filtered (and
        % cleaned). Load that data if files already exist, create from raw
        % data if its doesn't.
        xy_data_to_plot = read_DLC_output(subject_dir, session_info.subject_ID, experiment_info(x).timepoint_list,  bodypart_to_track, LPfreq, downsample_number);
        
        % analyze distance traveled results and add to table of animal data
        subject_summary = [subject_summary, distance_traveled(xy_data_to_plot (analysis_window(1):analysis_window(2),2), xy_data_to_plot (analysis_window(1):analysis_window(2),3))*session_info.box_scale];
   
        % plot trajectory
        subp = plot_DLC_output(i, x, analysis_window, xy_data_to_plot, analysis_dir, experiment_info(i).subject_ID, experiment_info(i).tx, experiment_info(x).timepoint_list, session_info.box_scale)

    end

    cohort_summary =  vertcat(cohort_summary, subject_summary)

end 

cohort_summary =  vertcat(cohort_summary, [cohort_name, bodypart_to_track(2), bodypart_to_track(3), LPfreq, downsample_number, analysis_window(1), analysis_window(2), "", "", ""])

% save session plots for each subject
distance_traveled_scaled =  cohort_summary ; save(strcat(analysis_dir, 'DATA/distance_traveled_scaled.mat'), 'distance_traveled_scaled');

