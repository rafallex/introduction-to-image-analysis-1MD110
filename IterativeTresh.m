% This script computes a global threshold for a given grayscale image I, by
% choosing an arbitrary initial estimate of a threshold, grouping the
% pixels into two sets, one with intensity values larger than the
% threshold, the other with intensity values smaller or equal than the
% threshold and calculate the mean of both sets. The mean of these two
% means will be taken as the new threshold estimate and this procedure is
% repeated until there is no change between two threshold estimates anymore
%
% The algorithm is equivalent to k-means clustering with two clusters.

% Load an image I before running the script
[M,N] = size(I);

[hist, x] = imhist(I);

% probability of intensities
p = hist/(M*N);

% pick an initial estimate threshold
thresh=mean(I(:))+0.2;

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
mask=I>thresh;
imshow(labeloverlay(I,mask,'Colormap','autumn'));













