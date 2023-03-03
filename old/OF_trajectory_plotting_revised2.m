% Open Field Graphing
%
% Sjulson Lab - Albert Einstein College of Medicine
% Kelly Clemenza - kelly.clemenza@einseteinmed.org
% So many thanks to Elie Fermino de Oliveira for helping!!
% 
% edited by Luke, 2020-12-05
% edited by KC, 3-11-2021, iterates through multiple files
% for calculating total distance traveled

select_type = 1;
origin = pwd;
color_theme = '#000000';
header2 = 15;
header3 = 15;

% Indicate start and stop frames, 1 minute = 1800 frames (roughly)
% start_time = 0; % 9000 = a generous 5 minute delay to ensure peak serum fentanyl levels
% stop_time = 36000   % 36000 = analyze 20 minutes of data, can go up to 54000 (30 min)
% smoothN = 0;

OF_distance_traveled_results = [];
all_timepoints_results_heading = {'ID', 'condition', 'sex', 'timepoint', 'total_distance_mm'};
OF_distance_traveled_results = [OF_distance_traveled_results; all_timepoints_results_heading];


%get the csv file on the folder
procedure = 'Open_Field_Assay';
cohort_name = 'LAMUOR-COHORT101';
filter_status = 'filtered'; % filtered or unfiltered
% for mac
% base_dir = fullfile('/Users/basil/My Drive/lab-shared/lab_projects/LAMuOR-Gi/4_Animal_Behavior/', procedure, cohort_name, 'DLC_Results/');
% for linux
base_dir = fullfile('/home/kelly/Documents/LAMUOR_PROJECT-DATA', procedure, cohort_name, '/');
load(strcat(base_dir, 'cohort_info.mat'));

% Iterate over data files for each subject
for i = 1:2(cohort_info.ID)
    subject_ID = cohort_info.ID(i);
    subject_dir = fullfile(base_dir, subject_ID);
    condition =  cohort_info.condition(i);
    VEHsaline_box = cohort_info.VEHsaline_box
    FENT050ug_box = cohort_info.FENT050ug_box
    FENT0100ug_box = cohort_info.FENT100ug_box
    FENT0500ug_box = cohort_info.FENT500ug_box
   
  %  box101_div = cohort_info.box101;  % 45 px = 10 mm | 0.22222222222 mm/px
   %box103_div = cohort_info.box103;  % 34 px = 10 mm | 0.29411764705 mm/px
    subject_ID = cohort_info.ID(i);
    condition =  cohort_info.condition(i);
    
    %  saline filtered
    load(fullfile(subject_dir, strcat('/', subject_ID, '/VEHsaline_QC_filtered_coordinates.mat')));
    sal = QC_filtered_coordinates;
    
    % fentanyl10 filtered
    load(fullfile(base_dir, strcat('/', subject_ID, '/FENT010ug_QC_filtered_coordinates.mat')));
    fent10 = QC_filtered_coordinates;
    
    % fentanyl50 filtered
    load(fullfile(base_dir, strcat('/', subject_ID, '/FENT050ug_QC_filtered_coordinates.mat')));
    fent50 = QC_filtered_coordinates;
    
    % fentanyl500 filtered
    load(fullfile(base_dir, strcat('/', subject_ID, '/FENT100ug_QC_filtered_coordinates.mat')));
    fent100 = QC_filtered_coordinates;
    
    % fentanyl500 filtered
    load(fullfile(base_dir, strcat('/', subject_ID, '/FENT500ug_QC_filtered_coordinates.mat')));
    fent500 = QC_filtered_coordinates;
    
    % cocaine20 filtered
    load(fullfile(base_dir, strcat('/', subject_ID, '/COCA020mg_QC_filtered_coordinates.mat')));
    coc20 = QC_filtered_coordinates;


    % extract information (needs to be generalized)
    sal_left_coord = sal(1:end,2:3);  
    fent10_left_coord = fent10(1:end,2:3);  
    fent50_left_coord = fent50(1:end,2:3);  
    fent100_left_coord = fent100(1:end,2:3);  
    fent500_left_coord = fent500(1:end,2:3);  
    coc20_left_coord = coc20(1:end,2:3);  
       
    sal_left_coord = [smooth(sal_left_coord(:,1), smoothN) smooth(sal_left_coord(:,2), smoothN)];
    fent10_left_coord = [smooth(fent10_left_coord(:,1), smoothN) smooth(fent10_left_coord(:,2), smoothN)];
    fent50_left_coord = [smooth(fent50_left_coord(:,1), smoothN) smooth(fent50_left_coord(:,2), smoothN)];
    fent100_left_coord = [smooth(fent100_left_coord(:,1), smoothN) smooth(fent100_left_coord(:,2), smoothN)];
    fent500_left_coord = [smooth(fent500_left_coord(:,1), smoothN) smooth(fent500_left_coord(:,2), smoothN)];
    coc20_left_coord = [smooth(coc20_left_coord(:,1), smoothN) smooth(coc20_left_coord(:,2), smoothN)];
    
    % Calculate total distance traveled
    sal_total_dist = dist(sal_left_coord(start_time:stop_time,1), sal_left_coord(start_time:stop_time,2));
    fent10_total_dist = dist(fent10_left_coord(start_time:stop_time,1), fent10_left_coord(start_time:stop_time,2));
    fent50_total_dist = dist(fent50_left_coord(start_time:stop_time,1), fent50_left_coord(start_time:stop_time,2));
    fent100_total_dist = dist(fent100_left_coord(start_time:stop_time,1), fent100_left_coord(start_time:stop_time,2));
    fent500_total_dist = dist(fent500_left_coord(start_time:stop_time,1), fent500_left_coord(start_time:stop_time,2));
    coc20_total_dist = dist(coc20_left_coord(start_time:stop_time,1), coc20_left_coord(start_time:stop_time,2));
    
    sal_total_m = sal_total_dist;
    fent10_total_m = fent10_total_dist;
    fent50_total_m = fent50_total_dist;
    fent100_total_m = fent100_total_dist;
    fent500_total_m = fent500_total_dist;
    coc20_total_m =  coc20_total_dist;
    
    
    % set up figure
    fig = figure(i);
    fig.Renderer = 'Painters';
    fig.Name = strcat('Open Field Assay, -', subject_ID, '-', condition);
    fig.Position = [0 0 2000 350];
    fig.PaperSize = [19 7]
    fig.PaperUnits = 'inches'
        
%     for x = 1:length(cohort_info.experimental_timepoint);
%         experiment_dir = fullfile(subject_dir, strcat(subject_ID, '_OF_', cohort_info.experimental_timepoint(x), '/'))
%     	if exist(strcat(experiment_dir, '/', subject_ID, '_OF_', cohort_info.experimental_timepoint(x), 'cleaned_selected_coordinates.mat'), 'file');
%             load(strcat(experiment_dir, '/', subject_ID, '_OF_', cohort_info.experimental_timepoint(x), 'cleaned_selected_coordinates.mat'));
%     	else
%             load(strcat(experiment_dir, '/', subject_ID, '_OF_', cohort_info.experimental_timepoint(x), '_selected_coordinates.mat'));
%         end
%         
%         experiment_box = cohort_info.experiment_box(x)
%         
%         x_coord = selected_coordinates(1:end,2);
%         y_coord = selected_coordinates(1:end,3);
%      
        
        total_distance_m = dist(x_coord(1:end,1), y_coord(1:end,1));
 
        % Convert pixels to mm
     %   if experiment_box == "101"
     %       total_distance_m = total_distance*box101_div;
     %   else if experiment_box == "103"
     %           total_distance_m = total_distance*box103_div;
     %       end
     %   end
    
        

     % saline plot
     s1 = subplot(1,5,1); hold on;
     % plot every 5th frame
     p1 = plot(sal_left_coord(start_time:5:stop_time,1),sal_left_coord(start_time:5:stop_time,2),'k');
     title_info = strcat(subject_ID, ' (', condition, ') - ', ' Saline');
     title(title_info, 'FontWeight', 'bold');
     set(gca,'xtick',[], 'ytick', []);
     box on

     % fentanyl50 plot
     s2 = subplot(1,5,2); hold on;
     % plot every 5th frame
     p1 = plot(fent50_left_coord(start_time:5:stop_time,1),fent50_left_coord(start_time:5:stop_time,2),'k');
     title_info = strcat(subject_ID, ' (', condition, ') - ', ' Fentanyl 50ug');
     title(title_info, 'FontWeight', 'bold');
     set(gca,'xtick',[], 'ytick', [])
     box on

     % fentanyl100 plot
     s3 = subplot(1,5,3); hold on;
     % plot every 5th frame
     p1 = plot(fent100_left_coord(start_time:5:stop_time,1),fent100_left_coord(start_time:5:stop_time,2),'k');
     title_info = strcat(subject_ID, ' (', condition, ') - ', ' Fentanyl 100ug');
     title(title_info, 'FontWeight', 'bold');
     set(gca,'xtick',[], 'ytick', [])
     box on

     % fentanyl500 plot
     s4 = subplot(1,5,4); hold on;
     % plot every 5th frame
     p1 = plot(fent500_left_coord(start_time:5:stop_time,1),fent500_left_coord(start_time:5:stop_time,2),'k');
     title_info = strcat(subject_ID, ' (', condition, ') - ', ' Fentanyl 500ug');
     title(title_info, 'FontWeight', 'bold');
     set(gca,'xtick',[], 'ytick', [])
     box on

     % coc20 plot
     s5 = subplot(1,5,5); hold on;
     % plot every 5th frame
     p1 = plot(coc20_left_coord(start_time:5:stop_time,1),coc20_left_coord(start_time:5:stop_time,2),'k');
     title_info = strcat(subject_ID, ' (', condition, ') - ', ' Cocaine 20mg');
     title(title_info, 'FontWeight', 'bold');
     set(gca,'xtick',[], 'ytick', [])
     box on


     % printing out distanced traveled info because I genuinely cannot figure
     % out how to export the information into a readable .csv file
     distance_results = (strcat(string(subject_ID), ',', string(condition), ',', string(sal_total_dist), ',', string(fent50_total_dist), ',', string(fent100_total_dist), ',', string(fent500_total_dist), ',', string(coc20_total_dist)));
     total_distance_traveled = [total_distance_traveled  distance_results];
     %   save plots in PDF
     %     print(sprintf('%s_OF_filtered_dose-response', subject_ID),'-dpdf');
    end
        
end

for x = 1:length(total_distance_traveled)
    disp(total_distance_traveled(x))
end