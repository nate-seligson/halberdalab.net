%% Init
%Caroline Myers
%% Hello
close all 
clearvars 

addpath('/Users/carolinemyers/Desktop/CM_Experiments/Packages/CM_Functions')


%% Establish any variables we care about:
myFont = 14;
%% Import
%source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/in_person_model/data';
source_dir = '/Users/carolinemyers/Desktop/CM_Experiments/IN_PROGRESS/NumberModel3/ManyGuess/MGP_v1_color/analysis/Preprocessing/data';
source_files = dir(fullfile(source_dir, '*.csv'));

%% set up opts
opts = delimitedTextImportOptions("NumVariables", 36);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "trial_index", "time_elapsed", "internal_node_id", "subject_id", "study_id", "session_id", "rt", "stimulus", "response", "position_of_items", "colors_of_items", "color_of_target", "wheel_spin", "response_angle", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "locs", "which_test", "set_size", "wheel_num_options", "actual_mask_duration", "actual_stim_duration", "CMDispTime", "maskArray", "maskRotation", "item_positions", "task", "randomSpinAmount", "mainTask"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "double", "string", "string", "string", "string", "double", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "double", "string", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "stimulus", "response", "maskArray", "maskRotation", "task", "mainTask"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["success", "timeout", "failed_images", "failed_audio", "failed_video", "trial_type", "internal_node_id", "subject_id", "study_id", "session_id", "stimulus", "response", "maskArray", "maskRotation", "task", "mainTask"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["rt", "position_of_items", "colors_of_items", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "locs", "item_positions"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["rt", "position_of_items", "colors_of_items", "physical_response_angle", "reported_color_angle", "reported_color_discrete", "locs", "item_positions"], "ThousandsSeparator", ",");

% Import the data
%LS4 = readtable("/Users/carolinemyers/Desktop/CM_Experiments/in_person_model/data/LS/LS_4.csv", opts);

%% First, save the raw data for all subjects as a .csv file.
for kk = 1:length(source_files)


    if length(source_files(kk).name) > 5

        rawDataAllThisSub = readtable(fullfile(source_dir,source_files(kk).name),opts);
        subNoThisSub = kk;

        rawDataAllThisSub.subNo = repmat(subNoThisSub,[height(rawDataAllThisSub),1]);

%freeRespThisSub = rawDataAllThisSub((height(rawDataAllThisSub)-6):height(rawDataAllThisSub),:);


        if kk == 1 %If subject number 1, make a new structure
            
            rawDataAll = rawDataAllThisSub;
            %freeRespAll = freeRespThisSub;
        else %Otherwise, add to existing structure
            rawDataAll = [rawDataAll;rawDataAllThisSub];
            %freeRespAll = [freeRespAll;freeRespThisSub];
        end
    end
end

writetable(rawDataAll,'rawDataAll.csv','Delimiter',',','QuoteStrings',true);
type 'rawDataAll.csv';

%writetable(freeRespAll,'freeRespAll.csv','Delimiter',',','QuoteStrings',true);
%type 'freeRespAll.csv';


%% Now that we have our raw data file, let's go through and clean it up a bit. 

%remove extra irrelevant columns we don't need:
cleanedDataAll = removevars(rawDataAll,{'success','timeout','failed_video','failed_audio','failed_images','trial_type','internal_node_id','study_id','session_id','stimulus'});

% remove instruction rows since there's nothing happening here 
%BUT BE CAREFUL! right now due to a coding blip some of our free responses
%are coded as '' for the task, so this eliminates some of them. We can get
%them back in the real version of the exp tho. 

    indexInstruction =  cleanedDataAll.task ~= ''; 
    cleanedDataAll = cleanedDataAll(indexInstruction,:);
    clearvars indexInstruction

% remove 'fixation' rows since there's nothing happening here 
    indexFix =  cleanedDataAll.task ~= 'fixation';
    cleanedDataAll = cleanedDataAll(indexFix,:);
        clearvars indexFix

%% Separate into precision and guess trials        

%remove rows where no response was given for whatever reason
% CAUTION: THIS INCLUDES OUR FREE RESPONSE Qs!
cleanedDataAll = rmmissing(cleanedDataAll ,'DataVariables',{'reported_color_discrete'});

keyboard();
%add one
cleanedDataAll.reported_color_discrete = cleanedDataAll.reported_color_discrete +1;
cleanedDataAll.color_of_target = cleanedDataAll.color_of_target + 1;

%% Now separate into guess and precision trials. 


        % get only precision trials
    indexPrecision =  cleanedDataAll.mainTask == 'color-precision2';
    precisionTrials = cleanedDataAll(indexPrecision,:);
        clearvars indexPrecision


        indexGuess =  cleanedDataAll.mainTask == 'many-guess-6';
    GuessTrials = cleanedDataAll(indexGuess,:);
        clearvars indexGuess

%% Test to make sure our real trials are normally destributed

  %% Transform the data.
        for ii = 1:height(precisionTrials)
            if precisionTrials.color_of_target(ii) > 180 
                tempTP = precisionTrials.color_of_target(ii);%true color
                tempResp = precisionTrials.reported_color_discrete(ii); %color they respond
                diff = ((360 - tempTP) + tempResp);
                precisionTrials.TransformedResponse(ii) = tempResp + 360;
                %precisionTrials.TransformedResponse(ii) = 360 + (360 - tempTP) + tempResp; %get transformed response
              %   precisionTrials.TransformedResponse(ii) = -1*((360 - tempTP) + tempResp);
                clearvars tempTP tempResp diff
            elseif precisionTrials.color_of_target(ii) < 180
                tempTP = precisionTrials.color_of_target(ii);
                tempResp = precisionTrials.reported_color_discrete(ii);
               % precisionTrials.TransformedResponse(ii) = tempResp - (360 + tempTP) + tempTP;     
               % precisionTrials.TransformedResponse(ii) = (360 - tempTP) + tempResp; 
               %diff = (360 + tempTP) + tempTP - 360;
              % precisionTrials.TransformedResponse(ii) = tempTP - diff;
              precisionTrials.TransformedResponse(ii) = tempResp - 360;
              %precisionTrials.TransformedResponse(ii) = (360 + tempTP) + tempTP - 360;
              clearvars tempTP tempResp diff
            elseif precisionTrials.color_of_target(ii) == 180
                    precisionTrials.TransformedResponse(ii) = precisionTrials.reported_color_discrete(ii);

            else
            end
        end
        

        %%Now get diff and take min.
        for ii = 1:height(precisionTrials)
            tempTP = precisionTrials.color_of_target(ii);
            tempResp = precisionTrials.reported_color_discrete(ii);
            tempTransformedResp = precisionTrials.TransformedResponse(ii);
            
            if abs(tempTP - tempResp) > abs(tempTransformedResp - tempTP)
                precisionTrials.TransformedResponseWinner(ii) = tempTransformedResp;
                
            elseif abs(tempTP - tempResp) < abs(tempTransformedResp - tempTP)
                precisionTrials.TransformedResponseWinner(ii) = tempResp;
           
            
            elseif abs(tempTP - tempResp) == abs(tempTransformedResp - tempTP)
                precisionTrials.TransformedResponseWinner(ii) = tempResp;
            end
        end
        precisionTrials.TRANSFORRMEDRESPONSE = precisionTrials.TransformedResponseWinner;
%% Get accuracy

ourAcc = horzcat(precisionTrials.color_of_target,precisionTrials.TRANSFORRMEDRESPONSE);
ourAcc(:,3) = abs(precisionTrials.color_of_target - precisionTrials.TRANSFORRMEDRESPONSE);

%%%%%% unbinned
for ii = 1:length(unique(ourAcc(:,1)))
  avgErrorByColor(:,ii) = mean(ourAcc(ourAcc(:,1)==(ii-1),3))';
end



figure(1)
plot(avgErrorByColor)

figure(2)
%plot(avgErrorByColor)
%[pdf, sigma] = circ_ksdensity(avgErrorByColorBinned, 0:360, 'msni');



%%%%%% now binned, 18 bins
[NAcc,edgesAcc,binsAcc] = histcounts(ourAcc(:,1),18);
ourAccBinned = horzcat(ourAcc, binsAcc)
for ii = 1:size(NAcc,2)
  avgErrorByColorBinned(:,ii) = mean(ourAccBinned(ourAccBinned(:,4)==(ii),3))';
end


%%Now let's look at accuracy and error for only 132 ms trials. 

ourAcc132 = horzcat(precisionTrials.color_of_target,precisionTrials.TRANSFORRMEDRESPONSE);
ourAcc132(:,3) = abs(precisionTrials.color_of_target - precisionTrials.TRANSFORRMEDRESPONSE)

%%%%%% unbinned
for ii = 1:length(unique(ourAcc132(:,1)))
  avgErrorByColor132(:,ii) = mean(ourAcc132(ourAcc132(:,1)==(ii-1),3))';
end


%%%%%% now binned, 18 bins
[NAcc132,edgesAcc132,binsAcc132] = histcounts(ourAcc132(:,1),18);
ourAccBinned132 = horzcat(ourAcc132, binsAcc132)
for ii = 1:size(NAcc132,2)
  avgErrorByColorBinned132(:,ii) = mean(ourAccBinned132(ourAccBinned132(:,4)==(ii),3))';
end

avgErrorByColorBinned


figure
d1 = avgErrorByColor; 

[tickz,colormat] = getColorsCM(18, 20);
myColor = colormat; % 10 bins/colors with random r,g,b for each

%d2 = histcounts(d1,18);
d2 = avgErrorByColorBinned132;

b = bar(d2, 'facecolor', 'flat');
b.CData = myColor;
xlabel('Color');
%xlim([0 360]);

ylabel('Error');
title('Avg error: all subjects');
hold on
Halberdify(myFont,1);

%% Are colors presented uniformly?
pd = makedist('uniform','Lower',1,'Upper',360); %generate uniform distribution
[h,p,ksstat,cv] = kstest(precisionTrials.color_of_target,'cdf',pd);

%% a quick test bc I'm freaking out
rows = precisionTrials.color_of_target == 150
test150 = precisionTrials(rows,:)
helpme150 = std(test150.TRANSFORRMEDRESPONSE)

rows = precisionTrials.color_of_target == 360
test360 = precisionTrials(rows,:)
helpme360 = std(test360.TRANSFORRMEDRESPONSE)

rows = precisionTrials.color_of_target == 1
test1 = precisionTrials(rows,:)
helpme1 = std(test1.TRANSFORRMEDRESPONSE)

rows = precisionTrials.color_of_target == 212
test212 = precisionTrials(rows,:)
helpme212 = std(test212.TRANSFORRMEDRESPONSE)

rows = precisionTrials.color_of_target == 180;
test180 = precisionTrials(rows,:);
helpme180 = std(test180.TRANSFORRMEDRESPONSE)

rows = precisionTrials.color_of_target == 179;
test179 = precisionTrials(rows,:);
helpme179 = std(test179.TRANSFORRMEDRESPONSE)

rows = precisionTrials.color_of_target == 277;
test277 = precisionTrials(rows,:);
helpme277 = std(test277.TRANSFORRMEDRESPONSE)
%% Getting standard deviations and precision for all color values
close all
colors = precisionTrials.color_of_target;
responses = precisionTrials.TRANSFORRMEDRESPONSE;
% Define circular range and number of bins
circ_range = [0 360];
n_bins = 360;

% Initialize arrays to hold precision and density estimates for each color
precisions = zeros(n_bins, 1);
densities = zeros(n_bins, 1);
stds = zeros(n_bins, 1);
stdsAll = zeros(n_bins, 1);
% Loop over each color
for color = 1:n_bins
    
    % Get responses for this color, accounting for circularity
    color_responses = responses; %mod(responses - color + 180, 360) - 180;
    
    %find all rows associated with this color
    temp_color_responses = color_responses(colors == color);
    tempMean = mean(temp_color_responses);
    tempStd = std(temp_color_responses);
    
    if tempStd == 0
        tempMean = mean(color_responses(colors == color - 1));
        tempStd = std(color_responses(colors == color - 1));
    else
    end
    means(color) = tempMean;
    stds(color) = tempStd;
    

    tempPrecision = 1/tempStd;
    precisions(color) = tempPrecision;
    
    clearvars temp_color_responses tempMean tempStd tempPrecision
end

figure
subplot(1,2,1)
plot(stds)
title('stds')
subplot(1,2,2)
plot(precisions,'color','r')
title('precisions')
%%%%%%%%%%%%%%%%%%%% good

%% Wait we have to correct:
precision_values_corrected = precisions
for ii = 1:height(precision_values_corrected)
    if precision_values_corrected(ii) == inf
        precision_values_corrected(ii) = precision_values_corrected(ii-1)
    else
    end
end

precisions = precision_values_corrected;

%% Okay now let's normalize so the area underneath sums to 1
precision_normalized = precisions / sum(precisions);

figure
plot(precision_normalized)
title('precision, normalized')
%% Plot precision
%close all
% color_vals = 1:360;  % 360 color values from 1 to 360
% precision_vals = precisions;  % 360 random precision values between 0 and 1
% 
% % Interpolate the data
% color_interp = linspace(1, 360, 10000);  % Interpolate over 10000 points
% precision_interp = interp1([color_vals, color_vals+360], [precision_vals, precision_vals], ...
%     mod(color_interp, 360), 'pchip');  % Use cubic spline interpolation with circular x-axis
% precision_interp = circshift(precision_interp, round(length(precision_interp)/2));  % Shift the data

% % Smooth the interpolated data using a moving average filter
% window_size = 300;  % Set the window size for the moving average filter
% b = (1/window_size)*ones(1,window_size);
% a = 1;
% precision_smoothed = filtfilt(b, a, precision_interp);
% 
% % Shift the data back
% precision_smoothed = circshift(precision_smoothed, -round(length(precision_smoothed)/2));
% 
% % Plot the smoothed precision values as a function of color value
% figure;
% scatter(color_vals,precisions,color, 'w');
% xlim([1 360])
% hold on
% plot(color_interp, precision_smoothed,'Linewidth',3);
% xlim([1 360])
% legend
% hold off
% xlabel('Color Value');
% ylabel('Precision');
% title('Smoothed Precision Values as a Function of Color Value (Circular)');
% Halberdify(myFont,1)
% 



%% okay let's normalize?
% Load the real data

% 
% % Interpolate the data
% color_interp = linspace(1, 360, 360);  % Interpolate over 10000 points
% precision_interp = interp1([color_vals, color_vals+360], [precisions, precisions], ...
%     mod(color_interp, 360), 'pchip');  % Use cubic spline interpolation with circular x-axis
% precision_interp = circshift(precision_interp, round(length(precision_interp)/2));  % Shift the data
% 
% % Normalize the precision values
% total_area = trapz(color_interp, precision_interp);  % Compute the total area under the curve
% precision_normalized = precision_interp ./ total_area;  % Divide each value by the total area
% 
% figure 
% plot(precision_normalized)
%% Great. precision_normalized is our precision. But now we need to smooth and wrap the data for plotting.
% Input vector of 360 precision values
precision_values = precisions'

% Set window size for circular moving average filter
window_size = 20;

% Create circular moving average filter kernel
kernel = ones(1,window_size)/window_size;

% Pad the precision values vector to wrap around the edges
padded_values = [precision_values(end-window_size+1:end) precision_values precision_values(1:window_size)];

% Apply circular moving average filter to smoothed values
precision_smoothed = conv(padded_values,kernel,'valid');

% Display the original and smoothed precision values in a plot
figure
plot(precision_values,'b')
hold on
plot(precision_smoothed,'r')
legend('Original precision values','Smoothed precision values')
xlabel('Color space index')
ylabel('Precision value')

%% This is what we've been using so far.
% Smooth the interpolated data using a moving average filter
% window_size = 20;  % Set the window size for the moving average filter
% b = (1/window_size)*ones(1,window_size);
% a = 1;
% precision_smoothed = filtfilt(b, a, precision_normalized);
% 
% % Shift the data back
% precision_smoothed = circshift(precision_smoothed, -round(length(precision_smoothed)/2));
% 
% % Plot the smoothed and normalized precision values as a function of color value
% figure;
% plot(color_interp, precision_smoothed);
% xlabel('Color Value');
% ylabel('Precision (Normalized)');
% title('Smoothed Precision Values as a Function of Color Value (Circular)');
% 
% % save out precision bc we'll compare this later
% save('precision_smoothed.mat','precision_smoothed');
% precision_smoothed



%% and now plot alltogether
keyboard();
precision_normalized_and_smoothed = precision_smoothed / sum(precision_smoothed);
x = [1:360];
figure
d1 = GuessTrials.reported_color_discrete; 
h = histogram(GuessTrials.reported_color_discrete,18, "Normalization","pdf");
d2 = histcounts(d1,18, "Normalization","pdf"); %we should also get bin counts for use in figures, etc. 
hold on 
[pdf, sigma] = circ_ksdensity(GuessTrials.reported_color_discrete, 0:360, 'msni',10);
plot(pdf, Color='k', LineWidth=5);
xlim([1,360])
hold on
plot(precision_normalized_and_smoothed',color = 'g',LineWidth=5)
scatter(x,precision_normalized,'MarkerEdgeColor','c','Marker','pentagram')
hold on
%plot(precision_smoothed,color = 'r',LineWidth=5)
xlim([1,360])

hold off
legend('Binned guesses','KDE of guess distribution','Precision (1/sd)','Precision normalized (individual)','Location','NorthEastOutside')
Halberdify(myFont,1);
shg


%% okay and this is unneccessary but just try it
% Load the real data

% 
% % Interpolate the data
% color_interp = linspace(1, 360, 10000);  % Interpolate over 10000 points
% precision_interp = interp1([color_vals, color_vals+360], [precision_vals, precision_vals], ...
%     mod(color_interp, 360), 'pchip');  % Use cubic spline interpolation with circular x-axis
% precision_interp = circshift(precision_interp, round(length(precision_interp)/2));  % Shift the data
% 
% % Normalize the precision values
% total_area = trapz(color_interp, precision_interp);  % Compute the total area under the curve
% precision_normalized = precision_interp ./ total_area;  % Divide each value by the total area
% 
% % Smooth the interpolated data using a moving average filter
% window_size = 200;  % Set the window size for the moving average filter
% b = (1/window_size)*ones(1,window_size);
% a = 1;
% precision_smoothed = filtfilt(b, a, precision_normalized);
% 
% % Shift the data back
% precision_smoothed = circshift(precision_smoothed, -round(length(precision_smoothed)/2));
% 
% % Normalize the smoothed precision values
% precision_smoothed_normalized = (precision_smoothed - min(precision_smoothed)) ./ range(precision_smoothed);
% 
% % Plot the smoothed and normalized precision values as a function of color value
% figure;
% plot(color_interp, precision_smoothed_normalized);
% xlim([1, 360]);
% xlabel('Color Value');
% ylabel('Precision (Normalized)');
% title('Smoothed Precision Values as a Function of Color Value (Circular)');
% 
% 
% save('precision_smoothed.mat','precision_smoothed_normalized');
%%

figure
[f,xi] = ksdensity(precisions,[1:360])
plot(xi,f);

figure
[pdf, sigma] = circ_ksdensity(stds, 1:360, 'std');
plot(pdf, Color='k', LineWidth=5);
%xlim([1 360]);
hold on
Halberdify(myFont,1);



figure;
title('just precision')
plot(1:n_bins, (precisions),'color','r','Linewidth',2);
xlim([0 360])
Halberdify(12,1)


%%


figure;
title('just precision')
plot(1:n_bins, (precisions),'color','r','Linewidth',2);
xlim([0 360])
Halberdify(12,1)

%
% Plot results
figure;
title('precisions')
plot(1:n_bins, (precisions));
hold on

plot(1:n_bins, rad2deg(stdsAll));

legend('Precision', 'STD');
xlabel('Color');
ylabel('Value');
xlim([0 360])




figure;
title('densities')
plot(1:n_bins, (densities));
hold off
% 
% 
% circ_range = linspace(0, 2*pi, n_bins+1);
% circ_range(end) = [];
% figure
% plot(circ_range, precisions);
% hold on;
% plot(circ_range, stds);
% legend('Precision', 'Standard Deviation');
% xlabel('Color (degrees)');
% ylabel('Precision/Standard Deviation');





%%
% Plot results
figure;
title('precisions')
plot(1:n_bins, (precisions));
hold on

plot(1:n_bins, rad2deg(stdsAll));

legend('Precision', 'STD');
xlabel('Color');
ylabel('Value');

%% old

% Identify the unique colors
unique_colors = unique(colors);

% Initialize a matrix to store the precision values for each color
precisions = zeros(length(unique_colors),1);

for i = 1:length(unique_colors)
    % Extract the responses for the current color
    color_responses = responses(colors == unique_colors(i));
    
    % Calculate the mean and standard deviation of responses
    mean_responses = mean(color_responses);
    std_responses = std(color_responses);
    
    % Calculate the precision of responses for the current color
    precision = 1/std_responses;
    
    % Store the precision value in the matrix
    precisions(i) = precision;
end

figure
plot(precisions)

figure(5)
%plot(avgErrorByColor)
[pdf, sigma] = circ_ksdensity(precisions, 0:360, 'msni');
plot(pdf)

%%

figure
d1 = GuessTrials.reported_color_discrete; 

[tickz,colormat] = getColorsCM(18, 20);
myColor = colormat; % 10 bins/colors with random r,g,b for each

d2 = histcounts(d1,18);

b = bar(d2, 'facecolor', 'flat');
b.CData = myColor;
xlabel('Color');
%xlim([0 360]);

ylabel('Frequency');
title('Distribution of guesses: all subjects');
hold on
Halberdify(myFont,1);

cd ../.. %gtfo
cd Figures
saveas(gcf,'HistogramAll.svg')
cd ../Analysis/Preprocessing/ %gtfo
shg


figure
[pdf, sigma] = circ_ksdensity(GuessTrials.reported_color_discrete, 0:360, 'msni',10);
plot(pdf, Color='k', LineWidth=5);
xlim([0 360]);
hold on
Halberdify(myFont,1);

cd ../.. %gtfo
cd Figures
saveas(gcf,'KDEAll.svg')
cd ../Analysis/Preprocessing/ %gtfo
shg

hold off
shg
%% Next, let's add a column where we put in the coordinates for each location
% Commented out for group version since apparently we don't have this
% column?
% for ii = 1:height(precisionTrials)
%     %pull out target location
%     thisTrialLoc = char(precisionTrials.item_positions(ii));
% 
%     precisionTrials.targetLocation(ii) = str2double(thisTrialLoc(2));
% clearvars thisTrialLoc
% end
% 
% for ii = 1:height(precisionTrials)
%     if precisionTrials.targetLocation(ii) == 0
%         precisionTrials.targetLocationDeg(ii) = 90;
% 
%     elseif precisionTrials.targetLocation(ii) == 1
%         precisionTrials.targetLocationDeg(ii) = 45;
% 
%       elseif precisionTrials.targetLocation(ii) == 2
%         precisionTrials.targetLocationDeg(ii) = 0;   
% 
%     elseif precisionTrials.targetLocation(ii) == 3
%         precisionTrials.targetLocationDeg(ii) = 315;
% 
%             elseif precisionTrials.targetLocation(ii) == 4
%         precisionTrials.targetLocationDeg(ii) = 270;
% 
%             elseif precisionTrials.targetLocation(ii) == 5
%         precisionTrials.targetLocationDeg(ii) = 225;
% 
%             elseif precisionTrials.targetLocation(ii) == 6
%         precisionTrials.targetLocationDeg(ii) = 180;
% 
%             elseif precisionTrials.targetLocation(ii) == 7
%         precisionTrials.targetLocationDeg(ii) = 135;
% 
%             elseif precisionTrials.targetLocation(ii) == 8
%         precisionTrials.targetLocationDeg(ii) = 90;
% 
%     else
%     end
% end

writetable(precisionTrials,'precisionTrials.csv','Delimiter',',','QuoteStrings',true)
type 'precisionTrials.csv'

%% Now let's actually calculate the difference
% Also commenting this out because we cant for some reason 

% for ii = 1:height(precisionTrials)
%     if precisionTrials.targetLocationDeg(ii) > 180 && precisionTrials.physical_response_angle(ii) <180
%      precisionTrials.colorUnCorrected(ii) = precisionTrials.physical_response_angle(ii);
%         precisionTrials.colorCorrected(ii) = precisionTrials.physical_response_angle(ii) + 360;
%     
% 
%     elseif precisionTrials.targetLocationDeg(ii) < 180 && precisionTrials.physical_response_angle(ii) >180
% precisionTrials.colorCorrected(ii) = precisionTrials.physical_response_angle(ii) - 360;
% precisionTrials.colorUnCorrected(ii) = precisionTrials.physical_response_angle(ii);    
%     else
%         precisionTrials.colorCorrected(ii) = precisionTrials.physical_response_angle(ii);
%     precisionTrials.colorUnCorrected(ii) = precisionTrials.physical_response_angle(ii);
%     end
%     
% end
% 
% for ii = 1:height(precisionTrials)
%     distance1 = abs(precisionTrials.colorCorrected(ii) - precisionTrials.targetLocationDeg(ii));
%     distance2 = abs(precisionTrials.targetLocationDeg(ii) - precisionTrials.colorUnCorrected(ii));
%     
%     precisionTrials.distance1(ii) = distance1;
%     precisionTrials.distance2(ii) = distance2;
% 
%     distance = min(vertcat(distance1,distance2));
% precisionTrials.distance(ii) = distance;
% clearvars distance1 distance2 distance;
% end
%% Now we can get just the guess trials
for ii = 1:height(cleanedDataAll)

    indexGuessTrials =  cleanedDataAll.CMDispTime == 0;
    cleanedData_GuessTrials = cleanedDataAll(indexGuessTrials,:);
end

writetable(cleanedData_GuessTrials,'cleanedData_GuessTrials.csv','Delimiter',',','QuoteStrings',true)
type 'cleanedData_GuessTrials.csv'

%% Now we can get just the NONguess trials
for ii = 1:height(cleanedDataAll)

    indexNonGuessTrials =  cleanedDataAll.CMDispTime ~= 0;
    cleanedData_NonGuessTrials = cleanedDataAll(indexNonGuessTrials,:);
end

writetable(cleanedData_NonGuessTrials,'cleanedData_NonGuessTrials.csv','Delimiter',',','QuoteStrings',true)
type 'cleanedData_NonGuessTrials.csv'

%% Now save out as excel 
dataRAW = table;
dataRAW.color_of_target = cleanedData_NonGuessTrials.color_of_target;
dataRAW.reported_color_discrete = cleanedData_NonGuessTrials.reported_color_discrete;
dataRAW.CMDispTime = cleanedData_NonGuessTrials.CMDispTime;
dataRAW.setSize = cleanedData_NonGuessTrials.set_size;
dataRAW.subName = cleanedData_NonGuessTrials.subNo;

cd ../.. %gtfo

cd PreprocessedData
writetable(dataRAW,'dataRAW.csv','Delimiter',',','QuoteStrings',true)
type 'dataRAW.csv'



guess = table;
guess.reported_color_discrete = cleanedData_GuessTrials.reported_color_discrete;
guess.subName = cleanedData_GuessTrials.subNo;
writetable(guess,'guess.csv','Delimiter',',','QuoteStrings',true);
type 'guess.csv'

cd ../Analysis/Preprocessing/ %gtfo


%% So now we have the physical distance from the cued location to the target. 


%% Now plot histogram and overlay kde 
figure(1)
lastSub = length(source_files); %%Change me? 5;
clearvars ii
for ii = 1:lastSub
       indexThisSub =  cleanedData_GuessTrials.subNo == ii;
    GuessTrials_ThisSub = cleanedData_GuessTrials(indexThisSub,:);

close all
nbins = 18;
uifigure('Name', 'subplotsFig');
tempPlacing = ceil(sqrt(length(source_files))); % For our subplots
subplot(tempPlacing,tempPlacing,ii)
histogram(GuessTrials_ThisSub.reported_color_discrete,nbins)
hold on 
xlim([0 360]);
%[f,xi] = ksdensity(GuessTrials_ThisSub.reported_color_discrete); 
hold on
%plot(xi,f)

%figure(ii) 
figure
d1 = GuessTrials_ThisSub.reported_color_discrete; 
[tickz,colormat] = getColorsCM(18, 20);
myColor = colormat; % 10 bins/colors with random r,g,b for each
%myColor = rand(10,3);
d2 = histcounts(d1,18);  
b = bar(d2, 'facecolor', 'flat');
b.CData = myColor;
xlabel('Color');
ylabel('Frequency');
title('Distribution of guesses', source_files(ii).name);
%keyboard()

%we were in 'data'
cd ../.. %Go up two levels
cd Figures %Now go into figures

tempTitle = strcat(source_files(ii).name,'Guesses.svg');
Halberdify(myFont,1);
saveas(gcf,tempTitle)
clearvars tempTitle 

cd ../ %Now go up one level
cd Analysis/Preprocessing/


kde(GuessTrials_ThisSub.reported_color_discrete)
[Y0bw, Y0dens, Y0mesh, Y0cdf] = kde(GuessTrials_ThisSub.reported_color_discrete);
end 

figure()
for ii = 1:lastSub
       indexThisSub =  cleanedData_GuessTrials.subNo == ii;
    GuessTrials_ThisSub = cleanedData_GuessTrials(indexThisSub,:);

[pdf, sigma] = circ_ksdensity(GuessTrials_ThisSub.reported_color_discrete, 0:360, 'msni',10);

gcf

plot(pdf);
title('KDE fits for individual subjects, all subs in black')
hold on
xlim([0 360]);
hold on

if ii == lastSub
    [pdf, sigma] = circ_ksdensity(cleanedData_GuessTrials.reported_color_discrete, 0:360, 'msni',10);
plot(pdf, Color='k', LineWidth=5);
hold on
xlim([0 360]);
hold off
shg

figure()
histogram(cleanedData_GuessTrials.reported_color_discrete,nbins)
xlim([0 360]);
title('all subjects histogram')

else
end


end

%% Now some last summary figures
close all
xx = repmat('',lastSub);
d = figure;

% First big kde overall
 [pdf, sigma] = circ_ksdensity(cleanedData_GuessTrials.reported_color_discrete, 0:360, 'msni',10);
plot(pdf, Color='k', LineWidth=5);
hold off
legend('average')

gcf
gca
hold on
for ii = 1:lastSub
       indexThisSub =  cleanedData_GuessTrials.subNo == ii;
    GuessTrials_ThisSub = cleanedData_GuessTrials(indexThisSub,:);

[pdf, sigma] = circ_ksdensity(GuessTrials_ThisSub.reported_color_discrete, 0:360, 'msni', 10);
plot(pdf, LineWidth=2);
hold on


end

%Now perform KS test for uniformity for ALL individual subjects
pd = makedist('uniform','Lower',0,'Upper',359); %generate uniform distribution
[h,p,ksstat,cv] = kstest(cleanedData_GuessTrials.reported_color_discrete,'cdf',pd);


%And add the p value for ALL subjects

subtitle(['p = ',num2str(p),' KS statistic = ', num2str(ksstat)]);

%Add cutesy details:
title('Empirical guess distributions, individual observers', FontSize= myFont + 4);
legend('average',xx); clearvars xx;
Halberdify(myFont,1);
xlim([0,360])
cd ../.. %gtfo
cd Figures
saveas(gcf,'KDEsAll.svg')
cd ../Analysis/Preprocessing/ %gtfo
shg

shg

%% And another figure, with the histogram and KDE overlaid

figure
d1 = cleanedData_GuessTrials.reported_color_discrete; 

[tickz,colormat] = getColorsCM(18, 20);
myColor = colormat; % 10 bins/colors with random r,g,b for each

d2 = histcounts(d1,18);

b = bar(d2, 'facecolor', 'flat');
b.CData = myColor;
xlabel('Color');
%xlim([0 360]);

ylabel('Frequency');
title('Distribution of guesses: all subjects');
hold on
Halberdify(myFont,1);

cd ../.. %gtfo
cd Figures
saveas(gcf,'HistogramAll.svg')
cd ../Analysis/Preprocessing/ %gtfo
shg


figure
[pdf, sigma] = circ_ksdensity(cleanedData_GuessTrials.reported_color_discrete, 0:360, 'msni',10);
plot(pdf, Color='k', LineWidth=5);
xlim([0 360]);
hold on
Halberdify(myFont,1);

cd ../.. %gtfo
cd Figures
saveas(gcf,'KDEAll.svg')
cd ../Analysis/Preprocessing/ %gtfo
shg





hold off
shg

%% Now histogram, but with percentages 
keyboard();
figure
d1 = cleanedData_GuessTrials.reported_color_discrete; 
h = histogram(cleanedData_GuessTrials.reported_color_discrete,18, "Normalization","pdf");
d2 = histcounts(d1,18, "Normalization","pdf"); %we should also get bin counts for use in figures, etc. 
hold on 
[pdf, sigma] = circ_ksdensity(cleanedData_GuessTrials.reported_color_discrete, 0:360, 'msni',10);
plot(pdf, Color='k', LineWidth=5);
hold off
Halberdify(myFont,1);
shg

cd ../.. %gtfo
cd Figures
saveas(gcf,'KDEAndNormedHist.svg')
cd ../Analysis/Preprocessing/ %gtfo
shg
keyboard()

%         guessTrials = cleanedData(indexGuessTrials,:);
%       
%         
% 
%         subjectID = data.subject_id(1);
%         subjectID = strcat('s',num2str(kk),'_',subjectID);
%         subjectStructNM3126.(subjectID).subjectID = subjectID;
%         
% 
%         
%         
%         subjectStructNM3126.(subjectID).rawData = rawDataAll;
%         
% 
% 
% 
%         
%         cleanedDataIndex = strcmp(data.task,'color');
%         cleanedData = data(cleanedDataIndex,:);
%        % cleanedData.absError = abs(cleanedData.error);
%         clearvars cleanedDataIndex
%         
%         %cleanedData = rmmissing(data,'DataVariables',{'error'});
%         
%         subjectStructNM3126.(subjectID).cleanedData = cleanedData;
%         
% 
%         
%         %%
%         
%         
%         indexGuessTrials =  cleanedData.CMDispTime == 0;
%         guessTrials = cleanedData(indexGuessTrials,:);
%         clearvars indexGuessTrials
%         subjectStructNM3126.(subjectID).guessTrials = guessTrials;
%         
%         indexNonGuessTrials =  cleanedData.CMDispTime ~= 0;
%         nonGuessTrials = cleanedData(indexNonGuessTrials,:);
%         %nonGuessTrials.CMDispTime
% 
%         clearvars indexNonGuessTrials
%         subjectStructNM3126.(subjectID).nonGuessTrials = nonGuessTrials;
%         subjectStructNM3126.(subjectID).nonGuessDurations = nonGuessTrials.CMDispTime;
%         
%          indexNonGuessTrials132 =  cleanedData.CMDispTime == 132;
%         nonGuessTrials132 = cleanedData(indexNonGuessTrials132,:);
%         clearvars indexNonGuessTrials132
%         subjectStructNM3126.(subjectID).nonGuessTrials132 = nonGuessTrials132;
%         
%    
%         indexNonGuessTrials66 =  cleanedData.CMDispTime == 66;
%         nonGuessTrials66 = cleanedData(indexNonGuessTrials66,:);
%         clearvars indexNonGuessTrials66
%         subjectStructNM3126.(subjectID).nonGuessTrials66 = nonGuessTrials66;
%         
%         %% Clean the data
%         
%  
%         
%         %% Transform the data.
%         for ii = 1:height(cleanedData)
%             if cleanedData.color_of_target(ii) > 180 
%                 tempTP = cleanedData.color_of_target(ii);%true color
%                 tempResp = cleanedData.reported_color_discrete(ii); %color they respond
%                 diff = ((360 - tempTP) + tempResp);
%                 cleanedData.TransformedResponse(ii) = tempResp + 360;
%                 %cleanedData.TransformedResponse(ii) = 360 + (360 - tempTP) + tempResp; %get transformed response
%               %   cleanedData.TransformedResponse(ii) = -1*((360 - tempTP) + tempResp);
%                 clearvars tempTP tempResp diff
%             elseif cleanedData.color_of_target(ii) < 180
%                 tempTP = cleanedData.color_of_target(ii);
%                 tempResp = cleanedData.reported_color_discrete(ii);
%                % cleanedData.TransformedResponse(ii) = tempResp - (360 + tempTP) + tempTP;     
%                % cleanedData.TransformedResponse(ii) = (360 - tempTP) + tempResp; 
%                %diff = (360 + tempTP) + tempTP - 360;
%               % cleanedData.TransformedResponse(ii) = tempTP - diff;
%               cleanedData.TransformedResponse(ii) = tempResp - 360;
%               %cleanedData.TransformedResponse(ii) = (360 + tempTP) + tempTP - 360;
%               clearvars tempTP tempResp diff
%             else
%             end
%         end
%         
% 
%     
%         subjectStructNM3126.(subjectID).cleanedData = cleanedData;
% 
%             if kk == 1
%         cleanedrawDataAll = cleanedData;
%             else 
%                 cleanedrawDataAll = [cleanedrawDataAll;cleanedData];
%                 clearvars cleanedData
%             end
% 
% %% Now let's make two separate full datasets, one with zero ms trials and one with nonzero
% %First finding our guess trials        
%         indexGuessTrials =  cleanedrawDataAll.CMDispTime == 0;
%         guessTrials = cleanedrawDataAll(indexGuessTrials,:);
%         clearvars indexGuessTrials
% 
% %First finding our nonguess trials        
%         indexNonGuessTrials =  cleanedrawDataAll.CMDispTime ~= 0;
%         nonGuessTrials = cleanedrawDataAll(indexNonGuessTrials,:);
%         clearvars indexNonGuessTrials
% 
%         
% 
% 
%         %% Now save
%         
%         %cd /Users/carolinemyers/Desktop/CM_Experiments/fire/FLSearch_v1.1.20/analysis
%         cd
%         
%         save('subjectStructNM3_1_26.mat','subjectStructNM3126');
%         clearvars data
%         
%     else
%     end
% 
% 
% end
