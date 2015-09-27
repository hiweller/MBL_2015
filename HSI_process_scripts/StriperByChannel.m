function StriperByChannel(Directory, Rad4Umat)
load Striper2Cones.dat;
load([Directory, '/', Rad4Umat]);
AniMask = importdata(['Masks/AnimalMask_SegImg_', Rad4Umat]);
BGMask = importdata(['Masks/BGMask_SegImg_', Rad4Umat]);
WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

for i = 1:16
    Simg(:,:,i) = BandImg(:,:,i)*Striper2Cones(1,i);
    Limg(:,:,i) = BandImg(:,:,i)*Striper2Cones(2,i);
end

% Simg = sum(Simg,3);
% Limg = sum(Limg,3);

figure;
for i = 1:16
    SAnimalChannel = Simg(:,:,i).*AniMask;
    SAnimalChannel = reshape(SAnimalChannel, 1, 512*512);
    SAnimalChannel = SAnimalChannel(SAnimalChannel~=0);
        SAnimalChannel = SAnimalChannel*5;
    SAnimalChannel = ksdensity(SAnimalChannel);
%     SAnimalChannel = SAnimalChannel/norm(SAnimalChannel, Inf);
    BGChannel = BandImg(:,:,i).*BGMask;
    BGChannel = reshape(BGChannel, 1, 512*512);
    BGChannel = BGChannel(BGChannel~=0);
    BGChannel = ksdensity(BGChannel);
%     BGChannel = BGChannel/norm(BGChannel, Inf);
    subplot(4,4,i), plot(BGChannel); title(WaveNumber{i});
    hold on; plot(SAnimalChannel); hold off;
end

figure;
for i = 1:16
    LAnimalChannel = Limg(:,:,i).*AniMask;
    LAnimalChannel = reshape(LAnimalChannel, 1, 512*512);
    LAnimalChannel = LAnimalChannel(LAnimalChannel~=0);
        LAnimalChannel = LAnimalChannel*5;
    LAnimalChannel = ksdensity(LAnimalChannel);

%     LAnimalChannel = LAnimalChannel/norm(LAnimalChannel, Inf);
    BGChannel = BandImg(:,:,i).*BGMask;
    BGChannel = reshape(BGChannel, 1, 512*512);
    BGChannel = BGChannel(BGChannel~=0);
    BGChannel = ksdensity(BGChannel);
%     BGChannel = BGChannel/norm(BGChannel, Inf);
    subplot(4,4,i), plot(BGChannel); title(WaveNumber{i});
    hold on; plot(LAnimalChannel); hold off;
end
    
Simg = sum(Simg, 3);
SSumAnimal = Simg.*AniMask;
SSA = reshape(SSumAnimal, 1, 512*512);
SSA = SSA(SSA~=0);
SSA = ksdensity(SSA);
SSB = Simg.*BGMask;
SSB = reshape(SSB, 1, 512*512);
SSB = SSB(SSB~=0);
SSB = ksdensity(SSB);
Limg = sum(Limg, 3);
LSA = Limg.*AniMask;
LSA = reshape(LSA, 1, 512*512);
LSA = LSA(LSA~=0);
LSA = ksdensity(LSA);
LSB = Limg.*BGMask;
LSB = reshape(LSB, 1, 512*512);
LSB = LSB(LSB~=0);
LSB = ksdensity(LSB);
    
figure; plot(SSB); title('S cone'); hold on; plot(SSA); hold off;
figure; plot(LSB); title('L cone'), hold on; plot(LSA); hold off;    
end