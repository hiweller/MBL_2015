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

flagdir = dir('Flagged Files/*.png');

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

F1BlueMask = imread(['FishMask_', F1Blue, '.tiff']);
whitecount = sum(F1BlueMask(:) == 1);
sqrt(17067);
% make circle with area = whitecount


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

j = 1;
for i = 2:length(raw(:,1))
    row = raw(i,:);
    if raw{i,5} == 1
        fprintf(fileID, formatSpec, raw{i,:});
    end
end

formatSpec = '%s %d %d %d %d %d %d %s\n';


[num, txt, raw] = xlsread('flaggedflounder.xls');
postdir = dir('Poster/*.3d');
for i = 2:length(raw(:,1))
    if isnan(raw{i,2}) == 0
        for j = 2:length(raw(:,1))
            if isnan(raw{j,3}) == 0
                if raw{i,2} == raw{j,3}
                    ObjName = raw{j,1};
                    ObjString = strsplit(ObjName, '/');
                    WhiteName = raw{i,1}
                    WhiteString = strsplit(WhiteName, '/');
                    ObjRef = sprintf('%s%s', 'Poster/', ObjString{2});
                    WhiteRef = sprintf('%s%s', 'Whites/', WhiteString{2});
                    GetReflectanceGlobal(ObjRef, WhiteRef);
                    pause
                end
            end
        end
    end
end

for i = 2:length(raw(:,1))
    if isnan(raw{i,2}) == 0
        for j = 2:length(raw(:,1))
            if isnan(raw{j,3}) == 0
                if raw{i,2} == raw{j,3}
                    ObjName = raw{j,1};
                    ObjString = strsplit(ObjName, '/');
                    WhiteName = raw{i,1};
                    WhiteString = strsplit(WhiteName, '/');
                    for k = 1:3
                        if strcmp(ObjString{2}, condir(k).name) == 1
                            ObjRef = sprintf('%s%s', 'Poster/', ObjString{2});
                            WhiteRef = sprintf('%s%s', 'Whites/', WhiteString{2});
                            GetReflectanceGlobal(ObjRef, WhiteRef);
                            pause
                        end
                    end
                end
            end
        end
    end
end


for i = 2:length(raw(:,1))
    for j = 2:length(raw(:,1))
        if isnan(raw{i,2}) == 0 & isnan(raw{j,3}) == 0 & raw{i,2} == raw{j,3}
            HSIname = raw{j,1};
            stringfriend = strsplit(HSIname, '/');
            WhiteRef = sprintf('%s%s', 'Whites/', stringfriend{2});
            ObjectRef = sprintf('%s%s', 'Flagged Flounder/', stringfriend{2});
            GetReflectanceGlobal(ObjectRef, WhiteRef);
        end
    end
end


fsegdir = dir('Masks/SegImg*.png');
postd = dir('Poster/SegImg*.png');
for i = 67:length(fsegdir)
    SegmentImage(fsegdir(i).name, fsegdir(i).name);
end

postdir = dir('Poster/*_Global_Ref');
DirImg = ['Poster/', postdir(1).name];
DateLight = 'Aug4';
LightNum = 1;
LightDirection = 1;

SegmentImage(postd(3).name, postd(3).name);


blackflags = dir('*.3d');
[num, txt, raw] = xlsread('flags.xls');

for i = 1:length(raw(:,1))
    if raw{i,4} == 1
        copyfile(blackflags(i).name, 'Black Flags/');
    elseif strcmp(raw{i,4}, 'WHITE') == 1
        copyfile(blackflags(i).name, 'Black Whites/');
    end
    
end


blackwhites = dir('Black Whites/*.mat');
blackblacks = dir('Black Flages/*.mat');

for i = 1:length(blackblacks)
    GetReflectanceGlobal(['Black Flags/', blackblacks(i).name], ['Black Whites/', blackwhites(2).name])
end

blackgrefs = dir('Black Flags/*_Global_Ref');
for i = 3:length(blackgrefs)
    GetSegmentationImage('Black Flags/', blackgrefs(i).name)
end

blackpngs = dir('Masks/*_Global_Ref.png');
SegmentImage(blackpngs(71).name, blackpngs(71).name);


% eval2 testing on gravel
Directory = 'ConeImages/Gravel';
graveldir = dir('ConeImages/Gravel/*_Global_Ref');
PE1 = zeros(1, length(graveldir));
CE1 = zeros(length(graveldir), 500);
for i = 1:length(graveldir)
    [PE1(i), CE1(i,:)] = Eval2(Directory, graveldir(i).name);
    pause
    close all;
end

% eval2 sand
Directory = 'ConeImages/Sand';
sanddir = dir('ConeImages/Sand/*_Global_Ref');
SandPE1 = zeros(1, length(sanddir));
SandCE1 = zeros(length(sanddir), 500);
for i = 1:length(sanddir)
    [SandPE1(i), SandCE1(i,:)] = Eval2(Directory, sanddir(i).name);
    pause
    close all;
end

Directory = 'ConeImages/Blue';
bluedir = dir('ConeImages/Blue/*_Global_Ref');
BluePE1 = zeros(1, length(bluedir));
BlueCE1 = zeros(length(bluedir), 500);
for i = 1:length(bluedir)
    [BluePE1(i), BlueCE1(i, :)] = Eval2(Directory, bluedir(i).name);
    pause
    close all;
end
mean(BluePE1)
mean2(BlueCE1)
mean(BluePE1)/mean2(BlueCE1);

Directory = 'ConeImages/Black Flags'
blackdir = dir('ConeImages/Black Flags/*_Global_Ref');
BlackPE1 = zeros(1, length(blackdir));
BlackCE1 = zeros(length(blackdir), 500);
for i = 1:length(blackdir)
    [BlackPE1(i), BlackCE1(i,:)] = Eval2(Directory, blackdir(i).name);
    pause
    close all
end


for i = 1:length(blackdir)
    GetSegmentationImage('Black Flags', blackdir(i).name);
end

blackrefs = dir('Masks/*201509011*.png');
for i = 1:length(blackrefs)
    SegmentImage(blackrefs(i).name, blackrefs(i).name);
end
















