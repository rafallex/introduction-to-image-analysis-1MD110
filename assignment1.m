I = imread("images\greytoys.png");
J = imread("images\greytoys.png")
imhist(J)
imtool(I)
h1 = imhist(J);
sum = cumsum(h);
num_pixels = int32(round(numel(I) / 256));
arr = 0:255;

[rows, cols] = size(I);

for grey_value = arr
    disp(grey_value);
    counter = 0;
    for r = 1:rows
        for c = 1:cols
            pixel_value = I(r, c);  % Access the pixel at row r, column c
            if pixel_value == grey_value
                counter = counter + 1;
            end
        end
    end

    if grey_value == 255

    elseif counter > num_pixels

        [row, col] = find(I == grey_value);
        
        temp = int32(counter - num_pixels);
        arr2 = 1:temp;
        
        for j = arr2
            %fprintf('iteration: %i\n', j)
            I(row(j), col(j)) = grey_value + 1;
            %fprintf('%i\n%i\n', I(row(j), col(j)))
        end

    elseif counter < num_pixels
        
        temp2 = 1;
        while counter < num_pixels

            [row, col] = find(I == grey_value+temp2);
            
            temp = int32(num_pixels - counter);
            if length(row) < temp
                arr2 = 1:length(row);
            else
                arr2 = 1:temp;
            end
            
            for j = arr2
                %fprintf('iteration: %i\n', j)
                I(row(j), col(j)) = grey_value;
                counter = counter + 1;
                %fprintf('%i\n%i\n', I(row(j), col(j)))
            end

            temp2 = temp2 + 1;

        end

    end

end

h2 = imhist(I);

difference = h2(255) - h2(256);
fprintf('difference %i\n', difference);
if difference > 0
    temp3 = 1;
    while difference > 1
        [row, col] = find(I == 255 - temp3);
        fprintf('row %i\n', row(1));
        I(row(1), col(1)) = 255;
        temp3 = temp3 + 1;
        difference = difference - 1;
        if temp3 > 254
            temp3 = 1;
        end
    end
else
    temp3 = 1;
    while difference < -1
        [row, col] = find(I == 255);
        I(row(1), col(1)) = 255 - temp3;
        temp3 = temp3 + 1;
        difference = difference + 1;
        if temp3 > 254
            temp3 = 1;
        end
    end

end




imhist(I)
imtool(I)