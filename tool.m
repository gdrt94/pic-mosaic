%% pixel info tool
% I = imread('BP031b.png');
% figure, imshow(I);
%hp = impixelinfo;
%diameter = imdistline(gca);
%diam : BP040: 91.66; BP031b: 44.50 BP031: 35
%default 'Sensitivity',0.985

%% main
I = imread('BP031.png'); %BP031b.png BP013G
%IForOcr = imread('BP031.png');
figure, imshow(I);

[centers, radii, metric] = imfindcircles(I,[17 18],'ObjectPolarity','dark', ...
    'Sensitivity',0.99,'EdgeThreshold',0.1); %dark, cause background is brighter, for BP040: [44 48], for 31b and 13 [21 23]
%delete(h); %comment this line in first iteration
h = [];
h = viscircles(centers,radii);

len = length(radii);
roi = zeros(len, 4);

hold on;

% draw surrounding rectangles
for i=1:len
    roi(i,1) = centers(i,1) - radii(i) * 3/5;
    roi(i,2) = centers(i,2) - radii(i) * 3/5;
    roi(i,3) = radii(i) * 6/5;
    roi(i,4) = radii(i) * 6/5 ;
    rectangle('Position', roi(i,:), 'EdgeColor','b');
end
I = rgb2gray(I);

%% BW

%figure;
%imshowpair(I, BW, 'montage');
%BW = imbinarize(I);

%% BW1

%Icorrected = imtophat(I, strel('disk', 15)); %//consider to change
%BW1 = imbinarize(Icorrected);

%imshowpair(Icorrected, BW1, 'montage');
%figure, imshow(BW1);

%% BW 2

Icorrected = imtophat(I, strel('disk', 15));

marker = imerode(Icorrected, strel('line',10,0));
Iclean = imreconstruct(marker, Icorrected);

BW2 = imbinarize(Iclean);

% figure;
% imshowpair(Iclean, BW2, 'montage');

%% OCR
ocrResults = ocr(BW2, roi, 'TextLayout', 'Block', 'CharacterSet' , 'I');

returnString = cell(len, 1);
IIcount = 0;
centers = int32(centers);
for i=1:len
 
    returnString(i) = regexprep(cellstr(ocrResults(i).Text), '\s' , '');
    if ocrResults(i).WordConfidences > 0.01
        I = insertText(I, [roi(i,1) roi(i,2)], returnString(i), 'AnchorPoint',...
        'RightTop', 'FontSize',25);
    end
 
    if strcmp(returnString{i, 1}, 'I') == 1
        centers(i, 3) = 1;
    elseif strcmp(returnString{i, 1}, 'II') == 1
        centers(i, 3) = 2;
        IIcount = IIcount + 1;
    elseif strcmp(returnString{i, 1}, 'III') == 1
        centers(i, 3) = 3;
    elseif strcmp(returnString{i, 1}, 'IV') == 1
        centers(i, 3) = 4;
    elseif strcmp(returnString{i, 1}, 'V') == 1
        centers(i, 3) = 4;
    elseif strcmp(returnString{i, 1}, 'VI') == 1
        centers(i, 3) = 4; 
    elseif strcmp(returnString{i, 1}, 'VII') == 1
        centers(i, 3) = 4;
    elseif strcmp(returnString{i, 1}, 'VIII') == 1
        centers(i, 3) = 4;
    end   
end

figure; imshow(I);
title('Recognition of circles and OCR of values in them');

dlmwrite('finalResults.txt', centers, 'delimiter',' ');




