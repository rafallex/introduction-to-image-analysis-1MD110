function [T] = feature_based_registration(path, fixed_image_path, moving_image_path, fixed_landmark_path, moving_landmark_path)

fprintf('feature_based_registration : working...\n');

%
% Load data (images and evaluation landmarks)
%

I1 = im2double(imread(fullfile(path, fixed_image_path)));
I2 = im2double(imread(fullfile(path, moving_image_path)));

p1 = readmatrix(fullfile(path, fixed_landmark_path));
p2 = readmatrix(fullfile(path, moving_landmark_path));

px1 = p1(:, 1);
py1 = p1(:, 2);

px2 = p2(:, 1);
py2 = p2(:, 2);


%
% Registration
%

tic;
points1 = detectSIFTFeatures(I1);
points2 = detectSIFTFeatures(I2);
t1 = toc;

fprintf('Number of points detected in fixed image: %d\n', points1.Count);
fprintf('Number of points detected in moving image: %d\n', points2.Count);


% Visualization
fig = figure;
fig.Position = fig.Position.*[1,1,2,1]; % Make wider figure window

tiledlayout(1, 3);
nexttile;
imshow(imfuse(I1, I2));
title('Fused view');
nexttile;
plot_image_and_points(I1, points1.Location(:,1),points1.Location(:,2), 'go');
title('Feature Points (Fixed)');
nexttile;
plot_image_and_points(I2, points2.Location(:,1),points2.Location(:,2), 'mo');
title('Feature Points (Moving)');
drawnow;


tic; 
[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1, features2);
t2 = toc;

fprintf('Number of matching points detected: %d\n', size(indexPairs, 1));
if size(indexPairs, 1) < 2
    fprintf('Error: At least 2 points are required for the transform estimation.\n');
    return
end


matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);


figure;
tiledlayout(1, 2);
nexttile;
plot_image_and_points(I1, matchedPoints1.Location(:,1),matchedPoints1.Location(:,2), 'go');
title('Matched Points (Fixed)');
nexttile;
plot_image_and_points(I2, matchedPoints2.Location(:,1),matchedPoints2.Location(:,2), 'mo');
title('Matched Points (Moving)');

figure;
showMatchedFeatures(I1,I2, matchedPoints1,matchedPoints2, 'PlotOptions',{'go','mo','y-'});

tic
T = estimateGeometricTransform(matchedPoints2, matchedPoints1, 'similarity');
t3 = toc;
fprintf('Elapsed time is %f seconds.\n', t1+t2+t3);


Ireg = imwarp(I2, T, 'OutputView', imref2d(size(I1)));

[px3, py3] = transformPointsForward(T, px2, py2);

dbefore = mean(sqrt((px2-px1).^2 + (py2-py1).^2));
fprintf('Landmark distance before registration: %f.\n', dbefore);
dafter = mean(sqrt((px3-px1).^2 + (py3-py1).^2));
fprintf('Landmark distance after registration: %f.\n', dafter);


figure;
tiledlayout(1, 2);
nexttile;
imshow(imfuse(I1, I2));
title('Before');
nexttile;
imshow(imfuse(I1, Ireg));
title('After');
drawnow;

end
