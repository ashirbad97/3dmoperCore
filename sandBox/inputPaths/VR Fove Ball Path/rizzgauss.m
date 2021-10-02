function depth_vel = rizzgauss(input_distribution, cutoff, length_gauss_filter)

sigma = cutoff/sqrt(2*log(2)); %*2*pi;
x = linspace(-length_gauss_filter / 2, length_gauss_filter / 2, length_gauss_filter);
g_filter = exp(-x .^ 2 / (2 * sigma ^ 2));
g_filter = g_filter / sum (g_filter);
depth_vel = conv(input_distribution, g_filter,'same'); % gaussian distributed depth
end