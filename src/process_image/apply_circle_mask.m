function [mask, x_mesh, y_mesh] = apply_circle_mask(radius, center, frame_width, frame_height)
%%apply_circle_mask determines all of the points in a 2D frame within a
%%circular mask and outputs a 2D array of logicals, with 1 representing
%%inside the mask
%
%Inputs
%   radius: [double]; pixels; radius of the mask circle 
%
%   center: [double]; pixels; 1D array with two elements indicating the x-
%   and y-location of the center of the circular mask
%
%   frame_width: [int]; pixels; width of the frame
%
%   frame_height: [int]; pixels; height of the frame
%
%Outputs
%   mask: [logical] 2D logical array of size [frame_width, frame_height]
%   where values of 1 represent coverage by the mask

% Create grid of pixel locations
[x_mesh, y_mesh] = meshgrid(1:frame_width, 1:frame_height);

% Calculate distance from circle center to each pixel
d = ((x_mesh - center(1)).^2 + (y_mesh - center(2)).^2).^0.5;

% Calculate mask
mask = d <= radius;

%%Example of overlaying the mask on an existing plot:
% hold on; 
% plot(x_mesh(mask), y_mesh(mask), 'r.')
end
