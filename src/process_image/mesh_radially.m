function [x_mesh, y_mesh] = mesh_radially(center, d_array, angle_array)
%%mesh_radially creates a 2D x-y mesh of points that emanate from a central
%%point and at distances d_array and angles angle_array
%
%Inputs
%   center: [double]; pixels; [x, y] center location from which the mesh
%   originates / emanates
%
%   d_array: [int]; pixels; 1D array of distance from center of the mesh
%   outward
%
%   angle_array: [double]; rad; 1D array of angles along which the mesh
%   points align
%
%%Outputs
%   x_mesh: [double]; pixels; x-axis location of mesh points
%
%   y_mesh: [double]; pixels; y-axis location of mesh points

% % Create a mesh of distances and angles (radians)
[d_mesh, angle_mesh] = meshgrid(d_array, angle_array);

% % Create 2D x- and y-arrays corresponding points connected in a circle,
% then transpose to align columns axially instead of azimuthally
x_mesh = (d_mesh.*cos(angle_mesh) + center(1))';
y_mesh = (d_mesh.*sin(angle_mesh) + center(2))';

end
