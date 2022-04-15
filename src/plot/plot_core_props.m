%% 
core_props_tbl.time = core_props_tbl.frame_num / 30;
data = tbl_all;
x_var_name_array = ["x_c", repmat("time", [1, 5] )];
y_var_name_array = ["y_c", "area", "circularity", "diameter",...
    "perimeter", "d_o_c"];
x_var_label_array = ["$x_c$", repmat("time", [1, 5] )];
y_var_label_array = {"$y_c$", 'Area', 'Circularity', 'Equivalent Diameter',...
    'Perimeter', 'Dist, Centroid to Drain'};
x_var_unit_array = [", cm", ", s", ", s", ", s", ", s", ", s"];
y_var_unit_array = [", cm", ", cm$^2$", "", ", cm", ", cm", ", cm"];

x_label_array = x_var_label_array + x_var_unit_array;
y_label_array = y_var_label_array + y_var_unit_array;

group_var_name_array = repmat("run_num", size(x_var_label_array));
group_label_array = repmat("Run", size(x_var_label_array));

for i = 1:length(x_var_name_array)
    figure
    plot_x_y_group(data, x_var_name_array(i), y_var_name_array(i),...
        group_var_name_array(i), x_label_array(i), y_label_array(i),...
        group_label_array(i))
end

