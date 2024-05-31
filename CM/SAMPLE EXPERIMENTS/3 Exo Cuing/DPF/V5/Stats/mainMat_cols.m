%% mainMat_cols
% Originally created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline Myers
% -------------------------------------------------------------------------
% Last update : 2021-06-09
% Project : DPF
% Version : 3.0
% -------------------------------------------------------------------------
%% Explanation
% Contains information of the experiment matrices: 
% 1. Design matrix: columns 1 - 20

% 2. Results matrix: columns 21-50

% 3. MSG matrix: columns 51 - 80
%    contains eye data and timing markers
%% expDes.expMat
% -------------------------------------------------------------------------
% Column #01 Block#
% Column #02 tasktype (1 = Thre 1, 2 = Thre 2, 3 = saccade)
% Column #03 Trial#
% Column #04 NaN
% Column #05 TiltEast1 (left: -20, right: +20)
% Column #06 TiltNorth2 (left: -20, right: +20)
% Column #07 TiltWest3 (left: -20, right: +20)
% Column #08 TiltSouth4 (left: -20, right: +20)
% Column #09 TargetLoc (1 = East, 2 = North, 3 = West, 4 = South)
% Column #10 CueCond (1 = valid, 2 = neutral)
% Column #11 NaN
% Column #12 NaN
% Column #13 NaN
% Column #14 NaN
% Column #15 NaN
% Column #15 NaN
% Column #16 NaN
% Column #17 NaN
% Column #18 NaN
% Column #19 NaN
% Column #20 NaN


%% resMat / eyeCrit / tmsMat
% -------------------------------------------------------------------------
% Column #21 resMat( 1) = k pressed: 	Detection: left = 1, right = 2                  
%                                       898 = FIXERR
% Column #22 resMat( 2) = correctness:  correct = 1, incorrect = 0
%                                       898 = FIXERR
%
% Column #23 resMat( 3) = eyeOK:        1 = SAC/FIX COR 
%                                       0 = SAC INCOR 
%                                      -1 = FIXBREAK
%                                      -2 = WRONG TARGET
% Column #24 resMat( 4) = respT: response time (in seconds)
% Column #25 resMat( 5) = NaN
% Column #26 resMat( 6) = gabC: Contrast
% Column #27 resMat( 7) = NaN
% Column #28 resMat( 8) = t_cueON: time of cue onset
% Column #29 resMat( 9) = t_testON: time of stim onset
% Column #30 resMat(10) = NaN

% Column #31 eyeMat( 1) = NaN, previously: eye leaves fixation
% Column #32 eyeMat( 2) = NaN, previously: eye reaches target
% Column #33 eyeMat( 3) = NaN, previously: eye stays at target sufficient time
% Column #34 eyeMat( 4) = NaN, previously: saccade latency too short (end-16)
% Column #35 eyeMat( 5) = NaN, previously: saccade latency too short (end-15)
% Column #36 eyeMat( 6) = NaN, previously: saccade target nb
% Column #37 eyeMat( 7) = NaN
% Column #38 eyeMat( 8) = NaN, previously: eyeON - tstOFF
% Column #39 eyeMat( 9) = NaN
% Column #40 eyeMat(10) = NaN

% Column #41 nanMat( 1) = NaN, previously: t_cueON
% Column #42 nanMat( 2) = NaN, previously: t_testON
% Column #43 nanMat( 3) = NaN, previously: t_testOFF
% Column #44 nanMat( 4) = NaN, previously: t_sacON
% Column #45 nanMat( 5) = NaN, previously: trainingDone (1 = yes, 0 = not yet)
% Column #46 nanMat( 6) = NaN, previously: trial.targ_w_deg
% Column #47 nanMat( 7) = NaN, previously: trial.targ_h_deg
% Column #48 nanMat( 8) = NaN
% Column #49 nanMat( 9) = NaN
% Column #50 nanMat(10) = NaN



%% MSGTAB
% -------------------------------------------------------------------------
% Column #51 (01) Trial ID (27)
% Column #52 (02) TRIAL_START
% Column #53 (03) TRIAL END                             %% TRIAL_END
% Column #54 (04) resmat block                              %% [resmat block]
% Column #55 (05) resmat trial                              %% [resmat trial]
% Column #56 (06) trialNum (from .dat)                               %% EVENT_FixationCheck
% Column #57 (07) 
% Column #58 (08) 
% Column #59 (09) 
% Column #60 (10) EVENT_FixationCheck

% Column #61 (11) EVENT_TRIAL_START
% Column #62 (12) T2                             %% T_start : fixation start
% Column #63 (13) T3                             %% T_cueON : cue onset
% Column #64 (14) T4                             %% T_testON : texture onset
% Column #65 (15) T5                             %% T_testOFF : blank onset
% Column #66 (16) T6                             %% T_end 
% Column #67 (17) T7
% Column #68 (18) EVENT_ANSWER
% Column #69 (19) EVENT_TIMEOUT
% Column #70 (20) EVENT_FIXBREAK

% Column #71 (21)                                %% EVENT_FIXBREAK  
% Column #72 (22)                                %% EVENT_SACON
% Column #73 (23)                                %% EVENT_SACOFF
% Column #74 (24)
% Column #75 (25)                                %% EVENT_ANSWER
% Column #76 (26) 
% Column #77 (27) 
% Column #78 (28) 
% Column #79 (29) 
% Column #80 (30) 


%% VAL RES
% -------------------------------------------------------------------------
% Column #81  (01) Fixation timeout
% Column #82  (02) saccade onset (real onset, ~20ms earlier than online)
% Column #83  (03) saccade offset
% Column #84  (04) saccade duration
% Column #85  (05) saccade velocity peak
% Column #86  (06) saccade distance
% Column #87  (07) saccade AMPLITUDE
% Column #88  (08) saccade onset x position
% Column #89  (09) saccade onset y position
% Column #90  (10) saccade offset x position
% Column #91  (11) saccade offset y position
% Column #92  (12) saccade LATENCY
% Column #93  (13) NaN      
% Column #94  (14) saccade target position x      
% Column #95  (15) saccade target position y      
% Column #96  (16) sac2Test : saccade onset to test offset delay    (should be positive!)
% Column #97  (17) NaN       
% Column #98  (18) NaN      
% Column #99  (19) NaN      
% Column #100 (20) NaN 
% Column #101 (21) durT1 : fixation  
% Column #102 (22) durT2 : duration T2 (cue)                  %% soaCT : soa test - cue
% Column #103 (23) durT3: duration T3 (ISI1)                  %% durTest : test duration
% Column #104 (24) durT4: duration T4 (stimuli)               %% durTMask : test mask duration
% Column #105 (25) durT5: duration T5                         %% ISI2 soaCD : soa dstr - cue
% Column #106 (26) durT6: duration T6 (response cue)          %% durDstr : dstr duration
% Column #107 (27) durT7: duration T7 (response window)                                           %% durDMask : dstr mask duration
% Column #108 (28) NaN                                        %% durMove
% Column #109 (29) NaN                                        %% durtResp
% Column #110 (30) NaN


%% TRIAL EVAL
% -------------------------------------------------------------------------
% Column #111 (01) %BAD TRIAL FLAG! Good trial flag                  (1 = YES; 0 = NO)
% Column #112 (02) Bad trial flag                   (1 = YES; 0 = NO)
% Column #113 (03) Online eye error trial           (1 = YES; 0 = NO)
% Column #114 (04) Miss time stamps                 (1 = YES; 0 = NO)
% Column #115 (05) Blink during trial               (1 = YES; 0 = NO)
% Column #116 (06) Offline fix error                (1 = YES; 0 = NO)
% Column #117 (07) No saccade detected trial        (1 = YES; 0 = NO)
% Column #118 (08) Innacurate saccade trial         (1 = YES; 0 = NO)
% Column #119 (09) NaN
% Column #120 (10) Saccade before test offset       (1 = YES; 0 = NO)


%% ADDITIONAL
% -------------------------------------------------------------------------
