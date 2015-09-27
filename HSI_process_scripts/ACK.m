










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
    [SandPE1(i), SandCE1(i,:)] = EvalEdge(Directory, sanddir(i).name);
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

% quant cone images -- what metrics do i want?
gravelrefs = dir('ConeImages/Gravel/*_Global_Ref');
GravelAll = zeros(1, length(gravelrefs));
GravelAnimal = zeros(1, length(gravelrefs));
for i = 1:length(gravelrefs)
    [GravelAll(i), GravelAnimal(i)] = QuantBuzzardConeImages('ConeImages/Gravel', gravelrefs(i).name);
    pause
    close all;
end




[num, txt, raw] = xlsread('flaggedflounder.xls');

% eval2 testing on gravel
Directory = 'Flagged Flounder/Gravel';
graveldir = dir('Flagged Flounder/Gravel/*.Rad4U.mat');

for i = 1:length(graveldir)
    for j = 2:length(raw(:,1))
        stringfriend = strsplit(raw{j,1}, '/');
        refname = stringfriend{2};
        if strcmp(graveldir(i).name, [refname, '.Rad4U.mat']) == 1 & raw{j,5} == 1
            [PE1(i), CE1(i,:)] = EvalEdge(Directory, graveldir(i).name);
%             pause
            close all;
        end
    end
end

for i = 1:length(PE1)
    tempctrl = CE1(i,:);
    temppct = PE1(i);
    dist = tempctrl(tempctrl >= temppct);
    pct = length(dist)/length(tempctrl);
    gravelpct(i) = pct;
    mean(gravelpct)
end
% mean = 0.0315 (~3%)

% eval2 sand
Directory = 'Flagged Flounder/Sand';
sanddir = dir('Flagged Flounder/Sand/*.Rad4U.mat');
for i = 5:length(sanddir)
    for j = 2:length(raw(:,1))
        stringfriend = strsplit(raw{j,1}, '/');
        refname = stringfriend{2};
        if strcmp(sanddir(i).name, [refname, '.Rad4U.mat']) == 1 & raw{j,5} == 1
            [PE2(i-2), CE2(i-2,:)] = EvalEdge(Directory, sanddir(i).name);
            close all;
        end
    end
end
for i = 1:length(PE2)
    tempctrl = CE2(i,:);
    temppct = PE2(i);
    dist = tempctrl(tempctrl >= temppct);
    pct = length(dist)/length(tempctrl);
    sandpct(i) = pct;
    mean(sandpct)
end
% mean = 0.0131, 0.0057(~1%)

Directory = 'Flagged Flounder/Blue';
bluedir = dir('Flagged Flounder/Blue/*.Rad4U.mat');
for i = 1:length(bluedir)
    for j = 2:length(raw(:,1))
        stringfriend = strsplit(raw{j,1}, '/');
        refname = stringfriend{2};
        if strcmp(bluedir(i).name, [refname, '.Rad4U.mat']) == 1 & raw{j,5} == 1
            [BluePE(i), BlueCE(i,:)] = EvalEdge(Directory, bluedir(i).name);
            close all;
        end
    end
end
for i = 1:length(BluePE)
    tempctrl = BlueCE(i,:);
    temppct = BluePE(i);
    dist = tempctrl(tempctrl >= temppct);
    pct = length(dist)/length(tempctrl);
    bluepct(i) = pct;
end
% mean(bluepct) = 0.1065
mean(BluePE)
mean2(BlueCE)
% mean(BluePE)/mean2(BlueCE);

Directory = 'Flagged Flounder/Black'
blackdir = dir('Flagged Flounder/Black/*.Rad4U.mat');
BlackPE1 = zeros(1, length(blackdir));
BlackCE1 = zeros(length(blackdir), 500);
for i = 1:length(blackdir)
    [BlackPE1(i), BlackCE1(i,:)] = EvalEdge(Directory, blackdir(i).name);
    close all
end
for i = 1:length(BlackPE1)
    tempctrl = BlackCE1(i,:);
    temppct = BlackPE1(i);
    dist = tempctrl(tempctrl >= temppct);
    pct = length(dist)/length(tempctrl);
    blackpct(i) = pct;
    mean(blackpct)
end
% mean(blackpct) = 0 (unsurprising)

rogerref = dir('Roger/*_Global_Ref');


lizdir = dir('Flagged Files/*.mat');

for i = 4:10
    [PE(i-1), CE(i-1,:)] = Eval2('Flagged Files', lizdir(i).name);
    pause
    close all;
end

% for flounder gravel/sand, leopard lizard sun/shade, horned lizard sun/shade
sampledir = dir('Samples/*.3d.Rad4U.mat');
for i = 1:length(sampledir)
    QuantBuzzardConeImages('Samples', sampledir(i).name);
    
    close all;
    
    [PctEdge(i), PctCtrl(i,:)] = Eval2('Samples', sampledir(i).name);
    
    close all;
end


% looking at color diffs
JNDdir = dir('Samples/JND/*.mat');
sampledir = dir('Samples/*.3d.Rad4U.mat');
for i = 1:length(JNDdir)
    JNDimg = importdata(['Samples/JND/', JNDdir(i).name], 1);
    imagesc(JNDimg); axis off; axis image;
    colorbar;
    pause
%     rect = importdata(['Samples/BGMask_SegImg_', sampledir(i).name, '.png.mat']);
    BW_Animal = importdata(['Samples/AnimalMask_SegImg_', sampledir(i).name, '.png.mat']);
    AnimalDist = JNDimg.*BW_Animal;
    imagesc(AnimalDist); axis off; axis image; colorbar;
    pause
    close all;
end

% looking at edge detection
load PctEdge.mat;
load PctCtrl.mat;
JNDdir = dir('Samples/JND/*.mat');
sampledir = dir('Samples/*.3d.Rad4U.mat');
for i = 1:length(JNDdir)
    JNDimg = importdata(['Samples/JND/', JNDdir(i).name], 1);
    figure;
    imagesc(JNDimg); axis off; axis image;
    colorbar;
    pause
    BW_Animal = importdata(['Samples/AnimalMask_SegImg_', sampledir(i).name, '.png.mat']);
    AnimalDist = JNDimg.*BW_Animal;
    figure; imagesc(AnimalDist); axis off; axis image; colorbar;
    pause
    SegImg = imread(['EdgeDetection_', sampledir(i).name, '.png']);
    figure; imshow(SegImg);
    pause
    temppct = PctEdge(i)
    tempctrl = PctCtrl(i,:);
    dist = tempctrl(tempctrl >= temppct);
    pct = length(dist)/length(tempctrl)
    TotalPcts(i) = pct; 
    figure; hist(PctCtrl(i,:), 30); hold on;
    line([temppct temppct], [0 40], 'LineStyle', '--', 'Color', [1 0 0]); hold off;
    pause
    tilefigs
    pause
    close all
end

% first we get the JNDs
ffdir = dir('Flagged Flounder/*'); % just start at i = 4 to ignore hidden files lmao
% substratedir = dir('Flagged Flounder/*/*.Rad4U.mat');
for i = 8:length(ffdir)
    substratedir = dir(['Flagged Flounder/', ffdir(i).name, '/*.Rad4U.mat']);
    for j = 1:length(substratedir)
        QuantBuzzardConeImages(['Flagged Flounder/', ffdir(i).name], substratedir(j).name);
        close all;
    end
    pause
end
% just fyi we gotta skip j = 3 and 4 for sand. not sure why. masks missing
% i guess. i cannot stand making another mask right now, so this will be
% fine.

% then we get the AnimalOnly and BGOnly kernel-smoothed density vectors
load('BadPixelMask.mat');
for i = 4:length(ffdir)
    substratedir = dir(['Flagged Flounder/', ffdir(i).name, '/JND/Raptor_*']);
    
    for j = 1:length(substratedir)
        load(['Flagged Flounder/', ffdir(i).name, '/JND/', substratedir(j).name]);
        AnimalMask = importdata(['Masks/AnimalMask_SegImg_', substratedir(j).name(8:end)]);
        BGMask = importdata(['Masks/BGMask_SegImg_', substratedir(j).name(8:end)]);
        BGOnly = TetraDist.*BGMask.*BadPixelMask;
        BGOnly = ksdensity(BGOnly(BGOnly ~= 0));
        AnimalOnly = TetraDist.*AnimalMask.*BadPixelMask;
        AnimalOnly = ksdensity(AnimalOnly(AnimalOnly ~= 0));
        BGKSDensity(j,:) = BGOnly;
        AnimalKSDensity(j,:) = AnimalOnly;
        plot(BGOnly); hold on; plot(AnimalOnly); hold off
        pause
    end
    close all
    save(['Flagged Flounder/', ffdir(i).name, '/JND/BGKSDensity.mat'], 'BGKSDensity');
    save(['Flagged Flounder/', ffdir(i).name, '/JND/AnimalKSDensity.mat'], 'AnimalKSDensity');
end

% then we plot the combined histograms
subvector = {'Sand' 'Gravel' 'Blue' 'Black'};
namevector = {'Sand' 'Gravel' 'Control'};
for i = 1:3
    refdir = sprintf('%s%s%s', 'Flagged Flounder/', subvector{i}, '/JND/');
    load([refdir, 'RaptorBGKSDensity.mat']);
    load([refdir, 'RaptorAnimalKSDensity.mat']);
%     for j = 1:length(RaptorBGKSDensity(:,1))
%         [whatever(j), pvalues(i,j)] = kstest2((RaptorBGKSDensity(j,:)/norm(RaptorBGKSDensity(j,:), Inf)), (RaptorAnimalKSDensity(j,:)/norm(AnimalKSDensity(j,:), Inf)));
%     end

%     BGsum = sum(Raptor_BGKSDensity)/norm(sum(Raptor_BGKSDensity), Inf);
if i ~=1
    BGS = Raptor_BGKSDensity(1,:);
    BGS2 = BGS/norm(BGS,Inf);
    AS = Raptor_AnimalKSDensity(1,:);
    AS2 = AS/norm(AS, Inf);
else
    BGS = Raptor_BGKSDensity(3,:);
    BGS2 = BGS/norm(BGS,Inf);
    AS = Raptor_AnimalKSDensity(3,:);
    AS2 = AS/norm(AS, Inf);
end

    subplot(3,1,i); plot(BGS2, 'LineWidth', 2); hold on; plot(AS2, 'LineWidth', 2);
    title(namevector{i}, 'FontSize', 20);
    ylabel('Normalized Pixel Counts', 'FontSize', 14);
    if i ==3
        xlabel('Minimal Discriminable Differences', 'FontSize', 14);
    end
    legend({'Background', 'Animal'}, 'Position', [0.69 0.82 0.2 0.08], 'FontSize', 13);
    hold off;
end

% p-values for Kolmogorov-Smirnov: 0.4431, 0.047, 5.7E-10 for
% Sand/Gravel/Blue Gravel respectively

% edge detection metrics
edgesubvector = {'Sand' 'Gravel' 'Black'}
colorvector = {
for i = 3:length(subvector)
    clear PctEdge;
    clear CtrlEdge;
    clear CtrlEdge2;
    clear h; clear bins;
    refdir = sprintf('%s%s%s', 'Flagged Flounder/', subvector{i});
    subdir = dir([refdir, '/*.Rad4U.mat']);
    if i == 1
        for j = [1:2, 5:length(subdir)]
            [PctEdge(j), CtrlEdge(j,:)] = EvalEdge(refdir, subdir(j).name);
        if j ~= length(subdir)
            close all;
        end
        end
    else
    for j = 1:length(subdir)
        [PctEdge(j), CtrlEdge(j,:)] = EvalEdge(refdir, subdir(j).name);
        if j ~= length(subdir)
            close all;
        end
    end
    end
    PctEdge = PctEdge(PctEdge~=0);
    CtrlEdge = CtrlEdge(CtrlEdge~=0);
%     CtrlEdge2 = reshape(CtrlEdge, 1, length(CtrlEdge(:,1))*length(CtrlEdge(1,:)));
%     CtrlEdge2 = CtrlEdge2(CtrlEdge2~=0);
%     bins = 30;
%     h = hist(CtrlEdge2, bins);
%     figure; histogram(CtrlEdge2, bins, 'FaceColor', [0.25 0.4 0.7]); axis([0 0.7 0 (max(h)+5)]); hold on;
%     line([mean(PctEdge) mean(PctEdge)], [0 (max(h)+5)], 'LineStyle', '--', 'Color', [1 0 0]); hold off;
     save([refdir, '/Edge/PctEdge.mat'], 'RaptorPctEdge');
     save([refdir, '/Edge/CtrlEdge.mat'], 'RaptorCtrlEdge');
end

subvector2 = {'Sand' 'Gravel' 'Black'}
for i = 1:length(subvector2)
  refdir = sprintf('%s%s%s', 'Flagged Flounder/', subvector2{i}, '/Edge/');
  load([refdir, 'PctEdge.mat']); load([refdir, 'CtrlEdge.mat']);
  CtrlEdge2 = reshape(CtrlEdge, 1, length(CtrlEdge(:,1))*length(CtrlEdge(1,:)));
  CtrlEdge2 = CtrlEdge2(CtrlEdge2~=0);
  bins = 30;
  h = hist(CtrlEdge2, bins);
  subplot(3,1,i); histogram(CtrlEdge2, bins, 'FaceColor', [0.25 0.4 0.7]); axis([0 0.7 0 (max(h)+20)]); hold on;
  ylabel('Counts', 'FontSize', 14);
  line([mean(PctEdge) mean(PctEdge)], [0 (max(h)+20)], 'LineStyle', '--', 'Color', [1 0 0]); hold off;
  if i == 3
      title('Control', 'FontSize', 16);
      xlabel('Proportion of Animal Outline Recovered by Edge Detection', 'FontSize', 14);
  else
      title(subvector2{i}, 'FontSize', 16);
  end
  legend({'Background', 'Animal'}, 'Position', [0.7 0.83 0.2 0.08], 'FontSize', 13);
end


% THEN we get the women




