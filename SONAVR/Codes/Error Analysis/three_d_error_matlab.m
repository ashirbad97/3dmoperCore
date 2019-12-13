%% Error Analysis FOVE

pos_eye_l = [0,-30,0];
pos_eye_r = [0,30,0];

pos_target = [600,0,0];

do_plot = 1;

dir_bw_eyes = normalize(pos_eye_r-pos_eye_l,'norm'); %Direction between the two eyes i.e Eyebase
up_dir = [0,0,1]; %Up direction which is Orthogonal to eye base

% Normalized rays from eyes to object
ray_l = normalize(pos_target-pos_eye_l,'norm');
ray_r = normalize(pos_target-pos_eye_r,'norm');

% Normalized horizontal and vertical direction for each eye
hor_l = normalize(cross(ray_l,up_dir),'norm');
ver_l = cross(hor_l,ray_l);

hor_r = normalize(cross(ray_r,up_dir),'norm');
ver_r = cross(hor_r,ray_r);

%% Variance of Angular Deviation
variance_l = deg2rad([1,1]);
variance_r = deg2rad([1,1]);

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
min_error_dist = norm((0.5.*pos_eye_r)+(0.5.*(pos_eye_l - pos_target)));

no_of_trials = 10000;

avg_estim_target_pos = zeros(1,3);

for i = 1:no_of_trials
    psi_l = normrnd(0,variance_l);
    psi_r = normrnd(0,variance_r);
    
    % Generate slightly rotated eye rays by adding components along eye and
    % up direction
    vray_l = normalize([ray_l+psi_l(1)*hor_l+psi_l(2)*ver_l],'norm');
    vray_r = normalize([ray_r+psi_r(1)*hor_r+psi_r(2)*ver_r],'norm');
    v = rizz_leastsq_3d(pos_eye_l,pos_eye_r,vray_l,vray_r);
    v = v';
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
        
    
    