function [] = view_frames(frames, fps)

[~,~,~,num_frames] = size(frames);

figure
ax = gca;
for f = 1:num_frames
    if f == 1
        h =	imshow(frames(:,:,:,f));
        set(ax, 'XLimMode', 'manual', 'YLimMode', 'manual') % set limits
    else
        set(h, 'CData', frames(:,:,:,f)) % replace image data
    end
    pause(1/fps)
end

end