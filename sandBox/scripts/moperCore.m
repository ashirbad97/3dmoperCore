function f = moperCore(trialId,dbFullPath,imgOutputFullPath)
%% Database Connection
%To be changed later, here consider the trialId as sessionID of the webapp
% dbpath = "../db/3dmoper.db";
dbpath = dbFullPath;
conn = sqlite(dbpath);
disp(dbpath);
fetchStimulusQueryAll = "select * from coordinates";
resultsStimulusPaths = fetch(conn,fetchStimulusQueryAll);

%fetchResultCoordinatesQuery = "select * from subTrialData where trialId = '1'"; %Parameterise trialId later
%resultsfetchResultPath = fetch(conn,fetchResultCoordinatesQuery);
resultsfetchResultPath = fetch(conn,['select * from subTrialData where sessionId = ''',num2str(trialId),'''']);
% Develop a proper way of handling the data, currently hardcoded
coordinates = resultsStimulusPaths(:,2);
resultcoordinates = resultsfetchResultPath;

%% Bunch of Switches
    write_Table_On = 0;
%% Get stimulus variables
% Due to time constraint manually hard-coded the row positions of beginning
% of x,y and z axis as 1,7 and 13, with each having 6 trials, improve this
% in future
j=1;
for i = 1:6
    x_stim(i,:) = jsondecode(cell2mat((coordinates(j)))); %Import the X-data
    j=j+1;
end
j=7;
for i = 1:6
    y_stim(i,:) = jsondecode(cell2mat((coordinates(j)))); %Import the X-data
    j=j+1;
end
j=13;
for i = 1:6
    z_stim(i,:) = jsondecode(cell2mat((coordinates(j)))); %Import the X-data
    j=j+1;
end
x_stim = str2double(x_stim);
y_stim = str2double(y_stim);
z_stim = str2double(z_stim);
%% Get response variables
j=6;
for i=1:6
    time_sec(i,:) = jsondecode(cell2mat((resultcoordinates(i,j))));
end
%x_resp = 3
j=3;
for i=1:6
    x_resp(i,:) =  jsondecode(cell2mat((resultcoordinates(i,j))));
end
%x_resp = 4
j=4;
for i=1:6
    y_resp(i,:) =  jsondecode(cell2mat((resultcoordinates(i,j))));
end
%x_resp = 5
j=5;
for i=1:6
    z_resp(i,:) =  jsondecode(cell2mat((resultcoordinates(i,j))));
end
time_sec = str2double(time_sec);
x_resp = str2double(x_resp);
y_resp = str2double(y_resp);
z_resp = str2double(z_resp);
% Clip first 2 seconds
clip_frames = 140;

x_stim(:,1:clip_frames) = [];
x_resp(:,1:clip_frames) = [];

y_stim(:,1:clip_frames) = [];
y_resp(:,1:clip_frames) = [];

z_stim(:,1:clip_frames) = [];
z_resp(:,1:clip_frames) = [];

%Define Perceptual Boundaries
x_resp(x_resp>200)=200;
x_resp(x_resp<-200)=-200;

y_resp(y_resp>200)=200;
y_resp(y_resp<-200)=-200;

z_resp(z_resp>600)=600;
z_resp(z_resp<0)=0;

%% Trial Exclusion X, Y, and Z
%For X
trial_excl_vel_x = diff(x_resp,1,2);
mask_x = trial_excl_vel_x~=0;

for kk = 1:size(mask_x,1)
    this_trial = mask_x(kk,:);
    if nnz(~this_trial)>600
        note_down_excl_trial_x{kk,:} = kk;
        continue;
    end
    
    transitions = diff([0; this_trial' == 0; 0]);
    runstarts = find(transitions == 1);
    runends = find(transitions == -1);
    runlengths = runends - runstarts;
    find_trashy_run = find(runlengths>350);
    if (isempty(find_trashy_run))
        find_faulty_run = find(runlengths>210);
        if (isempty(find_faulty_run))
            continue;
        end
        
        time_faulty_run = runlengths(find_faulty_run);
        faulty_run_start = runstarts(find_faulty_run);
        faulty_run_end = runends(find_faulty_run);
        if (faulty_run_start-60)<runends(find_faulty_run-1)
            time_faulty_prev = runlengths(find_faulty_run-1);
        end
        if(faulty_run_end+60)> runstarts(find_faulty_run+1)
            time_faulty_next = runlengths(find_faulty_run+1);
        else
            time_faulty_next = 0;
        end
        total_faulty_time = time_faulty_run+time_faulty_prev+time_faulty_next;
        if(total_faulty_time)>350
            note_down_excl_trial_x{kk,:} = kk;
        end
        
    else
        note_down_excl_trial_x{kk,:} = kk;
    end
end


%For Y
trial_excl_vel_y = diff(y_resp,1,2);
mask_y = trial_excl_vel_y~=0;

for kk = 1:size(mask_y,1)
    this_trial = mask_y(kk,:);
    if nnz(~this_trial)>600
        note_down_excl_trial_y{kk,:} = kk;
        continue;
    end
    
    transitions = diff([0; this_trial' == 0; 0]);
    runstarts = find(transitions == 1);
    runends = find(transitions == -1);
    runlengths = runends - runstarts;
    find_trashy_run = find(runlengths>350);
    if (isempty(find_trashy_run))
        find_faulty_run = find(runlengths>210);
        if (isempty(find_faulty_run))
            continue;
        end
        
        time_faulty_run = runlengths(find_faulty_run);
        faulty_run_start = runstarts(find_faulty_run);
        faulty_run_end = runends(find_faulty_run);
        if (faulty_run_start-60)<runends(find_faulty_run-1)
            time_faulty_prev = runlengths(find_faulty_run-1);
        else
            time_faulty_prev = 0;
        end
        if(faulty_run_end+60)> runstarts(find_faulty_run+1)
            time_faulty_next = runlengths(find_faulty_run+1);
        else
            time_faulty_next = 0;
        end
        total_faulty_time = time_faulty_run+time_faulty_prev+time_faulty_next;
        if(total_faulty_time)>350
            note_down_excl_trial_y{kk,:} = kk;
        end
        
    else
        note_down_excl_trial_y{kk,:} = kk;
    end
end


% For Z
trial_excl_vel_z = diff(z_resp,1,2);
mask_z = trial_excl_vel_z~=0;
% mask_z = mask_z';
for kk = 1:size(mask_z,1)
    this_trial = mask_z(kk,:);
    if nnz(~this_trial)>600
        note_down_excl_trial_z{kk,:} = kk;
        continue;
    end
    
    transitions = diff([0; this_trial' == 0; 0]);
    runstarts = find(transitions == 1);
    runends = find(transitions == -1);
    runlengths = runends - runstarts;
    find_trashy_run = find(runlengths>350);
    if (isempty(find_trashy_run))
        find_faulty_run = find(runlengths>210);
        if (isempty(find_faulty_run))
            continue;
        end
        
        time_faulty_run = runlengths(find_faulty_run);
        faulty_run_start = runstarts(find_faulty_run);
        faulty_run_end = runends(find_faulty_run);
        if (faulty_run_start-60)<runends(find_faulty_run-1)
            time_faulty_prev = runlengths(find_faulty_run-1);
        end
        if(faulty_run_end+60)> runstarts(find_faulty_run+1)
            time_faulty_next = runlengths(find_faulty_run+1);
        end
        total_faulty_time = time_faulty_run+time_faulty_prev+time_faulty_next;
        if(total_faulty_time)>350
            note_down_excl_trial_z{kk,:} = kk;
        end
        
    else
        note_down_excl_trial_z{kk,:} = kk;
    end
end

%%
%Remove jerks
x_resp_filt = medfilt1(x_resp,20,[],2); % Filter along rows
y_resp_filt = medfilt1(y_resp,20,[],2);
z_resp_filt = medfilt1(z_resp,20,[],2);

% [pks_x,locs_x] = findpeaks(x_resp_filt);
% [pks_y,locs_y] = findpeaks(y_resp_filt);

for ii = 1:size(z_resp_filt,1)
    [pks_z,locs_z] = findpeaks(z_resp_filt(ii,:));
    Results_peaks_z(ii).peaks = pks_z;
    Results_peaks_z(ii).locations = locs_z;
end

for kk = 1:length(Results_peaks_z)
    temp_peaks = Results_peaks_z(kk).peaks;
    temp_locs = Results_peaks_z(kk).locations;
    indix = find(temp_peaks>500);
    for zz = 1:length(indix)
        if (temp_locs(indix(1,zz))<4)
            temp_locs(indix(1,zz)) = 4;
        end
        z_resp_filt(kk,temp_locs(indix(1,zz))-3:temp_locs(indix(1,zz))+40) = NaN; %Check this
    end
end

z_resp_filt = z_resp_filt(:,1:size(z_stim,2));
clear kk temp_peaks temp_locs indixzz
% z_resp_filled = fillgaps(z_resp_filt',140)';
%z_resp_filled = fillmissing(z_resp_filt,'pchip'); %'makima',2);
z_resp_filled = fillmissing(z_resp_filt,'linear',2,'EndValues','nearest');
% z_resp_filled = fillmissing(z_resp_filt,'next'); %'makima',2);

%% Plot all the trials - For Visualization
fig_1 = figure;
fig_1.Units = 'normalized';
fig_1.Position = [0 0 1 1];
%fig_1 = figure('Position',[-61   242   911   744]); %Previous
fig_ind_x = 1;
for i = 1:3:18
    subplot(6,3,i); plot((x_stim(fig_ind_x,:)),'LineWidth',1.5);hold on; plot((x_resp_filt(fig_ind_x,:)),'LineWidth',1.5);title(sprintf('Trial %d : Ball Position - X vs Eye Position - X',fig_ind_x));
    if(fig_ind_x == 3)
        ylabel('Position (in virtual centimetres)');
    end
    fig_ind_x = fig_ind_x + 1;
end
xlabel('No. of Frames');
fig_ind_y = 1;
for i = 2:3:18
    subplot(6,3,i); plot((y_stim(fig_ind_y,:)),'LineWidth',1.5);hold on; plot((y_resp_filt(fig_ind_y,:)),'LineWidth',1.5);title(sprintf('Trial %d : Ball Position - Y vs Eye Position - Y',fig_ind_y));
    if(fig_ind_y == 3)
        ylabel('Position (in virtual centimetres)');
    end
    fig_ind_y = fig_ind_y + 1;
end
legendFig1 = legend('Ball Position','Eye Position');
legendFig1.Position = [0.484979054059679 0.010477837778827 0.0730369158248058 0.0393919685548785];
xlabel('No. of Frames');
fig_ind_z = 1;
for i = 3:3:18
    subplot(6,3,i); plot((z_stim(fig_ind_z,:)),'LineWidth',1.5);hold on; plot((z_resp_filled(fig_ind_z,:)),'LineWidth',1.5);title(sprintf('Trial %d : Ball Position - Z vs Eye Position - Z',fig_ind_z));
    if(fig_ind_z == 3)
        ylabel('Position (in virtual centimetres)');
    end
    fig_ind_z = fig_ind_z + 1;
end
xlabel('No. of Frames');
% fig_1.WindowState = 'maximized';
clear fig_ind_x fig_ind_y fig_ind_z i
%% Start all the time series from zero amplitude

x_stim_zero = bsxfun(@minus, x_stim, x_stim(:,1));
x_resp_zero = bsxfun(@minus, x_resp_filt, x_resp_filt(:,1));

y_stim_zero = bsxfun(@minus, y_stim, y_stim(:,1));
y_resp_zero = bsxfun(@minus, y_resp_filt, y_resp_filt(:,1));

z_stim_zero = bsxfun(@minus, z_stim, z_stim(:,1));
z_resp_zero = bsxfun(@minus, z_resp_filled, z_resp_filled(:,1));

%% Velocities (from position to velocity in cm/sec
x_stim_vel = zscore(diff(x_stim_zero'))';
x_resp_vel = zscore(diff(x_resp_zero'))';

y_stim_vel = zscore(diff(y_stim_zero'))';
y_resp_vel = zscore(diff(y_resp_zero'))';

z_stim_vel = zscore(diff(z_stim_zero'))';
z_resp_vel = zscore(diff(z_resp_zero'))';

%%Now exclude the faulty trials from CCG calculation
if (exist ('note_down_excl_trial_x','var'))
    note_down_excl_trial_x = note_down_excl_trial_x(~any(cellfun('isempty', note_down_excl_trial_x), 2), :);
else
    note_down_excl_trial_x = {0};
end


if (exist ('note_down_excl_trial_y','var'))
    note_down_excl_trial_y = note_down_excl_trial_y(~any(cellfun('isempty', note_down_excl_trial_y), 2), :);
else
    note_down_excl_trial_y = {0};
end

if (exist ('note_down_excl_trial_z','var'))
    note_down_excl_trial_z = note_down_excl_trial_z(~any(cellfun('isempty', note_down_excl_trial_z), 2), :);
else
    note_down_excl_trial_z = {0};
end


total_exclude_trials = [note_down_excl_trial_x;note_down_excl_trial_y;note_down_excl_trial_z];
total_exclude_trials_unique = unique(cell2mat(total_exclude_trials));
total_exclude_trials_unique(total_exclude_trials_unique==0)=[];

%Note the position when it gets deleted.
if (~isempty(total_exclude_trials_unique))
    for kk = 1:size(total_exclude_trials_unique,1)
        x_resp_vel(total_exclude_trials_unique(kk),:)=NaN;
        x_stim_vel(total_exclude_trials_unique(kk),:)=NaN;
        
        y_resp_vel(total_exclude_trials_unique(kk),:)=NaN;
        y_stim_vel(total_exclude_trials_unique(kk),:)=NaN;
        
        z_resp_vel(total_exclude_trials_unique(kk),:)=NaN;
        z_stim_vel(total_exclude_trials_unique(kk),:)=NaN;
    end
    fprintf('The following trials were faulty:\n');
    disp(total_exclude_trials_unique);
else
    fprintf('All trials seem to be fine!\n');
end

%Remove trials with NAN.

x_resp_vel(any(isnan(x_resp_vel), 2), :) = [];
x_stim_vel(any(isnan(x_stim_vel), 2), :) = [];
y_resp_vel(any(isnan(y_resp_vel), 2), :) = [];
y_stim_vel(any(isnan(y_stim_vel), 2), :) = [];
z_resp_vel(any(isnan(z_resp_vel), 2), :) = [];
z_stim_vel(any(isnan(z_stim_vel), 2), :) = [];
%% Plot CCG
try
    for i = 1:size(x_stim_vel,1)
        ccg_x(i,:) = xcorr(x_resp_vel(i,:),x_stim_vel(i,:),70,'coeff');
        
        ccg_y(i,:) = xcorr(y_resp_vel(i,:),y_stim_vel(i,:),70,'coeff');
        
        ccg_z(i,:) = xcorr(z_resp_vel(i,:),z_stim_vel(i,:),70,'coeff');
    end




% Average CCG
avg_ccg_x = mean(ccg_x);
avg_ccg_y = mean(ccg_y);
avg_ccg_z = mean(ccg_z);

% Median CCG
% median_ccg_x


colors = [    0.6980    0.0941    0.1686;...
    0.9373    0.5412    0.3843;...
    0.9922    0.8588    0.7804;...
    0.8196    0.8980    0.9412;...
    0.4039    0.6627    0.8118;...
    0.1294    0.4000    0.6745];

fig_2 = figure;
%fig_2 = figure('Position',[795   565   560   420]);%Previous
%h_x = plot((-70:70)/70,ccg_x,'LineWidth',3,'Color',colors(1,:));
h_x = plot((-70:70)/70,avg_ccg_x,'LineWidth',3);
hold on;
%h_y = plot((-70:70)/70,ccg_y,'LineWidth',3,'Color',colors(2,:));
h_y = plot((-70:70)/70,avg_ccg_y,'LineWidth',3);
%h_z = plot((-70:70)/70,ccg_z,'LineWidth',3,'Color',colors(3,:));
h_z = plot((-70:70)/70,avg_ccg_z,'LineWidth',3);
%xlim([0,1])
xlabel('Time (s)');
ylabel('Correlation value');
title('Average Velocity Cross-Correlograms for Horizontal, Vertical, Depth');
legend('Horizontal Component','Vertical Component', 'Depth Component');
fig_2.WindowState = 'maximized';
%% Gaussian Fitting - usual gaussian or skewed Gabor?
ccg_x_axis = (-70:70)/70;
%Usual Gaussian
%[fitresult_X, gof_X] = CCG_GaussFit_X(x, avg_ccg_x)
[x_gaussmodel, x_goodness] = fit(ccg_x_axis',avg_ccg_x','gauss1');
[y_gaussmodel, y_goodness] = fit(ccg_x_axis',avg_ccg_y','gauss1');
[z_gaussmodel, z_goodness] = fit(ccg_x_axis',avg_ccg_z','gauss1');

%Model Fit parameters
x_result.X_Amp = x_gaussmodel.a1; %Amplitude
x_result.X_Lag = x_gaussmodel.b1; %Mean of Gaussian
x_result.X_Width = x_gaussmodel.c1;
x_result.X_FWHM = x_gaussmodel.c1.*(2*sqrt(2*log(2)));
x_result.X_AdjR2 = x_goodness.adjrsquare;%DOF adjusted R-Square; adjR2 = 1-[SSE(n-1)/SST(v)] where v = n-m; SSTotal = SSRegress+SSError

y_result.Y_Amp = y_gaussmodel.a1; %Amplitude
y_result.Y_Lag = y_gaussmodel.b1; %Mean of Gaussian
y_result.Y_Width = y_gaussmodel.c1;
y_result.Y_FWHM = y_gaussmodel.c1.*(2*sqrt(2*log(2)));
y_result.Y_AdjR2 = y_goodness.adjrsquare;%DOF adjusted R-Square; adjR2 = 1-[SSE(n-1)/SST(v)] where v = n-m; SSTotal = SSRegress+SSError

z_result.Z_Amp = z_gaussmodel.a1; %Amplitude
z_result.Z_Lag = z_gaussmodel.b1; %Mean of Gaussian
z_result.Z_Width = z_gaussmodel.c1;
z_result.Z_FWHM = z_gaussmodel.c1.*(2*sqrt(2*log(2)));
z_result.Z_AdjR2 = z_goodness.adjrsquare;%DOF adjusted R-Square; adjR2 = 1-[SSE(n-1)/SST(v)] where v = n-m; SSTotal = SSRegress+SSError

%% Visualize Peak, Lag and FWHM
x_y_z_peaks = [x_result.X_Amp;y_result.Y_Amp;z_result.Z_Amp];
peaks_categories = categorical({'Horizontal','Vertical','Depth'});
fig_3 = figure;
%fig_3 = figure('Position',[797   58   560   420]); %previous
peaks_bar = bar(peaks_categories,x_y_z_peaks);
peaks_bar.FaceColor = 'flat';
peaks_bar.CData(1,:) = [1 0 0];
peaks_bar.CData(2,:) = [0 1 0];
peaks_bar.CData(3,:) = [0 0 1];
ylabel('Correlation');
title('CCG Peak');
fig_3.WindowState = 'maximized';

x_y_z_lags = [x_result.X_Lag;y_result.Y_Lag;z_result.Z_Lag];
lags_categories = categorical({'Horizontal','Vertical','Depth'});
fig_4 = figure;
%fig_4 = figure('Position',[1359   564   560   420]);%Previous
lags_bar = bar(lags_categories,x_y_z_lags);
lags_bar.FaceColor = 'flat';
lags_bar.CData(1,:) = [1 0 0];
lags_bar.CData(2,:) = [0 1 0];
lags_bar.CData(3,:) = [0 0 1];
ylabel('Time(s)');
title('CCG Lag');
fig_4.WindowState = 'maximized';

x_y_z_fwhm = [x_result.X_FWHM;y_result.Y_FWHM;z_result.Z_FWHM];
fwhm_categories = categorical({'Horizontal','Vertical','Depth'});
fig_5 = figure;
%fig_5 = figure('Position',[1362   59   560   420]);%Previous
fwhm_bar = bar(fwhm_categories,x_y_z_fwhm);
fwhm_bar.FaceColor = 'flat';
fwhm_bar.CData(1,:) = [1 0 0];
fwhm_bar.CData(2,:) = [0 1 0];
fwhm_bar.CData(3,:) = [0 0 1];
ylabel('Time(s)');
title('CCG Width (at half peak)');
fig_5.WindowState = 'maximized';

catch
    fprintf('Sorry! No trials are good enough to create a cross-correlogram.\n');
end

%% Write to Table

if write_Table_On
Result_Table = cat(2,struct2table(x_result),struct2table(y_result),struct2table(z_result));
filename = 'temp_3d_motion_vars.xlsx';
find_subj_num = regexp(folder_response,'\d*','Match'); %Works for 'E:\Rijul\UOG_Academics\Git Arena\VR_3D_Motion_Perception\SONAVR\Codes\Results\XXX'
subj_without_prefix = str2double(find_subj_num{1,2})+1; %Because first row is for variables; start from 2nd row
cd 'C:\Users\User\Desktop';
excel_row = ['J' num2str(subj_without_prefix)];

writetable(Result_Table,filename,'Sheet',1,'Range',excel_row,'WriteVariableNames',false);
%writetable(Result_Table,filename,'Sheet',1,'Range','J2','WriteVariableNames',false);
end


% Gabor skew curve fitting equations
% a*exp(-((t-mu)/2*c1)^2)*sin(2*pi*w*(t-mu)).*(t>=mu) + a*exp(-((t-mu)/2*c2)^2)*sin(2*pi*w*(t-mu)).*(t<mu);
%
% a*exp(-((t-mu)^2)/(2*c1*c1))*sin(2*pi*w*(t-mu)).*(t>=mu) + a*exp(-((t-mu)^2)/(2*c2*c2))*sin(2*pi*w*(t-mu)).*(t<mu);

%% Save Plots
% dirImg = "../../imgOutput";
dirImg = imgOutputFullPath;
trialPath = string(trialId);
dirImg = dirImg +"/"+ trialPath;
disp(dirImg);
fig_1_path = dirImg + "/" + 'fig_1.png';
fig_2_path = dirImg + "/" + 'fig_2.png';
fig_3_path = dirImg + "/" + 'fig_3.png';
fig_4_path = dirImg + "/" + 'fig_4.png';
fig_5_path = dirImg + "/" + 'fig_5.png';
    if ~exist(dirImg, 'dir')
       mkdir(dirImg)
    end
saveas(fig_1,fig_1_path);
saveas(fig_2,fig_2_path);
saveas(fig_3,fig_3_path);
saveas(fig_4,fig_4_path);
saveas(fig_5,fig_5_path);
end