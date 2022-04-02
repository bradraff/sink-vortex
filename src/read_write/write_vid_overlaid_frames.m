function vid_obj_out = write_vid_overlaid_frames(frames, props, filename_out)

[~,~,~,num_frames]  = size(frames); 
vid_obj_out         = VideoWriter(filename_out, 'MPEG-4');
open(vid_obj_out)

frames_with_props   = cat(1, props.FrameNum); 

figure('Position', [0 0 600 400], 'Color', 'w');
ax = gca;
for f = 1:num_frames
        imshow(frames(:,:,:,f), 'InitialMagnification', 'fit');
    if ~isempty(intersect(f, frames_with_props))
        idx = find(frames_with_props == f);
        hold on
        plot(props(idx).Boundaries(:,1), props(idx).Boundaries(:,2), 'g', 'LineWidth', 2)
        plot(props(idx).Centroid(1), props(idx).Centroid(2), 'r.', 'MarkerSize', 12)
        hold off
    end
    writeVideo(vid_obj_out, getframe(ax));
end

close(vid_obj_out)

end