function vid_obj_out = write_vid_subplot(frames1, frames2, filename_out, file_type_out)

[~,~,~,num_frames] = size(frames1);
vid_obj_out        = VideoWriter(filename_out, file_type_out);
open(vid_obj_out)

h = figure('Color', 'white');
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
    writeVideo(vid_obj_out, getframe(h));
end
close(vid_obj_out)

end