%  =====================================================================
%  CONDITIONED PLACE PREFERENCE - PREFERENCE ANALYSIS
%  =====================================================================
%  [Function: plot trajectory coordinates and extract time spent in each chamber]  
%
%  Sjulson Laboratory - Albert Einstein College of Medicine                                 
%  Kelly Clemenza (kelly.clemenza@einseteinmed.org)      
%  Alexa Fryc
%
%  v.11.10.2021      
%  Significant revisions made to adapt DLC coordinates to match orientation
%  seen on video.
% 
clear all
close all

% 1 minute = 1800 frames (for 30 fps), 1500 frames (for 20 fps)
start_time = 1; % 9000 = a generous 5 minute delay to ensure peak serum fentanyl levels
stop_time = 54000; % 36000 = analyze 20 minutes of data, can go up to 54000 (30 min)
smoothN = 1; % smoothing factor for analysis and plotting

results_base = []

CPP_preference_results = [];
all_timepoints_results_heading = {'ID', 'condition', 'sex', 'timepoint', 'left_chamber', 'right_chamber', 'left_time(s)', 'right_time(s)', 'left_preference(%)'};
CPP_preference_results = [CPP_preference_results; all_timepoints_results_heading];


%get the csv file on the folder
procedure = 'Conditioned_Place_Preference';
cohort_name = 'LAMUOR-COHORT001';
filter_status = 'Filtered'; % filtered or unfiltered
% for mac
%base_dir = fullfile('/Users/basil/Google Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, cohort_name, 'DLC_Results/');
% for linux
base_dir = strcat('/home/kelly/Google Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, '/', cohort_name, '/DLC_Results/');
load(strcat(base_dir, 'cohort_info.mat'));

% Iterate over data files for each subject
for i = 1:length(cohort_info.ID);
    subject_ID = string(cohort_info.ID(i));
    box_number = string(cohort_info.box_number(i));
    experimental_condition = string(cohort_info.condition(i));
    left_chamber = string(cohort_info.left_chamber(i));
    right_chamber =  string(cohort_info.right_chamber(i));
    sex = string(cohort_info.sex(i));

    for x = 2:2(cohort_info.experimental_timepoint);
       experimental_timepoint = cohort_info.experimental_timepoint(x);   
       if exist(strcat(base_dir, filter_status, '/', subject_ID, '/', subject_ID, '_CPP_' , experimental_timepoint, '_manually_filtered_coordinates.mat'), 'file');
            load(strcat(base_dir, filter_status, '/', subject_ID, '/', subject_ID, '_CPP_' , experimental_timepoint, '_manually_filtered_coordinates.mat'));
       else
            load(strcat(base_dir, filter_status, '/', subject_ID, '/', subject_ID, '_CPP_' , experimental_timepoint, '_filtered_coordinates.mat'));
       end

       if x == 1;
            threshold_coord = cohort_info.BASE1_threshold(i);
            else if x == 2;
                threshold_coord = cohort_info.TEST1_threshold(i);
                end
       end

       % making timestamps
       frame_rate = 30; % assume 30 Hz
       dt = 1/frame_rate;
       timestamps = 0:dt:dt*size(filtered_coordinates, 1);
       timestamps = timestamps(1:end-1);
       
       %  apply smoothing
       y_coord = smooth(filtered_coordinates(:,3), smoothN);
       x_coord = smooth(filtered_coordinates(:,2), smoothN);
       
       % converting to a tsd
       position_TSD = tsd(timestamps, x_coord);
       
       % restricting it to the official CPP time (made up numbers, but you get the idea)
       CPP_interval = intervalSet([start_time, stop_time]); % if your CPP isn't the entire recording
       position_TSD = position_TSD.Restrict(CPP_interval);
       
       % extracting when it's above and below the threshold
       % this is flipped bottom = top, top = bottom in accordance with DLC
       % coordinates
       % coordinates 
       right_intervals = position_TSD.thresholdIntervals(threshold_coord, 'Direction', 'Above');
       left_intervals = position_TSD.thresholdIntervals(threshold_coord, 'Direction', 'Below');
        
       left_chamber_value = left_intervals.tot_length;
       right_chamber_value = right_intervals.tot_length;
        
       percent_left_pref = (left_chamber_value/(left_chamber_value + right_chamber_value))*100;
       temp_matrix = [];
       temp_matrix = [subject_ID, experimental_condition, sex, experimental_timepoint, left_chamber, right_chamber, left_chamber_value, right_chamber_value, percent_left_pref];

       CPP_preference_results = [CPP_preference_results;temp_matrix];

       f1 = figure;
       f1.Renderer = 'Painters';
       %     f1.Name = strcat(procedure, '-', subject_ID, ' - ', experimental_condition);
       f1.Position = [0 0 2000 375];
       f1.PaperSize = [18 5];
       %     f1.PaperUnits = 'inches';
        
       title_info = strcat(subject_ID, ':', {' '},  experimental_condition, {' - '}, experimental_timepoint, {' - Left: '}, left_chamber, {' - Right: '}, right_chamber);
       title_info_alt = strcat(subject_ID, ':', {' '},  experimental_condition, {' - '}, experimental_timepoint, {' - Left(Bottom): '}, left_chamber, {' - Right(Top): '}, right_chamber);

        
       s1 = subplot(1,4,1); hold on;
       title('Trajectory');
       subtitle(title_info);
       s1.YDir = 'reverse';
       p1 = plot(x_coord(start_time:stop_time), y_coord(start_time:stop_time), 'black');     
        
       s1 = subplot(1,4,2); hold on;
       title('Trajectory');
       subtitle(title_info_alt);
       s1.YDir = 'reverse';
       p1 = plot(y_coord(start_time:stop_time), -x_coord(start_time:stop_time), 'black');
       yline(-threshold_coord, 'k--')       
        
       s3 = subplot(1,4,[3 4]); hold on;
       title('CPP-TEST Crosses (red = left, blue = right)');
       %subtitle(title_info);
       %s3.YDir = 'reverse';
       p1 = area(position_TSD.t, position_TSD.data - threshold_coord);
       p1.FaceColor = [0 1 0]; % green
       p1.FaceAlpha = 0.5;
       plot(left_intervals, 'r');
       plot(right_intervals, 'b');
        
    %   hold on
        figure_dir = strcat('/home/kelly/Google Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, '/', cohort_name, '/FIGURES/');
        print(sprintf('%s%s_CPP_preference_%s_%s', figure_dir, subject_ID, experimental_timepoint, filter_status),'-dpdf');
       
    end
end

base_dir = strcat('/home/kelly/Google Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, '/', cohort_name, '/DLC_Results/');
save(fullfile(base_dir,  strcat(experimental_timepoint, '_CPP_preference_results.mat')), 'CPP_preference_results');

