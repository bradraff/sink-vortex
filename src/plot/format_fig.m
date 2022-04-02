function [] = format_fig()
    set(gcf, 'Color', 'w')
    set(gca, 'fontsize', 16)
    grid on; grid minor
    box on
end