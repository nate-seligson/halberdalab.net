function [const] = sbjConfig(const)
% ----------------------------------------------------------------------
% [const]=sbjConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Take subject and block configuration.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Caroline MYERS
% Last update : 2021-06-08
% Project : DPF
% Version : 1.0
% ----------------------------------------------------------------------

if const.expStart
    const.sjct = input(sprintf('\n\tYour initials (e.g., CM) : '),'s');
    const.sjct_name = sprintf('%s_%s',const.sjct,const.expName);
    
    if const.eyeMvt
        const.sjct_DomEye = input(sprintf('\n\tWhich eye will you track (R or L)? Please choose your dominant one : '),'s');
        if strcmp(const.sjct_DomEye,'L');       const.recEye = 1;
        elseif strcmp(const.sjct_DomEye,'R');   const.recEye = 2;
        else
            error('Restart and choose one of your two eyes (R or L).');
        end
    else
        const.sjct_DomEye='XX';
        const.recEye = 2;
    end
    const.sjct_code = sprintf('%s_%s',const.sjct_name,const.sjct_DomEye);
    
    
    % Check current block status
    const.tasknames = {'Train','Thre','Main'};
    
    % check existing blocks
    const.blocknbs = nan(1,numel(const.tasknames));
    for idx_t = 1:numel(const.tasknames)
        fB = NaN; tB = 0;
        while isnan(fB)
            tB = tB+1;
            resExist = exist(sprintf('Data/%s_data/%s_data/Block%i/%s_B%i.edf',const.sjct_name,const.tasknames{idx_t},tB,const.sjct,tB));
            if resExist
                fileInfo = dir(sprintf('Data/%s_data/%s_data/Block%i/%s_B%i.edf',const.sjct_name,const.tasknames{idx_t},tB,const.sjct,tB));
            end
            if resExist == 0 || fileInfo.bytes < 1000
                const.blocknbs(idx_t) = tB-1;
                fB = 1;
            end
        end
    end
else
    const.sjct = 'XX';
    const.sjct_name = sprintf('%s_%s',const.sjct,const.expName);
    const.sjct_age = '99';
    const.sjct_gender = 'X';
    const.sjct_DomEye = 'R';
    const.sjct_code = strcat(const.sjct_name,'_Test');
    const.recEye = 2;
    const.sjct_height = 0;
    
    const.blocknbs = [0,0,0];
    
    
end

%%CM ADDED
if const.blocknbs(1) == 1 && const.blocknbs(2) == 0 && const.blocknbs(3) == 0;
    cd('Data')
    filePathString = strcat(const.sjct_name,'_data');
    cd(filePathString)
    cd('Train_data')
    cd('Block1')
    if exist('repeatTraining.mat','file')
        load(sprintf('repeatTraining.mat'))
        disp('checking whether training performance > 80%...')
        if repeatTraining == 1
            disp('Training performance < 80%. Please re-explain task and try again')
            const.blocknbs = [0,0,0];
            cd('../../../../')
        elseif repeatTraining == 0
            disp('Training performance > 80%. You may proceed with thresholding!')
            cd('../../../../')
        end
    else
    end
else
end

% Select task and block nb
if const.chooseTask
    cortask = 0;
    while ~cortask
        const.task = input(sprintf('\n\tTraining (1), Threshold (2), or Main experiment (3): '));
        if const.task == 1 || const.task == 2 || const.task == 3
            cortask = 1; WaitSecs(0.5);
            fprintf('\n\t\t\t Excellent choice!\n\n'); WaitSecs(0.5);
        else
            WaitSecs(0.5);
            fprintf('\n\t Nope... please check your offers again.\n');
        end
    end
    const.fromBlock = const.blocknbs(const.task)+1;
else
    % Training / Threshold / Main (how many blocks)
    const.blockGroups = [1,  2,  20];
    %const.blockGroups = [1,  2,  8]; CM changed to make max test blocks 20
    const.sumBlocks = sum(const.blockGroups(end,:));
            
    const.task = NaN;
    for idx_g = 1:size(const.blockGroups,1)
        % check training (task1) first
        %const.blocknbs is a 1 x 3 matrix containing the number of blocks
        %completed for each training (1) thresholding (2) and main (3) 
        
        %const.blockGroups is the number of blocks we expect [1, 2, 12]
        if const.blocknbs(1) < const.blockGroups(idx_g,1)
            const.task = 1;
            const.fromBlock = const.blocknbs(1)+1;
            break
        % check threshold (task2) second
        elseif const.blocknbs(2) < const.blockGroups(idx_g,2)
            const.task = 2;
            const.fromBlock = const.blocknbs(2)+1;
            break
        % then check main (task3)
        elseif const.blocknbs(3) < const.blockGroups(idx_g,3)
            const.task = 3;
            const.fromBlock = const.blocknbs(3)+1;
            break
        end
    end
    if isnan(const.task)
        error;
    end
end

if const.expStart && const.task == 1 && const.fromBlock == 1
    const.sjct_age = input(sprintf('\n\tAge: '));
    const.sjct_gender = input(sprintf('\n\tSex at birth (M / F): '),'s');
    const.sjct_height = input(sprintf('\n\tHeight (inches): '),'s');
end

WaitSecs(2);

end