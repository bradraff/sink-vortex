function vid_obj_out = write_vid(frames, filename_out, file_type_out)

[~,~,~,num_frames]  = size(frames); 
vid_obj_out         = VideoWriter(filename_out, file_type_out);
open(vid_obj_out)

figure
ax = gca;
for f = 1:num_frames
    if f ==1
        h =	imshow(frames(:,:,:,f));
        set(ax, 'XLimMode', 'manual', 'YLimMode', 'manual') % set limits
    else
        set(h, 'CData', frames(:,:,:,f)) % replace image data
    end
    writeVideo(vid_obj_out, getframe(ax));
end
close(vid_obj_out)

end