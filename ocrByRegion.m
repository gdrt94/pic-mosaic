I = imread('plan.jpg');

%{
figure; 
imshow(I);
roi = round(getPosition(imrect));
%}

roi = [2322 1350 348 132];
ocrResults = ocr(I, roi);
Iocr = insertText(I,roi(1:2),ocrResults.Text,'AnchorPoint',...
    'RightTop','FontSize',20);
figure;
imshow(Iocr);
