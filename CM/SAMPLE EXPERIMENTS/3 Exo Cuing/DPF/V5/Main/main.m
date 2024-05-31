function main(const)
% =========================================================================
% main(const)
% =========================================================================
% By : Nina HANNING
% edited by Caroline MYERS
% Last update : 2021-06-07
% Project : DPF
% Version : 1.0

% =========================================================================
% Input(s):
% const : struct containing different constant settings
% =========================================================================
%
%% Version details
% ===============
% -

%% Summary modifications
% ======================
% -

tic;

%% Function
% File director
[const] = dirSaveFile(const);

% Screen settings
[scr] = scrConfig(const);

% Keyboard settings
[my_key] = keyConfig;

% Color settings
[scr,const] = colorConfig(scr,const);

% Experimental constant
[const] = constConfig(scr,const);

% Experimental design
[expDes] = designConfig(const);

% Video settings
if const.mkVideo;const.numBlock=1;const.trial_nb=1;end
[expDes,vid] = getVideoSettings(scr,const,expDes);

% Auditory settings
[aud] = audioConfig(const);

% Open screen window
[scr.main,scr.rect] = Screen('OpenWindow',scr.scr_num,[0 0 0],[], scr.clr_depth,2);
Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(scr.main);Priority(priorityLevel);

% Gamma calibration
if ~isempty(scr.gamma_name)
    table = load(sprintf('../../../../../../x_allExp/Gamma/%s/%s.mat',scr.gamma_name,scr.gamma_name));
    table = table.table;
    %old
    % [oldtable, success] = Screen('LoadNormalizedGammaTable',scr.scr_num,table);
    %new for R1 - CM
    if strcmp(const.screenName,'CarrascoR1') == 1
    [oldtable] = Screen('LoadNormalizedGammaTable',scr.scr_num,table);
    newtable = Screen('ReadNormalizedGammaTable',scr.scr_num);
    elseif strcmp(const.screenName,'Carrasco956') == 1
        disp('There is no calibration file for this set up.')
    else
    [oldtable, success] = Screen('LoadNormalizedGammaTable',scr.scr_num,table);
     newtable = Screen('ReadNormalizedGammaTable',scr.scr_num);
    end
end

% Open sound pointer:
aud.master_main = PsychPortAudio('Open', [], aud.master_mode, aud.master_reqlatclass, aud.master_rate, aud.master_nChannels); % Open a PortAudio audio device and initialize it
PsychPortAudio('Start', aud.master_main, aud.master_rep, aud.master_when, aud.master_waitforstart); % Start a Port Audio device
PsychPortAudio('Volume', aud.master_main, aud.master_globalVol); % Set audio output volume
aud.stim_handle = PsychPortAudio('OpenSlave', aud.master_main, aud.slaveStim_mode);

% Initialise EyeLink :
if const.eyeMvt;[el,const] = initEyeLink(scr,const);
else el = [];end

% Main part :
ListenChar(2);GetSecs;
[vid]=run_block(scr,aud,const,expDes,el,my_key,vid);

% End
overDone(aud,const,vid);

end