function radSin = makeRadialSinusoidal(s,lambda,con)
% ----------------------------------------------------------------------
% radSin = makeRadialSinusoidal(s,lambda,con,gratORI,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Generate radial sinusoidal grating
% ----------------------------------------------------------------------
% Input(s) :
% s : size (in pix; width = heigth)
% lambda : spatial period in pixels
% con : contrast
% ----------------------------------------------------------------------
% Output(s):
% radSin : radial sinusoidal
% ----------------------------------------------------------------------
% Function created by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Jan KURZAWSKI (jk7127@nyu.edu)
% Last update : 2021-02-11
% Project : preSacPF
% Version : 17.0
% ----------------------------------------------------------------------

s = round(s);

[X,Y] = meshgrid(-1:2/(s-1):1);
% xo = 0;
% yo = 0;
% X = X-xo;
% Y = Y-yo;
[~,R] = cart2pol(X,Y);
radSin = (0.5*con)*sin(lambda*pi*R);

% figure;
% subplot(2,3,1)
% imagesc(gratORI); colormap gray
% 
% subplot(2,3,4)
% testGrat = gratORI(round(size(gratORI,1)/2),:);
% plot(testGrat);
% 
% subplot(2,3,2)
% imagesc(radSin); colormap gray
% 
% subplot(2,3,5)
% testRS = radSin(round(size(radSin,1)/2),:);
% plot(testRS);
% 
% subplot(2,3,6); hold on;
% plot(testGrat);plot(testRS)
% 
% 
% figure;
% for iii = 1:size(gratORI,1)
%     plotGab(iii) = gratORI(iii,iii);
%     plotRad(iii) = radSin(iii,iii);
% end
% subplot(2,3,1)
% imagesc(gratORI); colormap gray
% 
% subplot(2,3,4)
% plot(plotGab);
% 
% 
% subplot(2,3,2)
% imagesc(radSin); colormap gray
% 
% subplot(2,3,5)
% plot(plotRad);
% 
% subplot(2,3,6); hold on;
% plot(plotGab);plot(plotRad)
end