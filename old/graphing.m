% Open Field Graphing
%
% Sjulson Lab - Albert Einstein College of Medicine
% Kelly Clemenza - kelly.clemenza@einseteinmed.org
% So many thanks to Elie Fermino de Oliveira for helping!!
% 
% edited by Luke, 2020-12-05

select_type = 1;
origin = pwd;
color_theme = '#000000';
header2 = 15;
header3 = 15;

N = 50000; % only analyze this many data points to ensure the sessions are the same length

%get the csv file on the folder

filelist = {
    'FSA028_controlDLC_resnet50_openfieldtracking_nocablesDec3shuffle1_1030000.csv'
    'FSA029_controlDLC_resnet50_openfieldtracking_nocablesDec3shuffle1_1030000.csv'
    'FSA030_LAMuOR-highDLC_resnet50_openfieldtracking_nocablesDec3shuffle1_1030000.csv'
    'FSA031_LAMuOR-lowDLC_resnet50_openfieldtracking_nocablesDec3shuffle1_1030000.csv'
    'FSA032_LAMuOR-lowDLC_resnet50_openfieldtracking_nocablesDec3shuffle1_1030000.csv'
    'FSA034_LAMuOR-highDLC_resnet50_openfieldtracking_nocablesDec3shuffle1_1030000.csv'
    };
plot_which = 6; % which one to plot/calculate


csv_f = dir(filelist{plot_which}); 

csv_file = readtable(fullfile(csv_f.folder,csv_f.name));
%extract information (needs to be generalized)
temp = csv_file{3:end,1};
frame_num = csv_file{3:end,2:3};
temp = csv_file{3:end,2:3};
left_coord = csv_file{3:end,2:3};
temp = csv_file{3:end,5:6};
% p1 = plot(left_coord(:,1),left_coord(:,2),'k');

total_dist = dist(left_coord(1:N,1), left_coord(1:N,2))


% 
% p1 = figure;plot(left_coord(:,1),left_coord(:,2),'k');
% title('FSA031 (LAMuOR 1:1000)', 'FontSize',header2, 'FontWeight', 'bold');
% xticklabels(0)
% yticklabels(0)
%    


   %    legend([p1,p2],'active Pokes','inactive Pokes','Location','NorthWest','FontSize',12);
   %    legend('boxoff')

% print(csv_f, '-dpdf');

% for calculating total distance traveled
function z = dist(x, y)
Xsq = diff(x).^2;
Ysq = diff(y).^2;
Zsq = Xsq + Ysq;
z = sum(sqrt(Zsq));

end