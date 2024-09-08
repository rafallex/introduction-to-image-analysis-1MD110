function colorseg_RB(I)
%Interactive color-segmentation using Red and Blue channels of an image I

figure('Position',[100 100 1400 600]); %make a wide figure
subplot(1,2,1);
imshow(I);


[R,G,B]=imsplit(I); %split our image into R,G,B components
subplot(1,2,2);
h=histcounts2(R,B,256); %compute 2D (bivariate) histogram of Red and Blue
imagesc(log(h)); %display the histogram, use 'log' to improve contrast in darker regions
axis xy equal tight
ylabel('Red') 
xlabel('Blue')

title('Mark a region in the histogram');
%roi=drawfreehand('StripeColor','r');
roi=drawpolygon('StripeColor','r');
addlistener(roi,'MovingROI',@(varargin) update(I,R,B,varargin{:}));
addlistener(roi,'ROIMoved',@(varargin) update(I,R,B,varargin{:}));
update(I,R,B,roi)
end


function update(I,A,B,roi,evt)
cmask=createMask(roi); %turn the region into a binary mask
%vectorized: mask(i) = cmask(A(i),B(i)), for each pixel in the image
mask=reshape(cmask(sub2ind(size(cmask),1+A,1+B)),size(A));

subplot(1,2,1);
imshow(labeloverlay(I,mask,'Colormap','autumn'));
end