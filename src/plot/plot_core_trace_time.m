function [] = plot_core_trace_time(x_c, y_c, t, col)
%%plot_core_trace_time plots a line trace of the location of the core
%%location over time
%
%Inputs
%   x_c: [double array] an array of x-locations for a given dataset
%   y_c: [double array] an array of y-locations for a given dataset
%   y_c: [double array] an array of y-locations for a given dataset
%   col: [char] or [double array] a string of the desired color per
%   Matlab's standard available colors, or a 3x1 RGB double array for
%   customer colors
%
%Outputs
%   none
%
%Example
%   x_c = rand(100, 1) - 1/2;
%   y_c = rand(100, 1) - 1/4;
%   t = linspace(0, length(x_c) / fps, length(x_c))
%   figure
%   plot_core_trace_time(x_c, y_c, t, [0.4, 0.2, 0.5])

plot3(x_c, y_c, t, 'Color', col, 'marker', '.', 'linestyle', '-')
hold on
zlabel('$t''$, s', 'Interpreter', 'latex')
set(gca, 'ZDir', 'reverse')
xlabel('$x_{centroid}$, cm', 'Interpreter', 'latex')
ylabel('$y_{centroid}$, cm', 'Interpreter', 'latex')
format_fig()

end