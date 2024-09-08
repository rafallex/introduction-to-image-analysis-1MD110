RGB = imread("images/toysflash.png");

grayscale = rgb2gray(RGB);
doublescale = im2double(grayscale);

[rows, cols] = size(doublescale);
min_side = min(rows, cols); % determines size of square
start_row = floor((rows - min_side) / 2) + 1; % starting points for crop
start_col = floor((cols - min_side) / 2) + 1;
cropped = imcrop(doublescale, [start_col start_row min_side-1 min_side-1]);

resized = imresize(cropped, [128 128]);
imtool(resized);

function filtered_image = filter(im,filter_size)
       
    [num_rows, num_cols] = size(im);
    filtered_image = zeros(num_rows, num_cols);
    for x = 1:num_rows
        for y = 1:num_cols
            filter_result = 0.0;
            counter = 0;
            for f_x = 1:filter_size
                for f_y = 1:filter_size
                    im_x = x - 3 + f_x;
                    im_y = y - 3 + f_y;
                    if im_x >= 1 && im_x <= num_rows && im_y >= 1 && im_y <= num_cols
                        filter_result = filter_result + im(im_x, im_y);
                        counter = counter + 1;
                    end
                 end
             end

             filtered_image(x, y) = filter_result / counter;
        end
    end

    
end

filtered_image = filter(resized, 5);
imtool(filtered_image);
sub_image = resized - filtered_image;
imtool(sub_image);