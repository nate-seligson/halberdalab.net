function makeVideo(vid)
% ----------------------------------------------------------------------
% makeVideo(vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Make all image need to make after a video using quicktime
% ----------------------------------------------------------------------
% Input(s) :
% vid : struct containing video file
% ----------------------------------------------------------------------
% Output(s):
% none
% x number of .jpeg file
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 10 / 02 / 2020
% Project : preSacTMS
% Version : 1.0
% ----------------------------------------------------------------------

vidName = input(sprintf('\n\tVideo name: '),'s');
vidDir = sprintf('../../../../Video/demoVid/%s',vidName);


if ~isdir(sprintf('%s/Demo%s/',vidDir,vid.textVid))
    mkdir(sprintf('%s/Demo%s/',vidDir,vid.textVid))
end
imSave = 0;
fprintf(1,'\n\n\tVIDEO IN TREATMENT, PLEASE WAIT...');
for tIm = 1:vid.j1
    imSave = imSave +1;
    imwrite(vid.imageArray1(:,:,:,tIm),sprintf('%s/Demo%s/Demo%sIM%i.jpeg',vidDir,vid.textVid,vid.textVid,imSave))
end

for tIm = 1:vid.j2
    imSave = imSave +1;
    imwrite(vid.imageArray2(:,:,:,tIm),sprintf('%s/Demo%s/Demo%sIM%i.jpeg',vidDir,vid.textVid,vid.textVid,imSave))
end
if ~vid.j2
    vid.imageArray2 = [];
end

for tIm = 1:vid.j3
    imSave = imSave +1;
    imwrite(vid.imageArray3(:,:,:,tIm),sprintf('%s/Demo%s/Demo%sIM%i.jpeg',vidDir,vid.textVid,vid.textVid,imSave))
end
if ~vid.j3
    vid.imageArray3 = [];
end

for tIm = 1:vid.j4
    imSave = imSave +1;
    imwrite(vid.imageArray4(:,:,:,tIm),sprintf('%s/Demo%s/Demo%sIM%i.jpeg',vidDir,vid.textVid,vid.textVid,imSave))
end
if ~vid.j4
    vid.imageArray4 = [];
end

for tIm = 1:vid.j5
    imSave = imSave +1;
    imwrite(vid.imageArray5(:,:,:,tIm),sprintf('%s/Demo%s/Demo%sIM%i.jpeg',vidDir,vid.textVid,vid.textVid,imSave))
end
if ~vid.j5
    vid.imageArray5 = [];
end

m = cat(4,vid.imageArray1,vid.imageArray2,vid.imageArray3,vid.imageArray4,vid.imageArray5);


fprintf('\n\tProcessing video - please wait...\n')
writerObj = VideoWriter(sprintf('%s/%s',vidDir,vidName),'MPEG-4');
writerObj.FrameRate = 60;
writerObj.Quality = 100;
open(writerObj);
writeVideo(writerObj,m);
close(writerObj);


end