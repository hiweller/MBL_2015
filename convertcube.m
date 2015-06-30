
% Directory = 'Jun11';
% find images
imagedir = dir('test'); 

% for each image 

imagedir = imagedir(arrayfun(@(x)x.name(1),imagedir) ~='.'); %remove hidden files

for i = 1:length(imagedir); 
    fid = fopen(imagedir(i).name);
    cuberead = fread(fid,[2048 2048],'uint16');
    for j = 1:4
        ch = (cuberead(j:4:2560, 1:4:2160));
        channel = sprintf('%s%02d%s','chan',j,'.tiff');
        imagesc(ch);
        hold
        outname = sprintf('%s%s%s',imagedir_input(i).name,'.',channel);
   
    end
    
    for j = 5:8
        ch = (cuberead(j:4:2048, 2:4:
        
    end
    
    for j = 9:12 
    end
    
    for j = 13:16
    end
    
       
        
    
end
