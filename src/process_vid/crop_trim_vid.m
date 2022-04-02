
%% Create video objects
% % Pathing
clearvars; close all

cd('C:\gradSchool\courses\me354\project')

dir_vids        = '.\videos\mica_purple';
filename_in     = 'sink_vortex_mica_purp_1.mp4';
filename_out    = 'sink_vortex_3_mica_purp';
file_type_out   = 'MPEG-4';

% % Create video objects
vid_obj_in      = VideoReader([dir_vids '\' filename_in]);
fps             = vid_obj_in.FrameRate;
dur             = vid_obj_in.Duration;

%% Settings for Crop and Trim 
start_frame = 150;
end_frame   = 1200;
crop_vid    = true;
rotate_vid  = true;
rot_angle   = 90;
% Remove first 1 second and last 2 seconds
% start_frame = floor(1);
% end_frame   = vid_obj.NumFrames - floor(0);

%% Crop and Trim Frames
f = 1;
f_t = 1; % f_trimmed
while hasFrame(vid_obj_in)
    % Read frame
    frame = readFrame(vid_obj_in);
    if rotate_vid
        frame = imrotate(frame, rot_angle);
    end
    if f == 1 && crop_vid
        [~, crop_region] = imcrop(frame);
        close
    end
    % Process image if it is within our trim limits
    if start_frame < f && f < end_frame
        if crop_vid
            frames(:,:,:,f_t) = imcrop(frame, crop_region);
        else
            frames(:,:,:,f_t) = frame;
        end
        f_t = f_t + 1; % trim frame counter
    end
    f = f + 1; % total frame counter
end
[~,~,~,num_frames] = size(frames);

%% View Video
view_frames(frames, fps);

%% Write output video
vid_obj_out = write_video(frames, filename_out, file_type_out);