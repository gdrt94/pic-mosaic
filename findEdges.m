I = imread('BP040.png');
I = rgb2gray(I);
%BW = edge(I); %Sobel
%imshow(BW);
%BW1 = edge(I,'Canny'); %sucks
%imshow(BW1);
%BW2 = edge(I,'Prewitt');
%imshowpair(BW,BW2,'montage')

% Find Edges Using Prewitt Method on a GPU
I = gpuArray(I);
BW3 = edge(I,'prewitt');
figure, imshow(BW3);

