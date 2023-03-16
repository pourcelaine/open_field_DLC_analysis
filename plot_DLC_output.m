
function [DLC_xy_filtered_downsampled] = plot_DLC_output(i, x, analysis_window, DLC_xy_filtered_downsampled, analysis_dir, subject_ID, tx, timepoint_list, box_scale)

fig = figure(i); fig.Position = [0 0 2500 350];, set(fig, 'Papersize', [24 7])

subplot(1,5,x); 
plot_x = DLC_xy_filtered_downsampled(analysis_window(1):analysis_window(2),2)*box_scale
plot_y = DLC_xy_filtered_downsampled(analysis_window(1):analysis_window(2),3)*box_scale
plot(plot_x, plot_y);    
title(strcat(subject_ID, ' - ', tx, ' - ',  timepoint_list, ' (', string(box_scale), 'x Scale)'));

% % % % save PDF files
saveas(fig, fullfile(strcat(analysis_dir, 'FIGURES/', subject_ID, '_OF_trajectories.pdf')));
