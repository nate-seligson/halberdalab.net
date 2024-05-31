function vidMat_all=make_hybrids(vidMat_ori,numHyb)
% ----------------------------------------------------------------------
% vidMat_all=make_hybrids(vidMat_ori,numHyb)
% ----------------------------------------------------------------------
% Goal of the function :
% Create matrix with numHyb hybrids in between idependent input images
% for dynamic noise video
% ----------------------------------------------------------------------
% Input(s) :
% vidMat_ori : Matrix containing N*1independent images
% numHyb : nb of hybrids between two independent images
% ----------------------------------------------------------------------
% Output(s):
% vidMat_all : Matrix containing independent & hybrid images
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% Last update : 26 / 03 / 2020
% Project : preSacRes
% Version : 8.0
% ----------------------------------------------------------------------

vidMat_all = cell((numHyb+1)*(size(vidMat_ori,1)-1)+1,1);
percVec = 1:-(1/(numHyb+1)):1/(numHyb+1);

idxC = 1;
for idx_ind = 1:size(vidMat_ori,1)-1
    
    for idx_hyb = 1:numel(percVec)
        currIm = vidMat_ori{idx_ind}*percVec(idx_hyb) + vidMat_ori{idx_ind+1}*(1-percVec(idx_hyb));
        if percVec(idx_hyb) ~= 1
            if percVec(idx_hyb) > 0.5
                currIm = imhistmatch(currIm,vidMat_ori{idx_ind});
            else
                currIm = imhistmatch(currIm,vidMat_ori{idx_ind+1});
            end
        end
        vidMat_all{idxC,1} = currIm;
        
        idxC = idxC+1;
    end
end
vidMat_all{end} = vidMat_ori{end};

end