%% Random Path Generator for Ball in FOVE
% Rijul Soans

%% Set Parameters
fov = 30;
duration_frames = 1400;
aspect_ratio = 1.77;
no_of_paths = 6;
plot_On = 1;
save_paths_On = 1;
% z = [65:750];
% start_z = 65;
% end_z = 750;
% depth = (end_z-start_z).*rand(duration_frames,1) + start_z; %Randomized depth uniform distribution

for mm = 1:no_of_paths
    %% Generate Depth i.e. Z-axis
    std_dev_z = 5; %5 originally; Controls the overall range
    mean_z = 0;
    depth_vel_distribution = std_dev_z.*randn(duration_frames,1) + mean_z;
    
    %% Gaussian filter for Z
    cutoff_z = 20; %5 Hz originally; Controls the frame-to-frame jerks; Increasing it makes it smoother
    sz = duration_frames;    % length of gaussFilter vector
    filtered_depth_vel = rizzgauss(depth_vel_distribution, cutoff_z, sz);
    depth_pos = cumsum(filtered_depth_vel);
    
    %% If positions are negative, make it +ve
    depth_pos = depth_pos-min(depth_pos)+65; %Start from 65
%     depth_pos = round(depth_pos);
    
    if plot_On
    myplot1 = plot(depth_pos);myplot1.LineWidth = 3;
    title('Position of Z axis/Depth w.r.t Frames'); xlabel('Number of Frames');
    end
    
    % sorted_depth_pos = sort(depth_pos);
    % figure; myplot2 = plot(sorted_depth_pos);myplot2.LineWidth = 3;
    % title('Ascending order Position of Z axis/Depth'); xlabel('Number of Frames');
    %% Calculate Y-Axis/Height bounds
    y_total_bound = 2*depth_pos*tan(fov*0.5*(pi/180)); % height
    y_bounds = depth_pos*tan(fov*0.5*(pi/180)); % height +- this amt when camera is at 0,0,0
    
    y_bounds = floor(y_bounds);
    % y_boundary_line = sort(y_bounds); %ascending order
    y_other_end = -y_bounds;
    
    
    
    %% X-Axis/Width Bounds
    x_total_bound = y_total_bound.*aspect_ratio; %width
    x_bounds = y_bounds.*aspect_ratio; % +- this amt when camera is at 0,0,0
    x_bounds = floor(x_bounds);
    % x_boundary_line = sort(x_bounds); %ascending order
    x_other_end = -x_bounds;
    % x_other_end = -x_boundary_line;
    
    
    %% Generate Y
    height_pos = zeros(1,duration_frames);
    std_dev_y = 5;
    for k = 1:duration_frames-1
        height_pos(1,k+1)= height_pos(k)+ std_dev_y.*randn(1,1);
        if height_pos(1,k+1)> y_bounds(k+1,1)
            height_pos(1,k+1)= y_bounds(k+1,1)-abs(y_bounds(k+1,1)-height_pos(1,k+1));
        else
            height_pos(1,k+1)=-y_bounds(k+1,1)+abs(-y_bounds(k+1,1)-height_pos(1,k+1));
        end
    end
    
    %% Gaussian filter for Y
    cutoff_y = 5; % 5 previously
    sy = duration_frames;    % length of gaussFilter vector
    height_pos = rizzgauss(height_pos, cutoff_y, sy);
    
    if plot_On
    figure; myplot3 = plot(y_bounds);myplot3.LineWidth = 3; hold on; plot(y_other_end,'LineWidth',3);
    plot(height_pos,'LineWidth',3);
    camroll(90);
    title('Boundary Lines for Y Axis/Height w.r.t Frames');xlabel('Number of Frames');
    legend('+Ve Boundary Line','-Ve Boundary Line','Height Position as a function of frames');
    end
    
    %% Generate X
    width_pos = zeros(1,duration_frames);
    std_dev_x = 5;
    for j = 1:duration_frames-1
        width_pos(1,j+1) = width_pos(j)+ std_dev_x.*randn(1,1);
        if width_pos(1,j+1)> x_bounds(j+1,1)
            width_pos(1,j+1) = x_bounds(j+1,1)-abs(x_bounds(j+1,1)-width_pos(1,j+1));
        else
            width_pos(1,j+1) = -x_bounds(j+1,1)+abs(-x_bounds(j+1,1)-width_pos(1,j+1));
        end
    end
    
    %% Gaussian filter for X
    cutoff_x = 5; % 5 previously
    sx = duration_frames;    % length of gaussFilter vector
    width_pos = rizzgauss(width_pos, cutoff_x, sx);
    
    if plot_On
    figure; myplot4 = plot(x_bounds);myplot4.LineWidth = 3; hold on; plot(x_other_end,'LineWidth',3);
    plot(width_pos,'LineWidth',3);
    camroll(90);
    title('Boundary Lines for X Axis/Width w.r.t Frames');xlabel('Number of Frames');
    legend('+Ve Boundary Line','-Ve Boundary Line','Width Position as a function of frames');
    end
    
    %% Histograms of Velocities
    height_vel = diff(height_pos);
    width_vel = diff(width_pos);
    
    if plot_On
    figure; myplot5 = histogram(height_vel);title('Histogram of Height Velocity');
    figure; myplot6 = histogram(width_vel);title('Histogram of Width Velocity');
    end
    
    %% Check for Autocorrelation
    % height_vel_corr = xcorr(height_vel);
    % width_vel_corr = xcorr(width_vel);
    
    %% Save paths to text files
    if save_paths_On
    fsave = ['path' num2str(mm) '.mat'];
    textsave_x = ['x_pos_fove' num2str(mm) '.txt'];
    textsave_y = ['y_pos_fove' num2str(mm) '.txt'];
    textsave_z = ['z_pos_fove' num2str(mm) '.txt'];
    
    % C++ Implementation for text files
    mex_WriteMatrix(textsave_x, width_pos, '%0.4f', ',', 'w+');
    mex_WriteMatrix(textsave_y, height_pos, '%0.4f', ',', 'w+');
    mex_WriteMatrix(textsave_z, depth_pos', '%0.4f', ',', 'w+');
    
    save(fsave, 'depth_pos', 'height_pos', 'width_pos');
    end
    
end
% start_y = -min(y_bounds);
% end_y = min(y_bounds);
% height_vel_distribution = (end_y-start_y).*rand(duration_frames,1) + start_y;
%
% cutoff_y = 5; %
% sy = duration_frames;    % length of gaussFilter vector
% filtered_height_vel = rizzgauss(height_vel_distribution,cutoff_y, sy);
% height_pos = cumsum(filtered_height_vel);
% %%
% height_random = zeros(duration_frames,1);
% width_random = zeros(duration_frames,1);
%
%     y_new_bound = depth*tan(fov*0.5*(pi/180));
%     x_new_bound = y_new_bound.*aspect_ratio;
%     y_new_start = -y_new_bound;
%     y_new_end = y_new_bound;
%
%     for i = 1:length(depth)
%     height_random(i,:) = (y_new_end(i,1)-y_new_start(i,1)).*rand(1,1) + y_new_start(i,1);
%     end

