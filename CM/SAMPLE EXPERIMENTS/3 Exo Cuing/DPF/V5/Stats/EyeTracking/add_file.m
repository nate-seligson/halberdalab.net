function add_file(sub)
% ----------------------------------------------------------------------
% add_file(sub,eyeAna_bl)
% ----------------------------------------------------------------------
% Goal of the function :
% Add different parts corresponding to different experimental blocks, 
% and modify the number of block at the beginning of the second file.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

corMat_AllB = [];
%corTrace_AllB = [];

incorMat_AllB = [];
% incorTrace_AllB = [];

for rep = sub.nbBlocks
    
    curr_corMat     = dlmread(sprintf('csv/%s_B%i_corMat.csv',sub.ini,rep));
    corMat_AllB     = [corMat_AllB;curr_corMat];

    curr_incorMat   = dlmread(sprintf('csv/%s_B%i_incorMat.csv',sub.ini,rep));
    incorMat_AllB   = [incorMat_AllB;curr_incorMat];
    
    
    %load(sprintf('trace/%s_B%i_corTrace.mat',sub.ini,rep));
    %corTrace_AllB   = [corTrace_AllB,traceCor];

    %load(sprintf('trace/%s_B%i_incorTrace.mat',sub.ini,rep));
    %incorTrace_AllB = [incorTrace_AllB,traceIncor];    
    
end
    
dlmwrite(sprintf('csv/%s_AllB_corMat.csv',sub.ini),     corMat_AllB,'precision','%10.10f');
dlmwrite(sprintf('csv/%s_AllB_incorMat.csv',sub.ini),   incorMat_AllB, 'precision','%10.10f');

%save(sprintf('trace/%s_AllB_corTrace.mat',sub.ini),'corTrace_AllB');
%save(sprintf('trace/%s_AllB_incorTrace.mat',sub.ini),'incorTrace_AllB');

end