function [eyeana] = eyeana_config(scr,const)
% ----------------------------------------------------------------------
% [eyeana] = eyeana_config(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Collect and bundle relevant information for gaze analysis
% ----------------------------------------------------------------------
% Input(s) :
% const : experiment constants
% scr : screen configuration
% sub : subject configuration
% ----------------------------------------------------------------------
% Output(s):
% anaEye : eye analysis settings
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 04 / 02 / 2020
% Project : PreSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

eyeana.MO_PHYS      = scr.disp_sizeX;                   % screen width (cm)
eyeana.SAMPRATE     = 1000;                             % Eyelink sampling rate
eyeana.crit_cols    = [2 3];                            % colums containing xy-eye-coordingates in dat file
eyeana.fixRad       = const.FTrad_pixVal;               % fixation boundary (deg)

eyeana.velSD        = 3;                                % ms Lambda threshold
eyeana.minDur       = 20;                               % ms duration threshold
eyeana.VELTYPE      = 2;                                % velocity type for saccade detection
eyeana.maxMSAmp     = 2;                                % ms amplitude threshold
eyeana.mergeInt     = 20;                               % merge interval for subsequent saccadic events

DPP = pix2vaDeg(1,scr);
eyeana.DPP = DPP(1);                                    % degrees per pixel
eyeana.PPD = vaDeg2pix(1,scr);                      % pixels per degree

end