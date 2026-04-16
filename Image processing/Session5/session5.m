dollar = imread("dollar.png");

img = rgb2gray(dollar);

figure;
imshow(img);
title("GrayScale image of dollar");

img_vector = img(:);

counts = histcounts(img_vector, 0:255);
symbols = 0:255;

probabilities = counts / prod(size(img_vector));

nonZeroProbs = probabilities(probabilities > 0);
nonZeroSymbols = symbols(probabilities > 0);

[dict, avglen] = huffmandict(nonZeroSymbols,nonZeroProbs)

encoded_img = huffmanenco(img_vector,dict);

decoded_img_vector = huffmandeco(encoded_img,dict);
decoded_img = uint8(reshape(decoded_img_vector,size(img)));

similar = isequal(img,decoded_img)

figure;
imshow(decoded_img);
title("Image after decoding using Huffman Coding");

originalsize = numel(img_vector) * 8

encodedsize = length(encoded_img)

compressionRatio = originalsize / encodedsize

entropy = -sum(probabilities.*log2(probabilities))

efficiency = entropy / avglen

