I = imread('plan.jpg');
I = rgb2gray(I);
BW = imbinarize(I);

figure;
imshowpair(I, BW, 'montage');