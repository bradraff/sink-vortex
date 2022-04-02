function [frames, frame_ref] = vid_obj_to_frames_unopt(vid_obj, varargin)

if ~isempty(varargin)
   start_frame = varargin{1};
   end_frame = varargin{2};
end

%% Read frames
f = 1;
f_t = 1;
disp('Reading the frames within the trimmed limits')
while hasFrame(vid_obj)
    frame = readFrame(vid_obj);
    if f == 1
        dims_vid = size(frame);
        num_dims = length(dims_vid);
    end
    if mod(f, 20) == 0
        fprintf('Frame %d\n', f)
    end
    % Process image if it is within our trim limits
    if start_frame < f && f < end_frame
        % Crop the frame
        if num_dims == 2
            frames(:,:,f_t) = frame;
        elseif num_dims == 3
            frames(:,:,:,f_t) = frame;
        end
        f_t = f_t + 1; % Counter for trimmed frames
    end
    f = f + 1;
end
frame_ref = frame; % last frame is a reference frame for scaling, etc.
end