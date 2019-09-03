%cd 'D:\Rijul\SONA VR Postprocessing\Results\001'

%% Get stimulus variables
folder_stimulus = uigetdir(pwd,'Select the folder where stimulus paths are present'); %Choose stimulus folder
cd (folder_stimulus);
AllFiles_stimulus=dir('*.txt');

x_stim = zeros(6,1400); %Allocate variables to hold stimulus data
y_stim = zeros(6,1400);
z_stim = zeros(6,1400);

for kk = 1:6
    file_name_stimulus = AllFiles_stimulus(kk).name;
    x_stim(kk,:) = import_stim(file_name_stimulus, 1, 1); %Import the X-data
end

clearvars kk file_name_stimulus

for kk = 7:12
    file_name_stimulus = AllFiles_stimulus(kk).name;
    y_stim(kk,:) = import_stim(file_name_stimulus, 1, 1); %Import the Y-data
end
y_stim = y_stim(any(y_stim,2),:);

clearvars kk file_name_stimulus

for kk = 13:18
    file_name_stimulus = AllFiles_stimulus(kk).name;
    z_stim(kk,:) = import_stim(file_name_stimulus, 1, 1); %Import the Z-data
end
z_stim = z_stim(any(z_stim,2),:);

clearvars kk file_name_stimulus    
    
%% Get response variables
folder_response = uigetdir(pwd,'Select any result folder'); %Choose a particular result folder
cd (folder_response);
AllFiles_response=dir('*.csv');
time_sec = zeros(6,1400);
x_resp = zeros(6,1400);
y_resp = zeros(6,1400);
z_resp = zeros(6,1400);

for i = 1:size(AllFiles_response,1)
    file_name_response = AllFiles_response(i).name;
    fove_data = import_eyedata(file_name_response, [2, 1401]);
    time_sec(i,:) = (fove_data.frameTime)';
    x_resp(i,:) = (fove_data.eyePos3Dx)';
    y_resp(i,:) = (fove_data.eyePos3Dy)';
    z_resp(i,:) = (fove_data.eyePos3Dz)';
    clear fove_data
end

%Initial clean
x_resp(x_resp>100)=100;
x_resp(x_resp<-100)=-100;

y_resp(y_resp>100)=100;
y_resp(y_resp<-100)=-100;

z_resp(z_resp>600)=600;
z_resp(z_resp<0)=0;

%Remove jerks
x_resp_filt = medfilt1(x_resp,20,[],2); % Filter along rows
y_resp_filt = medfilt1(y_resp,20,[],2);
z_resp_filt = medfilt1(z_resp,20,[],2);

%% Plot all the trials - For Visualization

figure; fig_ind_x = 1;
for i = 1:3:18
subplot(6,3,i); plot((x_stim(fig_ind_x,:)),'LineWidth',1.5);hold on; plot((x_resp_filt(fig_ind_x,:)),'LineWidth',1.5);title(sprintf('Trial %d : Ball Position - X vs Eye Position - X',fig_ind_x));xlabel('No. of Frames');ylabel('Position (in virtual centimetres)');
legend('Ball Position','Eye Position');
fig_ind_x = fig_ind_x + 1;
end

fig_ind_y = 1;
for i = 2:3:18
    subplot(6,3,i); plot((y_stim(fig_ind_y,:)),'LineWidth',1.5);hold on; plot((y_resp_filt(fig_ind_y,:)),'LineWidth',1.5);title(sprintf('Trial %d : Ball Position - Y vs Eye Position - Y',fig_ind_y));xlabel('No. of Frames');ylabel('Position (in virtual centimetres)');
    legend('Ball Position','Eye Position');
    fig_ind_y = fig_ind_y + 1;
end

fig_ind_z = 1;
for i = 3:3:18
    subplot(6,3,i); plot((z_stim(fig_ind_z,:)),'LineWidth',1.5);hold on; plot((z_resp_filt(fig_ind_z,:)),'LineWidth',1.5);title(sprintf('Trial %d : Ball Position - Z vs Eye Position - Z',fig_ind_z));xlabel('No. of Frames');ylabel('Position (in virtual centimetres)');
    legend('Ball Position','Eye Position');
    fig_ind_z = fig_ind_z + 1;
end

clear fig_ind_x fig_ind_y fig_ind_z i
%% Start all the time series from zero amplitude

x_stim_zero = bsxfun(@minus, x_stim, x_stim(:,1));
x_resp_zero = bsxfun(@minus, x_resp_filt, x_resp_filt(:,1));

y_stim_zero = bsxfun(@minus, y_stim, y_stim(:,1));
y_resp_zero = bsxfun(@minus, y_resp_filt, y_resp_filt(:,1));

z_stim_zero = bsxfun(@minus, z_stim, z_stim(:,1));
z_resp_zero = bsxfun(@minus, z_resp_filt, z_resp_filt(:,1));

%% Velocities (from position to velocity in cm/sec
x_stim_vel = zscore(diff(x_stim_zero'))';
x_resp_vel = zscore(diff(x_resp_zero'))';

y_stim_vel = zscore(diff(y_stim_zero'))';
y_resp_vel = zscore(diff(y_resp_zero'))';

z_stim_vel = zscore(diff(z_stim_zero'))';
z_resp_vel = zscore(diff(z_resp_zero'))';

%% Plot CCG

for i = 1:size(x_stim,1)
ccg_x(i,:) = xcorr(x_resp_vel(i,:),x_stim_vel(i,:),70,'coeff');

ccg_y(i,:) = xcorr(y_resp_vel(i,:),y_stim_vel(i,:),70,'coeff');

ccg_z(i,:) = xcorr(z_resp_vel(i,:),z_stim_vel(i,:),70,'coeff');
end

avg_ccg_x = mean(ccg_x);
avg_ccg_y = mean(ccg_y);
avg_ccg_z = mean(ccg_z);


colors = [    0.6980    0.0941    0.1686;...
    0.9373    0.5412    0.3843;...
    0.9922    0.8588    0.7804;...
    0.8196    0.8980    0.9412;...
    0.4039    0.6627    0.8118;...
    0.1294    0.4000    0.6745];

figure;
%h_x = plot((-70:70)/70,ccg_x,'LineWidth',3,'Color',colors(1,:));
h_x = plot((-70:70)/70,avg_ccg_x,'LineWidth',3);
hold on;
%h_y = plot((-70:70)/70,ccg_y,'LineWidth',3,'Color',colors(2,:));
h_y = plot((-70:70)/70,avg_ccg_y,'LineWidth',3);
%h_z = plot((-70:70)/70,ccg_z,'LineWidth',3,'Color',colors(3,:));
h_z = plot((-70:70)/70,avg_ccg_z,'LineWidth',3);
%xlim([0,1])
xlabel('time (s)');
ylabel('correlation value');
title('X,Y,Z-stim CCG');
legend('Horizontal Component','Vertical Component', 'Depth Component');

