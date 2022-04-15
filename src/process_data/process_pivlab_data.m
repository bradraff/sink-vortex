% Converted from a lab - still need to clean up


%% Load data
close all; clearvars

load('PIVlab_mica_purp_1_data.mat');

%% Constants

fs  = 30;  % [Hz] sampling frequency
dt  = 1/fs; % [s] timestep
% D   = 44.5; % [mm] nozzle diameter
% t0  = 5;    % [s] time when recording starts after valve opened

time_array  = (1:length(x))*dt; % [s]
frame_nums  = (time_array) * fs; % subtract t0 to get time of recording and not time since valve opening
frame_nums_paired = floor(frame_nums / 2); % PIV analysis done on pairs of images, will only have half of original frames

%% Interpolate
d_from_core = 10:10:150; % [pixels]
angle_array = deg2rad(0:30:360);
[x_interp, y_interp] = mesh_radially(center, d_from_edge, angle_array);

% % Interpolate u and v to the mesh values
u_interp = interp2(x{1}, y{1}, u_original{1}, x_interp, y_interp);
v_interp = interp2(x{1}, y{1}, v_original{1}, x_interp, y_interp);


%% Plotting from PIVLab data

% % x, y are constant, so just pick out first entry in the cell array
X = x{1,1}*1000; % [mm] multiply by 1000 to convert from m to mm
Y = y{1,1}*1000; 

% % Concatenate u, v, into (NxNxF) matrices, where NxN = grid and F = num
% frames
u = cat(3, u_original{:,1});
v = cat(3, v_original{:,1});

% % Zoom in
% offr = 12;              % offset for rows
% offc = 5;               % offset for columns
% rngr = offr:31;         % range of rows
% rngc = offc:(31-offc);  % range of columns

% X_zoom = X(rngr, rngc);
% Y_zoom = Y(rngr, rngc);
% u_zoom = u(rngr, rngc, :);
% v_zoom = v(rngr, rngc, :);

% cnt = 1; % counter for subplots
% Plot (u, v) velocity vectors at (x, y) locations
for f = 300:310
    figure('color', 'white', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1])
        quiver( X, Y, u(:,:,f), v(:,:,f))
        camroll(180);
        set(gca, 'XAxisLocation', 'top', 'XDir', 'reverse', 'YAxisLocation', 'right')
        title(sprintf('$t=%0.1f$ s', time_array(f)))
        xlabel('x, mm')
        ylabel('y, mm')
        set(gca, 'fontsize', 16)
%     cnt = cnt + 1;
end

%% Time-averaged data

%%% Part (a)

% % Normalize each frame by its max velocity magnitude
[~,~,num_frames] = size(u_zoom);
for f = 1:num_frames
   M_matrix(:,:,f)  = sqrt(u_zoom(:,:,f).^2 + v_zoom(:,:,f).^2); % Matrix of velocity magnitudes
   M_max(f)         = max(M_matrix(:,:,f), [], 'all'); % Max magnitude in the matrix, M
   u_norm(:,:,f)    = u_zoom(:,:,f) / M_max(f); % u matrix normalized by M
   v_norm(:,:,f)    = v_zoom(:,:,f) / M_max(f); % v matrix normalized by M
end

% % Take mean across frames (third dimension)
u_mean = mean(u_zoom, 3);
v_mean = mean(v_zoom, 3);
u_mean_norm = mean(u_norm, 3);
v_mean_norm = mean(v_norm, 3);

% % Plot time-averaged, normalized velocity data
figure('color', 'white', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1])
    quiver( X_zoom, Y_zoom, u_mean_norm, v_mean_norm)
    camroll(180);
    set(gca, 'XAxisLocation', 'top', 'XDir', 'reverse', 'YAxisLocation', 'right')
    title('Velocity, time-averaged across all frames')
    xlabel('x, mm')
    ylabel('y, mm')
    set(gca, 'fontsize', 20)
    saveas(gcf, 'fig2.emf')
    
%%% Part (b)

rho = 1000; % [kg m^-3] density of water
up  = u_zoom - u_mean; % [m s^-1] velocity fluctuation, u component
vp  = v_zoom - v_mean; % [m s^-1]
TKE = 1/2 * rho * (up.^2 + vp.^2); % [kg m^-1 s^-2] turbulent kinetic energy

% ds = X_zoom(1,2) - X_zoom(1,1);
x_tick_labels = round(linspace(X_zoom(1,1), X_zoom(1,end), 5), -1); % [m -> mm]
x_ticks = linspace(1, size(X_zoom, 2), numel(x_tick_labels));

y_tick_labels = round(linspace(Y_zoom(1,1), Y_zoom(end,1), 5), -1) ; % [m -> mm]
y_ticks = linspace(1, size(Y_zoom, 2), numel(y_tick_labels));


figure('color', 'white', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1])
ax = gca;
cnt = 1;
for f = frame_nums_paired(1:4)
    subplot(2, 2, cnt)
        imagesc(TKE(:,:,f));
        set(gca, 'XTick', x_ticks, 'XTickLabel', x_tick_labels)
        set(gca, 'YTick', y_ticks, 'YTickLabel', y_tick_labels)
        xlabel('x, mm')
        ylabel('y, mm')
        title(sprintf('$t=%0.1f$ s', time_array(cnt)))
        set(gca, 'fontsize', 16)
    cnt = cnt+1;
end
hp4 = get(subplot(2,2,4), 'Position');
hcb = colorbar('Position', [hp4(1)+hp4(3)+0.01, hp4(2), 0.03, hp4(2)+hp4(3)*2.1]);
title(hcb, '$TKE, \frac{kg}{m\ s^2}$', 'interpreter', 'latex', 'fontsize', 16)
saveas(gcf, 'fig3.emf')

%% Timeseries data

%%% Part (a): Vertical velocity magnitude in 2x2 region

% % 2x2 Region
rrng = 16:17; % row range
crng = 15:16; % column range

% % Inspect the 2x2 region of velocity vectors, if desired
%{
figure
    quiver(x{1}, y{1}, u(:, :, 1), v(:, :, 1))
    hold on
    quiver(x{1}(rrng, crng), y{1}(rrng, crng), u(rrng, crng, 1), v(rrng, crng, 1))
%}

% % Calculate 2D spatial mean of v-component of velocity at each frame
t = 2*(1:500)*dt + t0; % [s] time vector
for f = 1:length(x)
    v_mean_region(f, 1) = mean2(v(rrng, crng, f)); % [m s^-1]
end

% % Plot
figure('color', 'w')
    plot(t, v_mean_region*100, 'b')
    xlabel('$t$, s')
    ylabel('$v_{mean}$, cm/s, 2x2 region')
    set(gca, 'fontsize', 20)
    xlim([5 10])
    saveas(gcf, 'fig4.emf')

%%% Part (b): Autocovariance of vertical velocity

t_start_stat= 5.75; % time of the start of stationary data
t_cxx       = t(t > t_start_stat);
v_mean_cxx  = v_mean_region(t > 5.75);
[Cxx, lags] = xcov(v_mean_cxx); % [m^2 s]

figure('color', 'w')
    plot(t_cxx, v_mean_cxx*100)
    set(gca, 'fontsize', 20)
    xlabel('$t$, s')
    ylabel('$v_{mean}$, cm/s, 2x2 region')
    title('Stationary velocity data')
    set(gca, 'fontsize', 20)
    xlim([t_start_stat max(t_cxx)])
    saveas(gcf, 'fig5.emf')
    
figure('color', 'w')
    plot(t_cxx-t_start_stat, Cxx(end-length(t_cxx)+1:end), 'r')
    xlabel('$t$, s')
    ylabel('$C_{xx}$, m$^2$/s, 2x2 region')
    set(gca, 'fontsize', 20)
    saveas(gcf, 'fig6.emf')
    

%% Determine locations for averaging PIV
% [x_mesh, y_mesh] = mesh_radially(
