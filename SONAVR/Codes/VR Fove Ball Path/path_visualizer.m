h = animatedline;
axis([0 2560 0 1440 0 1200]);
title('3D Random Walk');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Depth Axis');
view(3);

for k = 1:length(x_pos)
    addpoints(h,x_pos(k),y_pos(k),z_pos(k));
    drawnow
    pause(0.01)
end