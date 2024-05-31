function [corC]=check_cali(scr,aud,const,my_key)
% ----------------------------------------------------------------------
% [corC]=check_cali(scr,const,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Evaluate eyetracking calibration.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configuration
% aud : sound configuration
% const : experiment constants
% my_key : keyborad configuration
% ----------------------------------------------------------------------
% Output(s):
% corC : flag or signal of correct calibration
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% edited by Maya AGDALI
% Last update : 2021-06-07
% Project : ppSacApp
% Version : 1.0
% ----------------------------------------------------------------------

if const.eyeMvt
    Eyelink('message', 'EVENT_CalibrationCheck');
end

while KbCheck; end
FlushEvents('KeyDown');


%% Instruction
Screen('FillRect',scr.main,const.colBG);

% placeholders
for iii = 1:size(const.locMat,1)
    my_placeHolds(scr,const.locMat(iii,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
end

instr_txt{1} = 'Calibration check';
instr_txt{2} = 'Fixate the blue cross, then press [SPACE].';

if const.condition == 2
    instr_txt{3} = '(The cross will move to different locations,';
    instr_txt{4} = 'repeat until it disappears)';
end

xPos = const.fixPos(1);
yPos_vec = [const.fixPos(2)*0.3,...
            const.fixPos(2)*0.5,...
            const.fixPos(2)*0.6,...
            const.fixPos(2)*0.65];

for idx_t = 1:numel(instr_txt)
    my_text(scr,const,instr_txt{idx_t},xPos,yPos_vec(idx_t),const.colText);
end

% initial cross (FT)
my_crosses(scr,const.fixPos,const.cross_Rad_pix,const.crossW,const.crossCol,45);

Screen('Flip',scr.main);
WaitSecs(0.5);

while KbCheck(-1); end
KbWait;


if const.condition == 2
    pos_order = [Shuffle([1,3]),2]; % check all location in saccade condition
else
    pos_order = 2;                  % only check fixation in neutral condition
end



%% Loop through locations
eyePos_mat = nan(numel(pos_order),2);

for idxP = 1:numel(pos_order)
    
    key_press.space = NaN;
    
    xEye = [];
    yEye = [];
    
    Screen('FillRect',scr.main,const.colBG);
    
    % placeholders
    for iii = 1:size(const.locMat,1)
        my_placeHolds(scr,const.locMat(iii,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
    end
    
    % current cross
    my_crosses(scr,const.locMat(pos_order(idxP),:),const.cross_Rad_pix,const.crossW,const.crossCol,45);
    
    Screen('Flip',scr.main);
    
    while KbCheck; end
    while isnan(key_press.space)
        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown || const.condition ~= 2 %sum(ismember(const.fixBlocks,const.fromBlock))
            if (keyCode(my_key.space)) || const.condition ~= 2 %sum(ismember(const.fixBlocks,const.fromBlock))
                try
                    %[xEye,yEye] = getCoord(scr,const);
                    xEye_vec = NaN(25,1);
                    yEye_vec = NaN(size(xEye_vec));
                    for idx_t = 1:size(xEye_vec,1)
                        [xEye_vec(idx_t,1),yEye_vec(idx_t,1)] = getCoord(scr,const);
                        WaitSecs(0.02);
                    end
                    xEye = nanmean(xEye_vec);
                    yEye = nanmean(yEye_vec);
                catch err
                    err
                    key_press.space = 1;
                end
                
                if ~sum([xEye,yEye]) || isempty(xEye) || isempty(yEye)
                    corC = 0;
                    return;
                end
                eyePos_mat(pos_order(idxP),[1,2]) = [xEye,yEye];
                %eyeVec_mat_x{pos_order(idxP)} = xEye_vec;
                %eyeVec_mat_y{pos_order(idxP)} = xEye_vec;
                key_press.space = 1;
                my_sound(1,aud);
                WaitSecs(0.5);
            end
        end
    end
    
end

% Blank
Screen('FillRect',scr.main,const.colBG);

% placeholders
for iii = 1:size(const.locMat,1)
    my_placeHolds(scr,const.locMat(iii,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
end

Screen('Flip',scr.main);

WaitSecs(1.0);



%% Show result

Screen('FillRect',scr.main,const.colBG);
% placeholders
for iii = 1:size(const.locMat,1)
    my_placeHolds(scr,const.locMat(iii,:),const.ph_rad,const.dot_rad,const.colDots,4,const.phAng);
end


corC = 1;
for idxP = 1:numel(pos_order) % size(eyePos_mat,1)
    if sqrt((eyePos_mat(pos_order(idxP),1)-const.locMat(pos_order(idxP),1))^2+(eyePos_mat(pos_order(idxP),2)-const.locMat(pos_order(idxP),2))^2)<const.STrad_pix*0.5
        currCol = const.colGOOD;
    else
        currCol = const.colBAD;
        corC = 0;
    end
    my_dot(scr,currCol,eyePos_mat(pos_order(idxP),1),eyePos_mat(pos_order(idxP),2),const.tar_rad_pix);
    
end

instr_txt = [];
if corC
    instr_txt{1} = 'Good to go!';
else
    instr_txt{1} = 'Please repeat eyetracking calibration.';
end

xPos = const.fixPos(1);
yPos_vec = [const.fixPos(2)*0.75,...
    const.fixPos(2)*0.8];
for idx_t = 1
    my_text(scr,const,instr_txt{idx_t},xPos,yPos_vec(idx_t),const.colText);
end

Screen('Flip',scr.main);
WaitSecs(2);

end