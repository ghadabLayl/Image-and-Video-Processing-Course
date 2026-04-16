clc;
clear;
close all;

%% Read Image
plate = imread('img10.jfif');
img = rgb2gray(plate);

figure;
imshow(img);
title('Grayscale Image');

%% Edge Detection (Sobel)
[~, threshold] = edge(img, 'sobel');
fudgeFactor = 1;
BWs = edge(img, 'sobel', threshold * fudgeFactor);

figure;
imshow(BWs);
title('Binary Gradient Mask');

%% Dilate Edges
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);

figure;
imshow(BWsdil);
title('Dilated Gradient Mask');

%% Fill Holes
BWdfill = imfill(BWsdil, 'holes');

figure;
imshow(BWdfill);
title('Filled Holes');

%% Remove Border Objects
BWnobord = imclearborder(BWdfill, 4);

figure;
imshow(BWnobord);
title('Border Cleared');

%% Erode to Clean Up
seD = strel('diamond', 1);
BWfinal = imerode(BWnobord, seD);
BWfinal = imerode(BWfinal, seD);

figure;
imshow(BWfinal);
title('Final Segmented Image');

%% Overlay Mask
figure;
imshow(labeloverlay(img, BWfinal));
title('Mask Over Original Image');

%% Connected Components Analysis
cc = bwconncomp(BWfinal);
stats = regionprops(cc, 'BoundingBox', 'Area');

%% Plate Detection (Aspect Ratio + Area Filtering)
imgArea = size(img,1) * size(img,2);

bestIdx = -1;
bestScore = inf;
bestBox = [];

for i = 1:length(stats)
    bbox = stats(i).BoundingBox;
    width = bbox(3);
    height = bbox(4);
    
    aspectRatio = width / height;
    area = stats(i).Area;
    
    % Filtering conditions
    if aspectRatio > 2 && aspectRatio < 5 && ...
       area > 0.001 * imgArea && area < 0.1 * imgArea
        
        % Score based on closeness to ideal ratio (~3)
        score = abs(aspectRatio - 3);
        
        if score < bestScore
            bestScore = score;
            bestIdx = i;
            bestBox = bbox;
        end
    end
end

%% Display Result
figure;
imshow(img);
title('Detected License Plate');
hold on;

if bestIdx ~= -1
    rectangle('Position', bestBox, ...
              'EdgeColor', 'r', ...
              'LineWidth', 2);
else
    title('No Plate Detected');
end

hold off;

%% Optional: Crop the Plate
if bestIdx ~= -1
    croppedPlate = imcrop(img, bestBox);
    
    figure;
    imshow(croppedPlate);
    title('Cropped License Plate');
end