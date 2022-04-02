function [] = view_frames_subplot(frames1, frames2, fps)

[~,~,~,num_frames] = size(frames1);

figure
for f = 1:num_frames
    if f == 1
        subplot(1,2,1)
            ax1 = gca;
            h1  =	imshow(frames1(:,:,:,f));
            set(ax1, 'XLimMode', 'manual', 'YLimMode', 'manual') % set limits
        subplot(1,2,2)
            ax2 = gca;
            h2  =	imshow(frames2(:,:,:,f));
            set(ax2, 'XLimMode', 'manual', 'YLimMode', 'manual') % set limits
    else
        set(h1, 'CData', frames1(:,:,:,f)) % replace image data
        set(h2, 'CData', frames2(:,:,:,f)) % replace image data
    end
    pause(1/fps)
end

end