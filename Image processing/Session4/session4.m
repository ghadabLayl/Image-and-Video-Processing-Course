% log: clog(1+x(n)), gamma: x^gamma, histogram, inverse

%imhist, imadjust, adapthisteq/histeq, imsharp

%gaussain, laplacian, median and mean (salt and pepper)

i1 = imread("lena.png");

grey= rgb2gray(i1);

imshow(grey);

histogram = imhist(grey);

% Display the histogram of the grayscale image
figure;
bar(histogram);
title('Histogram of Grayscale Image');
xlabel('Pixel Intensity');
ylabel('Frequency');


histAdjusted = histeq(grey);

% Display the histogram of the adjusted image
figure;
bar(imhist(histAdjusted));
title('Histogram of Adjusted Grayscale Image');
xlabel('Pixel Intensity');
ylabel('Frequency');

figure;
imshow(histAdjusted);
title("adjusted image");


% Gamma transformation with gamma<1

J = imadjust(grey, [],[], 0.6);
figure;
imshow(J);
title("gamma transformed image with gamma=0.6");

% Gamma transformation with gamma>1

J = imadjust(grey, [],[], 1.5);
figure;
imshow(J);
title("gamma transformed image with gamma=1.5");

% Log transformation

L = 20*log(1+double(grey));
L=uint8(L);

figure;
imshow(L);
title("Log transformation with c=20");

%inv

inv= 255-i1;
figure;
imshow(inv);
title("inverse t");



i2= imread("flower.jfif");
grey2=rgb2gray(i2);
histogram2 = imhist(grey2);


figure;
bar(histogram2);
title('Histogram of Grayscale Image2');
xlabel('Pixel Intensity');
ylabel('Frequency');

figure;
imshow(grey2);
title("lenna original");

% Apply Gaussian filter to the grayscale image
gaus = fspecial("gaussian",[10 10], 0.7);
G=imfilter(grey2,gaus);
figure;
imshow(G);
title("Gaussian Filtered Image");
histogram3 = imhist(G);

% Display the histogram of the grayscale image
figure;
bar(G);
title('Histogram of Gause');
xlabel('Pixel Intensity');
ylabel('Frequency');

% Laplacian filter



Lap= fspecial("laplacian");
% Apply the Laplacian filter to the filtered image
laplacianImg = imfilter(grey2, Lap);
figure;
imshow(laplacianImg);
title("Laplacian Filtered Image");
histogram4 = imhist(laplacianImg);

% Display the histogram of the grayscale image
figure;
bar(histogram4);
title('Histogram of Laplace Image');
xlabel('Pixel Intensity');
ylabel('Frequency');

% mean filtering 
grey3=imread("saltAndPepper.jfif");
grey3 = rgb2gray(grey3);
figure;
imshow(grey3);
title("salt and pepper");
histogram5 = imhist(grey3);

% Display the histogram of the grayscale image
figure;
bar(histogram5);
title('Histogram of Grayscale Image');
xlabel('Pixel Intensity');
ylabel('Frequency');


h = fspecial("average", [5 5]);

M1= imfilter(grey3,h);

figure;
imshow(M1);
title("mean");
histogram6 = imhist(M1);

% Display the histogram of the grayscale image
figure;
bar(histogram6);
title('Histogram of Mean filtered Image');
xlabel('Pixel Intensity');
ylabel('Frequency');


M2= medfilt2(grey3);

figure;
imshow(M2);
title("median");


histogram7 = imhist(M2);

% Display the histogram of the grayscale image
figure;
bar(histogram7);
title('Histogram of M2 Image');
xlabel('Pixel Intensity');
ylabel('Frequency');