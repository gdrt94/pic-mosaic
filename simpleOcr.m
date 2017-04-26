I = imread('plan.jpg');

results = ocr(I);

word = results.Words{2};

wordBBox = results.WordBoundingBoxes(2,:);