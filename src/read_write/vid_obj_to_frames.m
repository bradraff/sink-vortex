function [frames, frame_ref] = vid_obj_to_frames(vid_obj, start_frame, end_frame)

%% Read frames
disp('Reading the frames within the trimmed limits')
% all_frames = cell(vid_obj.NumFrames, 1);
% all_frames(:) = {zeros(vid_obj.Height, vid_obj.Width, 4, 'uint8')};
% color_maps = cell(vid_obj.NumFrames, 1);
% color_maps(:) = {zeros(256, 3)};
% frames = struct(
f_t = 1;
for f = start_frame:end_frame
    frame = read(vid_obj, f);
    if f == start_frame
        dims_vid = size(frame);
        num_dims = length(dims_vid);
        % Get initial crop for reducing memory, not for a perfect centering
        % on the sink drain
        [frame, crop_region] = imcrop(frame);
        close
    end
    if mod(f, 20) == 0
        fprintf('Frame %d\n', f)
    end
    if num_dims == 2 && f > start_frame
        frames(:,:,f_t) = imcrop(frame, crop_region);
        f_t = f_t + 1;
    elseif num_dims == 3 && f > start_frame
        frames(:,:,:,f_t) = imcrop(frame, crop_region);
        f_t = f_t + 1;
    end
end
frame_ref = read(vid_obj, vid_obj.NumFrames); % last frame is a reference frame for scaling, etc.
frame_ref = imcrop(frame_ref, crop_region);
end