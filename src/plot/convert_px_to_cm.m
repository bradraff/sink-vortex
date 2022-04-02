function cm_per_px = convert_px_to_cm(frame, lengthscale, coords_center)
%%convert_px_to_mm

x_c = coords_center(1);
y_c = coords_center(2);

figure
    imshow(frame)
    hold on
    plot(x_c, y_c, 'g+')
    % Allow user to set zoom
    zoom on;
    pause()
    zoom off;
    % Prompt user to select opposite ends of the drain to determine its
    % diameter
    [x1, y1] = ginput(1);
    plot(x1, y1, 'r+')
    [x2, y2] = ginput(1);
    plot(x2, y2, 'r+')
close

distance_pixels = sqrt( (x1 - x2)^2 + (y1 - y2)^2 );
cm_per_px = lengthscale / distance_pixels;

end 