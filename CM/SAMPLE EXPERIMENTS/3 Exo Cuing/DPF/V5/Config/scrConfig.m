function [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Set screen parameters
% ----------------------------------------------------------------------
% Input(s) :
% const : experiment constants
% ----------------------------------------------------------------------
% Output(s):
% scr : screen configuration
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

% Number of the exp screen:
scr.all = Screen('Screens');
scr.scr_num = max(scr.all);

if scr.scr_num == 0 && const.transpMode
    PsychDebugWindowConfiguration(0,0.5);
end

% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY]=Screen('WindowSize', scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    fprintf('\n\t\t\t Current screen resolution: %i, %i \n\n',scr.scr_sizeX, scr.scr_sizeY);
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i,%i]',const.desiredRes(1),const.desiredRes(2));
end

% Size of the display :
if strcmp(const.screenName,'ViewPixxTMS')
    scr.dist = 57;
    scr.disp_sizeX = 530;
    scr.disp_sizeY = 300;
elseif strcmp(const.screenName,'CarrascoL1')
    scr.dist = 57;
    scr.disp_sizeX = 400;
    scr.disp_sizeY = 300;
elseif strcmp(const.screenName,'CarrascoR2')   
    scr.dist = 57;
    scr.disp_sizeX = 405;
    scr.disp_sizeY = 305;
elseif strcmp(const.screenName,'CarrascoR1')   
    scr.dist = 57; %%%CM
    scr.disp_sizeX = 400;
    scr.disp_sizeY = 300;
elseif strcmp(const.screenName,'Carrasco956')
    scr.dist = 57; %%%CM
    scr.disp_sizeX = 400;
    scr.disp_sizeY = 300;
else
    scr.dist = 57;
    scr.disp_sizeX = 520;
    scr.disp_sizeY = 330;    
end

% Pixels size:
scr.clr_depth = Screen('PixelSize', scr.scr_num);


if ~const.expStart
    warning('off');
    Screen('Preference', 'SkipSyncTests', 1);
end


% Frame rate (fps)
scr.fd = 1/(Screen('FrameRate',scr.scr_num));
if scr.fd == inf || scr.fd == 0
    scr.fd = 1/60;
end

% Frame rate (hertz)
scr.hz = 1/(scr.fd);
if (scr.hz >= 1.1*const.desiredFD || scr.hz <= 0.9*const.desiredFD) && const.expStart
    fprintf('\n\t\t\t Current screen refresh rate: %i \n\n',scr.hz);
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz',const.desiredFD);
end


% Center of the screen :
scr.x_mid = (scr.scr_sizeX/2);
scr.y_mid = (scr.scr_sizeY/2);
scr.mid   = [scr.x_mid,scr.y_mid];


% Gamma calibration  :
if strcmp(const.screenName,'CarrascoR2')
    scr.gamma_name = 'R2ViewSonic';
elseif strcmp(const.screenName,'CarrascoR1')
    scr.gamma_name = 'GammaTable_R1'; %%%CM
elseif strcmp(const.screenName,'CarrascoL1')
    scr.gamma_name = error;  %%%CM
else
    scr.gamma_name = [];
end



%% Saving procedure :
scr_file = fopen(const.scr_fileDat,'w');
fprintf(scr_file,'Screen name:\t%s\n',const.screenName);
fprintf(scr_file,'Resolution size X (pxl):\t%i\n',scr.scr_sizeX);
fprintf(scr_file,'Resolution size Y (pxl):\t%i\n',scr.scr_sizeY);
fprintf(scr_file,'Monitor size X (mm):\t%i\n',scr.disp_sizeX);
fprintf(scr_file,'Monitor size Y (mm):\t%i\n',scr.disp_sizeY);
fprintf(scr_file,'Color depth (bit):\t%i\n',scr.clr_depth);
fprintf(scr_file,'Subject distance (cm):\t%i\n',scr.dist);
fprintf(scr_file,'Frame duration (fps):\t%i\n',scr.fd);
fprintf(scr_file,'Refresh Rate (hz):\t%i\n',scr.hz);
fclose('all');

% .mat file
save(const.scr_fileMat,'scr');

end