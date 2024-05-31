function my_sound(t,aud)
% ----------------------------------------------------------------------
% my_sound(t,aud)
% ----------------------------------------------------------------------
% Goal of the function :
% Play a wave file a specified number of time.
% ----------------------------------------------------------------------
% Input(s) :
% t : sound number
% aud : sound configuration
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 14 / 04 / 2020
% Project : PreSacRes
% Version : 8.2
% ----------------------------------------------------------------------

if t == 1
    stimFreq = [3000;0;4000];
    stimDur  = [0.1;0.01;0.2];
elseif t == 2
    stimFreq = [300];
    stimDur  = [0.01];
    
elseif t == 3
    stimFreq = [5000];
    stimDur  = [0.1];
elseif t == 4
    stimFreq = [2000];
    stimDur  = [0.1];

elseif t == 5
    stimFreq = [500:-20:300]';
    stimDur  = [repmat(0.1,1,numel([400:500]))];
    
elseif t == 6    
    stimFreq = [5000;0;5000;0;5000];
    stimDur  = [0.05;0.03;0.05;0.03;0.05];

elseif t == 7    
    stimFreq = [1000];
    stimDur  = [0.05];
    
elseif t == 8
    stimFreq = [300:20:700]';
    stimDur  = [repmat(0.1,1,numel([300:20:700]))];
    
elseif t == 12
    stimFreq = [200];
    stimDur  = [0.5];
elseif t == 13
    stimFreq = [3000;2000;500]; %[5000;3000;1250];
    stimDur  = [0.05;0.05;0.05];  
    
elseif t == 14
    stimFreq = [850;0;850];
    stimDur  = [0.05;0.075;0.05];    
    
elseif t == 15
    stimFreq = [300;  0 ;300;  0 ;300];
    stimDur  = [0.1;0.05;0.1;0.05;0.1];    
    
elseif t == 16
    stimFreq = [;2000;3500;5000];
    stimDur  = [0.05;0.05;0.05];  
    
end

stimNb = size(stimFreq,1);

% Compute ramped sound and modulator
stimAll = [];
rampAll = [];
for tStim = 1:stimNb
    for i = 1:aud.master_nChannels
        stim(i,:) = MakeBeep(stimFreq(tStim), stimDur(tStim), aud.master_rate);
        ramp(i,:) = [aud.rampOffOn,ones(1,size(stim(i,:),2)-size(aud.rampOffOn,2)-size(aud.rampOnOff,2)),aud.rampOnOff];
    end
    stimAll = [stimAll,stim];stim =[];
    rampAll = [rampAll,ramp];ramp =[];
end

PsychPortAudio('FillBuffer' ,aud.stim_handle, stimAll.*rampAll);
PsychPortAudio('Start', aud.stim_handle, aud.slave_rep, aud.slave_when, aud.slave_waitforstart);

end
