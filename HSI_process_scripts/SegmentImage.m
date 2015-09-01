function SegmentImage(Filename, Refname)
% uses GUI to make two masks: first for animal, second for bg
% saves them to current directory
% also opens reference image
% ex: SegmentImage('12345678.png', '12345678_Global_Ref.jpg')

imgname = Filename(1:end-4);
refimg = imread(Refname);
figure
imshow(refimg);
readimg = imread(Filename);
roiwindow = CROIEditor(readimg);
disp('Create animal mask');
pause

% ROI GUI will pop up; make animal mask (polygon around only organisms)
% click apply when done, DO NOT QUIT GUI WINDOW, then return to command
% window and hit any key

[animalroi, labels, number] = getROIData(roiwindow);

% animalmask = sprintf('%s%s%s', 'AnimalMask_', imgname, '.tiff');
save(['AnimalMask_', imgname], animalroi);
delete(roiwindow);
bgwindow = CROIEditor(readimg);
disp('Create background mask');
pause

[bgroi, bglabels, bgnumber] = getROIData(bgwindow);
bgname = sprintf('%s%s%s', 'BackgroundMask_', imgname, '.tiff');
save(['BGMask_', imgname], bgroi);
delete(bgwindow);
close all;
end