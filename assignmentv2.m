imageDataPath = fullfile(matlabroot, 'toolbox', 'images', 'imdata');
files = dir(fullfile(imageDataPath, '*.png'));
disp({files.name});
image = imread(fullfile(imageDataPath, 'rice.png'));
imshow(image);

% Calculate histogram
[counts, binLocations] = imhist(image);

% Plot histogram
figure;
bar(binLocations, counts);
title('Intensity Histogram of Rice Image');
xlabel('Pixel Intensity');
ylabel('Frequency');

% This script computes a global threshold for a given grayscale image I, by
% choosing an arbitrary initial estimate of a threshold, grouping the
% pixels into two sets, one with intensity values larger than the
% threshold, the other with intensity values smaller or equal than the
% threshold and calculate the mean of both sets. The mean of these two
% means will be taken as the new threshold estimate and this procedure is
% repeated until there is no change between two threshold estimates anymore
% The algorithm is equivalent to k-means clustering with two clusters.

% Load an image I before running the script
[counts, binLocations] = size(image);

[hist, x] = imhist(image);

% probability of intensities
p = hist/(counts*counts);

% pick an initial estimate threshold
thresh=mean(image(:))+0.2;

while true
    % all pixel with intensity > current threshold
    group1 = (x > thresh);
    % mean intensity of this set of pixels
    mean1 = sum(x(group1).*p(group1))/sum(p(group1));
    % all pixel with intensity <= current threshold
    group2 = (x<= thresh);
    % mean intensity of this set of pixels
    mean2 = sum(x(group2).*p(group2))/sum(p(group2));
    
    % new threshold estimate
    threshnew = (mean1 + mean2)/2;
    % continue until convergence
    if thresh==threshnew || isnan(thresh)
        break;
    else
        thresh=threshnew  % show steps taken
    end
end

% display group1 as a red semi-transparent overlay
mask=image>thresh;
imshow(labeloverlay(image,mask,'Colormap','autumn'));


%otsu method
function [threshold, variance_plot] = otsu_method(image)

    % Compute the histogram and total number of pixels
    [counts, ~] = imhist(image);
    total_pixels = sum(counts);
    
    % Normalize the histogram (probability distribution of intensities)
    normalized_hist = counts / total_pixels;
    
    % Initialize variables
    max_variance = 0;
    threshold = 0;
    variance_plot = zeros(1, length(counts)); % Store variance values
    
    for t = 1:length(counts)
        % Probability of the two classes
        P1 = sum(normalized_hist(1:t));    % Class 1: pixels <= threshold t
        P2 = sum(normalized_hist(t+1:end)); % Class 2: pixels > threshold t
        
        % Class means
        m1 = sum((0:t-1)'.*normalized_hist(1:t)) / P1;
        m2 = sum((t:length(counts)-1)'.*normalized_hist(t+1:end)) / P2;
        
        % Global mean
        mg = sum((0:length(counts)-1)'.*normalized_hist);
        
        % Between-class variance
        sigma_b_sq = P1 * (m1 - mg)^2 + P2 * (m2 - mg)^2;
        
        % Store variance value
        variance_plot(t) = sigma_b_sq;
        
        % Update the threshold if a new max variance is found
        if sigma_b_sq > max_variance
            max_variance = sigma_b_sq;
            threshold = t;
        end
    end
    
    % Plot between-class variance
    figure;
    plot(variance_plot);
    xlabel('Threshold');
    ylabel('Between-Class Variance');
    title('Otsu’s Method: Between-Class Variance for Different Thresholds');
end

% Run Otsu's method on rice.png
[otsu_thresh, variance_plot] = otsu_method(image);
disp(['Otsu Method Threshold: ', num2str(otsu_thresh)]);


%comparison ....

I2 = imread('C:\Users\Filhos\Desktop\Uppsala\Image analysis\Lab1_Complete_material\images\hand2BW.png');



function threshold = my_otsu(I2)
    % Compute the histogram
    [counts, binLocations] = imhist(I2);
    total = sum(counts);  % Total number of pixels

    % Normalize histogram (probability distribution)
    p = counts / total;
    
    % Global mean
    m_g = sum(binLocations .* p);

    max_sigma_b_sq = 0;  % Initialize maximum between-class variance
    best_threshold = 0;  % Initialize best threshold

    % Iterate through all possible thresholds
    for T = 1:length(binLocations)
        P1 = sum(p(1:T));  % Probability of class 1
        P2 = sum(p(T+1:end));  % Probability of class 2
        
        if P1 == 0 || P2 == 0
            continue;  % Avoid division by zero
        end
        
        m1 = sum(binLocations(1:T) .* p(1:T)) / P1;  % Mean of class 1
        m2 = sum(binLocations(T+1:end) .* p(T+1:end)) / P2;  % Mean of class 2

        % Between-class variance
        sigma_b_sq = P1 * (m1 - m_g)^2 + P2 * (m2 - m_g)^2;

        % Check if this is the maximum variance
        if sigma_b_sq > max_sigma_b_sq
            max_sigma_b_sq = sigma_b_sq;
            best_threshold = binLocations(T);
        end
    end

    % Return the best threshold
    threshold = best_threshold;
end

% Call your Otsu function
my_threshold = my_otsu(I2);

% MATLAB's built-in Otsu method
matlab_threshold = graythresh(I2);

% Convert MATLAB's threshold from the [0, 1] range to [0, 255] for comparison
matlab_threshold_scaled = matlab_threshold * 255;

% Display results
fprintf('My Otsu threshold: %.2f\n', my_threshold);
fprintf('MATLAB graythresh threshold: %.2f\n', matlab_threshold_scaled);


% Threshold the image using your threshold
I_my_thresh = I2 > my_threshold;

% Threshold the image using MATLAB's threshold
I_matlab_thresh = I2 > matlab_threshold_scaled;

% Display the results
subplot(1, 3, 1), imshow(I2), title('Original Image');
subplot(1, 3, 2), imshow(I_my_thresh), title('My Otsu Threshold');
subplot(1, 3, 3), imshow(I_matlab_thresh), title('MATLAB graythresh');
