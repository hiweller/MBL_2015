function SaveCube(Date)
% shows ch 1 image without saving/sorting any files
% for use in checking image w/o processing
% should be above the directory
% ex: be in the directory containing the directory 'Jul21'

% flounderdir = dir([Date, '/JuvFlounder #*/']);
flounderdir = dir(Date);
for i = 1:length(flounderdir)
    
    imagedir = dir([Date, '/', flounderdir(i).name, '/*.3d']);
    
    for j = 1:length(imagedir)
        cuberead = fread(fopen([Date, '/', flounderdir(i).name, '/', imagedir(j).name]), [2048 2048], 'uint16');
        figure;
        ch_unflip = cuberead(1:4:2048, 1:4:2048);
        ch = flip(ch_unflip, 2);
        mrmaximum = max(max(ch));
        imshow(ch, [0 mrmaximum]);
        title(imagedir(j).name);
        export_fig([Date, '/', flounderdir(i).name, '/', imagedir(j).name]);
    end
end

end
