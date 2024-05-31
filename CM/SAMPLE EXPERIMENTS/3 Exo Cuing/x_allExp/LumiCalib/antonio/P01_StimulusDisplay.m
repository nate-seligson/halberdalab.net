clear all;
close all;
AssertOpenGL;     %exit if obsolete version of PTB
Screen('Preference', 'SkipSyncTests', 1); 
%define configuration parameters
countdownDelay = 10;                %number of secs wait before measurements start
whichScreen=max(Screen('Screens')); %select secondary display (if available)
calSize=300;                        %size of square luminance target (pixels)
%build array of screen intensity values to be sampled [range:0-255]
indexValues=[7	15	22	29	36	44	51	58	66	73	80	87 ...
    95	102	109	117	124	131	138	146	153	160	168	175	... 
    182	189	197	204	211	219	226	233	240	248	255];
%prepare to take photometric measurements
try
   %open PTB full-screen window
   [window,mainRect]=Screen('OpenWindow',whichScreen);
   %generate linear gamma ramp for baseline calibration phase
   linearCLUT = repmat([0:255]'./255,1,3);
   %upload linear gamma function to video screen
   originalCLUT=Screen('LoadNormalizedGammaTable',window,linearCLUT);
   %set window background to GRAY
   white = WhiteIndex(window); %%% NMH 2020_04
   Screen('FillRect',window,[0.5,0.5,0.5].*white);
   Screen('Flip',window);
   %remove mouse cursor from screen
   %HideCursor;
   %select large text font
   Screen('TextSize',window,36);

   %determine screen center-of-gravity coordinates
   xcenter = round((mainRect(3)-mainRect(1))/2);
   ycenter = round((mainRect(4)-mainRect(2))/2);
   
   %%% NMH 2020_04    
%    %determine size of calibration luminance target
%    targetRect=zeros(1,4);
%    targetRect(1)=round(xcenter-(calSize/2));
%    targetRect(2)=round(ycenter-(calSize/2));
%    targetRect(3)=round(xcenter+(calSize/2));
%    targetRect(4)=round(ycenter+(calSize/2));

   %%% NMH 2020_04
   rect = CenterRect(mainRect/2,mainRect); 
   
   %begin countdown on PTB3 screen
   Screen('TextSize',window,50);
   for(i=countdownDelay:-1:0)
       textMsg = num2str(i);
       Screen('DrawText',window,textMsg,xcenter,ycenter,[0 0 0]);
       Screen('Flip',window);
       WaitSecs(1);
   end
   %GetChar;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % measure luminance for each value in indexValues[] %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   xfeedback=mainRect(3)-100;
   yfeedback=mainRect(4)-80;
   for(i=1:length(indexValues))
       %update screen intensity level (2X to be sure)
       %display feedback re: current state at lower-right corner
       Screen('FillRect',window,indexValues(i),rect); %%% NMH 2020_04  Screen('FillRect',window,indexValues(i),targetRect);
       Screen('DrawText',window,num2str(i),xfeedback,yfeedback,[0 0 0]);
       Screen('Flip',window);
       Screen('FillRect',window,indexValues(i),rect); %%% NMH 2020_04  Screen('FillRect',window,indexValues(i),targetRect);
       Screen('DrawText',window,num2str(i),xfeedback,yfeedback,[0 0 0]);
       Screen('Flip',window);
       %
       temp = ColorCal2('MeasureXYZ');
       y(i)=temp.y;
       x(i)=temp.x;
       z(i)=temp.z;
       %GetChar;
       %
   end
   
catch
    Screen('CloseAll');
    ShowCursor;
end
Screen('CloseAll');

P02_GenGammaTable;