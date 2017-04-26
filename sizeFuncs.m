% I = imread('C:\Users\Gudrat\Google Drive\Others\Günay\IMG-20150509-WA0001.jpg');
% I = rgb2gray(I);
% I = imresize(I, [128 128]);
% 
% I = imread('C:\Users\Gudrat\Google Drive\Others\Günay\IMG-20150531-WA0000.jpg');
% I = imresize(I, [128 128]);
% imshow(I);

%% pixel info tool
I = imread('BP079_cropped.png'); %63 79
figure, imshow(I);
hp = impixelinfo;
diameter = imdistline(gca);
%api = iptgetapi(diameter);
%radius = api.getDistance();

%diam : BP040: 91.66; BP031b: 44.50