function [] = plot_core_props_all(tbl_all, fps)

dt      = 1/fps; 
runs    = unique(tbl_all.run);

for i = 1:length(runs)
    % % Filter by ith run
    run = runs(i);
    leg{i} = sprintf('Run %d', run);
    run_start = find(tbl_all.run == run, 1, 'first');
    run_end = find(tbl_all.run == run, 1, 'last');
    tbl_temp = tbl_all(run_start:run_end, :);
    
    % % Calculate time start (when core area hits its first maximum)
    idx_start   = find(tbl_temp.area == max(tbl_temp.area(tbl_temp.frame_num < 400)));
    tbl         = tbl_temp(idx_start:size(tbl_temp,1), :);
    t           = dt * 1:length(tbl.frame_num); % timeseries
    

    var_labels  = {'Area', 'Circularity', 'Equivalent Diameter', 'Perimeter', 'Dist, Centroid to Drain'};
    var_names   = {'area', 'circularity', 'diameter', 'perimeter', 'd_o_c'};
    units       = {', cm$^2$', '', ', cm', ', cm', ', cm'};
    cols        = {'b', 'g', [0.4 0.4 0.4], 'm', 'k'}; 

    % % Perimeter 
    for v = 1:length(var_names)
    vals = tbl.(var_names{v});
    figure(v)
        hold on
        plot(t, vals, 'linewidth', 1.5, 'color', cols{i})
        xlabel('$t''$, s')
        ylabel([var_labels{v} units{v}])
        format_cf()
        if i == length(runs)
            legend(leg)
        end
    end
    
    plot_2d(tbl, cols{i})
    if i == length(runs)
        legend(leg)
    end
    plot_3d(tbl, t, cols{i});
    if i == length(runs)
        legend(leg)
    end
end
function [] = plot_2d(tbl, col)
    figure(6)
        plot(tbl.x_c, tbl.y_c, 'Color', col, 'marker', '.', 'linestyle', '-')
        hold on
        xlabel('$x_{centroid}$, cm')
        ylabel('$y_{centroid}$, cm')
        format_cf()
end
function [] = plot_3d(tbl, t, col)
    figure(7)
        plot3(tbl.x_c, tbl.y_c, t, 'Color', col, 'marker', '.', 'linestyle', '-')
        hold on
        zlabel('$t''$, s')
        set(gcf, 'Color', 'w')
        set(gca, 'fontsize', 16)
        grid on; grid minor
        box on
        set(gca, 'ZDir', 'reverse')
        xlabel('$x_{centroid}$, cm')
        ylabel('$y_{centroid}$, cm')
        format_cf()
end

function [] = format_cf()
    set(gcf, 'Color', 'w')
    set(gca, 'fontsize', 16)
    grid on; grid minor
    box on
end

end