function [vid_obj_out, frames_out, o_coords, cm_per_pixel] = crop_trim_center_vid(frames, filename_out, start_frame, end_frame, rot_angle, crop_side_length_cm, dia_drain, ref_frame, varargin)
%

%% Pathing
file_type_out   = 'MPEG-4';

%% Crop and Trim Frames
f_t = 1;
disp('Trimming, cropping, and centering the video')
% Trimming, cropping, and centering the video
for f = 1:size(frames, 4)
    if mod(f, 20) == 0
        fprintf('Frame %d\n', f)
    end
    if rot_angle ~= 0
        frame = imrotate(frames(:,:,:,f), rot_angle);
    else
        frame = frames(:,:,:,f);
    end
    if f == 1
        if isempty(varargin)
            % Determine center of drain
            [x_c, y_c] = select_drain_center(ref_frame);
            o_coords = [x_c, y_c]; % Coordinates of the 'origin', o
            % Determine scale of photo
            cm_per_pixel = convert_px_to_cm(ref_frame, dia_drain, [x_c, y_c]);
            % Determine length of one side of the cropped region, in pixels
            crop_side_length_px = crop_side_length_cm / cm_per_pixel;
            % Determine cropped region based on scale
            crop_region = [ x_c - crop_side_length_px/2,...
                            y_c - crop_side_length_px/2,...
                            crop_side_length_px, crop_side_length_px];
        else
            crop_region = varargin{1};
        end
    end
    % Process image if it is within our trim limits
    if start_frame < f && f < end_frame
        % Crop the frame
        frames_out(:,:,:,f_t) = imcrop(frame, crop_region);
        f_t = f_t + 1; % Counter for trimmed frames
    end

end

%% View Video
% disp('Playing video for verification of cropping quality')
% view_frames(frames_out, 30);

%% Write output video
disp('Writing trimmed and cropped video')
vid_obj_out = write_vid(frames_out, filename_out, file_type_out);

end