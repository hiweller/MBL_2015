% change to 1 if you want to save outputs
Image_save = 1;

% find all the images you need to work on
d = dir('2014*sec');


% for each image
for ii = 1:length(d),
    fid = fopen(d(ii).name);
    I1 = fread(fid,[2560 2160],'uint16');
    for jj = 1:4,
        ch=(I1(jj:4:2560,1:4:2160));
        channel = sprintf('%s%02d%s','chan',jj,'.tif')
        imagesc(ch);
        hold
    
        if Image_save,
            outname = sprintf('%s%s%s',d_input(ii).name,'.',channel);
            eval(['print -dtiff ' outname]);
        end;
    end;
    for jj = 5:8,
        ch=(I1(jj-4:4:2560,2:4:2160));
        channel = sprintf('%s%02d%s','chan',jj,'.tif')
        imagesc(ch);
        hold
    
        if Image_save,
            outname = sprintf('%s%s%s',d_input(ii).name,'.',channel);
            eval(['print -dtiff ' outname]);
        end;
    end;
    for jj = 9:12,
        ch=(I1(jj-8:4:2560,3:4:2160));
        channel = sprintf('%s%02d%s','chan',jj,'.tif')
        imagesc(ch);
        hold
    
        if Image_save,
            outname = sprintf('%s%s%s',d_input(ii).name,'.',channel);
            eval(['print -dtiff ' outname]);
        end;
    end;
    for jj = 13:16,
        ch=(I1(jj-12:4:2560,4:4:2160));
        channel = sprintf('%s%02d%s','chan',jj,'.tif')
        imagesc(ch);
        hold
    
        if Image_save,
            outname = sprintf('%s%s%s',d_input(ii).name,'.',channel);
            eval(['print -dtiff ' outname]);
        end;
    end;
end;