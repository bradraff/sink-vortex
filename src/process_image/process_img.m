function [frames_comp_gray, frames_bw, vid_obj_out_gray, vid_obj_out_gray_bw] = process_img(frames, filename_out_vid_gray, filename_out_vid_gray_bw, dir_processed_frames)


%% Process frames
disp('Convert to gray, enhance contrast, and take complement of each image')
num_frames = size(frames,4);
for f = 1:num_frames
    if mod(f, 20) == 0
        fprintf('Frame %d\n', f)
    end
    % Convert from RGB to gray, keep uint8 for faster processing in pivlab
    frame_gray = rgb2gray(frames(:,:,:,f)); 
%     frame_gray = im2double(rgb2gray(frame)); 
    % Enhance contrast
    frame_gray_enh = imadjust(frame_gray);
    % Take complement of the image
    frames_comp_gray(:,:,:,f) = imcomplement(frame_gray_enh);
end
disp('Writing the gray frames to a .mat file')
save([dir_processed_frames '_gray.mat'], 'frames_comp_gray');

clearvars frame_gray frame frames

%% View frames
% view_frames(frames_comp_gray, 30);

%% Moving median
% m_mov = movmedian(frames_comp_gray, 3, 4);
% frames_comp_movmsub_gray = frames_comp_gray - m_mov;

% m_stat = median(frames_comp_gray, 4);
% frames_comp_statm_gray = frames_comp_gray - m_stat;

disp('Binarizing the gray frames')
for f = 1:size(frames_comp_gray, 4)
    if mod(f, 100) == 0
        fprintf('Frame %d\n', f)
    end
    frames_bw(:,:,:,f) = imbinarize(frames_comp_gray(:,:,:,f), 0.95); 
end
disp('Writing the binary frames to a .mat file')
save([dir_processed_frames '_bw.mat'], 'frames_bw');

%% Play video
% view_frames(frames_bw, 30)
% view_frames_subplot(frames_comp_gray, frames_bw, 30)

%% Save video
file_type_out = 'MPEG-4'; 
disp('Writing gray frame video')
vid_obj_out_gray = write_vid(frames_comp_gray, filename_out_vid_gray, file_type_out);
disp('Writing subplot video with gray and binary frames')
vid_obj_out_gray_bw = write_vid_subplot(frames_comp_gray, frames_bw, filename_out_vid_gray_bw, file_type_out);
end