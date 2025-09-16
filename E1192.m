%% % Clear workspace and close figures
clear; close all; clc;

% Load the left and right images
leftImage = imread('IMG_8627.JPG');
rightImage = imread('IMG_8629.JPG');

% Display the images to make sure they loaded correctly
figure;
imshowpair(leftImage, rightImage, 'montage');
title('Original Left and Right Images');

%% % --- Interactive Vertical Alignment ---

% 1. Get control points from the LEFT (fixed) image
figure;
imshow(leftImage);
title('Click a few points on the LEFT image, then press Enter');
[fixed_x, fixed_y] = ginput;

% 2. Get corresponding points from the RIGHT (moving) image
figure;
imshow(rightImage);
title('Click the SAME points in the SAME order on the RIGHT image, then press Enter');
[moving_x, moving_y] = ginput;
close all; % Close the figures

% 3. Calculate the average vertical shift and align the image
verticalShift = mean(moving_y - fixed_y);
alignedRightImage = imtranslate(rightImage, [0, -verticalShift]);

% 4. Display the aligned images to verify
figure;
imshowpair(leftImage, alignedRightImage, 'montage');
title('Vertically Aligned Images');
hold on;
% Draw a yellow line to help check the alignment
line([0, size(leftImage, 2) * 2], [size(leftImage, 1)/2, size(leftImage, 1)/2], 'Color', 'yellow');

% ------- 

%% Consolidate Your 3D Data
% X-coordinates from your LEFT image
x = [];
% Y-coordinates from your LEFT image (Updated)
y = [];
% Z-coordinates (depth) that you calculated
z = [];

%% Create an Interpolation Grid
% We create a regular grid to stretch our surface over.
[xq, yq] = meshgrid(min(x):10:max(x), min(y):10:max(y));

%% Interpolate the Z values on the Grid
% griddata creates a smooth surface from your unevenly sampled points
zq = griddata(x, y, z, xq, yq);

%% Incorporate original color 
% Interpolate the color channels from the left image onto the new grid.
R = interp2(double(leftImage(:,:,1)), xq, yq);
G = interp2(double(leftImage(:,:,2)), xq, yq);
B = interp2(double(leftImage(:,:,3)), xq, yq);
color_data = cat(3, R/255, G/255, B/255); % Scale to [0,1] for surf plot

%% Plot the 3D Surface
figure;
surf(xq, yq, zq);
title('3D Reconstructed Surface of the Box');
xlabel('X-coordinate (pixels)');
ylabel('Y-coordinate (pixels)');
zlabel('Depth (z)');

% Optional improvements for a nicer plot
shading interp; % Smooths the colors
colorbar;       % Shows a color scale for depth
