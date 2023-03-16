% Conditioned Place Preference - Data Filtering
%
% Sjulson Lab - Albert Einstein College of Medicine
% Kelly Clemenza - kelly.clemenza@einseteinmed.org
% So many thanks to Elie Fermino de Oliveira for helping!!
% 
% edited by Luke, 2020-12-05
% edited by KC, 3-11-2021, iterates through multiple files
% for creating filtered CPP data

% Indicate likelihood score threshold cutoff
clear all

% Indicate likelihood score threshold cutoff
QC_thresh = 0;

% Define data source
procedure = 'Conditioned_Place_Preference';
cohort_name = 'LAMUOR-COHORT001';
filter_status = 'Filtered'; % filtered or unfiltered
% MACOS
% base_dir = fullfile('/Users/basil/Google Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, cohort_name, 'DLC_Results/');
% LINUX
 base_dir = fullfile('/home/kelly/Google Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, cohort_name, 'DLC_Results/');
 load(strcat(base_dir, 'cohort_info.mat'));

% Iterate through each subject
for i = 1:length(cohort_info.ID);
    subject_ID = cohort_info.ID(i);
    subject_dir = fullfile(base_dir, strcat(filter_status, '/', subject_ID, '/'));
       
    % Iterate over data files for each experiment
    for x = 2:2(cohort_info.experimental_timepoint);
        experiment_data = readtable(string(fullfile(subject_dir, strcat(subject_ID, '_CPP_', cohort_info.experimental_timepoint(x), '.csv'))));
    
        % Filter by DLC-generated QC score according to user-defined threshold
        % Coordinates for CENTER point = [1 11 12 13]
        % Coordinates for TAILBASE point = [1 14 15 16]
        filtered_coordinates = experiment_data{1:end,[1 11 12 13]};
        filtered_coordinates((filtered_coordinates(:,4)<QC_thresh),:)=[]
        save(strcat(subject_dir, subject_ID, '_CPP_', cohort_info.experimental_timepoint(x), '_filtered_coordinates.mat'), 'filtered_coordinates');
	end
end
