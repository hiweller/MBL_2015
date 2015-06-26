function GetCombineDualGainImages(FilenameHG,FilenameLG)
% Example: GetCombineDualGainImages('Aug21/2014-08-21-10hr35min14sec','Aug21/2014-08-21-10hr35min33sec')
% Example: GetCombineDualGainImages('Aug21/2014-08-21-10hr35min24sec','Aug21/2014-08-21-10hr35min40sec')

OutFilename = [FilenameHG,'-HLgain'];

% high gain (moth only)
fid1 = fopen(FilenameHG);
ImgHG = fread(fid1,[2560 2160],'uint16');
fclose(fid1);
% low gain (moth only)
fid2 = fopen(FilenameLG);
ImgLG = fread(fid2,[2560 2160],'uint16');
fclose(fid2);

PercentSaturatedPixel_HighGain = length(find(ImgHG >= 4095))/(2560*2160)*100 % report the percent saturated pixels in the high gain image
PercentSaturatedPixel_LowGain = length(find(ImgLG >= 4095))/(2560*2160)*100 % report the percent saturated pixels in the low gain image

inx1 = find(ImgHG >= 4095); % saturated pixels in the high gain image
inx2 = find(ImgHG < 4095); % non-saturated pixels in the high gain image
ImgHG(inx1) = 0; % make saturated pixels in the high gain image zeros
ImgLG = (ImgLG/4096)*(12464-2048)+2048; % scale up pixel values in the low gain image
ImgLG(inx2) = 0; % make non-saturated pixels of the high gain image in the low gain image zeros
ImgTemp = ImgHG + ImgLG; % combined high and low gain images (about 13.5 bit image now)
 
fid3 = fopen(OutFilename,'w');
fwrite(fid3,ImgTemp,'uint16'); 
fclose(fid3);

for i = 1:4
    ImgDualGain(:,:,i)=(ImgTemp(i:4:2560,1:4:2160));
end;
for i = 5:8
    ImgDualGain(:,:,i)=(ImgTemp(i-4:4:2560,2:4:2160));
end;
for i = 9:12
    ImgDualGain(:,:,i)=(ImgTemp(i-8:4:2560,3:4:2160));
end;
for i = 13:16
    ImgDualGain(:,:,i)=(ImgTemp(i-12:4:2560,4:4:2160));
end;

sc1 = 12464;
figure
for i = 1:16
    subplot(4,4,i), imshow(ImgDualGain(:,:,i),[0 sc1]);
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf 13.5 bit image','HorizontalAlignment','center','VerticalAlignment', 'top');

sc2 = 2^12;
figure
for i = 1:16
    subplot(4,4,i), imshow(ImgDualGain(:,:,i),[0 sc2]);
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf 12 bit image','HorizontalAlignment','center','VerticalAlignment', 'top');

sc3 = 2^10;
figure
for i = 1:16
    subplot(4,4,i), imshow(ImgDualGain(:,:,i),[0 sc3]);
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf 10 bit image','HorizontalAlignment','center','VerticalAlignment', 'top');

CompImg1(:,:,1) = ImgDualGain(:,:,15)/sc1; CompImg1(:,:,2) = ImgDualGain(:,:,10)/sc1; CompImg1(:,:,3) = ImgDualGain(:,:,5)/sc1;
CompImg2(:,:,1) = ImgDualGain(:,:,15)/2^13; CompImg2(:,:,2) = ImgDualGain(:,:,10)/2^13; CompImg2(:,:,3) = ImgDualGain(:,:,5)/2^13;
CompImg3(:,:,1) = ImgDualGain(:,:,15)/2^12.5; CompImg3(:,:,2) = ImgDualGain(:,:,10)/2^12.5; CompImg3(:,:,3) = ImgDualGain(:,:,5)/2^12.5;
CompImg4(:,:,1) = ImgDualGain(:,:,15)/sc2; CompImg4(:,:,2) = ImgDualGain(:,:,10)/sc2; CompImg4(:,:,3) = ImgDualGain(:,:,5)/sc2;

figure
subplot(2,2,1), imshow(CompImg1); title('13.5 bit image');
subplot(2,2,2), imshow(CompImg2); title('12 bit image');
subplot(2,2,3), imshow(CompImg3); title('12.5 bit image');
subplot(2,2,4), imshow(CompImg4); title('12 bit image');

end