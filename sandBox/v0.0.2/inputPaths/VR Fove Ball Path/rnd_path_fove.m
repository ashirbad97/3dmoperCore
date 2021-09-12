% [x_pos, y_pos]=rnd_path2(duration_frames, xScreen, yScreen, vel)
%
% create a random walk path starting from the center of the screen
% (resolution xScreen yScreen) with a length of duration_frames
cd 'D:\Rijul\IIT\Academics\Lab-Offline\VR Fove EMC\Sphere Path files';

commandwindow;
% duration_frames = 4000;
% xScreen = 1280; %FOVE resolutions
% yScreen = 1440;
% function [x_pos, y_pos]=rnd_fixpath(duration_frames, xScreen, yScreen)
do_this = 1;
iter = 0;
for i = 1:1
    if do_this
        duration_frames = 1400; % Fove runs at 70 fps i.e 20 sec * 70 fps
        xScreen = 1000; % Fove resoln
        yScreen = 600; 
%         zScreen = 250; % arbitrarily chosen - but keep in mind accommodation-convergence conflict
        
        vel = 6; % 10 takes forever but it finishes
        while 1
            x_vel = randn(1,duration_frames);
            y_vel = randn(1,duration_frames);
%             z_vel = randn(1,duration_frames); %centred around 0 and ranging upto say +-5
            
            
            x_velgain = vel*4; % also the standard deviation of gaussian
            y_velgain = vel*4; % originally 2
%             z_velgain = vel*4;
            
            
            x_vel(1) = 0;
            y_vel(1) = 0;
%             z_vel(1) = 0;
            
            x_vel = x_vel.*x_velgain;
            y_vel = y_vel.*y_velgain;
%             z_vel = z_vel.*z_velgain;  %centred around 0 and ranging upto say +-50
            
            cutoff = 10; %Hz
            sigma = cutoff/sqrt(2*log(2)); %*2*pi;
            sz = duration_frames;    % length of gaussFilter vector
            x = linspace(-sz / 2, sz / 2, sz);
            g_filter = exp(-x .^ 2 / (2 * sigma ^ 2));
            g_filter = g_filter / sum (g_filter); % normalize
           
            
            %         sqfw=500;
            %         lp_x_vel=conv2(x_vel,ones(1,sqfw)/sqfw,'same');
            %         lp_y_vel=conv2(y_vel,ones(1,sqfw)/sqfw,'same');
            lp_x_vel = conv(x_vel, g_filter, 'same');
            lp_y_vel = conv(y_vel, g_filter,'same');
%             lp_z_vel = conv(z_vel, g_filter,'same'); %b.w +_15
            
            x_pos = cumsum(lp_x_vel);
            y_pos = cumsum(lp_y_vel);
%             z_pos = cumsum(lp_z_vel);
            
            % x_pos = cumsum(x_vel);
            % y_pos = cumsum(y_vel);
            
            x_pos = x_pos + xScreen/2;
            y_pos = y_pos + yScreen/2;
%             z_pos = z_pos + zScreen/2;
            
            
            if max(x_pos) > xScreen || min(x_pos) < 0 || max(y_pos) > yScreen || min(y_pos) < 0
%                     || max(z_pos) > zScreen || min(z_pos) < 0
                clc;
                iter = iter + 1
            else
                break;
            end
            %         t2=GetSecs;
            %         elapsed(ii) = t2-t1;
        end
        
        fsave = ['path' num2str(i) '.mat'];
        textsave_x = ['x_pos_path' num2str(i) '.txt'];
        textsave_y = ['y_pos_path' num2str(i) '.txt'];
%         textsave_z = ['z_pos_path' num2str(i) '.txt'];
        
        % C++ Implementation for text files
        mex_WriteMatrix(textsave_x, x_pos, '%0.4f', ',', 'w+');
        mex_WriteMatrix(textsave_y, y_pos, '%0.4f', ',', 'w+');
%         mex_WriteMatrix(textsave_z, z_pos, '%0.4f', ',', 'w+');
        
        save(fsave, 'x_pos', 'y_pos');
        
        
    end
end