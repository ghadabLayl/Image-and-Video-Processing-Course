im1 = imread('calculator.jpg');
calc = rgb2gray(im1);

im = imread('obj2.jpg');
obj2 = rgb2gray(im);

im2 = imread('desk.jpg');
desk = rgb2gray(im2);

%detecting feature points in both images
calcPoints = detectSURFFeatures(calc);
deskPoints = detectSURFFeatures(desk);

obj2Points = detectSURFFeatures(obj2);

% Strongest feature points in object to detect image
figure;
subplot(1,2,1),
imshow(calc),
title('Calculator (Object to detect)');

subplot(1,2,2),
imshow(calc),
title('100 strongest feature points on calculator');
hold on;
plot(selectStrongest(calcPoints,100));

figure;
subplot(1,2,1),
imshow(obj2),
title('Object 2 to detect');

subplot(1,2,2),
imshow(obj2),
title('100 Strongest feature points on obj2');
hold on;
plot(selectStrongest(obj2Points,100));

% Strongest feature points in target image
figure;
subplot(1,2,1),
imshow(desk),
title('Desk (Cluttered Scene)');

subplot(1,2,2),
imshow(desk),
title('300 Strongest points on desk');
hold on;
plot(selectStrongest(deskPoints,300));

% Extracting feature descriptors
[calcFeatures, calcPoints] = extractFeatures(calc,calcPoints);
[deskFeatures, deskPoints] = extractFeatures(desk,deskPoints);
[obj2Features, obj2Points] = extractFeatures(obj2,obj2Points);

% Finding putative point matches with outliers
calcPairs = matchFeatures(calcFeatures, deskFeatures);
matchedCalcPoints = calcPoints(calcPairs(:, 1), :);
matchedDeskPoints = deskPoints(calcPairs(:, 2), :);
figure;
showMatchedFeatures(calc, desk, matchedCalcPoints, ...
    matchedDeskPoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

obj2Pairs = matchFeatures(obj2Features,deskFeatures, ...
    'MaxRatio', 0.9);
matchedObj2Points = obj2Points(obj2Pairs(:,1), :);
matchedDeskPoints2 = deskPoints(obj2Pairs(:,2), :);
figure;
showMatchedFeatures(obj2,desk,matchedObj2Points,...
    matchedDeskPoints2,'montage');
title('Putatively Matched Points (Including Outliers) for Object2');

% Locating the Object in the Scene Using Putative Matches without outliers
[tform, inlierCalcPoints, inlierDeskPoints] = estimateGeometricTransform(matchedCalcPoints, matchedDeskPoints,...
    'affine');
figure;
showMatchedFeatures(calc,desk,inlierCalcPoints,...
    inlierDeskPoints,'montage');
title('Putatively Matched Points (Inliers Only)');

%obj2
[tform2, inlierObj2Points, inlierDeskPoints2] = estimateGeometricTransform(matchedObj2Points, ...
    matchedDeskPoints2,'affine');
figure;
showMatchedFeatures(obj2,desk,inlierObj2Points,...
    inlierDeskPoints2,'montage');
title('Putatively Matched Points (Inliers Only) for Object 2');

% bounding polygone in original image
calcPolygon = [1, 1;... 
        size(calc, 2), 1;... 
        size(calc, 2), size(calc, 1);... 
        1, size(calc, 1);... 
        1, 1];

obj2Polygon = [1, 1;...
    size(obj2, 2), 1;...
    size(obj2, 2), size(obj2, 1);...
    1, size(obj2, 1);...
    1, 1];

% indicate location of object in scene
newCalcPolygon = transformPointsForward(tform, calcPolygon);
newObj2Polygon = transformPointsForward(tform2,obj2Polygon);

figure;
imshow(desk);
hold on;
line(newCalcPolygon(:, 1), newCalcPolygon(:, 2), 'Color', 'y');
line(newObj2Polygon(:, 1), newObj2Polygon(:, 2), 'Color', 'g');
title('Detected Calculator and Object 2');