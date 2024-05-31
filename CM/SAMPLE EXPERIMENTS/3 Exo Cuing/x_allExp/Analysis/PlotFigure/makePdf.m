function makePdf(fileDir,f,fileName)
% ----------------------------------------------------------------------
% makePdf(fileDir,f,fileName)
% ----------------------------------------------------------------------
% Goal of the function :
% Create pdf with vector elements in Matlab 2015b
% How to make it work?
% 1. download and install xQuartz: http://xquartz.org/
% 2. download install and run once Inkscape: https://inkscape.org/
%    (the first run will take a while - depending on your machine)   
% 3. create a link to the software by puttin this line in terminal:
%    sudo ln -s /Applications/Inkscape.app/Contents/Resources/bin/inkscape /usr/local/bin
%
% Rk: contourf and colorplot don't work with Matlab 2015b and probably with
% others
% ----------------------------------------------------------------------
% Input(s) :
% fileDir: file full directory /Users/martin/Desktop/
% f: figure handle
% fileName: file name 'figure1'
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Data saved :
% PDF files containing each results.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 17 / 06 / 2016
% Project :     -
% Version :     -
% ----------------------------------------------------------------------

plot2svg([fileDir,fileName,'.svg'],f);
setenv('DYLD_LIBRARY_PATH',''); %run this if problem of lybrary
svgDir = sprintf('%s%s.svg',fileDir,fileName);
pdfDir = sprintf('%s%s.pdf',fileDir,fileName);

%[~,~]=system(['/usr/local/bin/inkscape --export-pdf=',pdfDir,' ',svgDir]);
[~,~]=system(['/usr/local/bin/inkscape --export-pdf=',pdfDir,' ',svgDir]);
%delete(sprintf('%s%s.svg',fileDir,fileName));

end