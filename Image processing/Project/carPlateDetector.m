%% Original Image & grayscale
img = imread('Cars112.png');
figure;
imshow(img);
title('Original');

I = rgb2gray(img);
figure;
imshow(I);
title('grayscale');

%% Image Enhancement
% Contrast Enhancement
imgAdjust = imadjust(I);
imgHist = histeq(I);
imgAdaptHist = adapthisteq(I);

figure;
imshow(I), title('Original');
figure;
imshow(imgAdjust), title('using imadjust');
figure;
imshow(imgHist), title('using histeq');
figure;
imshow(imgAdaptHist), title('using adapthisteq');

% Sharpening and Detail Enhancement
sharpenedImg = imsharpen(imgAdaptHist,'Radius',5,'Amount',0.9,'Threshold',0.001);
figure;
imshow(sharpenedImg), title('Sharpened Image');

% Salt and pepper removal
filteredImg = medfilt2(sharpenedImg);
figure;
imshow(filteredImg), title('Filtered sharpened image (without salt and pepper)')


%% Binarization of the image
IBin = imbinarize(I);

figure;
imshow(IBin);
title('Binarized Image');

filled = imfill(IBin,'holes');
filled = bwareaopen(filled,50);
figure;
imshow(filled);
title('Filled and noise removed from original');

edges = edge(filled,'sobel');

figure;
imshow(edges);
title('edges');

% Perform morphological dilation to enhance edges
dilatedEdges = imdilate(edges, strel('disk', 1));
dilatedEdges = imclearborder(~dilatedEdges);
dilatedEdges = bwareafilt(dilatedEdges,2);
dilatedEdges = imfill(dilatedEdges,'holes');
dilatedEdges = bwareaopen(dilatedEdges,50);
figure;
imshow(dilatedEdges);
title('Dilated Edges');

blob = regionprops(dilatedEdges,'BoundingBox');

% Crop the image
Icropped = imcrop(img,blob.BoundingBox);
% Show the result
figure;
imshow(Icropped);