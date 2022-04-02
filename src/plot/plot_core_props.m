function [] = plot_core_props(tbl, fps, t_start)

dt  = 1/fps; 
t   = dt * tbl.frame_num; % timeseries
idcs = t>t_start;

var_labels   = {'Area', 'Circularity', 'Equivalent Diameter', 'Perimeter', 'Distance, core centroid to drain center'};
var_names    = {'area', 'circularity', 'diameter', 'perimeter', 'd_o_c'};
units       = {', cm$^2$', '', ', cm', ', cm', ', cm'};
cols        = {'b', 'r', [0.4 0.4 0.4], 'm', 'k'}; 

% % Perimeter 
for v = 1:length(var_names)
vals = tbl.(var_names{v});
vals = vals(idcs);
figure()
    plot(t(idcs), vals, 'linewidth', 1.5, 'color', cols{v})
    xlabel('$t$, s')
    ylabel([var_labels{v} units{v}])
    format_cf()
end

figure 
    plot(tbl.x_c(idcs), tbl.y_c(idcs), 'r', 'marker', '.', 'linestyle', '-')
    xlabel('$x_{centroid}$, cm')
    ylabel('$y_{centroid}$, cm')
    format_cf()

figure
    plot3(tbl.x_c(idcs), tbl.y_c(idcs), t(idcs), 'r', 'marker', '.', 'linestyle', '-')
    zlabel('$t$, s')
    set(gcf, 'Color', 'w')
    set(gca, 'fontsize', 16)
    grid on; grid minor
    box on
    set(gca, 'ZDir', 'reverse')
    xlabel('$x_{centroid}$, cm')
    ylabel('$y_{centroid}$, cm')
    format_cf()
    
function [] = format_cf()
    set(gcf, 'Color', 'w')
    set(gca, 'fontsize', 16)
    grid on; grid minor
    box on
end

end