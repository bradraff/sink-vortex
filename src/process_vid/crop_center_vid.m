function [vid_obj_out, frames_out, o_coords, cm_per_pixel] = crop_center_vid(frames, filename_out, rot_angle, crop_side_length_cm, dia_drain, ref_frame, varargin)
%%plot_x_y_group plots a line of the location of input data and groups by
%%the input grouping variable.
%
%Inputs
%   franes: [unit8] 
%
%   filename_out: []
%
%   rot_angle: []
%
%   rot_angle: []
%
%   crop_side_length_cm: []
%
%   dia_drain: []
%
%   ref_frame: []
%
%%Outputs
%  vid_obj_out, frames_out, o_coords, cm_per_pixel

file_type_out = 'MPEG-4';

%% Crop, center, and rotate frames
disp('Rotating, cropping, and centering the video')
ref_frame = imrotate(ref_frame, rot_angle);

% Trim, crop, and center the video
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
            % User provided the cropped region
            crop_region = varargin{1};
            o_coords = [];
            cm_per_pixel = [];
        end
    end

    % Crop the frame
    frames_out(:,:,:,f) = imcrop(frame, crop_region);

end

%% Write output video
disp('Writing trimmed and cropped video')
vid_obj_out = write_vid(frames_out, filename_out, file_type_out);

end

%%TODO
%{
1. Break out crop_center_vid into multiple functions
2. Handle varargin more cleanly
3. Documentation
%}