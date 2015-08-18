function GetReflectanceGlobal_BatchProcess

WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];
[NUMERIC,TXT,RAW] = xlsread('D:\CHIAO\MBL2015\HSI\lizards_rated','lizards');

for k = 1:178  % k is the total number of image pair (178) we will like to get reflectance iamges 
    for i = 1:2197
     if RAW{i,5} == k & RAW{i,6} == 0
         if RAW{i,7} > 0
             FileIndex1(k) = i;
             FileIndex2(k) = FileIndex2(RAW{i,7});
%              Filename1 = RAW{i,1};
         else
             FileIndex1(k) = i;
%              Filename1 = RAW{i,1};
         end
     elseif RAW{i,5} == k & RAW{i,6} == -1
%         Filename2 = RAW{i,1};
         FileIndex2(k) = i;
     else
     end
    end
    Filename1 = RAW{FileIndex1(k),1};
    Filename2 = RAW{FileIndex2(k),1};
    
    FileObject = ['F:\',Filename1];
    FileWhite = ['F:\',Filename2]; 
%     cuberead1 = fread(fopen(FileObject), [2048 2048], 'uint16');
%     figure;
%     ch_unflip1 = cuberead1(1:4:2048, 1:4:2048);
%     ch1 = fliplr(ch_unflip1);
%     mrmaximum = max(max(ch1));
%     imshow(ch1, [0 mrmaximum]);
%     cuberead2 = fread(fopen(FileWhite), [2048 2048], 'uint16');
%     figure;
%     ch_unflip2 = cuberead2(1:4:2048, 1:4:2048);
%     ch2 = fliplr(ch_unflip2);
%     mrmaximum = max(max(ch2));
%     imshow(ch2, [0 mrmaximum]);

    if str2num(Filename1(35:37)) > 0
        xxx1 = Filename1(35:37);
    elseif str2num(Filename1(35:36)) > 0
        xxx1 = Filename1(35:36);
    else
        xxx1 = Filename1(35);
    end
    if str2num(Filename2(35:37)) > 0
        xxx2 = Filename2(35:37);
    elseif str2num(Filename2(35:36)) > 0
        xxx2 = Filename2(35:36);
    else
        xxx2 = Filename2(35);
    end
    
    for i = 1:16
        ImgFileObject = [FileObject,'_',xxx1,'.00ms_',WaveNumber((i-1)*5+1:i*5),'_global.tiff']; 
        ImgObject(:,:,i) = imread(ImgFileObject,'tiff');
        ImgFileWhite = [FileWhite,'_',xxx2,'.00ms_',WaveNumber((i-1)*5+1:i*5),'_global.tiff']; 
        ImgWhite(:,:,i) = imread(ImgFileWhite,'tiff');
    end
    
    figure
    colormap(gray)
    imagesc(ImgWhite(:,:,10));
    rect = uint16(getrect);
    close(gcf);
    
    for i = 1:16
        AvgWhite = mean2(ImgWhite(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),i));
        RefObjectImg(:,:,i) = double(ImgObject(:,:,i))/double(AvgWhite); % make them floating numbers
    end
    ImgRGB(:,:,1) = RefObjectImg(:,:,15); % 640nm
    ImgRGB(:,:,2) = RefObjectImg(:,:,10); % 540nm
    ImgRGB(:,:,3) = RefObjectImg(:,:,5);  % 436nm
    figure
    imshow(ImgRGB);
    
    Output_filename_img = [FileObject,'_global_Ref_RGB.tiff'];
    imwrite(ImgRGB, Output_filename_img, 'tiff');

    Output_filename = [FileObject,'_global_Ref.mat'];
    save(Output_filename, 'RefObjectImg','-mat');
end

end