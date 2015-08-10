function GetReflectanceGlobal(Date, ObjectDirectory, WhiteDirectory)
% Example: GetReflectanceGlobal('Aug6','2014-08-06-14hr25min40sec','2014-08-06-14hr25min40sec',1.3)

WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];

for i = 1:16
    ObjectFilename = [Date,'/',ObjectDirectory,'/',ObjectDirectory,'_',WaveNumber((i-1)*5+1:i*5),'_global.tiff'];  
    ObjectImg(:,:,i) = imread(ObjectFilename,'tiff');
    WhiteFilename = [Date,'/',WhiteDirectory,'/',WhiteDirectory,'_',WaveNumber((i-1)*5+1:i*5),'_global.tiff'];  
    WhiteImg(:,:,i) = imread(WhiteFilename,'tiff');
end

figure
colormap(gray)
imagesc(WhiteImg(:,:,10));

rect = uint16(getrect);
close(gcf);

for i = 1:16
    AvgWhite = mean2(WhiteImg(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),i));
    RefObjectImg(:,:,i) = single(ObjectImg(:,:,i))/single(AvgWhite); % make them floating numbers
end

ImgRGB(:,:,1) = RefObjectImg(:,:,15); % 640nm
ImgRGB(:,:,2) = RefObjectImg(:,:,10); % 540nm
ImgRGB(:,:,3) = RefObjectImg(:,:,5);  % 436nm

figure
imshow(ImgRGB);

Output_filename = [ObjectDirectory,'_Global_Ref'];
save(Output_filename, 'RefObjectImg');

Output_filename_img = [ObjectDirectory,'_Global_Ref.jpg'];
imwrite(ImgRGB, Output_filename_img, 'jpeg'); 

end