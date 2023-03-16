function drawpoly(subplotPtr, whichOne)

% function drawpoly1(subplotPtr, whichOne)
%
% This function is used as a GUI callback by clean_tracking, which allows you to crop out reflections from the movement data.
%
% Luke Sjulson, 2015-12-18

global pos_struct;

[X,Y,p] = UISelect();

if strcmpi(whichOne, 'X_coord')
    
    % X position
    
    in = inpolygon(pos_struct.timevec, pos_struct.xpos, X, Y);
    tempxpos = pos_struct.xpos(in);
    tempypos = pos_struct.ypos(in);
    temptime = pos_struct.timevec(in);
    tempxvel = pos_struct.xvel(in);
    
    % update xpos vs time plot
    subplot(3,3,[2 3 5 6]);
    hold on
    p3 = scatter(temptime, tempxpos, 'g');

    % update X vs Y scatterplot
    subplot(3,3,[1 4])
    hold on
    p4 = scatter(tempypos, tempxpos, 'g');
    set(p4, 'LineWidth', 1);
    
    % update velocity
    subplot(3, 3, [8 9]);
    hold on
    p5 = scatter(temptime, tempxvel, 'g');

    qbtn = questdlg('Do you want to delete these points?', 'Question:', 'Yes', 'No', 'No');
    if strcmp(qbtn, 'Yes')
        pos_struct.xpos(in) = NaN;
        pos_struct.ypos(in) = NaN;
        pos_struct.xvel(in) = NaN;
        pos_struct.yvel(in) = NaN;
        delete(p);
        delete(p3);
        delete(p4);
        delete(p5);
        p1 = get(subplotPtr(1), 'Children'); % the scatterplot
        p2 = get(subplotPtr(2), 'Children'); % the plot figure
        p3 = get(subplotPtr(3), 'Children'); % the velocity figure
        set(p2(1), 'YData', pos_struct.xpos);
        set(p1(1), 'YData', pos_struct.xpos);
        set(p3(1), 'YData', pos_struct.xvel);
        
    elseif strcmp(qbtn, 'No')
        delete(p);
        delete(p3);
        delete(p4);
        delete(p5);
    end
        
elseif strcmpi(whichOne, 'Y_coord')

    % Y position
    
    in = inpolygon(pos_struct.timevec, pos_struct.ypos, X, Y);
    tempxpos = pos_struct.xpos(in);
    tempypos = pos_struct.ypos(in);
    temptime = pos_struct.timevec(in);
    tempyvel = pos_struct.yvel(in);
    
    % update Ypos vs time plot
    subplot(3,3,[2 3 5 6]);
    hold on
    p3 = scatter(temptime, tempypos, 'g');

    % update X vs Y scatterplot
    subplot(3,3,[1 4])
    hold on
    p4 = scatter(tempxpos, tempypos, 'g');
    set(p4, 'LineWidth', 1);
    
    % update velocity
    subplot(3, 3, [8 9]);
    hold on
    p5 = scatter(temptime, tempyvel, 'g');

    qbtn = questdlg('Do you want to delete these points?', 'Question:', 'Yes', 'No', 'No');
    if strcmp(qbtn, 'Yes')
        pos_struct.xpos(in) = NaN;
        pos_struct.ypos(in) = NaN;
        pos_struct.xvel(in) = NaN;
        pos_struct.yvel(in) = NaN;
        delete(p);
        delete(p3);
        delete(p4);
        delete(p5);
        p1 = get(subplotPtr(1), 'Children'); % the scatterplot
        p2 = get(subplotPtr(2), 'Children'); % the plot figure
        p3 = get(subplotPtr(3), 'Children'); % the velocity figure
        set(p2(1), 'YData', pos_struct.ypos);
        set(p1(1), 'YData', pos_struct.ypos);
        set(p3(1), 'YData', pos_struct.yvel);
        
    elseif strcmp(qbtn, 'No')
        delete(p);
        delete(p3);
        delete(p4);
        delete(p5);
    end
    
 
    

    
 
end



