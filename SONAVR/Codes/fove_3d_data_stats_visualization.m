%% Data Stats Visualization for 3D Motion Perception
%Rijul Soans

% Boxplots
load motion_3d_vars_mainfeatures
plotorder=[1 4 7 2 5 8 3 6 9];
boxplot(motion_3d_mainfeatures(:,plotorder),main_features_labels(plotorder,:),'Notch','on');
ylabel('Value');
xlabel('CCG Features');
title('Boxplot of all the CCG features');

%Correlation Heatmap
[corrcoeff_feat,pval] = corr(motion_3d_mainfeatures);

%One style
% figure;imagesc(corrcoeff_feat); % Display correlation matrix as an image
% set(gca, 'XTick', 1:size(corrcoeff_feat,1)); % center x-axis ticks on bins
% set(gca, 'YTick', 1:size(corrcoeff_feat,1)); % center y-axis ticks on bins
% set(gca, 'XTickLabel', main_features_labels); % set x-axis labels
% 
% set(gca, 'YTickLabel', main_features_labels); % set y-axis labels
% title('Correlation Heatmap for all the CCG Features', 'FontSize', 14); % set title
% colormap('jet'); % Choose jet or any other color scheme
% colorbar;

%Better style
heatmap_labels = cellstr(main_features_labels)';
compact_label = arrayfun(@(x){sprintf('%0.3f',x)}, corrcoeff_feat); 
addpath('E:\Rijul\UOG_Academics\Git Arena\VR_3D_Motion_Perception\SONAVR\Codes\heatmaps');
heatmap(corrcoeff_feat, heatmap_labels, heatmap_labels, compact_label,'TickAngle', 45,'Colorbar', true,'FontSize', 10, 'TextColor', 'xor');
colormap jet
title('Correlation Heatmap for all the CCG Features', 'FontSize', 14); % set title

% Directional Correlations in Subjects - Scatter Plots
figure;
subplot(3,3,1);
scatter_xamp_yamp = scatter(motion_3d_mainfeatures(:,1),motion_3d_mainfeatures(:,4),'filled');
scatter_xamp_yamp.LineWidth = 0.6;
scatter_xamp_yamp.MarkerEdgeColor = 'b';
scatter_xamp_yamp.MarkerFaceColor = [0 0.5 0.5];
title('X Amplitude vs Y Amplitude');

subplot(3,3,2);
scatter_xamp_zamp = scatter(motion_3d_mainfeatures(:,1),motion_3d_mainfeatures(:,7),'filled');
scatter_xamp_zamp.LineWidth = 0.6;
scatter_xamp_zamp.MarkerEdgeColor = 'b';
scatter_xamp_zamp.MarkerFaceColor = [0 0.5 0.5];
title('X Amplitude vs Z Amplitude');

subplot(3,3,3);
scatter_yamp_zamp = scatter(motion_3d_mainfeatures(:,4),motion_3d_mainfeatures(:,7),'filled');
scatter_yamp_zamp.LineWidth = 0.6;
scatter_yamp_zamp.MarkerEdgeColor = 'b';
scatter_yamp_zamp.MarkerFaceColor = [0 0.5 0.5];
title('Y Amplitude vs Z Amplitude');

subplot(3,3,4);
scatter_xlag_ylag = scatter(motion_3d_mainfeatures(:,2),motion_3d_mainfeatures(:,5),'filled');
scatter_xlag_ylag.LineWidth = 0.6;
scatter_xlag_ylag.MarkerEdgeColor = 'b';
scatter_xlag_ylag.MarkerFaceColor = [0 0.5 0.5];
title('X Lag vs Y Lag');

subplot(3,3,5);
scatter_xlag_zlag = scatter(motion_3d_mainfeatures(:,2),motion_3d_mainfeatures(:,8),'filled');
scatter_xlag_zlag.LineWidth = 0.6;
scatter_xlag_zlag.MarkerEdgeColor = 'b';
scatter_xlag_zlag.MarkerFaceColor = [0 0.5 0.5];
title('X Lag vs Z Lag');

subplot(3,3,6);
scatter_ylag_zlag = scatter(motion_3d_mainfeatures(:,5),motion_3d_mainfeatures(:,8),'filled');
scatter_ylag_zlag.LineWidth = 0.6;
scatter_ylag_zlag.MarkerEdgeColor = 'b';
scatter_ylag_zlag.MarkerFaceColor = [0 0.5 0.5];
title('Y Lag vs Z Lag');

subplot(3,3,7);
scatter_xfwhm_yfwhm = scatter(motion_3d_mainfeatures(:,3),motion_3d_mainfeatures(:,6),'filled');
scatter_xfwhm_yfwhm.LineWidth = 0.6;
scatter_xfwhm_yfwhm.MarkerEdgeColor = 'b';
scatter_xfwhm_yfwhm.MarkerFaceColor = [0 0.5 0.5];
title('X FWHM vs Y FWHM');

subplot(3,3,8);
scatter_xfwhm_zfwhm = scatter(motion_3d_mainfeatures(:,3),motion_3d_mainfeatures(:,9),'filled');
scatter_xfwhm_zfwhm.LineWidth = 0.6;
scatter_xfwhm_zfwhm.MarkerEdgeColor = 'b';
scatter_xfwhm_zfwhm.MarkerFaceColor = [0 0.5 0.5];
title('X FWHM vs Z FWHM');

subplot(3,3,9);
scatter_yfwhm_zfwhm = scatter(motion_3d_mainfeatures(:,6),motion_3d_mainfeatures(:,9),'filled');
scatter_yfwhm_zfwhm.LineWidth = 0.6;
scatter_yfwhm_zfwhm.MarkerEdgeColor = 'b';
scatter_yfwhm_zfwhm.MarkerFaceColor = [0 0.5 0.5];
title('Y FWHM vs Z FWHM');
    