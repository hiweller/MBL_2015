function Spectra_PCA(Folder)
% can make this function either run in a folder or load everything in
% workspace first -- for now i'll set it to run in a folder
% run in a folder that CONTAINS THE TWO FOLDERS with your dat files for
% comparison since ProcessSpec names them the same each time 

% assumes you already ran ProcessSpec and have .dat files for comparison
% run PCA on each channel/.dat file
% plot them all as subplots maybe?
% specdir = dir(['../',Folder])
% specdir = (arrayfun(@(x)x.name(1),specdir) ~='.')

figure(1)
for i = [0, 1, 3, 4, 6, 7]
    
    if i == 0
        j = 1
    elseif i == 1
        j = 2
    elseif i == 3
        j = 3
    elseif i == 4
        j = 4
    elseif i == 6
        j = 5
    else
        j = 6
    end 
    if j ~= 6
        filename = sprintf('%s%d%s', 'Spec_ch',i,'_Spec.dat');
        datfile = load(filename);
        coeff = pca(datfile.');
        subplot(2, 3, j)
        plot(coeff(:,1),coeff(:,2),'+')
    else
        subplot(2,3,j) % just plotting nonsense to fill the 6th space as a test
        plot(1:10, 1:10, '.')
    end
end

end
% function(Group1, Group2) and compares them channel by channel using PCA