function new_pos_struct = clean_tracking(pos_struct, timevec)

% function new_pos_struct = clean_tracking(pos_struct)
%
% Interface for manually deleting bad points from motion tracking
% estimates.
%
% This function takes a position struct (pos_struct) with the following
% fields:
% pos_struct.timevec -> the vector of timestamps
% pos_struct.xpos -> the X coordinate position
% pos_struct.ypos -> the Y coordinate position
%
% After you manually delete the bad points, it makes a new position struct
% with the bad points interpolated over, unless there is a stretch of
% greater than NaNthresh bad points (default = 300), in which case it will
% leave them as NaNs and not try to interpolate.
% 
% Luke Sjulson, 2021-09-19


% %% for testing
% clear all
% close all
% clc
% load FSA061_TEST_struct.mat
% pos_mat = FSA061_TEST_struct;
% basedir = pwd;
% global pos_struct s;
% pos_struct.xpos = pos_mat(:,3);
% pos_struct.ypos = pos_mat(:,2);
% pos_struct.timevec = pos_mat(:,1) * 1/30;


%% start of actual function

% parameters
global pos_struct s;
NaNthresh = 300; % about 10 seconds. Runs of NaNs longer than this won't be interpolated over

%%

disp('Draw polygon around reflection points to remove from the movement ')
disp('record. Left click to make points, right click to erase points,')
disp('and middle click (or shift-click) to close the polygon. Close the figure to ')
disp('advance to the next one.');

% calculating velocities

length(pos_struct.xvel)
pos_struct.yvel = [0; diff(pos_struct.ypos(:))];


%% erase reflections from pos_struct.xpos

% make scatterplot, X vs Y
% f1 = figure('name', basedir);
f1 = figure;
s(1) = subplot(3,3,[1 4]);
p0 = scatter(pos_struct.ypos, pos_struct.xpos, 'b.');

% plot velocity
s(3) = subplot(3, 3, [8 9]);
p2 = plot(pos_struct.timevec, pos_struct.xvel, 'b');
title('X velocity');

% plot raw xpos vs time
s(2) = subplot(3,3,[2 3 5 6]);
linkaxes([s(1) s(2)], 'y');
p1 = plot(pos_struct.timevec, pos_struct.xpos, 'b');
title('X position, shift-click to close polygon')
% Create push button to draw a polygon
btnDraw = uicontrol('Style', 'pushbutton', 'String', 'Draw Polygon', 'Position', [20 20 100 30], 'Callback', 'global s; drawpoly1(s, ''X_coord'');');

linkaxes([s(2) s(3)], 'x');

while ishandle(f1)
    pause(0.5);
end


%% erase reflections from pos_struct.ypos

% make scatterplot, X vs Y
% f1 = figure('name', basedir);
f1 = figure;
s(1) = subplot(3,3,[1 4]);
p0 = scatter(pos_struct.xpos, pos_struct.ypos, 'r.');

% plot velocity
s(3) = subplot(3, 3, [8 9]);
pos_struct.timevec
p2 = plot(pos_struct.timevec, pos_struct.yvel, 'r');

% plot raw xpos vs time
s(2) = subplot(3,3,[2 3 5 6]);
linkaxes([s(1) s(2)], 'y');
p1 = plot(pos_struct.timevec, pos_struct.ypos, 'r');
title('Y position, shift-click to close polygon')
% Create push button to draw a polygon
btnDraw = uicontrol('Style', 'pushbutton', 'String', 'Draw Polygon', 'Position', [20 20 100 30], 'Callback', 'global s; drawpoly1(s, ''Y_coord'');');

linkaxes([s(2) s(3)], 'x');

while ishandle(f1)
    pause(0.5);
end


%% look for stretches of NaNs that are longer than a threshold - leave those
% as NaNs, but cut all the rest out prior to interpolation
X_coord_good = pos_struct.xpos;
Y_coord_good = pos_struct.ypos;

positionIsNan = find(isnan(X_coord_good)); % indices of NaNs
NaNflag = zeros(size(positionIsNan));

% coming from left side
for idx = 1:length(positionIsNan)-NaNthresh
    if positionIsNan(idx)+NaNthresh == positionIsNan(idx+NaNthresh)
        NaNflag(idx:idx+NaNthresh) = 1;
    end
end
% coming from right side
for idx = length(positionIsNan):-1:1+NaNthresh
    if positionIsNan(idx)-NaNthresh == positionIsNan(idx-NaNthresh)
        NaNflag(idx:-1:idx-NaNthresh) = 1;
    end
end
keepFlags = ones(size(X_coord_good));
keepFlags(positionIsNan(NaNflag==0)) = 0;
timevec_good = pos_struct.timevec(keepFlags==1);
X_coord_good = X_coord_good(keepFlags==1);
Y_coord_good = Y_coord_good(keepFlags==1);


% making new position struct
new_pos_struct.timevec = pos_struct.timevec;
new_pos_struct.xpos = interp1(timevec_good, X_coord_good, pos_struct.timevec);
new_pos_struct.ypos = interp1(timevec_good, Y_coord_good, pos_struct.timevec);



