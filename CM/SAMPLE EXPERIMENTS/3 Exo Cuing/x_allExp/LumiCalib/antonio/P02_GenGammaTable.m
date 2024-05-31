%% Input the data
% last edited AF 072419
GammaInput = [7	15	22	29	36	44	51	58	66	73	80	87 ...
    95	102	109	 117	124	131	138	146	153	160	168	175	...
    182	189	197	204	211	219	226	233	240	248	255]'/255;
%% With user defined color scheme and full contrast/brightness
GammaData = y';
%GammaData = [0.263,0.460,0.885,1.146,1.955,2.844,3.731,5.613,7.719,8.692,11.04,13.67,14.08,16.15,17.39,21.22,25.08,28.32,29.83,33.11,...
%    38.17,40.92,43.59,47.88,52.78,56.76,60.67,63.51,69.18,73.24,79.06,83.54,87.94,90.91,92.21]';
GammaData = GammaData./max(GammaData);

% Plot the data
figure; clf; hold on
plot(GammaInput,GammaData,'+');

%% Fit simple gamma power function
output = linspace(0,1,100)';
[simpleFit,simpleX] = FitGamma(GammaInput,GammaData,output,1);
plot(output,simpleFit,'r');
fprintf(1,'Found exponent %g\n\n',simpleX(1));

%% Fit extended gamma power function
% Here the fit is the same as for the simple function (could be better)
[extendedFit,extendedX] = FitGamma(GammaInput,GammaData,output,2);
plot(output,extendedFit,'g');
fprintf(1,'Found exponent %g, offset %g\n\n',extendedX(1),extendedX(2));
title('Simple and Extended fit');
%% By passing other values of fitType (last arg to FitGamma), you can
% fit other parametric forms or spline the data.  See "help FitGamma"
% for information.  FitGamma can also be called with fitType set to
% zero to cause it to fit all of its forms and let you know which
% one produces the lowest fit error.
% Plot the data
figure; clf; hold on
plot(GammaInput,GammaData,'+');
for i = 1:7
    theFit(:,i) = FitGamma(GammaInput,GammaData,output,i); %#ok<SAGROW>
end
plot(output,theFit,'.','MarkerSize',2);
fprintf('\n');
theFit0 = FitGamma(GammaInput,GammaData,output,0);
plot(output,theFit0,'r');
title('7 other fits');
%% For grins, we can use the parameters from the extended fit to
% invert the gamma function.  The inversion isn't perfect,
% particularly at the low end.  This is because the fit isn't
% perfect there.  Because the gamma function is so flat, a
% small error in fit is amplified on the inversion, when
% the inversion is examined in the input space.  On the
% other hand, the same flatness means that the actual display
% error resulting from the inversion error is small.
%
% Analytial inverse functions are not currently implemented
% for other parametric fits.  Typically we do the inversion
% by inverse table lookup in the actual calibration routines.
maxInput = max(GammaInput);
invertedInput = InvertGammaExtP(extendedX,maxInput,GammaData);
figure; clf; hold on
plot(GammaInput,invertedInput,'r+');
axis('square');
axis([0 maxInput 0 maxInput]);
plot([0 maxInput],[0 maxInput],'r');
title('gamma function inversion, points should be on the line');
%% generate table
maxLum = max(GammaData);
%maxLum = 137.4547;
luminanceRamp=[0:1/255:1];
pow = extendedX(1);
offset = extendedX(2);
invertedRamp=((maxLum-offset)*(luminanceRamp.^(1/pow)))+offset; %invert gamma w/o rounding
%normalize inverse gamma table
invertedRamp=invertedRamp./max(invertedRamp);
%plot inverse gamma function
pels=[0:255];
figure;
plot(pels,invertedRamp,'r');
axis('square');
axis([0 255 0 1]);
xlabel('Pixel Values');
ylabel('Inverse Gamma Table');
strTitle{1}='Inverse Gamma Table Function';
strTitle{2}=['for Exponent = ',num2str(pow),'; Offset = ',num2str(offset)];
title(strTitle);
hold off;
GammaTable = repmat(invertedRamp',1,3);