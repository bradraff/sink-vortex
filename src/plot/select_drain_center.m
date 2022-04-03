function [x_c, y_c] = select_drain_center(frame)
%%draw_circle_center

cnt = 1;
figure
imshow(frame)
hold on
while 1

    % Allow user to set zoom
    if cnt == 1
        title('Drag-to-zoom around drain perimeter, press any key to continue')
        zoom on;
        pause()
        zoom off;
    end

    % Prompt user to select center of drain, using a crosshair
    title('Left-click center of the drain, right click when finished')
    [x_c, y_c] = ginput(1); 
    selection = get(gcf, 'SelectionType'); 
    % Check if the user input was a right click
    if strcmpi(selection, 'alt') 
        x_c = x_temp;
        y_c = y_temp;
        break
    end
    plot(x_c, y_c, 'g+')
    x_temp = x_c;
    y_temp = y_c;
    cnt = cnt + 1;

end
close
fprintf('Center location is [%f %f]\n', x_c, y_c)

end 