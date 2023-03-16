clear all
loc = '/home/kelly/Documents/LAMUOR_PROJECT-DATA/Open_Field_Assay/LAMUOR-COHORT102/'
ID = '1nVzlq2DlNhWZBZcWgKoxA0qRe1YrCPoqouGWkF1yrew'
sheet_name = 'session_info';
url_name = sprintf('https://docs.google.com/spreadsheets/d/%s/gviz/tq?tqx=out:csv&sheet=%s', ID, sheet_name);
info_sheet = webread(url_name)

cohort = dir(loc);
cohort = cohort(3:14)
for x = 1:12(cohort.name)
    subject_loc = fullfile(loc, cohort(x).name);
    subject_dir = dir(subject_loc);
    subject_dir = subject_dir(3:7)
      for i = 1:5(subject_dir.name)
        session_loc = fullfile(subject_loc, subject_dir(i).name)
        cohort(x).name
        subject_dir(i).name
        if subject_dir(i).name == strcat(cohort(x).name, "_OF_COCA020mg")
            timepoint = "COCA020mg"
            timepoint_no = 4*3
        end
        if subject_dir(i).name == strcat(cohort(x).name, "_OF_FENT050ug")
            timepoint = "FENT050ug"
            timepoint_no = 1*3
        end
        if subject_dir(i).name == strcat(cohort(x).name, "_OF_FENT100ug")
            timepoint = "FENT100ug"
            timepoint_no = 2*3
        end
        if subject_dir(i).name == strcat(cohort(x).name, "_OF_FENT500ug")
            timepoint = "FENT500ug"
            timepoint_no = 3*3
        end
        if subject_dir(i).name == strcat(cohort(x).name, "_OF_VEHsaline")
            timepoint = "VEHsaline"
            timepoint_no = 4*3
        end

        session_info = struct("subject_ID", table2cell(info_sheet(x,1)), "tag_ID", table2cell(info_sheet(x,2)), "tx", table2cell(info_sheet(x,3)), "sex", table2cell(info_sheet(x,4)), "DOB", table2cell(info_sheet(x,5)), "timepoint", timepoint, "weight", table2cell(info_sheet(x,(6+timepoint_no))), "box_ID", table2cell(info_sheet(x, (7+timepoint_no))), "box_scale", table2cell(info_sheet(x,(8+timepoint_no)))); 
        save(fullfile(session_loc, 'session_info.mat'), 'session_info')  
      end
end


%         foldername = fullfile(loc, subject(x).name)
%         load(fullfile(foldername, dir(fullfile(foldername, '*_session_info.mat')).name))
%         new_data = load(fullfile(foldername, dir(fullfile(foldername, 'session_info.mat')).name))
% end

%             orig_file_find = dir(fullfile(session_loc, '*_session_info.mat')).name
%             session_info = load(fullfile(session_loc, orig_file_find)).session_info
%             session_info = rmfield(session_info, "weight")
%             session_info = rmfield(session_info, "mouse_info")
%             session_info = rmfield(session_info, "visual_stimulus")
%             session_info = rmfield(session_info, "gray_level")
%             session_info = rmfield(session_info, "vis_gratings")
%             session_info = rmfield(session_info, "vis_raws")
%             session_info = rmfield(session_info, "treadmill")
%             session_info = rmfield(session_info, "manual_date")
%             session_info = rmfield(session_info, "reward_size")
%             session_info = rmfield(session_info, "timeout_length")
% 
%             save(fullfile(session_loc, 'session_info.mat'), 'session_info')


%             new_sessinfo = struct2table(load(fullfile(session_loc, 'session_info.mat')).session_info)
%             session_info = table2struct([orig_sessinfo, new_sessinfo])
%             save(fullfile(session_loc, 'session_info.mat'), 'session_info')
       