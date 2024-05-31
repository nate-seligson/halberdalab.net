function overDone(aud,const,vid)
% ----------------------------------------------------------------------
% overDone(aud,const,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Close screen and check transfer of eye-link data.
% ----------------------------------------------------------------------
% Input(s) :
% aud : auditory configurations
% const : struct containing all constant settings
% vid : video structure
% t : trial count
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline Myers
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

ListenChar(1);
if const.eyeMvt
    statRecFile = Eyelink('ReceiveFile',const.edffilename,const.edffilename);
    
    if statRecFile ~= 0
        fprintf(1,'\n\tEyelink EDF file correctly transfered');
    else
        fprintf(1,'\n\Error in Eyelink EDF file transfer');
        statRecFile2 = Eyelink('ReceiveFile',const.edffilename,const.edffilename);
        if statRecFile2 == 0
            fprintf(1,'\n\tEyelink EDF file is now correctly transfered');
        else
            fprintf(1,'\n\n\t!!!!! Error in Eyelink EDF file transfer !!!!!');
            my_sound(9,aud);
        end
    end
    Eyelink('CloseFile');
    WaitSecs(2.0);
    Eyelink('Shutdown');
    WaitSecs(2.0);
    
    oldDir = 'XX.edf';
    newDir = sprintf('%s_B%i.edf',const.sjct,const.fromBlock);
    movefile(oldDir,newDir);
end

timeDur=toc/60;
fprintf(1,'\n\n\tThis part of the experiment took : %2.0f min.\n\n',timeDur);

ShowCursor;
Screen('CloseAll');
if const.mkVideo
    makeVideo(vid);
end

PsychPortAudio('Close');

end