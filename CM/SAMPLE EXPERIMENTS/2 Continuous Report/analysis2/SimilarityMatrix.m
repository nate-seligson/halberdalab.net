function avgs = SimilarityMatrix()
  d = load('LikertRawData.mat');
  colors = load('../../Model/ColorWheel360.mat');
  
  % These are the offsets we asked subjects about:
  offsetConds = [0, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 120, 150, 180];
  offsetConds = [-offsetConds(end:-1:2) offsetConds];
  
  % How should we bin the data (e.g., how big a step for each row in the
  % figure?)
  colorBins = 0:20:360;
      
  for i=1:length(d.data)    
    % Organize the data:
    for j=1:length(d.data{i}.trialStruct)
      cur = d.data{i}.trialStruct(j);
      startColor(j) = cur.colorStart;
      endColor(j) = cur.colorStart + cur.condDescription;
      if endColor(j)<=0, endColor(j)=endColor(j)+360; end
      if endColor(j)>360, endColor(j)=endColor(j)-360; end
      similarity(j) = cur.similarity;
      offset(j) = cur.condDescription;
      rt(j) = cur.rt;
    end   
    
    % Only include reasonable RT trials:
    include = rt>200 & rt<5000;
    
    % Analyze average:
    startBins = discretize(startColor,colorBins);
    endBins = discretize(endColor,colorBins);
    for o=1:length(offsetConds)
      for b=1:length(colorBins)-1
        simData(b,o,i) = nanmean(similarity(startBins==b &...
          offset==offsetConds(o) & include==1));
      end
    end
    
    % Exclusion criteria: similiarity >6 for 0 offset:
    if mean(similarity(offset==0)) <=6 
      simData(:,:,i) = NaN;
      fprintf('Excluding subject %d data\n', i);
    end
  end
  
  % Compute average for each color bin and plot basic function
  simAvg = nanmean(simData,3); % avg over subjects
  for j=1:length(colorBins)-1
    % Normalize to 0-1 scale:
    normalizedSimData = ((simAvg(j,:)-1) ./ 6); 
    confusionEst = (normalizedSimData-min(normalizedSimData))...
      ./max(normalizedSimData-min(normalizedSimData));
    
    % Interpolate data to make full matrix:
    similarityMatrix(j,:) = interp1(offsetConds,confusionEst,-179:180,'spline');
  end
  save SimilarityMatrix.mat similarityMatrix colorBins;
  
  % Plot as black and white matrix centered on each color
  figure(1); clf;
  subplot(1,3,2:3);
  imagesc(similarityMatrix, [0 1]); colorbar;
  set(gca, 'XTick', 0:60:360, 'XTickLabel', -180:60:180, ...
    'YTick', [], 'FontSize', 12);
  xlim([0 360]);
  set(gca, 'FontSize', 14);
  colormap('gray');
  
  % Show the colors associated with each bin from this plot:
  subplot(1,3,1);
  for j=1:length(colorBins)-1
    % Bins are 20 wide, so take the middle color (+10) to show
    whichColor = colorBins(j)+10;   
    colorMat(j,1,1:3) = colors.fullcolormatrix(whichColor,:)./255;
  end
  imshow(imresize(colorMat,[200 20],'nearest'));
  
  keyboard;
  avgs = []
  for ii = 1:height(simAvg) 
      avgs(ii,:) = mean(simAvg(ii,:))
  end
  
  
  figure
  plot(avgs)
  
end


