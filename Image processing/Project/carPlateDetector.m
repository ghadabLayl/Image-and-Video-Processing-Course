%% Original Image & grayscale
function [croppedImg] = carPlateDetector(imgPath)
img = imread(imgPath);
figure;
imshow(img);
title('Original');

I = rgb2gray(img);
figure;
imshow(I);
title('grayscale');

%% Binarization of the image
IBin = imbinarize(I);
figure;
imshow(IBin);
title('Binarized Image');

%% Fill holes
filled = imfill(IBin,4,'holes');
figure;
imshow(filled),title('imfill');
filled = bwareaopen(filled,50);
figure;
imshow(filled),title('bwareaopen')
figure;
imshow(filled);
title('Filled and noise removed from original');


%% Detect edges
edges = edge(filled,'sobel');

figure;
imshow(edges);
title('edges');

%% Perform morphological dilation to enhance edges
dilatedEdges = imdilate(edges, strel('disk', 1));
dilatedEdges = imclearborder(~dilatedEdges);
dilatedEdges = bwareafilt(dilatedEdges,3);
dilatedEdges = imfill(dilatedEdges,'holes');
dilatedEdges = bwareaopen(dilatedEdges, round(numel(I) * 0.0005));
figure;
imshow(dilatedEdges);
title('Dilated Edges');


%% Rectangular region detection with "Square-Check"
% Get properties for the top candidates
% Note: Make sure you used bwareafilt(dilatedEdges, 2) or higher before this

blobs = regionprops(dilatedEdges, 'BoundingBox', 'Area');

targetRatio = 3.25;
bestIdx = 0;
minDiff = inf;

% --- NEW: SIZE THRESHOLD ---
% We define a "Minimum Valid Area". A good rule of thumb is that a plate
% must be at least 0.5% (0.005) of the total image size.

totalPixels = numel(I); 
minAreaThreshold = round(totalPixels * 0.005); % 0.5% of total pixels

for k = 1:length(blobs)
    bb = blobs(k).BoundingBox;
    area = blobs(k).Area;
    width = bb(3);
    height = bb(4);
    currentRatio = width / height;

    % --- 1. THE SIZE & SCALE CHECK (NEW) ---
    % If it's smaller than our minimum area, skip it.
    % This eliminates the BMW logo and the detached region immediately.

        % --- THE SQUARE CHECK ---
    % A perfect square has a ratio of 1.0. 
    % We define a "Safe Zone": the width must be at least 1.5x the height.
    % This automatically ignores wheels, headlights, and square signs.

    if area < minAreaThreshold
        continue;
    end
    
    if currentRatio < 1.6 || currentRatio > 6.0
        continue; % Skip this blob, it's the wrong shape
    end
    
    % --- RATIO COMPARISON ---
    ratioDiff = abs(currentRatio - targetRatio);
    
    if ratioDiff < minDiff
        minDiff = ratioDiff;
        bestIdx = k;
    end
end

%% Final Result Display
figure;
if bestIdx > 0
    croppedImg = imcrop(img, blobs(bestIdx).BoundingBox);
    imshow(croppedImg);
    title(['Plate Detected! Ratio: ', num2str(blobs(bestIdx).BoundingBox(3)/blobs(bestIdx).BoundingBox(4), 2)]);
else
    % If bestIdx is still 0, it means no blobs passed the "Square Check"
    croppedImg = img;
    imshow(img);
    title('No valid rectangular plate found (only squares detected)');
end

end
