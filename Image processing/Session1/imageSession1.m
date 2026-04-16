lena = imread('lena.jfif');

Ired = lena(:,:,1);

imshow(Ired);

Icrop = imcrop(lena,[0 0 128 128]);

grayIm = rgb2gray(Icrop);

imshow(grayIm);

