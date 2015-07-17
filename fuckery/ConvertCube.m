function ConvertCube(Date)
% interprets binary .3d data files produced by HSI into 16 tiffs and graphs
% them in a 4x4 grid...theoretically

% need to be in the directory to execute the function
% ex: ConvertCube('Jun29')

imagedir = dir(['../', Date, '/*.3d']); 

% for each image 

% imagedir = imagedir(arrayfun(@(x)x.name(1),imagedir) ~='.'); %remove hidden files

for i = 1:length(imagedir); 
%     fid = fopen(imagedir(i).name);
    cuberead = fread(fopen(imagedir(i).name),[2048 2048],'uint16');
    FolderID = imagedir(i).name(1:end-3);
    mkdir(FolderID) % make directory to fill with tiffs
    figure(i);
    
    for j = 1:4
        for k = 1:4 
            subaxis(4,4,k+4*(j-1), 'Spacing', 0.01); % plot all 16 channels in one figure
            ch_unflip = (cuberead(j:4:2048, k:4:2048)); % 512x512 grid of 4x4 squares containing pixels for each channel
            ch = flip(ch_unflip, 2); % image inverted
            channel = sprintf('%s%d%s','chan',k+4*(j-1),'.tif');
            albert = max(max(ch));
            imshow(ch, [0 albert], 'border', 'tight') % make image
%             colormap(gray); % convert to grayscale - does this work?
            % what is this doing?
            outname = sprintf('%s%s%s',imagedir(i).name,'.',channel);
            imwrite(uint16(ch), [FolderID, '/', outname]);
        end
    end
   
end

end

