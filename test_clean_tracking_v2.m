
%get the csv file on the folder
cohort_name = 'LAMUOR-COHORT101';
base_dir = fullfile('/home/kelly/Documents/LAMUOR_PROJECT-DATA/Open_Field_Assay/', cohort_name, '/');
load(fullfile(base_dir, 'experiment_info.mat'));

% Iterate over data files for each subject
% Iterate over data files for each subject
for i = 12:12(experiment_info.subject_ID);
    subject_dir = fullfile(base_dir, experiment_info(i).subject_ID);
    
    for x = 2:2(experiment_info.timepoint_list);
    fullfile(subject_dir, strcat(experiment_info(i).subject_ID, '_OF_', experiment_info(x).timepoint_list, '_DLC_xy.mat'))
    load(fullfile(subject_dir, strcat(experiment_info(i).subject_ID, '_OF_', experiment_info(x).timepoint_list, '/', experiment_info(i).subject_ID, '_OF_', experiment_info(x).timepoint_list, '_DLC_xy.mat')))
    pos_struct.xpos = DLC_xy(:,1);
    pos_struct.ypos = DLC_xy(:,2);
    pos_struct.timevec = 1:length(DLC_xy)
   
    % call clean_tracking
    manually_cleaned_DLC_xy = clean_tracking(pos_struct, timevec);
    save(fullfile(subject_dir,'manually_cleaned_DLC_xy.mat'),'manually_cleaned_DLC_xy');
    end
end

