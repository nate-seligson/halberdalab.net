function [out] = MLE_ModelFunc_V25_power_V1 (X,Y,MaxIter,Y0dens,Y0mesh,sig0,mean0,smoothwindowsize)
% 02-16-2012
% I replaced fminsearch with MLE
% this is for Number&ColorV25, OriV4, and LengthV3.
% Here, the model does not fit the variance. Variance is fixed in its form.
% Intercept is fixed to be 0
% The mass2 for null model is determined by the KDE of 0 msec data.
% fminsearch
% here I had sigma of X*Intsig instead of sqrt(X)*Intsig
% Input: Xi, Yi
% output: Z, parameters: Z, beta, sigInt2, y0, sig02
% in this version, I cut off data points at 0.5 of Z value : for internal
% representation

X = X';
Y = Y';
nn = length(X);
sig0 = 0.1; %std of guess response

initial = [1 sig0]; %%% this is original!!
% initial = rand(1,2); % this is for simulation

%initial values
Z = rand(1,nn);
alpha = 0; % fixed intecept
sigInt = initial(2); %.1
tau = 0.7; %% this is original!
% tau = rand; % this is for simulation

alphaold = alpha;
sigIntold = sigInt;
tauold = tau;
% init_beta = rand;
% betaold = init_beta;

Allnum_exp = [1];
figure(5)
%Allnum_exp = [0.75:0.05:1]; % beta = 1;
for expexp = 1:length(Allnum_exp)
    num_exp = Allnum_exp(expexp); 
    for ii = 1:MaxIter
        % until convergence
        % E-step: replace Zi by expectation taken under posterior probability
        mass1 = normpdf(Y,X.^num_exp, (X.^num_exp) .*sigInt)*tau;
           
        mass2 = getDensityKDE_v3(Y0dens, Y0mesh, Y, smoothwindowsize)*(1-tau);
        
        plot(smooth(mass1,.05),'linewidth', 2);
        title(['Mass1, iterations = ',num2str(ii), 'sigInt = ', num2str(sigInt)]);
        Marisize(12,1)
        hold on
% % % %         mass1 = normpdf(Y,X.^num_exp, X .*sigInt)*tau;
%         mass2 = getDensityKDE(Y0dens, Y0mesh, Y)*(1-tau); % from kernel density
%         mass2 = mass2';
        Z = mass1./(mass1+mass2);
        % M-step: maximize parameters using weighted data.
        % fit sigInt %%%%%%%%%%%%%%%%%% ?????????????
        sigInt = sqrt( nansum( Z .*(((Y- (X.^num_exp)).^2)./(X.^num_exp) .^2) ) / nansum(Z) ); % this is what HY's math got
        
% % % % %         sigInt = sqrt( sum( Z .*(((Y- (X.^num_exp)).^2)./X.^2) ) / sum(Z) ); % this is what HY's math got
        
        %     xsgsq = (X.^2) .*(sigInt^2);
        %     betafunction = @(betaparm) sum( -1 .* log( Z.*( ((-1./xsgsq) .* Y .* (X.^betaparm(1))) + ((1./(2*xsgsq)) .* (X.^(2*betaparm(1))))  ) ) );
        %     options = optimset('LargeScale', 'off');
        %     beta = fmincon(betafunction, betaold, [],[],[],[], 0.1, 2, [], options); % maximizing function
        %     beta = fminsearch(betafunction, betaold); % maximizing function
        % fit tau
        tau = (nansum(Z)+1) / (nn+2);  % with prior tau ~ Beta(1,1)
        if abs(tau-tauold) < 1e-3 && abs(sigInt-sigIntold) <1e-3
            
            %     if abs(tau-tauold) < 1e-3 && abs(beta-betaold) <1e-3 && abs(sigInt-sigIntold) <1e-3
            %                 fprintf('iteration=%d\n' ,ii);
            break;
        end
        sigIntold = sigInt;
        tauold = tau;
    end
    mass1 = normpdf(Y,X.^num_exp, (X.^num_exp) .*sigInt)*tau;
   
 % % % % %     mass1 = normpdf(Y,X.^num_exp, X .*sigInt)*tau;
    mass2 = getDensityKDE_v3(Y0dens, Y0mesh, Y,smoothwindowsize)*(1-tau); % from kernel density
%     mass2 = getDensityKDE(Y0dens, Y0mesh, Y)*(1-tau); % from kernel density
    %     mass2 = getDensityKDE(Y0dens, Y0mesh, Y)*(1-tau); % from kernel density
%     mass2 = mass2';
% % % % %     %%%%%% test 
% % % % %     mass1 = mass1./sum(mass1); 
%     mass2 = mass2./sum(mass2); 
    Z = mass1./(mass1+mass2);
%     LL = log(sum(Z .*mass1))+log(sum((1-Z) .*mass2));
%     temp = Z .*mass1 + (1-Z) .*mass2;
%     size(temp)
    sumL = nansum(log(Z .*mass1 + (1-Z) .*mass2));
    LL = log(sumL);    
    %%%%%%%%%%%%%%%
    Pm = nanmean(Z);
    AllPm(expexp) = Pm; 
    AllZ{expexp} = Z; %Pint/latent
    Allmass1{expexp} = mass1; 
    Allmass2{expexp} = mass2; 
    Alltau(expexp) = tau; 
    AllLL(expexp) = LL; 
    AllsigInt(expexp) = sigInt; 
    Allexp(expexp) = num_exp; 
end
% find the max likelihood
[maxlikelihood maxid] = max(AllLL);
finalZ = AllZ{maxid};
finaltau = Alltau(maxid);
finalpm = AllPm(maxid);
finalmass1 = Allmass1{maxid};
finalmass2 = Allmass2{maxid};
finalsigInt = AllsigInt(maxid);
finalexp = Allexp(maxid); 
finalLL = AllLL(maxid); 
out.latent = finalZ; 
% out.beta = beta;
out.sigInt =sigInt;
out.sig0 = finalsigInt;
out.Pm = finalpm;
out.tau = finaltau;
out.mass1 = finalmass1; 
out.mass2 = finalmass2; 
out.numexp = finalexp; 
out.LL = finalLL; 
out.X = X; 
out.Y = Y; 