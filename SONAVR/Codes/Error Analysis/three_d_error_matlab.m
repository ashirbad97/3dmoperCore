%% Error Analysis FOVE
% Rijul Soans - Dec 2019

%% Specify eye positions and target position(in column vector format)
clc;clear;close all;
pos_eye_l = [-30,0,0]';%[0,-30,0];
pos_eye_r = [30,0,0]';%[0,30,0];

pos_target = [0,0,1000]';%[600,0,0]

do_plot = 1;

dir_bw_eyes = normalize(pos_eye_r-pos_eye_l,'norm'); %Direction between the two eyes i.e Eyebase
up_dir = [0,1,0]'; %Up direction which is Orthogonal to eye base; [0,0,1];

% Normalized rays from eyes to object
ray_l = normalize(pos_target-pos_eye_l,'norm');
ray_r = normalize(pos_target-pos_eye_r,'norm');

% Normalized horizontal and vertical direction for each eye
hor_l = normalize(cross(ray_l,up_dir),'norm');
ver_l = cross(hor_l,ray_l);

hor_r = normalize(cross(ray_r,up_dir),'norm');
ver_r = cross(hor_r,ray_r);

%% Variance of Angular Deviation
variance_l = deg2rad([10,10]); %1 degree error in horizontal and vertical for left eye
variance_r = deg2rad([10,10]);

fprintf('The positions of the Left and Right eyes are at:\n');
fprintf(' %.2f ',pos_eye_l);
fprintf('\n');
fprintf(' %.2f ',pos_eye_r);
fprintf('\n');

%%
x_intersect = [];
y_intersect = [];

min_psi = [];
max_psi = [];

max_error_dist = 0;
min_error_dist = norm(0.5.*pos_eye_r+0.5.*pos_eye_l - pos_target);

no_of_trials = 10000;

avg_estim_target_pos = zeros(3,1);%centroid of intersections

for i = 1:no_of_trials
    psi_l = normrnd(0,variance_l)';
    psi_r = normrnd(0,variance_r)';
    
    % Generate slightly rotated eye rays by adding components along eye and
    % up direction
    vray_l = normalize([ray_l+psi_l(1)*hor_l+psi_l(2)*ver_l],'norm');
    vray_r = normalize([ray_r+psi_r(1)*hor_r+psi_r(2)*ver_r],'norm');
    v = rizz_leastsq_3d(pos_eye_l,pos_eye_r,vray_l,vray_r);
%     v = v';
    %Keep track of centroid of estimated target pos
    avg_estim_target_pos = avg_estim_target_pos+v;
    
    %Keep track of smallest and largest distance
    ls = norm(0.5*pos_eye_r+0.5*pos_eye_l-v);
    
    if(ls>max_error_dist)
        max_error_dist = ls;
        max_psi = [psi_l,psi_r];
    end
    
    if(ls<min_error_dist)
        min_error_dist = ls;
        min_psi = [psi_l,psi_r];
    end
    
    x_intersect(i,:) = v(1);
    y_intersect(i,:) = v(2);
    z_intersect(i,:) = v(3);
end

fprintf('Largest distance:\n');
fprintf(' %.3f ',max_error_dist);
fprintf('\n');
fprintf('These result from angle variations of:\n');
fprintf(' %.3f ',rad2deg(max_psi));
fprintf('\n');
fprintf('Smallest distance:\n');
fprintf(' %.3f ',min_error_dist);
fprintf('\n');

avg_estim_target_pos =  avg_estim_target_pos./no_of_trials;

fprintf('Centroid of estimated target positions:\n');
fprintf(' %.3f ',avg_estim_target_pos);
fprintf('\n');
fprintf('In comparison to the target located at:\n');
fprintf(' %.3f ',pos_target);
fprintf('\n');
        
if do_plot
    iris_l = pos_eye_l+10*ray_l;
    iris_r = pos_eye_r+10*ray_r;
    
    %% 3D plot with standard MATLAB axes
%     scatter3(pos_eye_l(1,1),pos_eye_l(2,1),pos_eye_l(3,1), 'ok');hold on;
%     scatter3(pos_eye_r(1,1),pos_eye_r(2,1),pos_eye_r(3,1), 'ok');hold on;
%     scatter3(iris_l(1,1),iris_l(2,1),iris_l(3,1), '.k', 'filled');hold on;
%     scatter3(iris_r(1,1),iris_r(2,1),iris_r(3,1), '.k', 'filled');hold on;
%     scatter3(pos_target(1,1),pos_target(2,1),pos_target(3,1), 'og', 'filled');hold on;
%     scatter3(x_intersect,y_intersect,z_intersect,'xr');
%     
%     xlabel('Horizontal/X-axis');
%     ylabel('Vertical/Y-Axis');
%     zlabel('Depth/Z-Axis');
    
    
    %%3D Plot with textbook-style MATLAB Axes i.e. Y and Z reversed. Depth
    %%goes in and out of screen
    vergence_plot = scatter3(pos_eye_l(1,1),pos_eye_l(3,1),pos_eye_l(2,1),100, 'ob');hold on;
    scatter3(pos_eye_r(1,1),pos_eye_r(3,1),pos_eye_r(2,1),100, 'ok');hold on;
%     scatter3(iris_l(1,1),iris_l(3,1),iris_l(2,1),30, '.k', 'filled');hold on;
%     scatter3(iris_r(1,1),iris_r(3,1),iris_r(2,1),30, '.k', 'filled');hold on;
    scatter3(pos_target(1,1),pos_target(3,1),pos_target(2,1),100, 'og', 'filled');hold on;
    scatter3(x_intersect,z_intersect,y_intersect,'xr');
    set(gca,'XLim',[-40 40],'YLim',[0 3000],'ZLim',[-40 80])
    
%     set(gca,'XLim',[0 inf],'YLim',[0 inf],'ZLim',[0 inf])
legend('Position of Left Eye','Position of Right Eye','The Target','All vergence points');
    %legend('Position of Left Eye','Position of Right Eye','Position of Left Iris','Position of Right Iris','The Target','All vergence points');
%     vergence_plot.YAxis.Limits = [0 3000];
%     set(gca, 'XAxisLocation', 'origin')
%     set(gca, 'YAxisLocation', 'origin')
%     set(gca, 'ZAxisLocation', 'origin')
    
    xlabel('Horizontal/X-axis (in millimetres)');
    ylabel('Depth/Z-Axis (in millimetres');
    zlabel('Vertical/Y-Axis (in millimetres');
    title('Distribution of Vergence points from eye rays distorted with zero-mean normally distributed noise');
end
    
     
%     plot3(pos_eye_l(1,1),pos_eye_l(2,1),pos_eye_l(3,1), 'ok', 'MarkerSize',15);hold on;%Plot your eye
%     plot3(pos_eye_r(1,1),pos_eye_r(2,1),pos_eye_r(3,1), 'ok', 'MarkerSize',15);hold on;
%     
%     plot3(iris_l(1,1),iris_l(2,1),iris_l(3,1), '.k', 'MarkerSize',8);hold on;%Plot the iris of eye
%     plot3(iris_r(1,1),iris_r(2,1),iris_r(3,1), '.k', 'MarkerSize',8);hold on;
%     
%     plot3(pos_target(1,1),pos_target(2,1),pos_target(3,1), 'og', 'MarkerSize',15);hold on; %Plot target
%     %plot3(pos_eye_l(1,1),pos_eye_l(2,1),pos_eye_l(3,1), '.r', 'MarkerSize',69);
%     plot3(pos_target(1,1),pos_target(2,1),pos_target(3,1), 'og', 'MarkerSize',15);hold on;
    
    