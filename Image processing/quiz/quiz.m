% grp 1
% img 2 methods to darken the image
% DFT

i1 = imread('lena.png');
img = rgb2gray(i1);

% using imadjust

dark1 = imadjust(img, [0 1],[0 1], 1.5);
subplot(1,2,1),
imshow(img),
title('Original');
subplot(1,2,2),
imshow(dark1),
title('Darkened using gamma = 1.5');


% using histogram
dark2 = imhist(img);
dark2 = histeq(img);
figure,
subplot(1,2,1),
imshow(img),
title('Original');
subplot(1,2,2),
imshow(dark2),
title('Darkened using Histogram Equalization');

% DFT
dft = fft2(img);
shifted = fftshift(dft);
logscale = log(abs(shifted));

figure;
mesh(logscale);