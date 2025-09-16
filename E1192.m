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

%% 1. Consolidate Your 3D Data
% X-coordinates from your LEFT image
x = [1683;
1536;
2143;
2089;
1515;
2055;
2121;
1868;
1812;
1530;
2089;
1521;
2078;
1521;
2059;
2144;
2137;
2117;
1647;
1975;
1679;
1835;
1646;
1932;
1823;
1705;
2114;
2093;
1512;
1641;
1855;
2055;
1622;
1805;
2051;
2121;
2146;
2113;
2120;
2125;
1513;
1519];
% Y-coordinates from your LEFT image (Updated)
y = [1649;
1761;
1687;
1777;
2799;
2841;
2582;
1658;
1760;
1969;
1996;
2329;
2358;
2631;
2695;
1970;
2327;
2674;
1836;
2137;
2302;
2558;
2727;
2767;
1703;
1688;
2124;
2543;
2784;
2808;
2804;
2823;
2658;
2662;
2699;
2155;
2071;
2351;
2512;
2596;
1911;
1862];
% Z-coordinates (depth) that you calculated
z = [0.1329583227;
0.1342975207;
0.1335387776;
0.1346801347;
0.1343669251;
0.1340551689;
0.1327885598;
0.1335387776;
0.1347499352;
0.1340551689;
0.1345059493;
0.1340551689;
0.1340206186;
0.133744856;
0.1336417373;
0.1336760925;
0.1332991541;
0.1338136902;
0.1331285202;
0.1346104064;
0.1342281879;
0.1353461739;
0.1341935484;
0.1329583227;
0.1335387776;
0.1334359764;
0.1340551689;
0.1333675301;
0.1340551689;
0.1332991541;
0.1349247535;
0.1339860861;
0.1335387776;
0.1338825953;
0.1338136902;
0.1335387776;
0.1336073998;
0.1327885598;
0.133162612;
0.1333333333;
0.1335730799;
0.1338825953];

%% 2. Create an Interpolation Grid
% We create a regular grid to stretch our surface over.
[xq, yq] = meshgrid(min(x):10:max(x), min(y):10:max(y));

%% 3. Interpolate the Z values on the Grid
% griddata creates a smooth surface from your unevenly sampled points
zq = griddata(x, y, z, xq, yq);

%% 4. Plot the 3D Surface
figure;
surf(xq, yq, zq);
title('3D Reconstructed Surface of the Box');
xlabel('X-coordinate (pixels)');
ylabel('Y-coordinate (pixels)');
zlabel('Depth (z)');

% Optional improvements for a nicer plot
shading interp; % Smooths the colors
colorbar;       % Shows a color scale for depth