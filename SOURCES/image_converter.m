% 1. Görseli oku ve yeniden boyutlandır
img = imread('image.jpg');  % kendi resminin adını buraya yaz
img = imresize(img, [128 128]);    % boyutlandır

% 2. Renk bileşenlerini al
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

% 3. 16-bit RGB565'e dönüştür
R5 = bitshift(uint16(R), -3);           % 8 bit → 5 bit
G6 = bitshift(uint16(G), -2);           % 8 bit → 6 bit
B5 = bitshift(uint16(B), -3);           % 8 bit → 5 bit

RGB565 = bitor( ...
            bitshift(R5, 11), ...
            bitor(bitshift(G6, 5), B5) ...
         );

% 4. .COE dosyasını oluştur
fid = fopen('image128x128.coe','w');
fprintf(fid, 'memory_initialization_radix=16;\n');
fprintf(fid, 'memory_initialization_vector=\n');

for i = 1:numel(RGB565)
    if i ~= numel(RGB565)
        fprintf(fid, '%04x,\n', RGB565(i));
    else
        fprintf(fid, '%04x;\n', RGB565(i));  % son satır noktalı
    end
end

fclose(fid);
disp("128x128 COE dosyası oluşturuldu.")
