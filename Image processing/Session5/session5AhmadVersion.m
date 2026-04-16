i1 = imread('lena.png'); 
img = rgb2gray(i1);
img_vector = double(img(:));  

figure;
imshow(img);
title('original img');


symbols = unique(img_vector);
counts = histcounts(img_vector, [symbols; max(symbols)+1]);
probs = counts / sum(counts);


[dict, avglen] = huffmandict(symbols, probs);


encoded_data = huffmanenco(img_vector, dict);


decoded_vector = huffmandeco(encoded_data, dict);
reconstructed_img = reshape(uint8(decoded_vector), size(img));


figure;
imshow(reconstructed_img);
title('Decoded Image');