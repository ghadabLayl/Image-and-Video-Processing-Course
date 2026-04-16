% Filtering in time domain
% 1st method: using matlab fcts
lena = imread("lena.png");

lenagray = rgb2gray(lena);

lpf = fspecial("disk", 5);

guassian = fspecial("gaussian",10,0.5);

filtered = imfilter(lenagray, lpf);
filtered2 = imfilter(lenagray, guassian);

figure;

subplot(1,3,1),
imshow(filtered),
title("disk");
subplot(1,3,2),
imshow(filtered2),
title('Gaussian');
subplot(1,3,3),
imshow(lenagray),
title('Original');


% 2de method: LPF (3x3) and HPF (3x3) manually

LPF = [0.075 0.124 0.075;
       0.124 0.204 0.124;
       0.075 0.124 0.075];

HPF = [-1 -1 -1;
       -1 9 -1;
       -1 -1 -1];

lowpass = imfilter(lenagray,LPF);

figure;
subplot(1,2,1),
imshow(lowpass),
title("LPF");

highpass = imfilter(lenagray,HPF);

subplot(1,2,2),
imshow(highpass),
title("HPF");

% DFT

dftimg = fft2(lenagray);

shifted = fftshift(dftimg);

logscale = log(1+abs(shifted));

figure;
mesh(logscale)
title("3D image representation after DFT");

reverseshift = ifft2(dftimg);
imgfinal = uint8(reverseshift);
figure;
imshow(imgfinal)

