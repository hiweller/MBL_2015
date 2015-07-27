% read in deconvolution matrix

DeconMat = cell2mat(textscan(fopen('deconvolution.txt'), '%f'));

for i = 1:16
    index = DeconMat(((i-1)*16+1):(i*16));
    TransforMatrix(:, :, i) = vec2mat(index, 4);
end


