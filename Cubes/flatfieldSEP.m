s = ones(20,20);
test = ShowRad('defocused_sky');

transformmat = zeros(512,512,16);

for iband = 1:16
temp = squeeze(test(:,:,iband));
smoothedtemp = 1./(conv2(temp,s)+eps);
smoothedtemp(smoothedtemp>3) = 1;
transformtest = smoothedtemp-mean(mean(smoothedtemp(50:500,50:500)))+1;
transformmat(:,:,iband) = transformtest(9:520,9:520);
end