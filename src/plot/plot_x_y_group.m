function [] = plot_x_y_group(data, x, y, group, x_label, y_label, group_label)
%%plot_x_y_group plots a line of the location of input data and groups by
%%the input grouping variable.
%
%Inputs
%   data: [table] or [struct] a table or struct of the data of interest.
%   Must contain variables x, y, and group.
%
%   x: [string] or [char] a string or character string of the x-axis
%   variable of interest within data
%
%   y: [string] or [char] a string or character string of the y-axis
%   variable of interest within data
%
%   group: [string] or [char] a string or character string of the grouping
%   variable of interest within data; each group will be plotted within its
%   own group data as a separate line
%
%   x_label: [string] or [char] a string or character string for the x-axis
%   label
%
%   y_label: [string] or [char] a string or character string for the y-axis
%   label
%
%   group_label: [string] or [char] a string or character string of the
%   grouping variable name for labeling purposes of the legend title
%
%%Outputs
%   none
%
%%Example
%   data = table();
%   time_array = [1, 2, 3, 4, 5, 6]';
%   data.time = repmat(time_array, [2, 1]);
%   data.var_a = rand(size(data.time)) - 1/2;
%   data.var_b = rand(size(data.time)) - 1/4;
%   test_number = repmat([1, 2], size(time_array));
%   data.test_number = test_number(:);
%   plot_x_y_group(data, "var_a", "var_b", "test_number", "$A$, inches",...
%   "$B$", "Test")

g = gscatter(data.(x), data.(y), data.(group));
set(g, 'linestyle', '-')
leg = get(gca, 'legend');
leg.Title.String = group_label;
xlabel(x_label, 'Interpreter', 'latex')
ylabel(y_label, 'Interpreter', 'latex')
format_fig()

end
