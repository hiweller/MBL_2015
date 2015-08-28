F1Gravel = '20150806145852.542_47ms.3d_47.00ms';
F1GravelWhite = '20150806150039.656_23ms.3d_23.00ms';
F1Sand = '20150730102012.079_41ms.3d_41.00ms';
F1SandWhite = '20150730102053.278_17ms.3d_17.00ms';

F2Gravel = '20150724104729.711_26ms.3d_26.00ms';
F2GravelWhite = '20150724104454.494_13ms.3d_13.00ms';
F2Sand = '20150730101055.833_42ms.3d_42.00ms';
F2SandWhite = '20150730101144.329_16ms.3d_16.00ms';
F2Rocks = '20150728102430.721_129ms.3d_129.00ms';
F2RocksWhite = '20150728102556.827_75ms.3d_75.00ms';

F3Gravel = '20150724110559.555_33ms.3d_33.00ms';
F3GravelWhite = '20150724110719.795_12ms.3d_12.00ms';
F3Sand = '20150730104549.650_36ms.3d_36.00ms';
F3SandWhite = '20150730104649.934_20ms.3d_20.00ms';

F4Gravel = '20150806145510.796_42ms.3d_42.00ms';
F4GravelWhite = '20150806145556.736_18ms.3d_18.00ms';
F4Sand = '20150730102559.874_43ms.3d_43.00ms';
F4SandWhite = '20150730102726.378_16ms.3d_16.00ms';

F1Blue = '20150814104945.840_31ms.3d_31.00ms';
F2Blue = '20150814105334.625_27ms.3d_27.00ms';
F3Blue = '20150814104909.756_31ms.3d_31.00ms';
F5Blue = '20150814105011.556_31ms.3d_31.00ms';
F135BlueWhite = '20150814105114.261_12ms.3d_12.00ms';
F2BlueWhite = '20150814105518.394_12ms.3d_12.00ms';

imvector = {F1Gravel F1Sand F1Blue F2Gravel F2Sand F2Blue F3Gravel F3Sand F3Blue F4Gravel F4Sand F5Blue};

for i = 1:length(imvector)
    readimg = imread([imvector{i}, '_Global_Ref.jpg']);
    img = roipoly(readimg);
    savename = sprintf('%s%s%s', 'FishMask_', imvector{i}, '.tiff');
    imwrite(img, savename);
    pause
end

% generating fish-only mask
for i = 1:length(imvector)
    readimg = imread([imvector{i}, '_Global_Ref.jpg']);
    roiwindow = CROIEditor(readimg);
    pause
    %     Multi-ROI GUI will pop up; make mask, then click "apply" when done 
    [roi, labels, number] = getROIData(roiwindow);
    
    savename = sprintf('%s%s%s', 'FishMask_', imvector{i}, '.tiff');
    imwrite(roi, savename);
    delete(roiwindow);
end

% generating mask for the background (blocking out fish + bins/edges etc)
for i = 10:length(imvector)
    readimg = imread([imvector{i}, '_Global_Ref.jpg']);
    roiwindow = CROIEditor(readimg);
    pause
%     Multi-ROI GUI will pop up; make mask, then click "apply" when done 
%     select everything non-background (fish, bin sections, shadows etc)
    [roi, labels, number] = getROIData(roiwindow);
    
    savename = sprintf('%s%s%s', 'BackgroundMask_', imvector{i}, '.tiff');
    
%     imcomplement inverts the image so non-background is blacked out
    imwrite(imcomplement(roi), savename);
    delete(roiwindow);
end


% get flagged flounder 3d files
[num, txt, raw] = xlsread('flaggedflounder.xls');

for i = 2:length(raw(:,1))
    HSIname = raw{i,1};
    stringfriend = strsplit(HSIname, '/');
    matsource = sprintf('%s%s%s', 'Highlights/RadFiles/', stringfriend{2}, '.Rad4U.mat');
    pngsource = sprintf('%s%s%s', 'Highlights/RadFiles/', stringfriend{2}, '.Rad4U_RGB.png');
    if raw{i,7} == 1
        copyfile(matsource, 'Whites/');
        copyfile(pngsource, 'Whites/');
        copyfile(HSIname, 'Whites/');
    end
%     if raw{i,5} == 1
%         copyfile(matsource, 'Flagged Flounder/');
%         copyfile(pngsource, 'Flagged Flounder/');
%         copyfile(HSIname, 'Flagged Flounder/');
%     end

end















