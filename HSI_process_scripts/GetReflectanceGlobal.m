function GetReflectanceGlobal(ObjectDirectory, WhiteDirectory)
% writes Global_Ref image to HSIData/ConeImages/FlounderNum/Substrate
% writes jpg to folder with tiffs in it
% start HSIData
% Example: GetReflectanceGlobal('Flagged Flounder/12345678.3d', 'Whites/12345678.3d')

% WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];

% ObjectFilename = [ObjectDirectory, '.Rad4U.mat'];
% WhiteFilename = [WhiteDirectory, '.Rad4U.mat'];

ObjectFilename = ObjectDirectory;
WhiteFilename = WhiteDirectory;

load(ObjectFilename); % will load as BandImg
ObjectImg = BandImg;
clear BandImg;
load(WhiteFilename);
WhiteImg = BandImg;

figure
colormap(gray)
imagesc(WhiteImg(:,:,10));

rect = uint16(getrect);
close(gcf);

for i = 1:16
    AvgWhite = nanmean(mean(WhiteImg(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),i)));
    RefObjectImg(:,:,i) = single(ObjectImg(:,:,i))/single(AvgWhite); % make them floating numbers
end

ImgRGB(:,:,1) = RefObjectImg(:,:,15); % 640nm
ImgRGB(:,:,2) = RefObjectImg(:,:,10); % 540nm
ImgRGB(:,:,3) = RefObjectImg(:,:,5);  % 436nm

figure
imshow(ImgRGB);

Output_filename = [ObjectDirectory,'_Global_Ref'];
save(Output_filename, 'RefObjectImg');

GRef_Dest = sprintf('%s', 'ConeImages/');
Output_filename_img = [ObjectDirectory,'_Global_Ref.png'];
imwrite(ImgRGB, Output_filename_img, 'png'); 

movefile(Output_filename, GRef_Dest);
movefile(Output_filename_img, GRef_Dest);
end