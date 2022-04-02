function [] = vid_to_frames(dir_in, filename_in, dir_out)

vid_obj     = VideoReader([dir_in '\' filename_in]);
fps         = vid_obj.FrameRate;
dur         = vid_obj.Duration;

%% Process frames
f = 1;
while hasFrame(vid_obj)
    % Read frame
    
    if f == 1
        frame = readFrame(vid_obj);
        dims_vid = size(frame);
        num_dims = length(dims_vid);
        if num_dims == 2
            frames(:,:,f) = frame;
        elseif num_dims == 3
            frames(:,:,:,f) = frame;
        end
    end
    if num_dims == 2
        frames(:,:,f) = readFrame(vid_obj);
    elseif num_dims == 3
        frames(:,:,:,f) = readFrame(vid_obj);
    end
    f = f + 1;
end

num_frames = f-1;
%% 

for f = 1:num_frames
    fig_name = sprintf('%s\\fig%04d.tiff', dir_out, f);
    imwrite(frames(:,:,:,f), fig_name);
end

end