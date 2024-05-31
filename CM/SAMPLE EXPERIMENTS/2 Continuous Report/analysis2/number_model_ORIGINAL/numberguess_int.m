% function [] = numberguess_int ()
guessd = importdata('guessTrials.csv');
guessresp = guessd.data(:,2);
intd = importdata('mostTargetSize.csv');
intAns = intd.data(:,1);
intResp = intd.data(:,2);
figure(1);
subplot(2,2,1);
hist(guessresp);
hold on;
title('histogram of guess responses');
ylabel('Frequency', 'FontSize', 18); 
subplot(2,2,2);
plot(intAns, intResp, 'ko');
hold on;
[Y0bw, Y0dens, Y0mesh, Y0cdf] = kde(guessresp);
sig0N = std(guessresp, 1);
mean0N = mean(guessresp);
title('Answer - Response'); 
xlabel('Answer', 'FontSize', 18); 
ylabel('Response', 'FontSize', 18); 
smoothwindowsize = 0.5; % try to vary this: this variable is used for smoothing (especially when the numbers of trials for guessing condition and for actual test trials are not balanced)

% out = MLE_ModelFunc_V25_noncirc(intAns,intResp,1000,Y0dens,Y0mesh,smoothwindowsize);
out = MLE_ModelFunc_V25_power (intAns,intResp,1000,Y0dens,Y0mesh,sig0N,mean0N, smoothwindowsize);
% result
subplot(2,2,3); 
hist(out.latent); 
xlim([0 1]); 
xlabel('Probability (Pint)', 'FontSize', 18); 
title('histogram of latent (Pint)'); 

subplot(2,2,4);
nn_tmp = length(out.X);
Zmat = out.latent; 
colorcode = repmat(0,nn_tmp,3);
colorcode(:,1)=Zmat;
colorcode(:,2)=1-Zmat;
sizecode = (abs(Zmat-0.5)+0.4)*24;
scatter(out.X,out.Y,sizecode,colorcode, 'linewidth',1.4);
55555
out
title('model results showing Pint for each data'); 
xlabel('Answer', 'FontSize', 18); 
ylabel('Response', 'FontSize', 18); 
averagePint = out.Pm

5555
