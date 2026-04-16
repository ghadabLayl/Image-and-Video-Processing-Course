% 1) perform a convolution between an image and a filter in frequency
% domain using DFT

lena = imread("lena.png");
gray = rgb2gray(lena);

lena2 = imread("lena2.png");
gray2 = rgb2gray(lena2);

icon = imread("icon.png");
icon_gray = rgb2gray(icon);

DFT = fft2(gray);
lpf = fspecial("disk", 5);

lpf_freq = fft2(lpf);

convolution = conv2(gray,lpf_freq);

shifted = fftshift(convolution);

logscale = log(1+abs(shifted));

figure;
mesh(logscale);
title("Convolution image with LPF");

% 2) Compute Mean Squared Error between 2 images

% with a similar image
mse = immse(gray,gray2);

error = gray-gray2;
mae = mean(abs(error(:)));

% with an image with a lot of difference
mse_icon = immse(gray,icon_gray);

error_diff = gray - icon_gray;
mae_icon = mean(abs(error_diff(:)));


% -----------------------
filtered = imfilter(gray, lpf);

figure;
imshow(filtered);
title("Image with LPF");

figure;
imshow(gray);
title("Image without LPF");

mse = immse(filtered,gray)
err = filtered - gray;
mae_filt = mean(abs(err(:)))