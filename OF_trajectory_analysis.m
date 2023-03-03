% % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% OPEN FIELD ASSAY                                      %
% DLC Data Analysis                                     %
% Sjulson Lab - Albert Einstein College of Medicine     %
% Kelly Clemenza - kelly.clemenza@einseteinmed.edu      %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% First set static definitions for ALL hardcoded variables required by script
% STATIC VARIABLES MUST NOT BE ADDED OR CHANGED BEYOND THIS POINT
cohort_name = 'LAMUOR-COHORT101';
format longG
bodypart_to_track = [1,11,12,13]
freq = 30; % 30 hz
LPfreq = 10;  % low-pass frequency in Hz
cohort_summary = []

if isunix
    base_dir = fullfile('/home/kelly/Documents/LAMUOR_PROJECT-DATA/Open_Field_Assay/', cohort_name, '/');
elseif ismac
    base_dir = fullfile('/Users/basil/My Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, cohort_name, 'DLC_Results/');
end 

% Load experiment information 
load(fullfile(base_dir, 'cohort_info.mat'));
load(fullfile(base_dir, 'experiment_info.mat'));
% bodypart_to_track = experiment_info.DLC_bodyparts(experiment_info.DLC_bodyparts(:,1)==bodypart_to_track,2);

% Iterate over data files for each subject
for i = 1:12(cohort_info.subject_ID);
    subject_dir = fullfile(base_dir, cohort_info(i).subject_ID);
    subject_summary = [cohort_info(i).subject_ID, cohort_info(i).tx]
    for x = 1:5(experiment_info.timepoint_list);
        norm_trajectory = read_DLC_output(subject_dir, cohort_info(i).subject_ID, experiment_info.timepoint_list(x), [1,11,12,13], freq, LPfreq);
        dist = distance_traveled(norm_trajectory(:,1), norm_trajectory(:,2));
        subject_summary = [subject_summary, dist]
    end
   

%         
%     t = table({subject_ID, condition, sex, experiment_data.total_dist(1), experiment_data.total_dist(2), experiment_data.total_dist(3), experiment_data.total_dist(4), experiment_data.total_dist(5)}, 'VariableNames', {'ID', 'condition', 'sex', string(experiment_data.timepoint(1)), string(experiment_data.timepoint(2)), string(experiment_data.timepoint(3)), string(experiment_data.timepoint(4)), string(experiment_data.timepoint(5))}, 'RowNames', {string(subject_ID)});
%     results_summary = [results_summary; t]
end
%     for p = 1:length(cohort_info.experimental_timepoint);  
%         figure(1)
%         h{p} = subplot(2,length(cohort_info.experimental_timepoint),p)
%         hLine{p} = plot(experiment_data.coordinates(p));title(strcat(subject_ID, condition, experiment_data.timepoint);
%     end
%          print(sprintf(strcat(subject_dir, '/', subject_ID, "_OF_dose-response")),'-dpdf');
% end
% 
%       
%     
    
    % set up figure


     % printing out distanced traveled info because I genuinely cannot figure
     % out how to export the information into a readable .csv file
%        distance_results = (strcat(string(subject_ID), ',', string(condition), ',', string(sal_total_m), ',', string(fent50_total_m), ',', string(fent100_total_m), ',', string(fent500_total_m), ',', string(coc20_total_m)))     
%        total_distance_traveled = [total_distance_traveled  distance_results];
%      %   save plots in PDF
% 

