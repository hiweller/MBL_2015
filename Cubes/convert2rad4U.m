function convert2rad4U

% 360, 380, 405, 420, 436, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660    |Filter Wavelengths
% 9,   6,   5,   13,  3,   10,  14,  15,  4,   8,   0,   11,  12,  1,   7,   2      |Filter array map (sub pixel index of above wavelengths)
% ¡¥0¡¦ indexed, from left-to-right, top-to-bottom as they appear from the perspective of the focal plane.
ArrayInx = [9,   6,   5,   13,  3,   10,  14,  15,  4,   8,   0,   11,  12,  1,   7,   2];
ArrayInx = ArrayInx+1; % make index starting from 1

WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};
[NUMERIC,TXT,RAW] = xlsread('D:\CHIAO\MBL2015\HSI\lizards_rated','lizards');

imagedir = dir([Lizards, '/*.3d']);

fig = figure;

for i = 1:length(imagedir)
    cuberead = fread(fopen([Lizards '/' imagedir(i).name]), [2048 2048], 'uint16');
    ch_unflip = cuberead(1:4:2048, 1:4:2048);
    ch = flip(ch_unflip, 2);
    mrmaximum = max(max(ch));
    figure(fig);
    imagesc(ch, [0 mrmaximum]);
    colormap(gray);
    axis square;
    axis off;
    title(imagedir(i).name,'Interpreter','none');
    pause
end

for k = 1:178  % k is the total number of image pair (178) we will like to get reflectance iamges 
    for i = 1:2197
     if RAW{i,5} == k & RAW{i,6} == 0
         FileIndex1(k) = i;
     else
     end
    end
    Filename1 = RAW{FileIndex1(k),1};    
    FileObject = ['F:\',Filename1];
    SuperPixelImg = fread(fopen(FileObject), [2048 2048], 'uint16');
    for i = 1:4
        FilterImg(:,:,i)=SuperPixelImg(i:4:2048,1:4:2048);
    end
    for i = 5:8
        FilterImg(:,:,i)=SuperPixelImg(i-4:4:2048,2:4:2048);
    end
    for i = 9:12
        FilterImg(:,:,i)=SuperPixelImg(i-8:4:2048,3:4:2048);
    end
    for i = 13:16
        FilterImg(:,:,i)=SuperPixelImg(i-12:4:2048,4:4:2048);
    end
    for j = 1:16
        BandImg(:,:,j) = fliplr(FilterImg(:,:,ArrayInx(j))); % flip image left-right
    end
    BandImg = double(BandImg)/2^16;

    RGBImg(:,:,1) = BandImg(:,:,15)/max(BandImg(:)); % 640 nm
    RGBImg(:,:,2) = BandImg(:,:,10)/max(BandImg(:)); % 540 nm
    RGBImg(:,:,3) = BandImg(:,:,5)/max(BandImg(:)); % 436 nm

    Output_filename_img = [FileObject,'_PseudoColor_RGB.png'];
    imwrite(RGBImg, Output_filename_img, 'png');
end

end
