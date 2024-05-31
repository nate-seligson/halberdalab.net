%% 00 INIT
% Written by Caroline MYERS (03/08/22)
% Part of the 'draw masks' package
% Assumes files in cd folder are images created with drawMasks.js,
% renames them for concise read in to javascript  

clear
cd('output'); %change if necessary
files = dir('*.png'); %file type should be png
 
for ii = 1:length(files) %for all of the images in the cd

    % Get the file name 
    [~, f,ext] = fileparts(files(ii).name);
    tempNewName = strcat('mask',num2str(ii),'.png');
    
    movefile(files(ii).name, tempNewName); 
    clearvars tempNewName
end



    