function ConvertCube(Date)


% Directory = 'Jun11';
% find images
imagedir = dir(Date); 

% for each image 

imagedir = imagedir(arrayfun(@(x)x.name(1),imagedir) ~='.'); %remove hidden files

for i = 1:length(imagedir); 
    fid = fopen(imagedir(i).name);
    cuberead = fread(fid,[2048 2048],'uint16');
%     figure(i); subplot(4,4,1);
    for j = 1:4
        for k = 1:4
        ch = (cuberead(j:4:2048, k:4:2048));
        channel = sprintf('chan',j,'.tiff');
        imagesc(ch); 
%         figure; subplot(j,k,1);
        outname = sprintf('%s%s%s',imagedir(i).name,'.',channel);
        end
    end  
end

end

