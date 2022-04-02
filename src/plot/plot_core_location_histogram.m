function [] = plot_core_location_histogram(x_c, y_c)
%%plot_core_location_histogram plots a histogram of the location of the
%%vortex core.
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
%   plot_core_location_histogram(x_c, y_c)

figure('Color', 'w')

    % Determine x-axis limits
    x_axis_lim = max([x_c, y_c], [], 'all');

    % Subplot for x_c
    subplot(1,2,1)
        histogram(x_c, 'Normalization', 'pdf')
        xlabel('$x_c$, cm', 'Interpreter', 'latex')
        ylabel('PDF')
        y_lim_1 = get(gca, 'YLim');
        xlim([-x_axis_lim, x_axis_lim])
        set(gca, 'fontsize', 16)

    % Subplot for y_c
    subplot(1,2,2)
        histogram(y_c, 'Normalization', 'pdf')
        xlabel('$y_c$, cm', 'Interpreter', 'latex')
        ylabel('PDF')
        y_lim_2 = get(gca, 'YLim');
        xlim([-x_axis_lim, x_axis_lim])
        set(gca, 'fontsize', 16)

    % Calculate y limits
    y_lim = [0, max([y_lim_1(2), y_lim_2(2)])];

    % Set y limits
    subplot(1,2,1)
        ylim(y_lim)
    subplot(1,2,2)
        ylim(y_lim)
end