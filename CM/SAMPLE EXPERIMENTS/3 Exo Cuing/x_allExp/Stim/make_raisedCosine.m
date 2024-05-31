function [raisedCosine]=make_raisedCosine(imY,imX,nCosSteps,apH,apW,yoff,xoff)
% ----------------------------------------------------------------------
% [raisedCosine]=make_raisedCosine(imX,imY,nCosSteps,apH,apW)
% ----------------------------------------------------------------------
% Goal of the function :
% Make a raised cosine aperture mask for a 2D visual stimulus. 
% 3 arguments mandatory (aperture has same diameter as Image)
% 4 arguments - round aperture (smaller than Image)
% 5 arguments for elliptical aperture.
% ----------------------------------------------------------------------
% Input(s) :
% imY : Image y size
% imX : Image x size
% nCosSteps : number of cosine steps     ! nCosSteps<min([apH apW])/2) !
% apH : height of aperture (y)
% apW : width of aperture (x)
% ----------------------------------------------------------------------
% Output(s):
% raisedCosine : image including raised cosine apperture
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by David AAGTEN-MURPHY
% Last update : 02 / 03 / 2020
% Project : preSacRes
% Version : 1.0
% ----------------------------------------------------------------------

if nargin < 4; apH=imY; apW=apH; end
if nargin < 5; apW=apH; end
if nargin < 6; yoff=0;xoff=0; end



% if nargin==3; apH=imY; apW=apH;
% elseif nargin==4; apW=apH;
% elseif nargin==5; yoff=0;xoff=0;
% end

HWratio = apW/apH;

% Make bigger, to later subtract first and last zero rows/cols to obtain original size

imY_ori = imY;
imX_ori = imX;

imX = imX+2;
imY = imY+2;
apH = apH+4;
apW = apW+4;

% if even, make odd
if mod(imX,2)==0; imX=imX+1; end
if mod(imY,2)==0; imY=imY+1; end

if min([apH apW])/2 < nCosSteps
    sca; error('Mask Steps are set wrong');
end

[X,Y] = meshgrid(floor(-imX/2)+1:ceil(imX/2)-1,floor(-imY/2)+1:ceil(imY/2)-1);
radii = sqrt((X/HWratio).^2 + Y.^2);

% Use a linear transformation to scale the radii values so that the 
% value corresponding to the inner edge of the ramp is equal to 
% (zero x pi) and the value for the outer edge is equal to (1 x pi). 
% The cosine of these values will be 1.0 and zero, respectively.
 
if apW >= apH
    % set inner edge to zero
    radii = radii - radii(round(end/2),round(end/2+apW/2-nCosSteps));
    
    % Do linear transform to set outer edge to pi
    outerVal = radii(round(end/2),round(end/2+apW/2-1));
    radii = radii * pi/outerVal ;
    
elseif apH > apW
    % set inner edge to zero
    radii = radii - radii(round(end/2+apH/2-nCosSteps),round(end/2));
    
    % Do linear transform to set outer edge to pi
    outerVal = radii(round(end/2+apH/2-1),round(end/2));
    radii = radii * pi/outerVal ;
end

% set values more central than the soft aperture to 0 (ie, cos(0) = 1)
radii(radii<=0) = 0;    %radii(find(radii<=0) ) = 0;

% set values more beyond soft aperture to pi (ie, cos(pi) = 0)
radii(radii>=pi) = pi;  %radii(find(radii>=pi) ) = pi;

% Finally, take cos of all the transformed radial values.
raisedCosMask = .5 + .5 * cos(radii);


%% Adjust size
if size(raisedCosMask,1) ~= imY_ori
    raisedCosMask = raisedCosMask(round(abs(diff([size(raisedCosMask,1),imY_ori]))/2):round(abs(diff([size(raisedCosMask,1),imY_ori]))/2)+imY_ori-1,:);
end
if size(raisedCosMask,2) ~= imX_ori
    raisedCosMask = raisedCosMask(:,round(abs(diff([size(raisedCosMask,2),imX_ori]))/2):round(abs(diff([size(raisedCosMask,2),imX_ori]))/2)+imX_ori-1,:);
end


%% Shift image
raisedCosine = zeros(size(raisedCosMask,1)+abs(yoff)*2,size(raisedCosMask,2)+abs(xoff)*2);

raisedCosine(abs(yoff)+yoff+1:abs(yoff)+yoff+size(raisedCosMask,1),...
             abs(xoff)+xoff+1:abs(xoff)+xoff+size(raisedCosMask,2)) = raisedCosMask;

raisedCosine = raisedCosine(abs(yoff)+1:end-abs(yoff),abs(xoff)+1:end-abs(xoff));         
         
% if xoff>=0;     raisedCosine = raisedCosine(:,abs(xoff)+1:abs(xoff)+size(raisedCosMask,2));
% elseif xoff<0;  raisedCosine = raisedCosine(:,abs(xoff)+xoff+1:abs(xoff)+xoff+size(raisedCosMask,2));
% end
% if yoff>=0;     raisedCosine = raisedCosine(abs(yoff)+1:abs(yoff)+size(raisedCosMask,1),:);
% elseif yoff<0;  raisedCosine = raisedCosine(abs(yoff)+yoff+1:abs(yoff)+yoff+size(raisedCosMask,1),:);
% end

end