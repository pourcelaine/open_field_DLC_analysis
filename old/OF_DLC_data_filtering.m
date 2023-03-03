% Open Field Assay - DLC Data Analysis 
% Sjulson Lab - Albert Einstein College of Medicine
% Kelly Clemenza - kelly.clemenza@einseteinmed.org

% Define data source
procedure = 'Open_Field_Assay';
cohort_name = 'LAMUOR-COHORT101';
bodypart_to_track = "CENTER"

if isunix
    base_dir = fullfile('/home/kelly/Documents/LAMUOR_PROJECT-DATA', procedure, cohort_name, '/');
elseif ismac
    base_dir = fullfile('/Users/basil/My Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, cohort_name, 'DLC_Results/');

% Load experiment information 
load(strcat(base_dir, 'cohort_info.mat'));
load(strcat(base_dir, 'experiment_info.mat'));

% Iterate through each subject
for i = 1:length(cohort_info.ID);
    subject_dir = fullfile(base_dir, cohort_info.ID(i);
       
    % Iterate over data files for each experiment
    for x = 1:length(experiment_info.timepoints);


        read_DLC_output(subject_dir, cohort_info, experiment_info)

   
f1 = figure
        s1 = subplot(3,1,1); hold on;
        plot(select_xy(:,2));
        title('xy')

        s2 = subplot(3,1,2); hold on;
        plot(select_xy_filtered(:,1));
        title('xy filtered');

        s3 = subplot(3,1,3); hold on;
        plot(select_xy_filtered_downsampled(:,1));
        title('xy filtered downsampled');
    end   
        

 
end
