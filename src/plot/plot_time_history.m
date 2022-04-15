function [] = plot_time_history(data, var_name, var_label, var_units)

g = gscatter(data.time_prime, data.(var_name), data.run_num);
set(g, 'linestyle', '-')
leg = get(gca, 'legend');
leg.Title.String = 'Run';
xlabel('$t''$, s')
ylabel([var_label var_units])
format_fig()

end