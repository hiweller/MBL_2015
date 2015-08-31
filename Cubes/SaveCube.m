function SaveCube(Date)
% saves tiffs of image

imagedir = dir([Date, '/*.3d']);

fig = figure;

for i = 1:length(imagedir)
    cuberead = fread(fopen([Date '/' imagedir(i).name]), [2048 2048], 'uint16');
    ch_unflip = cuberead(1:4:2048, 1:4:2048);
    ch = flip(ch_unflip, 2);
    mrmaximum = max(max(ch));
    imgsave = imagesc(ch, [0 mrmaximum]);
    figure(fig);
    imgsave;
    colormap(gray);
    axis square;
    axis off;
    title(imagedir(i).name,'Interpreter','none');
    export_fig([Date, '/', imagedir(i).name]);
    pause
end

end
