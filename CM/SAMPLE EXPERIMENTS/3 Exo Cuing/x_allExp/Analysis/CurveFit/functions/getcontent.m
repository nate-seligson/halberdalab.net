function content = getcontent(folder,filetype,ext)

% -------------------------------------------------------------------------
% content = getcontent(folder,filetype,ext)
% -------------------------------------------------------------------------
% Goal of the function:
% Get file or directories list from a specific path.
% -------------------------------------------------------------------------
% Inputs:
% folder: path to the target folder (absolute or relative).
% filetype : directories ('dir') or files ('file') list..
% ext (only for files): extension of the wanted files.
% -------------------------------------------------------------------------
% Outputs:
% param: struct array providing information about folder hierarchy.
% -------------------------------------------------------------------------
% function created by Florian Perdreau (florian.perdreau@parisdescartes.fr)
% Last update: 27/03/2012
% Project: ImpPosExp
% -------------------------------------------------------------------------
cd(folder); 

if ~exist('ext','var') || isempty(ext)
    ext = '*';
end
switch char(filetype)
    case 'file'
        content = dir(strcat('*.',ext));
        dirIndex = [content.isdir];
        content = {content(~dirIndex).name};
    case 'dir'
        content = dir;
        dirIndex = [content.isdir];
        content = {content(dirIndex).name};
        empty = zeros(1,numel(content));
        for f = 1:numel(content)
            if ~isempty(findstr(content{f},'.'))
                empty(f) = 1;
            end
        end
        if isempty(find(empty == 0, 1))
            warning('The specified folder is empty');
            return
        end
end

if ~isempty(content)
    content = char(content');
    content = content(content(:,1)~='.',:);
    for i = 1:size(content,1)
        file = char(content(i,:));
        ind = isstrprop(file,'alphanum') | isstrprop(file,'punct');
        filend = find(ind == 1,1,'last');
        if ~isempty(filend)
            file = file(1:filend);
        end
        contentcell{i,:} = file;
    end
    content = contentcell;
else
    fprintf('The specified folder is empty \n');
end
end
