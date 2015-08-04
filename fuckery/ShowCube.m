function ShowCube(Date)
% shows ch 1 image without saving/sorting any files
% for use in checking image w/o processing
% should be in the directory
% ex: ShowCube('Jul31')

imagedir = dir(['../', Date, '/*.3d']);

for i = 1:length(imagedir)
    cuberead = fread(fopen(imagedir(i).name), [2048 2048], 'uint16');
    figure;
    ch_unflip = cuberead(1:4:2048, 1:4:2048);
    ch = flip(ch_unflip, 2);
    mrmaximum = max(max(ch));
    imshow(ch, [0 mrmaximum]);
    title(imagedir(i).name);
end

end






