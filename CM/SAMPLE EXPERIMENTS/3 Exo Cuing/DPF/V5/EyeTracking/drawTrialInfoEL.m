function drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a box on the eyelink display.
% Modified for the fixation task
% ----------------------------------------------------------------------
% Input(s) :
% scr = window pointer
% const = struct containing constant configurations
% expDes = struct containing experiment design
% t : trial meter
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

% o--------------------------------------------------------------------o
% | EL Color index                                                     |
% o---------------------------------o----------------------------------o
% | Nb |  Other(cross,box,line)     | Clear screen                     |
% o---------------------------------o----------------------------------o
% |  0 | black                      | black                            |
% o---------------------------------o----------------------------------o
% |  1 | dark blue                  | dark dark blue                   |
% o----o----------------------------o----------------------------------o
% |  2 | dark green                 | dark blue                        |
% o----o----------------------------o----------------------------------o
% |  3 | dark turquoise             | blue                             |
% o----o----------------------------o----------------------------------o
% |  4 | dark red                   | light blue                       |
% o----o----------------------------o----------------------------------o
% |  5 | dark purple                | light light blue                 |
% o----o----------------------------o----------------------------------o
% |  6 | dark yellow (brown)        | turquoise                        |
% o----o----------------------------o----------------------------------o
% |  7 | light gray                 | light turquoise                  |
% o----o----------------------------o----------------------------------o
% |  8 | dark gray                  | flashy blue                      |
% o----o----------------------------o----------------------------------o
% |  9 | light purple               | green                            |
% o----o----------------------------o----------------------------------o
% | 10 | light green                | dark dark green                  |
% o----o----------------------------o----------------------------------o
% | 11 | light turquoise            | dark green                       |
% o----o----------------------------o----------------------------------o
% | 12 | light red (orange)         | green                            |
% o----o----------------------------o----------------------------------o
% | 13 | pink                       | light green                      |
% o----o----------------------------o----------------------------------o
% | 14 | light yellow               | light green                      |
% o----o----------------------------o----------------------------------o
% | 15 | white                      | flashy green                     |
% o----o----------------------------o----------------------------------o

%% Colors
fixCol          = 10;
stimFrmCol      = 15;  %white
testCol         = 13;  %pink
textCol         = 15;  %white
BGcol           =  0;  %black


%% Variables
blocknum  = expDes.expMat(t, 1);
trialID   = expDes.expMat(t, 3);
tDir1  	= expDes.expMat(t, 5);   % rand1: tilt direction RIGHT (-20 left, +20 right)
tDir2  	= expDes.expMat(t, 6);   % rand2: 
tDir3 	= expDes.expMat(t, 7);   % rand3: 
tDir4   = expDes.expMat(t, 8);   % rand4: 
tarPos    = expDes.expMat(t, 9);   % rand5: target position (1-4)
gabC      = expDes.expMat(t,11);   % rand7: gabor contrast

tDir_vec = [tDir1,tDir2,tDir3,tDir4];

tDir = tDir_vec(tarPos);

%% Clear Screen :
eyeLinkClearScreen(BGcol);


%% Draw Stimulus

% Fixation target & boundary
eyeLinkDrawBox(const.fixPos(1),const.fixPos(2),const.fixRad*2,const.fixRad*2,2,[],fixCol);
eyeLinkDrawBox(const.fixPos(1),const.fixPos(2),const.FTrad_pix*2,const.FTrad_pix*2,1,fixCol,[]);

% Locations
for i = 1:4
    eyeLinkDrawBox(const.locMat(i,1),const.locMat(i,2),const.ph_rad*2,const.ph_rad*2,1,stimFrmCol,[]);
end

% Test
eyeLinkDrawBox(const.locMat(tarPos,1)+2*tDir,const.locMat(tarPos,2),const.test_rad_pix/2,const.test_rad_pix/2,2,[],testCol);



% Two lines of text during trial (slow process)
corT = expDes.corTrial;
remT = expDes.iniEndJ - expDes.corTrial;

txtVal = {'TRAIN','THRE','MAIN'};

text0 = sprintf('tCor=%3.0f | tRem=%3.0f | Block=%3.0f (%s) | TrialID=%3.0f | Contr=%1.3f',corT,remT,blocknum,txtVal{const.task},trialID,gabC);
eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 30,textCol,text0);
WaitSecs(0.1);

end