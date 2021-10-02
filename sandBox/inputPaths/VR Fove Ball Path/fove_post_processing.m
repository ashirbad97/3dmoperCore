%% Post-Processing FOVE
% This script currently displays the X, Y & Z positions of the eye vs that
% of the ball
% Rijul Soans - 2019

%% Import data from FOVE

%cd E:\Rijul\UOG_Academics\Lab\VR_Unity_2017\Ball_Movement_v2_2
%cd 'E:\Rijul\UOG_Academics\Git Arena\VR_3D_Motion_Perception'
cd 'C:\Users\User\Desktop\SONA Forms\Results\003'
addpath 'E:\Rijul\UOG_Academics\Lab\VR Fove Ball Path'
fove_data = import_eyeresp('fove_recorded_results_v2_1_14.csv', 2, 1401);
x_stim = import_stim('x_pos_fove1.txt', 1, 1);
y_stim = import_stim('y_pos_fove1.txt', 1, 1);
z_stim = import_stim('z_pos_fove1.txt', 1, 1);

%% Extract X,Y,Z pos and time:

time_sec = (fove_data.frameTime)';
x_resp = (fove_data.eyePos3Dx)';
x_resp(x_resp>100)=100;
x_resp(x_resp<-100)=-100;
y_resp = (fove_data.eyePos3Dy)';
y_resp(y_resp>100)=100;
y_resp(y_resp<-100)=-100;
z_resp = (fove_data.eyePos3Dz)';
z_resp(z_resp>600)=600;
z_resp(z_resp<0)=0;

%% Plot 
figure;plot(x_stim,'LineWidth',1.5);hold on;plot(x_resp,'LineWidth',1.5);title('Ball Position - X vs Eye Position - X');xlabel('No. of Frames');ylabel('Position (in virtual centimetres)');
legend('Ball Position','Eye Position');

figure;plot(y_stim,'LineWidth',1.5);hold on;plot(y_resp,'LineWidth',1.5);title('Ball Position - Y vs Eye Position - Y');xlabel('No. of Frames');ylabel('Position (in virtual centimetres)');
legend('Ball Position','Eye Position');

figure;plot(z_stim,'LineWidth',1.5);hold on;plot(z_resp,'LineWidth',1.5);title('Ball Position - Z vs Eye Position - Z');xlabel('No. of Frames');ylabel('Position (in virtual centimetres)');
legend('Ball Position','Eye Position');

%% Velocities (from position to velocity in cm/sec
ifi = 0.0142; %70 Hz

x_stim_vel = diff(x_stim)/ifi; %Differentiate
x_resp_vel = diff(x_resp)/ifi;

y_stim_vel = diff(y_stim)/ifi;
y_resp_vel = diff(y_resp)/ifi;

z_stim_vel = diff(z_stim)/ifi;
z_resp_vel = diff(z_resp)/ifi;

%% Stimulus Velocity vs Eye Velocity (Modifications required)
time_sec_new_x = time_sec(1:length(x_resp_vel));
figure(2)
subplot(3,1,1)
plot(time_sec_new_x, x_resp_vel,'r','LineWidth',1); hold on; plot(time_sec_new_x, x_stim_vel,'k', 'LineWidth',1);
ylim([-300 300]); xlim([0 20]);  plot([0 20],[0 0],'k-', 'LineWidth',0.5); plot([0 20],[30 30],'k--', 'LineWidth',0.5); plot([0 20],[-30 -30],'k--', 'LineWidth',0.5);
xlabel('Time (s)'); ylabel('Eye Velocity (cm/sec)'); title('Horizontal Component')
                
subplot(3,1,2)
plot(time_sec_new_x, y_resp_vel,'r','LineWidth',1);  hold on; plot(time_sec_new_x, y_stim_vel,'k','LineWidth',1);
ylim([-300 300]); xlim([0 20]); plot([0 20],[0 0],'k-', 'LineWidth',0.5); plot([0 20],[30 30],'k--', 'LineWidth',0.5); plot([0 20],[-30 -30],'k--', 'LineWidth',0.5);
xlabel('Time (s)'); ylabel('Velocity (cm/sec)'); title('Vertical Component')

subplot(3,1,3)
plot(time_sec_new_x, z_resp_vel,'r','LineWidth',1);  hold on; plot(time_sec_new_x, z_stim_vel,'k','LineWidth',1);
ylim([-300 300]); xlim([0 20]); plot([0 20],[0 0],'k-', 'LineWidth',0.5); plot([0 20],[30 30],'k--', 'LineWidth',0.5); plot([0 20],[-30 -30],'k--', 'LineWidth',0.5);
xlabel('Time (s)'); ylabel('Velocity (cm/sec)'); title('Depth Component')

%% Saccade Masking?
thresh = 30; % threshold for saccades (deg/sec)
fw = 5; % fattening window
[mask_x_stim_vel, smooth_x_stim_vel] = saccmask(x_stim_vel,thresh, fw);
[mask_y_stim_vel, smooth_y_stim_vel] = saccmask(y_stim_vel,thresh, fw);

[mask_x_resp_vel, smooth_x_resp_vel] = saccmask(x_resp_vel,thresh, fw);
[mask_y_resp_vel, smooth_y_resp_vel] = saccmask(y_resp_vel,thresh, fw);
%% FIG 3 - Example of saccade mask??
if do_plot
    figure(3)
    subplot(2,1,1)
    plot(mask_x_resp_vel,'k','LineWidth',1); ylim([-0.5 1.5]);
    xlabel('Time (in frames)'); ylabel('Mask value'); title('Saccades over the threshold value'); %previously, Time(s)
    subplot(2,1,2)
    plot(smooth_x_resp_vel,'k','LineWidth',1); ylim([-0.5 1.5]);
    xlabel('Time (in frames)'); ylabel('Mask value'); title('Smooth Velocity Mask');
end

%% smoothing & lowpassing the velocities
x_stim_smoothvel = smoothvel(x_stim_vel, x_new_time, smooth_x_stim_vel); % remove saccadic component
x_resp_smoothvel = smoothvel(x_resp_vel, x_new_time, smooth_x_resp_vel); % SMOOTHVEL apply a smoothing mask to a velocity vector to remove the saccades.
%Each saccades is replaced with a linear interpolation between +-5 samples of the original vector.
y_stim_smoothvel = smoothvel(y_stim_vel, x_new_time, smooth_y_stim_vel);
y_resp_smoothvel = smoothvel(y_resp_vel, x_new_time, smooth_y_resp_vel);

cutoff = 5;
x_resp_smoothvel_lp = lowpassvel(x_resp_smoothvel,cutoff); % apply the same cutoff frequency used in the generation of the stimuli
y_resp_smoothvel_lp = lowpassvel(y_resp_smoothvel,cutoff);

%% FIG 4 - Smoothed & Lowpassed velocity vectors
if do_plot
    figure(4) % xtime has to be the length of Fig. 2
    subplot(2,1,1)
    plot(x_new_time,x_resp_smoothvel_lp,'r','LineWidth',1); hold on; plot(x_new_time,x_stim_smoothvel, 'k', 'LineWidth',1);
    ylim([-30 30]); xlim([0 20]);  plot([0 20],[0 0],'k-', 'LineWidth',0.5);
    xlabel('Time (s)'); ylabel('Velocity (deg/sec)'); title('Horizontal Component')
    
    subplot(2,1,2)
    plot(x_new_time,y_resp_smoothvel_lp,'r','LineWidth',1); hold on; plot(x_new_time,y_stim_smoothvel, 'k', 'LineWidth',1);
    ylim([-30 30]); xlim([0 20]);  plot([0 20],[0 0],'k-', 'LineWidth',0.5);
    xlabel('Time (s)'); ylabel('Velocity (deg/sec)'); title('Vertical Component')
end

%% Velocity and Saccadic crosscorrelograms

x_pos_err(:,1) = x_resp_pixel - x_stim_pixel;
y_pos_err(:,1) = y_resp_pixel - y_stim_pixel;

one_second = round(1/ifi); % roughly, 59.8802 frames
[x_axis, x_vel_cor] = ccg(x_resp_smoothvel_lp, x_stim_vel,one_second*2); %ccg: resp_vel, stim_vel, trim window
[~, y_vel_cor] = ccg(y_resp_smoothvel_lp, y_stim_vel,one_second*2);

[~, x_sac_cor] = ccg(x_resp_vel, x_pos_err, one_second*2);
[~, y_sac_cor] = ccg(y_resp_vel, y_pos_err, one_second*2);

x_axis_seconds = x_axis.*ifi; % To convert it in seconds
x_vel_tot(:,1) = x_vel_cor;
y_vel_tot(:,1) = y_vel_cor;
x_sac_tot(:,1) = x_sac_cor;
y_sac_tot(:,1) = y_sac_cor;

x_vel_avg = nanmean(x_vel_tot,2); %Useful only if there are multiple trials
y_vel_avg = nanmean(y_vel_tot,2);

x_sac_avg = nanmean(x_sac_tot,2);
y_sac_avg = nanmean(y_sac_tot,2);

x_pos_err_tot = reshape(x_pos_err,1,size(x_pos_err,1)*size(x_pos_err,2));
y_pos_err_tot = reshape(y_pos_err,1,size(y_pos_err,1)*size(y_pos_err,2));

ecc_vect = -20:20;

hx=hist(x_pos_err_tot, ecc_vect);
hy=hist(y_pos_err_tot, ecc_vect);

[hx_gauss, hx_good]=fit(ecc_vect',(hx/sum(hx))','gauss1');
[hy_gauss, hy_good]=fit(ecc_vect',(hy/sum(hy))','gauss1');


%% guassian fit & results
[x_gmodel, x_good]=fit(x_axis_seconds',x_vel_avg,'gauss1');
[y_gmodel, y_good]=fit(x_axis_seconds',y_vel_avg,'gauss1');

% velocity ccg
x_result.amp = x_gmodel.a1;
x_result.lag = x_gmodel.b1;
x_result.width = x_gmodel.c1;
x_result.adjR2 = x_good.adjrsquare;

% positional errors
x_result.erramp = hx_gauss.a1;
x_result.errmean = hx_gauss.b1;
x_result.errstd = hx_gauss.c1;
x_result.errR2 = hx_good.adjrsquare;

% saccadic ccg
[x_result.saccpeak, x_sacc_delay] = min(x_sac_avg);
x_result.saccdelay = (x_sacc_delay - round(length(x_sac_avg)/2))*ifi;

% velocity ccg
y_result.amp = y_gmodel.a1;
y_result.lag = y_gmodel.b1;
y_result.width = y_gmodel.c1;
y_result.adjR2 = y_good.adjrsquare;

% positional errors
y_result.erramp = hy_gauss.a1;
y_result.errmean = hy_gauss.b1;
y_result.errstd = hy_gauss.c1;
y_result.errR2 = hy_good.adjrsquare;

% saccadic ccg
[y_result.saccpeak, y_sacc_delay] = min(y_sac_avg);
y_result.saccdelay = (y_sacc_delay - round(length(y_sac_avg)/2))*ifi;

%% FIG 5 - CCG velocity
if do_plot
    figure(5)
    subplot(2,1,1)
    
    plot(x_axis_seconds, x_vel_avg, 'color', [0.4 0.4 0.4], 'LineWidth',2); hold on; plot(x_gmodel, 'r');
    ylim([-0.2 0.2]); xlim([-2 2]);  plot([0 0],[-1 1],'k--','LineWidth',0.5);
    xlabel('Time (s)'); ylabel('Normalized Cross-Correlation'); title('Horizontal Component')
    
    subplot(2,1,2)
    plot(x_axis_seconds, y_vel_avg, 'color', [0.4 0.4 0.4], 'LineWidth',2); hold on; plot(y_gmodel, 'r');
    ylim([-0.2 0.2]); xlim([-2 2]);  plot([0 0],[-1 1],'k--','LineWidth',0.5);
    xlabel('Time (s)'); ylabel('Normalised cross-correlation'); title('Vertical Component')
end

clc;
disp('---RESULTS---');
x_result
disp('-------------')
y_result
disp('-------------')

%% FIG 6 CCG - saccadic correlogram & positional error
if do_plot
    figure(6)
    subplot(2,1,1)
    
    x_noise = 3*std(x_sac_avg(1:round(length(x_sac_avg)/4)));
    grey_area=patch([-2 -2 2 2],[-x_noise x_noise x_noise -x_noise],[0.9 0.9 0.9],'EdgeColor',[0.8 0.8 0.8]);
    a=plot(x_axis_seconds, x_sac_avg, 'color', [0.4 0.4 0.4], 'LineWidth',2); hold on;
    plot([0 0],[-1 1],'k--','LineWidth',0.5);
    ylim([-0.2 0.2]); xlim([-2 2]);
    
    xlabel('Time (s)'); ylabel('Normalized Cross-Correlation'); title('Horizontal Component')
    % legend([a,grey_area],'Saccade Correlogram', 'Noise Level')
    
    subplot(2,1,2)
    y_noise = 3*std(y_sac_avg(1:round(length(x_sac_avg)/4)));
    grey_area=patch([-2 -2 2 2],[-y_noise y_noise y_noise -y_noise],[0.9 0.9 0.9],'EdgeColor',[0.8 0.8 0.8]);
    plot(x_axis_seconds, y_sac_avg, 'color', [0.4 0.4 0.4], 'LineWidth',2); hold on;
    plot([0 0],[-1 1],'k--','LineWidth',0.5);
    ylim([-0.2 0.2]); xlim([-2 2]);
    xlabel('Time (s)'); ylabel('Normalized Cross-Correlation'); title('Vertical Component')
end

%% Figure 7 - Positional Error and Probability
if do_plot
    figure(7)
    set(gcf,'Position',[300 500 1000 400]);
    subplot(2,1,1)
    bx=bar(ecc_vect,hx/sum(hx),'facecolor',[0.75 0.8 1],'LineWidth',1); xlim([-20 20]);
    hold on;
    plot(hx_gauss);ylim([0 0.3]);
    xlabel('Positional Error (Deg)'); ylabel('Probability (%)');
    
    subplot(2,1,2)
    by=bar(ecc_vect,hy/sum(hy),'facecolor',[1 0.8 0.75],'LineWidth',1); ylim([-20 20]); alpha(0.5);
    hold on;
    gpy = plot(hy_gauss); xlim([-20 20]); ylim([0 0.5]);
    ax = gca;
    ax.YAxisLocation = 'right';
    camroll(90);
    % rotate(gpy,[0 0 1],90);
    % rotate(by,[0 0 1],90);
end

% left_Gaze_origin_x = fove_data.leftGazeoriginx;
% left_Gaze_origin_y = fove_data.leftGazeoriginy;
% left_Gaze_origin_z = fove_data.leftGazeoriginz;
% left_Gaze_origin = cat(2,left_Gaze_origin_x, left_Gaze_origin_y, left_Gaze_origin_z);
%
% right_Gaze_origin_x = fove_data.rightGazeoriginx;
% right_Gaze_origin_y = fove_data.rightGazeoriginy;
% right_Gaze_origin_z = fove_data.rightGazeoriginz;
% right_Gaze_origin = cat(2,right_Gaze_origin_x, right_Gaze_origin_y, right_Gaze_origin_z);
%
% left_Gaze_direction_x = fove_data.leftGazedirectionx;
% left_Gaze_direction_y = fove_data.leftGazedirectiony;
% left_Gaze_direction_z = fove_data.leftGazedirectionz;
% left_Gaze_direction = cat(2, left_Gaze_direction_x, left_Gaze_direction_y, left_Gaze_direction_z);
%
% right_Gaze_direction_x = fove_data.rightGazedirectionx;
% right_Gaze_direction_y = fove_data.rightGazedirectiony;
% right_Gaze_direction_z = fove_data.rightGazedirectionz;
% right_Gaze_direction = cat(2, right_Gaze_direction_x, right_Gaze_direction_y, right_Gaze_direction_z);
%
% %3D point intersection:
% P_intersect = zeros(size(left_Gaze_origin,1),3);
% distances = zeros(size(left_Gaze_origin,1),2);
% for i = 1:size(left_Gaze_origin)
% PA = [left_Gaze_origin(i,:);right_Gaze_origin(i,:)];
% PB = [left_Gaze_origin(i,:)+left_Gaze_direction(i,:);right_Gaze_origin(i,:)+right_Gaze_direction(i,:)];
% [P_intersect(i,:),distances(i,:)] = lineIntersect3D(PA,PB);
% end
