%read
path = 'C:\Users\Gudrat\Pictures\';
imageFiles = dir(strcat(path, '*jpg'));
mainImage = imread('C:\Users\Gudrat\Desktop\main3.jpg');
mainImage = rgb2gray(mainImage);
nFiles = length(imageFiles);

%preallocation
images = cell(2, nFiles);

%get images, convert to gray, calculate mean grayscale
for i=1:nFiles
    currentImage = imread(strcat(path, imageFiles(i).name));
    currentImage = rgb2gray(currentImage);
    mean_value = mean(mean(currentImage));
    [x,y] = size(currentImage);

%make images quadratic, fill with mean color   
    if x > y
        for j=1:x
            for k=y+1:x
                currentImage(j,k) = mean_value;
            end
        end
    end
    if x < y
        for j=x+1:y
            for k=1:y
                currentImage(j,k) = mean_value;
            end
        end
    end
    
    images{1, i} = currentImage;
    images{2, i} = mean_value;
end

%bubblesort source images by mean grayvalues
%consider to change
for i=1:nFiles
    for j=1:i
        if images{2, j} > images{2, i}
            x = images{1, j};
            y = images{2, j};
            images{1, j} = images{1, i};
            images{2, j} = images{2, i};
            images{1, i} = x;
            images{2, i} = y;
        end
    end
end

%assign dimensions
pixels = 15;
squares = 72;
dimen = pixels*squares;
amplifier = 17;

%compute mean values of the grids of the main image
valuesOfMain = zeros(squares, squares);
valuesOfMain = uint32(valuesOfMain);
i = 1;
for m = 1:dimen
    j = 1;
    for n = 1:dimen
        valuesOfMain(i, j) = valuesOfMain(i, j) + uint32(mainImage(m, n));
        if mod(n, pixels) == 0
            j = j + 1;
        end
    end
    if mod(m, pixels) == 0
            i = i + 1;
    end
end

%normalize mean values
for i=1:squares
    for j=1:squares
        valuesOfMain(i, j) = valuesOfMain(i, j)/(pixels*pixels);
    end
end

%draw final image
finalImage = zeros(128*squares, 128*squares);
finalImage = uint8(finalImage);
resized = zeros(128, 128);
resized = uint8(resized);
j = 1;
k = 1;
for i=1:squares*squares
    [min_value,index] = min(valuesOfMain(:));
    [i_row, i_col] = ind2sub(size(valuesOfMain),index);
    valuesOfMain(i_row,i_col) = 256;
    
    resized = imresize(images{1, k}, [128 128]);
    if mod(i, amplifier) == 0
        k = k + 1;
    end
        
    for m=128*(i_row-1)+1:128*i_row
        for n=128*(i_col-1)+1:128*i_col
            raz = min_value - uint32(images{2, k});
            finalImage(m,n) = resized(m-128*(i_row-1), n-128*(i_col-1)) + uint8(raz);
        end
    end
end

imshow(finalImage);
imwrite(finalImage,'C:\Users\Gudrat\Desktop\final3.png');

%background
% tempImage = zeros(864, 864);
% tempImage = uint8(tempImage);
% 
% i = 1;
% for m = 1:dimen
%     j = 1;
%     for n = 1:dimen
%         tempImage(m, n) = valuesOfMain(i, j, 2);
%         if mod(n, pixels) == 0
%             j = j + 1;
%         end
%     end
%     if mod(m, pixels) == 0
%             i = i + 1;
%     end
% end
% imshow(tempImage);
