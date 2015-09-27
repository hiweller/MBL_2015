function ParalichthysByChannel(Directory, Rad4Umat)
load Paralichthys2Cones.dat;
load([Directory, '/', Rad4Umat]);
AniMask = importdata(['Masks/AnimalMask_SegImg_', Rad4Umat]);
BGMask = importdata(['Masks/BGMask_SegImg_', Rad4Umat]);
WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

for i = 1:16
    Simg(:,:,i) = BandImg(:,:,i)*Paralichthys2Cones(1,i);
    Limg(:,:,i) = BandImg(:,:,i)*Paralichthys2Cones(2,i);
end


figure;
for i = 1:16
    SAnimalChannel = Simg(:,:,i).*AniMask;
    SAnimalChannel = reshape(SAnimalChannel, 1, 512*512);
    SAnimalChannel = SAnimalChannel(SAnimalChannel~=0);
%         SAnimalChannel = SAnimalChannel;
    SAnimalChannel = ksdensity(SAnimalChannel);
%     SAnimalChannel = SAnimalChannel/norm(SAnimalChannel, Inf);
    SBGChannel = Simg(:,:,i).*BGMask;
    SBGChannel = reshape(SBGChannel, 1, 512*512);
    SBGChannel = SBGChannel(SBGChannel~=0);
    SBGChannel = ksdensity(SBGChannel)*5;
%     BGChannel = BGChannel/norm(BGChannel, Inf);
    subplot(4,4,i),  plot(SBGChannel); title(WaveNumber{i});
    hold on; plot(SAnimalChannel); hold off;
end



figure;
for i = 1:16
    LAnimalChannel = Limg(:,:,i).*AniMask;
    LAnimalChannel = reshape(LAnimalChannel, 1, 512*512);
    LAnimalChannel = LAnimalChannel(LAnimalChannel~=0);
        LAnimalChannel = LAnimalChannel;
    LAnimalChannel = ksdensity(LAnimalChannel);

%     LAnimalChannel = LAnimalChannel/norm(LAnimalChannel, Inf);
    LBGChannel = Limg(:,:,i).*BGMask;
    LBGChannel = reshape(LBGChannel, 1, 512*512);
    LBGChannel = LBGChannel(LBGChannel~=0);
    LBGChannel = ksdensity(LBGChannel)*5;
%     BGChannel = BGChannel/norm(BGChannel, Inf);
    subplot(4,4,i), plot(LBGChannel); title(WaveNumber{i});
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