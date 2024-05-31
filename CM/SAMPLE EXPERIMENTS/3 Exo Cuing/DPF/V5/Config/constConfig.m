function [const]=constConfig(scr,const)

% ----------------------------------------------------------------------
% [const]=constConfig(scr,const,expDes)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute all constant data of this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing all constant data.
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 3.0
% ----------------------------------------------------------------------
% Edit history: 

% 06/21/21
% CM edits so CPD is now changed to 6. Will think about best way to make
% this a cool variable, probably using const. 
% ----------------------------------------------------------------------

const.text_font = 'Verdana';
const.text_size = 20;
%CM added
const.repeatTraining = [];

%% Background parameter
% Fixation point (eye)
const.fixPos        	= [scr.x_mid,scr.y_mid];
const.fixRadVal         = 0.25;          	[const.fixRad,~] = vaDeg2pix(const.fixRadVal,scr);
const.fixW              = 1.5;    % maybe 2 ;)
const.crossAng          = 0;

% Radius main circle
const.mainEcc_val       = 6.4;              [const.mainEcc,~] = vaDeg2pix(const.mainEcc_val,scr);

% Location frames
const.ph_radVal         = 2.1;           	[const.ph_rad,~] = vaDeg2pix(const.ph_radVal,scr);
const.dot_radVal        = 0.05;             [const.dot_rad,~] = vaDeg2pix(const.dot_radVal,scr);
const.phAng             = 0; % rotation angle of placeholder (0 = diamond)

const.dotCue_radVal     = 0.16;             [const.dotCue_rad,~] = vaDeg2pix(const.dotCue_radVal,scr);

% Response Cue
const.respLVal          = 0.8;              [const.respL,~] = vaDeg2pix(const.respLVal,scr);
const.respW             = const.fixW;
const.respDistVal       = 0.3 + const.fixRadVal; [const.respDist,~] = vaDeg2pix(const.respDistVal,scr); %% CM check distance of resp line from center



%% Gabors
const.test_rad_deg      = 1.6;
const.test_rad_pix      = round(vaDeg2pix(const.test_rad_deg,scr));

const.oneDeg2pix        = vaDeg2pix(1,scr);

%% CM ADDED
const.gabor1_cpd        = const.spatialFreq; %CM added so now we can change this easily
%const.gabor1_cpd        = 6.0;                                  % cycles per deg

%% OK BACK TO NORMAL
const.gabor1_ppp        = const.oneDeg2pix/const.gabor1_cpd; 	% pixels per period

const.gabor_phase       = 0;
const.gabor_ori         = 0;
const.gabor_sig         = round(vaDeg2pix(0.46,scr));

const.bgluminance       = const.colBG(1)/255;

gaborApt                = GenerateGaussian(const.test_rad_pix*2,const.test_rad_pix*2,const.gabor_sig,const.gabor_sig,0,0,0);
const.gaborApt          = gaborApt.*255;

const.gabor_angle       = 20;


%% Positions

% x & y positions
const.ang = [ 0, 90, 180, 270];
const.locMat = nan(size(const.ang,2),2);
for tPos = 1:size(const.ang,2)
    const.locMat(tPos,1) = const.mainEcc * cosd(const.ang(tPos)) + const.fixPos(1);   % x center    CAH
    const.locMat(tPos,2) = const.mainEcc * -sind(const.ang(tPos)) + const.fixPos(2);  % y center    SOH
end

% resp cue positions
const.ang = [ 0, 90, 180, 270];
const.rcueMat = nan(size(const.ang,2),4);
for tPos = 1:size(const.ang,2)
    const.rcueMat(tPos,1) = const.fixPos(1) +  const.respDist *  cosd(const.ang(tPos));   % x center    CAH
    const.rcueMat(tPos,2) = const.fixPos(2) +  const.respDist * -sind(const.ang(tPos));   % y center    SOH
    const.rcueMat(tPos,3) = const.fixPos(1) + (const.respDist+const.respL) *  cosd(const.ang(tPos));
    const.rcueMat(tPos,4) = const.fixPos(2) + (const.respDist+const.respL) * -sind(const.ang(tPos)); 
end


% rectangles to draw the stimuli in
const.rectMat = [];
for idx_pos = 1:size(const.ang,2)
    currX = const.locMat(idx_pos,1);
    currY = const.locMat(idx_pos,2);
    const.rectMat(idx_pos,:) = [currX - const.test_rad_pix; currY - const.test_rad_pix; currX + const.test_rad_pix ; currY + const.test_rad_pix];
end



%% Staircase / Contrast

if const.task == 1 % training - use default contrast
    const.gabor_contr = 1;

elseif const.task == 2 % threshold - titrate contrast
    
    %% LEVITT STAIRCASE
   
    
    % LEVITT settings
    stairDir = sprintf('Thre_data');
    
    const.upCount       = 1;
    const.downCount     = 3;
    const.stepChange    = [1,3,7,15]; % after how many reversals to half the stepsize
    
    const.minC = 0.001;
    const.maxC = 1;
    
    
    % starting contrast
    if const.fromBlock == 1
        const.gabor_contr = 0.15;
        
    elseif const.fromBlock == 2
        if const.expStart
            load(sprintf('../Block1/%s_stairc_val.mat',const.sjct_code));
            
            contr_vec = nan(1,4);
            for i = 1:4
                contr_vec(i) = stairc_val{i}(1,end);
                fprintf(1,'\n\tStair Contrast %i \t= %3.2f deg',i,stairc_val{i}(1,end));
            end
            const.gabor_contr = mean(contr_vec);
            fprintf(1,'\n\n\tStair Contrast ALL \t= %3.2f deg',const.gabor_contr);
        else
            const.gabor_contr = 0.15;
        end
    end
    
    % contrast steps
    if const.fromBlock == 1
        const.step = 0.07;
    elseif const.fromBlock == 2
        const.step = 0.015;
    end
    
    const.gabor_contr_vec = const.step;
    for i = 1:numel(const.stepChange)
        const.gabor_contr_vec = [const.gabor_contr_vec,const.gabor_contr_vec(end)/2];
    end

    % create start martix
    const.stairc_val    = [];
    const.stairc_resp   = [];
    for tstPos = 1:4
        const.stairc_val{tstPos} = const.gabor_contr;
        const.stairc_resp{tstPos} = NaN;
        const.stairc_count{tstPos} = []; % to store current response (to decide whether to increase or decrease)
    end
    
elseif const.task == 3 % main - use value detemined in threshold
    
    if const.expStart == 1 && const.manualContrast == 0;% CM added
        
        if const.fromBlock == 1
            load(sprintf('../../Thre_data/Block2/%s_stairc_val.mat',const.sjct_code));
            
            contr_vec = nan(1,4);
            for i = 1:4
                contr_vec(i) = stairc_val{i}(1,end);
                fprintf(1,'\n\tStair Contrast %i \t= %3.2f deg',i,stairc_val{i}(1,end));
            end
            const.gabor_contr = mean(contr_vec);
            fprintf(1,'\n\n\tStair Contrast ALL \t= %3.2f deg',const.gabor_contr);
        else
            
            % load avContr & avPerf of previous block
            load(sprintf('../Block%i/avContr_%s_%s_%s_B%i',const.fromBlock-1,const.sjct,const.expName,const.sjct_DomEye,const.fromBlock-1));
            load(sprintf('../Block%i/avPerf_%s_%s_%s_B%i',const.fromBlock-1,const.sjct,const.expName,const.sjct_DomEye,const.fromBlock-1));
            
            diffCor = avPerf-80;
            const.gabor_contr = avContr - (avContr*(diffCor/100)); % <<< adjust by whatever magic CM
        end
    elseif    const.expStart == 1 && const.fromBlock ~= 1 && const.manualContrast == 1;
        disp('Do you want to manually change the contrast?');
        manualResponse = input(sprintf('\n\tType yes to change contrast, otherwise type no. ONLY TYPE yes IF YOU ARE CAROLINE: '),'s');
        if strcmp(manualResponse,'yes') == 1 || strcmp(manualResponse,'Yes') == 1 || strcmp(manualResponse, 'YES') == 1;
            load(sprintf('../Block%i/avContr_%s_%s_%s_B%i',const.fromBlock-1,const.sjct,const.expName,const.sjct_DomEye,const.fromBlock-1));
            disp(['The current contrast is: ',num2str(avContr)])
            const.manualContrastInput = input(sprintf('\n\tHi Caroline, what would you like to set it to? '),'s');
            const.manualContrastInput = str2num(const.manualContrastInput)
            const.gabor_contr = const.manualContrastInput;
            disp(['Great! You just set the contrast to ',num2str(const.gabor_contr)])
            const.gabor_contr = const.manualContrastInput;
            
            if const.manualContrastInput > 1 || const.manualContrastInput < .01
                disp('Are you sure? I''m not.')
                const.manualContrastInput = input(sprintf('\n\tWhat would you like to set it to? '),'s');
                const.manualContrastInput = str2num(const.manualContrastInput)
                const.gabor_contr = const.manualContrastInput;
                disp(['Much better. The current contrast is: ',num2str(const.gabor_contr)])
            end
        else
            disp('ok, we will keep the contrast as is.')
        end
        %const.sjct_name = sprintf('%s_%s',const.sjct,const.expName);
    else
        % default contrast
        const.gabor_contr = 0.15;
    end

end

   %load contrast from previous block
%const.gabor_contr = .02


%% Experimental timing settings

% T1: Fixation
% const.durT1_min	= 0;    const.numT1_min = (round(const.durT1_min/scr.fd));
% const.durT1_max	= 0;    const.numT1_max = (round(const.durT1_max/scr.fd));
% const.numT1    	= const.numT1_min:const.numT1_max;
% const.durT1    	= const.numT1*scr.fd;
% T1: Fixation %CM added
const.durT1         = 0.250;
const.numT1         = round(const.durT1/scr.fd);

% T2: Cue
const.durT2   	= 0.060;
const.numT2    	= round(const.durT2/scr.fd);

% T3: ISI
const.durT3    	= 0.060;
const.numT3   	= (round(const.durT3/scr.fd));

% T4: Stimuli
const.durT4    	= 0.120;
const.numT4   	= round(const.durT4/scr.fd);

% T5: ISI2
const.durT5    	= 0.040;
const.numT5   	= round(const.durT5/scr.fd);

% T6: RESPONSE
const.durT6    	= 0.660;
const.numT6   	= round(const.durT6/scr.fd);

%CM Changed
const.durMax    = const.durT1 + const.durT2 + const.durT3 + const.durT4 + const.durT5 + const.durT6;
%const.durMax    = const.durT1_max + const.durT2 + const.durT3 + const.durT4 + const.durT5 + const.durT6;
const.numMax    = round(const.durMax/scr.fd);

% RESPONSE WINDOW
const.durT7     = 5.000;
const.numT7   	= round(const.durT7/scr.fd);

const.durITI    = 1.000;
const.numITI   	= round(const.durITI/scr.fd);



%% General settings
% Time :
const.my_clock_ini = clock;

% Screen calibration        %%%CM: check fixation radius
const.FTrad_pixVal = 2.00;          const.FTrad_pix = vaDeg2pix(const.FTrad_pixVal,scr); % fixation acceptance region

% Eye-tracker configuration :
const.radCalib_val       = 12.00;   % Eyelink calibration radius
const.calTargetRad_deg   = 0.3;  	[const.calTargetRad_pix,~]     = vaDeg2pix(const.calTargetRad_deg,scr);
const.calTargetWidth_deg = 0.2;  	[const.calTargetWidth_pix,~]   = vaDeg2pix(const.calTargetWidth_deg,scr);

% Eye fixation check
const.timeOut = 7.0;    % maximum eye fixation check time
const.tCorMin = 0.1;    %CM changed
%const.tCorMin = 0.250;  % 250ms FIXATION PERIOD minimum correct eye fixation time


%% Saving procedure :
const_file = fopen(const.const_fileDat,'w');
fprintf(const_file,'Subject initial :\t%s\n',const.sjct_name);
if const.task == 1 && const.fromBlock == 1 %&& const.repeatTraining ~= 1 
    
    fprintf(const_file,'Subject age :\t%s\n',const.sjct_age);
    fprintf(const_file,'Subject gender :\t%s\n',const.sjct_gender);
    fprintf(const_file,'Subject height (inches) :\t%s\n',const.sjct_height);
end
fprintf(const_file,'Recorded Eye :\t%s\n',const.sjct_DomEye);
fprintf(const_file,'Date : \t%i-%i-%i\n',const.my_clock_ini(3),const.my_clock_ini(2),const.my_clock_ini(1));
fprintf(const_file,'Starting time : \t%ih%i\n',const.my_clock_ini(4),const.my_clock_ini(5));

fclose('all');

% .mat file
save(const.const_fileMat,'const');

end