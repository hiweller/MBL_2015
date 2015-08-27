% for i = 1:length(imvector)
%     readimg = imread([imvector{i}, '_Global_Ref.jpg']);
%     img = roipoly(readimg);
%     savename = sprintf('%s%s%s', 'FishMask_', imvector{i}, '.tiff');
%     imwrite(img, savename);
%     pause
% end

flagdir = dir('Flagged Files/*.png');
% generating lizard-only mask
for i = 1:length(flagdir)
    readimg = imread(flagdir(i).name);
    roiwindow = CROIEditor(readimg);
    pause
    %     Multi-ROI GUI will pop up; make mask, then click "apply" when done 
    [roi, labels, number] = getROIData(roiwindow);
    
    savename = sprintf('%s%s%s', 'LizardMask_', imvector{i}, '.tiff');
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



