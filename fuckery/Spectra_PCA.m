function Spectra_PCA(Folder)
% compares spectra
% ok for now this just works for a single folder at a time
% i'm sure there's a way to modify it

% folderdir = dir(['../',Folder]);
% folderdir = folderdir(arrayfun(@(x)x.name(1),folderdir) ~='.');

filedir = dir(Folder);
filedir = filedir(arrayfun(@(x)x.name(1), filedir) ~='.');

ch = [0 1 3 4 6];

figure(1)
for i = 1:5
%     matrixname = sprintf('%s%d%s', 'Spec_ch', i, '_mat');    
%     for j = 1:length(folderdir)
%         filename = sprintf('%s%s%d%s', folderdir(j).name, '/Spec_ch',i,'_Spec.dat');
%         datfile = load(filename);
%         if j == 1
%             newmatrix = datfile;
%         else
%             newmatrix = [newmatrix; datfile];
%         end
%     end

    filename = sprintf('%s%s%d%s', Folder, '/Spec_ch', ch(i), '_Spec.dat');
    datfile = load(filename);
    coeff = pca(datfile.');
    subplot(2, 3, i)
    
%     col = repmat(length(coeff));
    col = linspace(1, 100, length(coeff(:,1)));
    scatter(coeff(:,1),coeff(:,2),30,col, 'filled')
    title(['Channel: ', num2str(ch(i))]);
    end
  
end
% function(Group1, Group2) and compares them channel by channel using PCA