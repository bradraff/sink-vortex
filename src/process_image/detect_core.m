function [props, t] = detect_core(frames_bw, o_coords, cm_per_pixel, run_num)
%%detect_core detects the core of the vortex using image processing
%%techniques
% frames_bin are the binary frames of the movie that have been processed
% o_coords are the origin coordinates with respect to which the location of
% the core is calculated (specifically, the pixels of the 
% x_c, y_c are the 2D coordinates of the core 
% r is the radius of the core
% frames_core are the frames with the center and edges outlined

% % Extract number of frames
[~,~,num_frames] = size(frames_bw);
p = 1;
% % Loop through each frame
for f = 1:num_frames
    
    % % Check to see if there are any white pixels (features) in the cropped
    % region
    if isempty(find(frames_bw(:,:,f), 1))
        continue % If no features, continue to next for-loop iteration 
    end
    
    % % Filter cropped region by largest feature (presumably the vortex
    % core)
    img_core_estimate_bw(:,:,p) = bwareafilt(frames_bw(:,:,f), 1);

    % % Determine various properties of the core geometry
    cc          = bwconncomp(img_core_estimate_bw(:,:,p)); % Connected component
    props_temp  = regionprops(cc, 'Centroid', 'Circularity', 'Eccentricity', 'EquivDiameter', 'Area', 'Perimeter');

    % % Calculate distance from centroid to origin
    x_c = props_temp.Centroid(1);
    y_c = props_temp.Centroid(2);
    d_c_o   = ( (x_c - o_coords(1))^2 + (y_c - o_coords(2))^2 )^0.5; % distance from core centroid to the origin
    
    % % Determine boundaries / edges of the core
    b = bwboundaries(img_core_estimate_bw(:,:,p));
    
    % % Map boundary coordinates in cropped frame to total frame
    y_b     = b{1}(:,1);
    x_b     = b{1}(:,2);
    props_temp.Boundaries = [x_b, y_b]; % boundary
    props_temp.DistOrigin = d_c_o;
    props_temp.FrameNum   = f;
    props(p) = props_temp;
    
    p = p + 1;

end

coords_c_global_px = cat(1, props.Centroid);
% Get centroid coordinates w.r.t. origin
x_c_wrt_o = (coords_c_global_px(:,1) - size(frames_bw, 2)/2)*cm_per_pixel; 
y_c_wrt_o = (coords_c_global_px(:,2) - size(frames_bw, 1)/2)*cm_per_pixel;

% Area
a = cat(1, props.Area)*cm_per_pixel^2;

% Diameter
d = cat(1, props.EquivDiameter)*cm_per_pixel;

% Distance from the origin
d_o = (x_c_wrt_o.^2 + y_c_wrt_o.^2).^(0.5);

% Circularity
c = cat(1, props.Circularity);

% Frame number
f = cat(1, props.FrameNum);

% Perimeter
p = cat(1, props.Perimeter)*cm_per_pixel;

% Eccentricity
% e = cat(1, props.Eccentricity);

% Table
t = table();
    t.run_num = run_num*ones(size(f));
    t.frame_num = f;
    t.x_c = x_c_wrt_o;
    t.y_c = y_c_wrt_o;
    t.d_o_c = d_o;
    t.diameter = d;
    t.perimeter = p;
    t.area = a;
    t.circularity = c;
%     t.eccentricity = e;

end