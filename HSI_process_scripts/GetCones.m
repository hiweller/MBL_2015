function GetCones(ConeVector, DatName)
% cone vector should be a vector with lambda max values 
% (ex: ConeVector = [450, 550, 600]
% DatName is the name you want to save the .dat file as
% if you want to save the .dat file to a specific folder then specify that
% in DatName

% Using template from Stavenga et al (1993)
% Based on Alpha band only
A = 1;
a0 = 380;
a1 = 6.09;
a2 = 13.90804;

RefNumber = [360, 380, 405, 420, 436, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660];
RefNumber = RefNumber - 299;

for j = 1:length(ConeVector)
    spectrum = zeros(1,501);
    LambdaMax = ConeVector(j);
    for i = 1:501
        spectrum(i) = A*exp((-1)*a0*((log10((i+299)/LambdaMax))^2)*(1+(a1*(log10((i+299)/LambdaMax)))+(a2*(log10((i+299)/LambdaMax))^2)));
    end
    HSIVector(j, :) = spectrum;
end
HSIVector = HSIVector(:, RefNumber);
HSIVector = HSIVector/norm(HSIVector, Inf);

dlmwrite(DatName, HSIVector);
end