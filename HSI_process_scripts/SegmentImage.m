function SegmentImage(Filename, Refname)
% uses GUI to make three masks: non-artifacts (get rid of hands, bins,
% glare, etc), animal-only, bg-only
% saves them to current directory
% also opens reference image
% ex: SegmentImage('12345678.png', '12345678_Global_Ref.jpg')

imgname = Filename;
refimg = imread(['Masks/', Refname]);
figure
imshow(refimg);
readimg = imread(['Masks/', Filename]);
artifactroi = roipoly(readimg);
% aroiwindow = CROIEditor(readimg);
disp('Create non-artifact mask');
pause
% ROI GUI will pop up; draw polygon around anything you don't want analyses
% to ignore (both animal + background but not artificial things)
% click apply when done, DO NOT QUIT GUI WINDOW, return to command window
% and hit any key
% [artifactroi, labels, number] = getROIData(aroiwindow);
save(['Masks/GeneralMask_', imgname, '.mat'], 'artifactroi');
% delete(aroiwindow);

% roiwindow = CROIEditor(readimg);
animalroi = roipoly(readimg);
disp('Create animal mask');
pause
% [animalroi, labels, number] = getROIData(roiwindow);
save(['Masks/AnimalMask_', imgname, '.mat'], 'animalroi');
% delete(roiwindow);

bgwindow = CROIEditor(readimg);
disp('Create background mask');
pause
[bgroi, bglabels, bgnumber] = getROIData(bgwindow);
save(['Masks/BGMask_', imgname, '.mat'], 'bgroi');
delete(bgwindow);
close all;
end