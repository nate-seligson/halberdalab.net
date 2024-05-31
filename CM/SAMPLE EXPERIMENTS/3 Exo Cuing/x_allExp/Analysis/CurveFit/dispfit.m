% dispfit.m
%
%      usage: dispfit(d,x,y,s,anat,thresh)
%         by: justin gardner
%       date: 01/22/04
%    purpose: function to display fits of data
%
function [ehdr, r2] = dispfit(d,x,y,s,anat,thresh,mapnum)

ehdr = [];

dispanat = 1;
if (nargin == 4)
  mapnum = 0;
  dispanat = 0;
  thresh = 0.2;
  if isfield(d,'r2rand'),thresh = d.r2rand.cutoff;,end
elseif (nargin == 5)
  mapnum = 0;
  thresh = 0.2;
  if isfield(d,'r2rand'),thresh = d.r2rand.cutoff;,end
elseif (nargin == 6)
  mapnum = 0;
elseif (nargin ~= 7)
  help dispfit;
  return
end

% check for a valid dim field
if (~isfield(d,'dim') || (length(d.dim)~=4))
  disp(sprintf('UHOH: dim field should be four long ([x y s t])'));
  return
end
% check for valid data
if (~isfield(d,'data') || (isempty(d.data)))
  disp('UHOH: No data field');
  return
end
% check point is in bouds
if ((x <= 0) || (x > d.dim(1)) || (y <= 0) || (y > d.dim(2)))
  disp(sprintf('UHOH: Voxel (%i,%i) not in image',x,y));
  return
end
% check slice in bounds
if ((s <= 0) || (s > d.dim(3)))
  disp(sprintf('UHOH: Slice number %i out of range (1-%i)',s,d.dim(3)));
  return
end
% check that full time series exists
if (d.dim(4) > size(d.data,4))
  disp(sprintf('UHOH: Data only has %i volumes instead of the full %i',size(d.data,4),d.dim(4)));
  return
end

% set up figure
smartfig('dispestimate','landscape');

% check for volumes field
if (~isfield(d,'volumes'))
  d.volumes = 1:d.dim(4);
end

% get the desired time series and subtract mean
timeseries = squeeze(d.data(x,y,s,d.volumes))';
timeseriesmean = mean(timeseries);
timeseries = timeseries-timeseriesmean;

colors = ['r' 'c' 'b' 'g' 'm' 'k'];
colors = [colors colors colors];
symbols = ['+' 'o' '*' 'x' 's' 'd' 'v' '^'];
symbols = [symbols symbols symbols];

r2 = d.r2(x,y,s);
if (mapnum == 0)
  dirs = 0:(2*pi)/(d.nhdr):2*pi;
  hdrs = 1:d.nhdr;
  nhdr = d.nhdr;
else
  dirs = d.map{mapnum}.dirs;
  hdrs = d.map{mapnum}.hdrs;
  dirs(length(dirs)+1) = dirs(1);
  nhdr = d.map{mapnum}.nhdr;
end

% plot the estimated hdr
for k = 1:3
  if (isfield(d,'samprate'))
    time = (1:d.hdrlen)*d.samprate;
    samprate = d.samprate;
  else
    time = (1:d.hdrlen)*d.tr;
    samprate = d.tr;
  end
  legstr = 'legend(';
  % look for voxel in sigvox
  matchvox=insigvox(d,x,y,s);
  if ((k == 1) | matchvox)
    subplot(2,4,k);
  hold on
  end
  for j = 1:nhdr
    % get matching color to the one in the first subfigure
    thiscolor = colors(find(d.stimpulselens(hdrs(j)) == d.pulselens));
    thissymbol = symbols(find(d.stimpulselens(hdrs(j)) == d.pulselens));
    if (matchvox & (k > 1))
      plot(time,squeeze(d.ehdr(x,y,s,((hdrs(j)-1)*d.hdrlen+1):(hdrs(j)*d.hdrlen))),[thiscolor thissymbol]);
    elseif (k == 1)
      plot(time,squeeze(d.ehdr(x,y,s,((hdrs(j)-1)*d.hdrlen+1):(hdrs(j)*d.hdrlen))),[thiscolor thissymbol '-']);
    end
    legstr = [legstr sprintf('''%i'',',d.stimpulselens(j))];
  end
  legstr = [legstr(1:length(legstr)-1) ');'];
  % plot fits
  if (matchvox && isfield(d,'response') && isfield(d.response,'fit1') && ~isempty(d.response.fit1) && (k == 2))
    for j = 1:nhdr
      thiscolor = colors(find(d.stimpulselens(hdrs(j)) == d.pulselens));
      plot(d.response.fit1{matchvox}.times+samprate,d.response.fit1{matchvox}.fit{hdrs(j)},[thiscolor '-']);
    end
  end
  % plot fits
  if (matchvox && isfield(d,'response') && isfield(d.response,'fit2') && ~isempty(d.response.fit2) && (k == 3))
    for j = 1:nhdr
      thiscolor = colors(find(d.stimpulselens(hdrs(j)) == d.pulselens));
      plot(d.response.fit2{matchvox}.times+samprate,d.response.fit2{matchvox}.fit{hdrs(j)},[thiscolor '-']);
    end
  end
  if (matchvox);
    xlabel(sprintf('time (sec) - sample rate = %0.2f sec',samprate));
    eval(legstr);
    xaxis(min(time),max(time));
    ylabel('% BOLD');
  end
  if ((~matchvox & (k == 1)) | (matchvox & (k == 2)))
    title(sprintf('%s %s (%i,%i,%i) r2 = %.03f ',d.expname,getlastdir(d.fidName),x,y,s,r2));
  end
end


if (matchvox)
  %%%%%%%%%%%%%%%%%
  % use max value
  %%%%%%%%%%%%%%%%%
  subplot(2,4,5);
  % plot max
  polar(dirs,[d.response.max(matchvox,hdrs) d.response.max(matchvox,hdrs(1))],'ko-');
  hold on
  % plot min
  polar(dirs,abs([d.response.min(matchvox,hdrs) d.response.min(matchvox,hdrs(1))]),'kx-')
  % get mean vector
  [phi1 r1] = rmean(dirs(1:length(dirs)-1),d.response.max(matchvox,hdrs));
  plotr1 = max(d.response.max(matchvox,:));
  polar(phi1,plotr1,'go');
  % get mean vector as modulation depth
  [phi2 r2] = rmean(dirs(1:length(dirs)-1),d.response.max(matchvox,hdrs)-d.response.min(matchvox,hdrs));
  r2 = max(d.response.max(matchvox,hdrs));
  polar(phi2,r2,'bo');
  polar([0 phi1],[0 plotr1],'g-');
  polar([0 phi2],[0 r2],'b-');
  for i = 1:length(dirs)-1
    plot(cos(dirs(i))*d.response.max(matchvox,hdrs(i)),sin(dirs(i))*d.response.max(matchvox,hdrs(i)),'o','MarkerFaceColor',colors(i+1));
  end
  legend('max','-min',sprintf('max %0.0f deg',r2d(phi1)),sprintf('max-min %0.0f deg',r2d(phi2)),3);
  title(sprintf('dir = %0.0f r = %0.4f',r2d(phi1),r1/mean(abs(d.response.max(matchvox,hdrs)))));
  %%%%%%%%%%%%%%%%%
  % use absarea
  %%%%%%%%%%%%%%%%%
  subplot(2,4,8);
  absresp = d.response.absarea(matchvox,hdrs);
  polar(dirs,[absresp absresp(1)],'ko-');
  hold on
  % get mean vector
  [phi r] = rmean(dirs(1:length(dirs)-1),d.response.absarea(matchvox,hdrs));
  plotr = max(absresp);
  polar(phi,plotr,'ro');
  polar([0 phi],[0 plotr],'r-');
  for i = 1:length(dirs)-1
    plot(cos(dirs(i))*d.response.absarea(matchvox,hdrs(i)),sin(dirs(i))*d.response.absarea(matchvox,hdrs(i)),'o','MarkerFaceColor',colors(i+1));
  end
  legend('absarea',sprintf('%0.0f deg',r2d(phi1)),3);
  title(sprintf('dir = %0.0f r = %0.4f',r2d(phi),r/mean(abs(d.response.absarea(matchvox,hdrs)))));
  %%%%%%%%%%%%%%%%%
  % use fit1
  %%%%%%%%%%%%%%%%%
  if (isfield(d.response,'fit1') && ~isempty(d.response.fit1))
    subplot(2,4,6);
    polar(dirs,[d.response.fit1{matchvox}.max(hdrs) d.response.fit1{matchvox}.max(hdrs(1))],'ko-');
    hold on
    % get mean vector
    [phi r] = rmean(dirs(1:length(dirs)-1),d.response.fit1{matchvox}.max(hdrs));
    plotr = max(d.response.fit1{matchvox}.max(hdrs));
    polar(phi,plotr,'ro');
    polar([0 phi],[0 plotr],'r-');
    legend('max fit1',sprintf('%0.0f deg',r2d(phi)),3);
    for i = 1:length(dirs)-1
      plot(cos(dirs(i))*d.response.fit1{matchvox}.max(hdrs(i)),sin(dirs(i))*d.response.fit1{matchvox}.max(hdrs(i)),'o','MarkerFaceColor',colors(i+1));
    end
    title(sprintf('dir = %0.0f r = %0.4f',r2d(phi),r/mean(abs(d.response.fit1{matchvox}.max(hdrs)))));
  end
  %%%%%%%%%%%%%%%%%
  % use fit2
  %%%%%%%%%%%%%%%%%
  if (isfield(d.response,'fit2') && ~isempty(d.response.fit2))
    subplot(2,4,7);
    polar(dirs,[d.response.fit2{matchvox}.max(hdrs) d.response.fit2{matchvox}.max(hdrs(1))],'ko-');
    hold on
    % get mean vector
    [phi r] = rmean(dirs(1:length(dirs)-1),d.response.fit2{matchvox}.max(hdrs));
    plotr = max(d.response.fit2{matchvox}.max(hdrs));
    polar(phi,plotr,'ro');
    polar([0 phi],[0 plotr],'r-');
    legend('max fit2',sprintf('%0.0f deg',r2d(phi)),3);
    for i = 1:length(dirs)-1
      plot(cos(dirs(i))*d.response.fit2{matchvox}.max(hdrs(i)),sin(dirs(i))*d.response.fit2{matchvox}.max(hdrs(i)),'o','MarkerFaceColor',colors(i+1));
    end
    title(sprintf('dir = %0.0f r = %0.4f',r2d(phi),r/mean(abs(d.response.fit2{matchvox}.max(hdrs)))));
  end
end

if (dispanat)
  subplot(2,4,4);
  dispoverlay(anat,d,'r2',thresh,s);hold on
  scale = anat.dim(1)/d.dim(1);
  plot(256-(y-1)*scale-1.5,x*scale-1.5,'cx');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to return unbiased hdr estimate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ehdr = unbiased_ehdr(bold,stimcmatrix)

bold = bold -mean(bold);
ehdr = ((stimcmatrix'*stimcmatrix)^-1)*stimcmatrix'*bold';
