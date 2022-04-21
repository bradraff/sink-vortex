%% Prepare workspace and pathing
clearvars; close all; clc
restoredefaultpath
wd = pwd;
pause(3)

% Add paths
addpath('.\plot\')
addpath('.\process_data\')
addpath('.\process_image\')
addpath('.\read_write\')
addpath('.\process_vid\')

%% User inputs
run_num = 3;
rot_angle = 90;
dia_drain = 3.4*2.54; % [cm] drain is 3.4 inches in diameter
crop_side_length_bw_cm = dia_drain*2; 
crop_side_length_gray_cm = dia_drain*3; 
mask_radius = 2.5; % [cm] 

%% Load video
[vid_file_name, vid_dir_name] = uigetfile('All Files (*.*)', 'Pick a file');

%% File pathing
vid_file_path = fullfile(vid_dir_name, vid_file_name);
[~, vid_name, ~] = fileparts(vid_file_path);
img_dir = '..\data\processed\images\';
vid_dir = '..\data\processed\videos\';
dir_processed_frames = [img_dir vid_name];
filepath_out_vid_gray = fullfile(vid_dir, [vid_name '_vid_gray']);
filepath_out_vid_bw = fullfile(vid_dir, [vid_name '_vid_gray_bw']);
filepath_out_vid_gray_cropped = ...
    fullfile(vid_dir_name, [vid_name '_gray_trimmed_cropped.mp4']);
filepath_out_bw_cropped = ...
    fullfile(vid_dir_name, [vid_name '_bw_trimmed_cropped.mp4']);
filepath_out_ref_frame = fullfile(img_dir, [vid_name '_ref_frame.png']);

%% Read video and properties
vid_obj = VideoReader(vid_file_path);
fps = vid_obj.FrameRate;
dur = vid_obj.Duration;

%% Play video
implay(vid_file_path)

%% Select start, end frames for trimming
start_frame = 195;
end_frame = 1295;

%% Get raw frames from video
[frames_raw, frame_ref] = vid_obj_to_frames(vid_obj, start_frame,...
    end_frame);

%% Process frames
[frames_comp_gray, frames_bw, vid_obj_out_gray, vid_obj_out_gray_bw] =...
    process_img(frames_raw, filepath_out_vid_gray, filepath_out_vid_bw, ...
    dir_processed_frames);

%% Crop, trim, and center the black and white video
[vid_obj_bw_cr, frames_bw_cr, o_coords_bw, cm_per_pixel] = ...
    crop_center_vid(frames_bw, filepath_out_bw_cropped, rot_angle,...
                    crop_side_length_bw_cm, dia_drain, frame_ref);

%% Crop, trim, and center the grayframe video for use in PIV
% % Crop region for gray video, based on coordinates of drain center used
% on BW video
crop_region =  [o_coords_bw(1) - crop_side_length_gray_cm/2 / cm_per_pixel,...
               o_coords_bw(2) - crop_side_length_gray_cm/2 / cm_per_pixel,...
               crop_side_length_gray_cm / cm_per_pixel,...
               crop_side_length_gray_cm / cm_per_pixel];

[vid_obj_gray_comp_cr, frames_gray_comp_cr, ~, ~] = ...
    crop_center_vid(frames_comp_gray, filepath_out_vid_gray_cropped, rot_angle,...
                    crop_side_length_gray_cm, dia_drain, frame_ref, crop_region);

%% Analyze the binary frames for the characteristics of the core
[core_props_struct, core_props_tbl] = ...
    detect_core(frames_bw_cr, o_coords_bw, cm_per_pixel, run_num);

%% Create circular mask centered on vortex core and output mask as .tif for use in PIV

for ii = 500:600%1:height(core_props_tbl)
    disp(ii)
    [mask_ii, x_mask_ii, y_mask_ii] = apply_circle_mask(mask_radius / cm_per_pixel, ...
        [core_props_tbl.x_c(ii) / cm_per_pixel, ...
        core_props_tbl.y_c(ii) / cm_per_pixel] + size(frames_gray_comp_cr, 1, 2) / 2, ...
        size(frames_gray_comp_cr, 2), ...
        size(frames_gray_comp_cr, 1) );
    mask(:, :, ii) = mask_ii;
    x_mask(:, :, ii) = x_mask_ii;
    y_mask(:, :, ii) = y_mask_ii;
    imwrite(mask_ii, ['..\data\processed\images\' vid_name '_frame_' num2str(ii) '.tif'])
end

%%
figure
for i = 500:600%size(mask, 3) 
    m = (mask(:, :, i));
    x = x_mask(:, :, i);
    y = y_mask(:, :, i);

    imshow(frames_gray_comp_cr(:,:,:,i))
    hold on
    s = scatter(x(m), y(m), 'filled');
    s.MarkerFaceColor = 'red';
    s.MarkerFaceAlpha = 0.01; % Need to set very low since density is high
    pause(1/30)
end

%% Save data
% save(['..\data\' run_str '\processed\core_properties\' run_str ...
%     '_tbl.mat'], 'core_props_tbl');
% save(['..\data\' run_str '\processed\core_properties\' run_str ...
%     '_struct.mat'], 'core_props_struct');


%% Extra

% %% Draw circular mask
% figure('units', 'normalized', 'Position', [0 0 .8 .8], 'Color', 'w')
% title('Watch video play and then decide where to place mask circle for PIV')
% for i = 1:size(frames_comp_gray, 4)
%     imshow(frames_comp_gray(:, :, :, i))
% end
% [radius, center] = draw_mask_circle();
% close
% 
% %% Output mask as .tiff for use in PIV
% [mask, x_mask, y_mask] = apply_circle_mask(radius, center, ...
%     size(frames_comp_gray, 1), size(frames_comp_gray, 2));
% imwrite(mask, ['..\data\processed\images\' vid_name '.tiff'])
