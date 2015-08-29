function GetCones(ConeVector, DatName)
% cone vector should be a vector with lambda max values 
% (ex: ConeVector = [450, 550, 600]
% DatName is the name you want to save the .dat file as
% if you want to save the .dat file to a specific folder then specify that
% in DatName

RefNumber = [360, 380, 405, 420, 436, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660];
RefNumber = RefNumber - 299;

for i = 1:length(ConeVector)
    HSIVector(i, :) = GenVPtemplate(ConeVector(i));
end
HSIVector = HSIVector(:, RefNumber);
HSIVector = HSIVector/norm(HSIVector, Inf);

dlmwrite(DatName, HSIVector);
end