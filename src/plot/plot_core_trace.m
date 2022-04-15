function [] = plot_core_trace(x_c, y_c, run_num)
%%plot_core_trace plots a line trace of the location of the core location
%%over time
%
%Inputs
%   x_c: [double array] an array of x-locations for a given dataset
%   y_c: [double array] an array of y-locations for a given dataset
%
%Outputs
%   none
%
%Example
%   x_c = rand(100, 1) - 1/2;
%   y_c = rand(100, 1) - 1/4;
%   plot_core_trace(x_c, y_c)



plot(x_c, y_c, 'Color', col, 'marker', '.', 'linestyle', '-')
xlabel('$x_{centroid}$, cm', 'Interpreter', 'latex')
ylabel('$y_{centroid}$, cm', 'Interpreter', 'latex')
format_fig()

end