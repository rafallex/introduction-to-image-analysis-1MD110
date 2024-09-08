function colorseg_SV(I)
%Interactive color-segmentation using Saturation and Value of an image I

figure('Position',[100 100 1400 600]); %make a wide figure
subplot(1,2,1);
imshow(I);


[H,S,V]=imsplit(rgb2hsv(I)); %split our image into H,S,V components

%turn into interger in range [0,63]
H=uint8(round(63*H));
S=uint8(round(63*S));
V=uint8(round(63*V));

subplot(1,2,2);
h=histcounts2(S,V,64); %compute 2D (bivariate) histogram of Saturation and Value
imagesc(log(h)); %display the histogram, use 'log' to improve contrast in darker regions
axis xy equal tight
ylabel('Saturation')
xlabel('Value') 

title('Mark a region in the histogram');
%roi=drawfreehand('StripeColor','r');
roi=drawpolygon('StripeColor','r');
addlistener(roi,'MovingROI',@(varargin) update(I,S,V,varargin{:}));
addlistener(roi,'ROIMoved',@(varargin) update(I,S,V,varargin{:}));
update(I,S,V,roi)
end


function update(I,A,B,roi,evt)
cmask=createMask(roi); %turn the region into a binary mask
%vectorized: mask(i) = cmask(A(i),B(i)), for each pixel in the image
mask=reshape(cmask(sub2ind(size(cmask),1+A,1+B)),size(A));

subplot(1,2,1);
imshow(labeloverlay(I,mask,'Colormap','autumn'));
end