% Remove background, because there is non-uniform background in the image
I = imread('plan.jpg');
I = rgb2gray(I);
Icorrected = imtophat(I, strel('disk', 15));

BW1 = imbinarize(Icorrected);
%{
figure;
imshowpair(Icorrected, BW1, 'montage');
%}

% morphological reconstruction, show binarized image.
marker = imerode(Icorrected, strel('line',10,0));
Iclean = imreconstruct(marker, Icorrected);

BW2 = imbinarize(Iclean);
%{
figure;
imshowpair(Iclean, BW2, 'montage');
%}

ocrResults = ocr(BW2, 'TextLayout', 'Block');
%Consider specifying CharacterSet%

goodConfidenceIndeces = ocrResults.CharacterConfidences > 0.5;
goodConfidenceBoxes = ocrResults.CharacterBoundingBoxes(goodConfidenceIndeces, :);
goodConfidenceValues = ocrResults.CharacterConfidences(goodConfidenceIndeces);

Iocr = insertObjectAnnotation(I, 'rectangle', ...
                      goodConfidenceBoxes, ...
                      goodConfidenceValues, 'Color', 'red');

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);
imshow(Iocr);


