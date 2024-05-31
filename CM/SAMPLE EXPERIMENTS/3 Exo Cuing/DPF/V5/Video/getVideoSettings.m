function [expDes,vid] = getVideoSettings(scr,const,expDes)
% ----------------------------------------------------------------------
% [expDes,vid] = getVideoSettings(scr,const,expDes)
% ----------------------------------------------------------------------
% Goal of the function :
% Select type of trial relative the different variables used in this
% experiment for the only one trial saved later as a video.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% expVar : struct containing all variables configurations.
% const : struct containing all constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg all variable data randomised.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 27 / 06 / 2016
% Project :     StimTest
% Version :     1.0
% ----------------------------------------------------------------------

if const.mkVideo
    
    if ~isdir('../demoVid')
        mkdir('../demoVid')
    end
    
    fprintf(1,'\n\n\tVIDEO MODE ACTIVATED...\n');
    
    vid.textVid = [];
    
    for tCond = 1:expDes.nb_cond
        varMat(tCond) = input(sprintf('\n\tCOND %i = ',tCond));
        vid.textVid = [vid.textVid,sprintf('_Cond%iM%i',tCond,varMat(tCond))];
    end
    
    if isempty(tCond);tCond = 0;end
    
    for tVar = 1:expDes.nb_var
        varMat(tCond+tVar) = input(sprintf('\n\tVAR %i = ',tVar));
        vid.textVid = [vid.textVid,sprintf('_Var%iM%i',tVar,varMat(tCond+tVar))];
    end
    
    if isempty(tVar);tVar = 0;end
        
    for tRand = 1:expDes.nb_rand
        varMat(tCond+tVar+tRand) = input(sprintf('\n\tRAND %i = ',tRand));
        vid.textVid = [vid.textVid,sprintf('_Rand%iM%i',tRand,varMat(tCond+tVar+tRand))];
    end
    
    vid.j = 0;
    vid.j1 =0;
    vid.j2 =0;
    vid.j3 =0;
    vid.j4 =0;
    vid.j5 =0;

    vid.sparseFile = round(round(const.numMax*1.20)/5);

    if const.condition == 1
        stimVal = 20;
    elseif const.condition == 2 || const.condition == 6
        stimVal = 45;
    elseif const.condition == 3
        stimVal = 0;
    elseif const.condition == 4
        stimVal = 10;
    elseif const.condition == 5
        stimVal = 8;
    end
    
    %% end of specific add
    tRTval = input(sprintf('\n\tReaction time (in seconds) = '));fprintf(1,'\n');
    expDes.timeRTvid = (round(tRTval/scr.frame_duration));
    
    expDes.expMat= [1 1 const.condition const.threTask varMat stimVal];
    
else
    vid =[];
end

