I = imread('BP031b.png'); % BP013G.png
figure, imshow(I);
hp = impixelinfo;
%diameter = imdistline(gca);
%diam : BP040:91.66; BP031b:44.50
[centers, radii, metric] = imfindcircles(I,[21 23],'ObjectPolarity','dark', ...
    'Sensitivity',0.985,'EdgeThreshold',0.1); %dark, cause background is brighter, for BP040: [44 48]
%delete(h); %comment this line in first iteration/ obsolete
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

ocrResults = ocr(I, roi, 'TextLayout', 'Block', 'CharacterSet' , 'IV');
% Iocr = insertObjectAnnotation(I, 'rectangle', ...
%                       ocrResults.CharacterBoundingBoxes, ...
%                       ocrResults.CharacterConfidences, 'Color', 'red');
% figure;
% imshow(Iocr);

returnString = cell(len, 1);
IIcount = 0;
for i=1:len
 
    returnString(i) = regexprep(cellstr(ocrResults(i).Text), '\s' , '');
    if ocrResults(i).WordConfidences > 0.01
        I = insertText(I, [roi(i,1) roi(i,2)], returnString(i), 'AnchorPoint',...
        'RightTop', 'FontSize',25);
    end
 
    if strcmp(returnString{i, 1}, 'II') == 1
        IIcount = IIcount + 1;
    end
end

%roi(i,1:2)
figure; imshow(I);
title('Recognition of circles and OCR of values in them');