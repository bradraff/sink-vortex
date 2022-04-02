%% Load video
% clearvars; 

cd('C:\gradSchool\courses\me354\project')
dir_vids    = '.\';
filename    = 'sink_vortex_3_mica_purp.mp4';
vid_obj     = VideoReader([dir_vids filename]);
fps         = vid_obj.FrameRate;
dur         = vid_obj.Duration;

%% Process frames
f = 1; % initialize frame counter
while hasFrame(vid_obj)
    % Read frame
    frames(:,:,:,f) = readFrame(vid_obj);
    f = f + 1;
end