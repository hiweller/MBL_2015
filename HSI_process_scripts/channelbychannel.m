function channelbychannel(Directory, Rad4Umat)
load([Directory, '/', Rad4Umat]);
AniMask = importdata(['Masks/AnimalMask_SegImg_', Rad4Umat]);
BGMask = importdata(['Masks/BGMask_SegImg_', Rad4Umat]);
WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

for i = 1:16
    AnimalChannel = BandImg(:,:,i).*AniMask;
    AnimalChannel = reshape(AnimalChannel, 1, 512*512);
    AnimalChannel = AnimalChannel(AnimalChannel~=0);
    AnimalChannel = ksdensity(AnimalChannel);
%     AnimalChannel = AnimalChannel/norm(AnimalChannel, Inf);
    BGChannel = BandImg(:,:,i).*BGMask;
    BGChannel = reshape(BGChannel, 1, 512*512);
    BGChannel = BGChannel(BGChannel~=0);
    BGChannel = ksdensity(BGChannel);
%     BGChannel = BGChannel/norm(BGChannel, Inf);
    subplot(4,4,i), plot(BGChannel); title(WaveNumber{i});
    hold on; plot(AnimalChannel); hold off;
end
    
end