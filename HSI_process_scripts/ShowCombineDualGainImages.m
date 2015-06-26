function ShowCombineDualGainImages(FilenameHGm,FilenameHGmw,FilenameLGm,FilenameLGmw)
% Example: ShowCombineDualGainImages('Aug21/2014-08-21-10hr35min14sec','Aug21/2014-08-21-10hr35min24sec','Aug21/2014-08-21-10hr35min33sec','Aug21/2014-08-21-10hr35min40sec')
% Example: ShowCombineDualGainImages('Aug21/2014-08-21-10hr36min06sec','Aug21/2014-08-21-10hr36min15sec','Aug21/2014-08-21-10hr36min24sec','Aug21/2014-08-21-10hr36min33sec')

% high gain (moth only)
fid = fopen(FilenameHGm);
Img = fread(fid,[2560 2160],'uint16');
for i = 1:4
    HGm(:,:,i)=(Img(i:4:2560,1:4:2160));
end;
for i = 5:8
    HGm(:,:,i)=(Img(i-4:4:2560,2:4:2160));
end;
for i = 9:12
    HGm(:,:,i)=(Img(i-8:4:2560,3:4:2160));
end;
for i = 13:16
    HGm(:,:,i)=(Img(i-12:4:2560,4:4:2160));
end;

% figure
% for i = 1:16
%     subplot(4,4,i), imshow(HGm(:,:,i)/2^12);
% end

figure
colormap(gray)
for i = 1:16
    subplot(4,4,i), imshow(HGm(:,:,i),[0 4096]);
end

% CompImg(:,:,1) = HGm(:,:,15)./2^12;
% CompImg(:,:,2) = HGm(:,:,10)./2^12;
% CompImg(:,:,3) = HGm(:,:,5)./2^12;
% 
% figure
% subplot(2,2,1), imshow(HGm(:,:,5)./2^12);
% subplot(2,2,2), imshow(HGm(:,:,10)./2^12);
% subplot(2,2,3), imshow(HGm(:,:,15)./2^12);
% subplot(2,2,4), imshow(CompImg);

% high gain (moth + white)
fid = fopen(FilenameHGmw);
Img = fread(fid,[2560 2160],'uint16');
for i = 1:4
    HGmw(:,:,i)=(Img(i:4:2560,1:4:2160));
end;
for i = 5:8,
    HGmw(:,:,i)=(Img(i-4:4:2560,2:4:2160));
end;
for i = 9:12
    HGmw(:,:,i)=(Img(i-8:4:2560,3:4:2160));
end;
for i = 13:16
    HGmw(:,:,i)=(Img(i-12:4:2560,4:4:2160));
end;

figure
colormap(gray)
for i = 1:16
    subplot(4,4,i), imshow(HGmw(:,:,i),[0 4096]);
end

% low gain (moth only)
fid = fopen(FilenameLGm);
Img = fread(fid,[2560 2160],'uint16');
for i = 1:4
    LGm(:,:,i)=(Img(i:4:2560,1:4:2160));
end;
for i = 5:8
    LGm(:,:,i)=(Img(i-4:4:2560,2:4:2160));
end;
for i = 9:12
    LGm(:,:,i)=(Img(i-8:4:2560,3:4:2160));
end;
for i = 13:16
    LGm(:,:,i)=(Img(i-12:4:2560,4:4:2160));
end;

figure
colormap(gray)
for i = 1:16
    subplot(4,4,i), imshow(LGm(:,:,i),[0 4096]);
end

% low gain (moth + white)
fid = fopen(FilenameLGmw);
Img = fread(fid,[2560 2160],'uint16');
for i = 1:4
    LGmw(:,:,i)=(Img(i:4:2560,1:4:2160));
end;
for i = 5:8
    LGmw(:,:,i)=(Img(i-4:4:2560,2:4:2160));
end;
for i = 9:12
    LGmw(:,:,i)=(Img(i-8:4:2560,3:4:2160));
end;
for i = 13:16
    LGmw(:,:,i)=(Img(i-12:4:2560,4:4:2160));
end;

figure
colormap(gray)
for i = 1:16
    subplot(4,4,i), imshow(LGmw(:,:,i),[0 4096]);
end

end