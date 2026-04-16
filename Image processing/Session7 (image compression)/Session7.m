img = imread('lena.png');

lena = rgb2gray(img);

figure;
imshow(lena);

L = 16;

edges = linspace(0,512,L+1)

levels = (edges(1:end-1) + edges(2:end)) / 2



quant = imquantize(lena,edges(2:end-1),levels);

figure;
imshow(uint8(quant));

% delta
delta = 256 / L

% Number of bits per pixel
bits_original = 8;
bits_quantized = log2(L); 


% Compression
compressionRate = bits_original/ bits_quantized;
% MSE (Mean Squared Error)
lena_double = double(lena);
quant_double = double(quant);

MSE = mean((lena_double(:) - quant_double(:)).^2);

disp(['Step size (delta): ', num2str(delta)]);
disp(['Bits per pixel (original): ', num2str(bits_original)]);
disp(['Bits per pixel (quantized): ', num2str(bits_quantized)]);
disp(['Compression ratio: ', num2str(compressionRate)]);
disp(['MSE: ', num2str(MSE)]);
