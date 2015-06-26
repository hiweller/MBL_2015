function GetReflectanceRaw(Date, ObjectDirectory, WhiteDirectory)

WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];

for i = 1:16
    ObjectFilename = [Date,'/',ObjectDirectory,'/',ObjectDirectory,'_',WaveNumber((i-1)*5+1:i*5),'_raw.tiff'];  
    ObjectImg(:,:,i) = imread(ObjectFilename,'tiff');
    WhiteFilename = [Date,'/',WhiteDirectory,'/',WhiteDirectory,'_',WaveNumber((i-1)*5+1:i*5),'_raw.tiff'];  
    WhiteImg(:,:,i) = imread(WhiteFilename,'tiff');
end

UpBound = max(max(WhiteImg(:,:,10)));
sc = 2^16/UpBound;
ScaledImg = WhiteImg*sc;

figure
imshow(ScaledImg(:,:,10));

rect = uint16(getrect);
close(gcf);

for i = 1:16
    AvgWhite = mean2(WhiteImg(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),i));
    RefObjectImg(:,:,i) = (double(ObjectImg(:,:,i))/AvgWhite)*(2^16-1);
end

ImgRGB(:,:,1) = RefObjectImg(:,:,15); % 640nm
ImgRGB(:,:,2) = RefObjectImg(:,:,10); % 540nm
ImgRGB(:,:,3) = RefObjectImg(:,:,5);  % 436nm

ScaledImgRGB = uint8(ImgRGB/256);
Output_filename_img = [Date,'/',ObjectDirectory,'/',ObjectDirectory,'_raw_Ref.tiff'];

figure
imshow(ScaledImgRGB);
imwrite(ScaledImgRGB, Output_filename_img, 'tiff');

% ScaledRefObjectImg = uint8(RefObjectImg/256);
% for i = 1:16
%     Output_filename_img = [Date,'/',ObjectDirectory,'/',ObjectDirectory,'_raw_Ref',num2str(i),'.tiff'];
%     imwrite(ScaledRefObjectImg(:,:,i), Output_filename_img, 'tiff');
% end

Output_filename = [Date,'/',ObjectDirectory,'/',ObjectDirectory,'_raw_Ref'];
save(Output_filename, 'RefObjectImg');
end