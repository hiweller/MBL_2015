
% Directory = 'Jun11';
% find images
imagedir = dir('test'); 

% for each image 

imagedir = imagedir(arrayfun(@(x)x.name(1),imagedir) ~='.'); %remove hidden files

for i = 1:length(imagedir); 
%     fid = fopen(imagedir(i).name);
    cuberead = fread(fopen(imagedir(i).name),[2048 2048],'uint16');
    figure(i);
    for j = 1:4
        for k = 1:4
        hold
        ch = (cuberead(j:4:2048, k:4:2048));
        channel = sprintf('chan',j,'.tiff');
        imagesc(ch); 
        figure(); 
        outname = sprintf('%s%s%s',imagedir(i).name,'.',channel);
        end
    end  
end