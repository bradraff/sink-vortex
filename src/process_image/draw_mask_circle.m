function [radius, center] = draw_mask_circle()
% Reference:
% https://www.mathworks.com/help/images/use-wait-function-after-drawing-roi-example.html

% Plot reference frame
title('Draw circle for PIV mask and double-left click once finished positioning it')

% Draw circle
c = drawcircle;

% Get radius and center after the user ends the wait
[radius, center] = custom_wait(c);

end

function [radius, center] = custom_wait(h)

% Listen for mouse clicks on the ROI
l = addlistener(h, 'ROIClicked', @clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);

% Return the current radius and center
radius = h.Radius;
center = h.Center;

end

function clickCallback(~, evt)

if strcmp(evt.SelectionType, 'double')
    uiresume;
end

end