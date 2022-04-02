function [] = view_overlaid_frames(frames, props, fps)

frames_with_props   = cat(1, props.FrameNum); 
[~,~,~,num_frames]  = size(frames);


figure('Position', [0 0 600 400], 'Color', 'w')
for f = 1:num_frames
        imshow(frames(:,:,:,f), 'InitialMagnification', 'fit');
    if ~isempty(intersect(f, frames_with_props))
        idx = find(frames_with_props == f);
        hold on
        plot(props(idx).Boundaries(:,1), props(idx).Boundaries(:,2), 'g', 'LineWidth', 2)
        plot(props(idx).Centroid(1), props(idx).Centroid(2), 'r.', 'MarkerSize', 12)
        hold off
    end
    pause(1/fps)
end

end

% figure