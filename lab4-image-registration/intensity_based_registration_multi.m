function [T] = intensity_based_registration_multi(path, fixed_image_path, moving_image_path, fixed_landmark_path, moving_landmark_path)

fprintf('intensity_based_registration_multi : working...\n');

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
% Visualization
% 

fig = figure;
fig.Position = fig.Position.*[1,1,2,1]; % Make wider figure window

tiledlayout(1, 3);
nexttile;
imshow(imfuse(I1, I2));
title('Fused view');
nexttile;
plot_image_and_points(I1, px1, py1, 'go');
title('Fixed image with landmarks');
nexttile;
plot_image_and_points(I2, px2, py2, 'mo');
title('Moving image with landmarks');
drawnow; % Show image now


%
% Registration
%

pyramid_levels = 5;
iterations = 1000;

optimizer = registration.optimizer.OnePlusOneEvolutionary();
metric = registration.metric.MattesMutualInformation();
    
optimizer.MaximumIterations = iterations;
optimizer.InitialRadius =  7e-05;
    
tic;
T = imregtform(I2, I1, 'rigid', optimizer, metric, 'PyramidLevels', pyramid_levels);%, 'DisplayOptimization', 1);
toc


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
