%%MAIN
clearvars; close all; clc
restoredefaultpath
wd = ('C:\gradSchool\courses\me354\project');
pause(3)

%% Add paths
addpath([wd '\code\plot\'])
addpath([wd '\code\process_data\'])
addpath([wd '\code\process_image\'])
addpath([wd '\code\read_write\'])
addpath([wd '\code\edit_vid\'])

%% User inputs
run_num = 5;
rot_angle = 90;
dia_drain = 3.4*2.54; % [cm] drain is 3.4 inches in diameter
crop_side_length_cm = dia_drain*2; 

%% Load video
run_str = sprintf('run%03d', run_num);
filename = [run_str '.mp4'];
dir_vids = [wd '\data\' run_str '\raw\video\'];
vid_filepath = [dir_vids filename];
vid_obj = VideoReader(vid_filepath);
fps = vid_obj.FrameRate;
dur = vid_obj.Duration;

%% Play video
implay(vid_filepath)

%% Select start, end frames for trimming
start_frame = 195;
end_frame = 1295;

%% Get raw frames from video
[frames_raw, frame_ref] = vid_obj_to_frames(vid_obj, start_frame,...
    end_frame);
% write_vid(frames_raw, 'test.mp4', 'MPEG-4')

%% Process frames
filename_out_vid_gray = [wd '\data\' run_str '\processed\videos\' ...
    run_str '_vid_gray'];
filename_out_vid_bw = [wd '\data\' run_str '\processed\videos\' ...
    run_str '_vid_gray_bw'];
dir_processed_frames = [wd '\data\' run_str '\processed\images\' run_str];

[frames_comp_gray, frames_bw, vid_obj_out_gray, vid_obj_out_gray_bw] =...
    process_img(frames_raw, filename_out_vid_gray, filename_out_vid_bw, ...
    dir_processed_frames);

%% Crop, trim, and center video
vid_filepath_cropped = [dir_vids run_str '_trimmed_cropped.mp4'];
[vid_obj_bw_cr, frames_bw_cr, o_coords, cm_per_pixel] = ...
    crop_center_vid(frames_bw, vid_filepath_cropped, rot_angle,...
                    crop_side_length_cm, dia_drain, frame_ref);

%% Analyze the binary frames for the characteristics of the core
[core_props_struct, core_props_tbl] = ...
    detect_core(frames_bw_cr, o_coords, cm_per_pixel, run_num);
save([wd '\data\' run_str '\processed\core_properties\' run_str ...
    '_tbl.mat'], 'core_props_tbl');
save([wd '\data\' run_str '\processed\core_properties\' run_str ...
    '_struct.mat'], 'core_props_struct');

%% Plot
plot_core_props(run002, 30, .9);

%% Mesh

%% Concatenate the data
tbl_all = [run002; run003; run004; run005];

%% Plot over multiple realizations
plot_core_props_all(tbl_all, 30);

%% Histogram
figure('Color', 'w')
    subplot(1,2,1)
        histogram(tbl_all.x_c, 'Normalization', 'pdf')
        xlabel('$x_c$, cm')
        ylabel('PDF')
        xlim([-8 8])
        ylim([0 1.3])
        set(gca, 'fontsize', 16)
    subplot(1,2,2)
        histogram(tbl_all.y_c, 'Normalization', 'pdf')
        xlabel('$y_c$, cm')
        ylabel('PDF')
        xlim([-8 8])
        ylim([0 1.3])
        set(gca, 'fontsize', 16)
        
%% Plot over time

