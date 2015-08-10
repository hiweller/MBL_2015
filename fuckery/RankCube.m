% script to pull out all the HSI data cubes ranked 4 and 5

% read rankings file into matlab
[num, txt, raw] = xlsread('HSI Rankings.xlsx', 'A1:C493');

% split first line file identifier into different folder names
Horatio = strsplit(char(raw(2, 1)), '/');

% create identifier to create necessary folders
% this will be compared to other strings to see when a new folder has to be
% made
folderID = sprintf('%s%s%s', Horatio{1}, '/', Horatio{2});
mkdir(['Highlights/', folderID])
for i = 2:length(raw(:,1))
    
    % pull out row name ( = filepath)
    filename = raw{i, 1};
    
    % divide up into different directory names
    parts = strsplit(filename, '/');
    
    Date = parts{1};
    FlounderID = parts{2};
    CubeID = parts{3};
    
    newfolderID = sprintf('%s%s%s', Date, '/', FlounderID);
    
    % if the new Date/FlounderID folder already exists, do nothing
    % if it does not, make a new one and set it as the new filepath
    if folderID(end) ~= newfolderID(end)
        mkdir(['Highlights/', newfolderID]);
        folderID = newfolderID;
    end
    
    Source = sprintf('%s%s%s', folderID, '/', CubeID);
    Destination = sprintf('%s%s%s', 'Highlights/', folderID, '/');
    
    if raw{i, 2} == 4 | raw{i, 2} == 5 | raw{i, 2} == 'WHITE'
        copyfile(Source, Destination)
    end
    
end

% channel = sprintf('%s%d%s','chan',k+4*(j-1),'.tif');
