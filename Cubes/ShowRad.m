function ShowCube(Lizards)
% shows ch 1 image without saving/sorting any files
% for use in checking image w/o processing
% ex: ShowCube('Jul31')

imagedir = dir([Lizards, '/*.3d']);

fig = figure;

for i = 1:length(imagedir)
    cuberead = fread(fopen([Lizards '/' imagedir(i).name]), [2048 2048], 'uint16');
    ch_unflip = cuberead(1:4:2048, 1:4:2048);
    ch = flip(ch_unflip, 2);
    mrmaximum = max(max(ch));
    figure(fig);
    imagesc(ch, [0 mrmaximum]);
    colormap(gray);
    axis square;
    axis off;
    title(imagedir(i).name,'Interpreter','none');
    pause
end

end
