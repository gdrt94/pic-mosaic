businessCard = imread('plan.jpg');
ocrResults   = ocr(businessCard, 'TextLayout', 'Block', 'CharacterSet' , '0123456789VXI'); 
%Consider specifying CharacterSet%

goodConfidenceIndeces = ocrResults.CharacterConfidences > 0.5;
goodConfidenceBoxes = ocrResults.CharacterBoundingBoxes(goodConfidenceIndeces, :);
goodConfidenceValues = ocrResults.CharacterConfidences(goodConfidenceIndeces);

Iocr = insertObjectAnnotation(businessCard, 'rectangle', ...
                      goodConfidenceBoxes, ...
                      goodConfidenceValues, 'Color', 'red');

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);
imshow(Iocr);