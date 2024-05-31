
mlm.powermodel <- function(intensity, response, remove.outliers = FALSE, outliers.sd = 3.0)
{
  #Variable Initialization
  number.of.outliers<-0 
  
  #This function is only used if outliers are being removed. If outliers are not being removed,
  #this function will be skipped. 
  if(remove.outliers==TRUE)
  {
    #Step One: Estimate the Parameters over all data (i.e., data that might have outliers)
    temp.model<-mle2(response~dnorm(mean=alpha*intensity^beta,sd=(alpha*intensity^beta)*sigmaint),
                 optimizer="nlminb",
                 start=list(alpha=1, beta=1, sigmaint=1),
                 data=list(response=response,intensity=intensity))
    temp.alpha <- coef(temp.model)[1]
    temp.beta <- coef(temp.model)[2]
    temp.sigmaint <- coef(temp.model)[3]
    
    #Step Two: Create upper and lower boundaries that match each intensity's mean and SD
    temp.model.mean <- temp.alpha*intensity^temp.beta
    temp.model.sd <- temp.model.mean * temp.sigmaint
    upperboundary <- (temp.model.mean) + (outliers.sd*(temp.model.sd))
    lowerboundary <- (temp.model.mean) - (outliers.sd*(temp.model.sd))
    
    #Step Three: Construct data array that removes any values above upper or below lower boundary
    outlier.data <- data.frame(intensity=intensity,response=response,lowerlimit=lowerboundary,upperlimit=upperboundary)
    outlier.data <- outlier.data[response < upperboundary & response > lowerboundary,]
   
    #Step Four: Put data back into original names for second estimation (now with no outlier data)
    number.of.outliers <- length(response)-length(outlier.data$intensity)
    intensity <- outlier.data$intensity
    response <- outlier.data$response
  }
  
  
  #Estimate Parameters
  powermodel<-mle2(response~dnorm(mean=alpha*intensity^beta,sd=(alpha*intensity^beta)*sigmaint),
                   optimizer="nlminb",
                   start=list(alpha=1, beta=1, sigmaint=1),
                   data=list(response=response,intensity=intensity))
  power.alpha <- coef(powermodel)[1]
  power.beta <- coef(powermodel)[2]
  power.sigmaint <- coef(powermodel)[3]
  
  power.alpha.se <- stdEr(powermodel)[1]
  power.beta.se <- stdEr(powermodel)[2]
  power.sigmaint.se <- stdEr(powermodel)[3]
  
  out = list("name"="power",
              "trials"=length(response),
              "model"=powermodel,
              "logLik"=as.numeric(logLik(powermodel)),
              "alpha"=power.alpha,
              "beta"=power.beta,
              "sigmaint"=power.sigmaint,
              "alpha.se"=power.alpha.se,
              "beta.se"=power.beta.se,
              "sigmaint.se"=power.sigmaint.se,
              "outliers"=remove.outliers,
              "num.outliers"=number.of.outliers,
              "intensity"=intensity,
              "response"=response)
  
  if(remove.outliers) {
    out$alpha.pre=temp.alpha
    out$beta.pre=temp.beta
    out$sigmaint.pre=temp.sigmaint
  }
  
  return(out)
}

mlm.linearmodel <- function(intensity, response, remove.outliers = FALSE, outliers.sd = 3.0)
{
  #Variable Initialization
  number.of.outliers<-0 
  
  #This function is only used if outliers are being removed. If outliers are not being removed,
  #this function will be skipped. 
  if(remove.outliers==TRUE)
  {
    #Step One: Estimate the Parameters over all data (i.e., data that might have outliers)
    temp.model<-mle2(response~dnorm(mean=alpha+intensity*beta,sd=(alpha+intensity*beta)*sigmaint),
                     optimizer="nlminb",
                     start=list(alpha=1, beta=1, sigmaint=1),
                     data=list(response=response,intensity=intensity))
    temp.alpha <- coef(temp.model)[1]
    temp.beta <- coef(temp.model)[2]
    temp.sigmaint <- coef(temp.model)[3]
    
    #Step Two: Create upper and lower boundaries that match each intensity's mean and SD
    temp.model.mean <- temp.alpha+intensity*temp.beta
    temp.model.sd <- temp.model.mean * temp.sigmaint
    upperboundary <- (temp.model.mean) + (outliers.sd*(temp.model.sd))
    lowerboundary <- (temp.model.mean) - (outliers.sd*(temp.model.sd))
    
    #Step Three: Construct data array that removes any values above upper or below lower boundary
    outlier.data <- data.frame(intensity=intensity,response=response,lowerlimit=lowerboundary,upperlimit=upperboundary)
    outlier.data <- outlier.data[response < upperboundary & response > lowerboundary,]
    
    #Step Four: Put data back into original names for second estimation (now with no outlier data)
    number.of.outliers <- length(response)-length(outlier.data$intensity)
    intensity <- outlier.data$intensity
    response <- outlier.data$response
  }
  
  
  #Estimate Parameters
  linearmodel<-mle2(response~dnorm(mean=alpha+intensity*beta,sd=(alpha+intensity*beta)*sigmaint),
                   optimizer="nlminb",
                   start=list(alpha=1, beta=1, sigmaint=1),
                   data=list(response=response,intensity=intensity))
  linear.alpha <- coef(linearmodel)[1]
  linear.beta <- coef(linearmodel)[2]
  linear.sigmaint <- coef(linearmodel)[3]
  
  linear.alpha.se <- stdEr(linearmodel)[1]
  linear.beta.se <- stdEr(linearmodel)[2]
  linear.sigmaint.se <- stdEr(linearmodel)[3]
  
  out = list("name"="linear",
             "trials"=length(response),
             "model"=linearmodel,
             "logLik"=as.numeric(logLik(linearmodel)),
             "alpha"=linear.alpha,
             "beta"=linear.beta,
             "sigmaint"=linear.sigmaint,
             "alpha.se"=linear.alpha.se,
             "beta.se"=linear.beta.se,
             "sigmaint.se"=linear.sigmaint.se,
             "outliers"=remove.outliers,
             "num.outliers"=number.of.outliers,
             "intensity"=intensity,
             "response"=response)
  
  if(remove.outliers) {
    out$alpha.pre=temp.alpha
    out$beta.pre=temp.beta
    out$sigmaint.pre=temp.sigmaint
  }
  
  return(out)
}

mlm.logmodel <- function(intensity, response, remove.outliers = FALSE, outliers.sd = 3.0)
{
  #Variable Initialization
  number.of.outliers<-0 
  
  #This function is only used if outliers are being removed. If outliers are not being removed,
  #this function will be skipped. 
  if(remove.outliers==TRUE)
  {
    #Step One: Estimate the Parameters over all data (i.e., data that might have outliers)
    temp.model<-mle2(response~dnorm(mean=alpha+log(intensity)/beta,sd=(alpha+log(intensity)/beta)*sigmaint),
                     optimizer="nlminb",
                     start=list(alpha=1, beta=1, sigmaint=1),
                     data=list(response=response,intensity=intensity))
    temp.alpha <- coef(temp.model)[1]
    temp.beta <- coef(temp.model)[2]
    temp.sigmaint <- coef(temp.model)[3]
    
    #Step Two: Create upper and lower boundaries that match each intensity's mean and SD
    temp.model.mean <-temp.alpha+log(intensity)/temp.beta
    temp.model.sd <- temp.model.mean * temp.sigmaint
    upperboundary <- (temp.model.mean) + (outliers.sd*(temp.model.sd))
    lowerboundary <- (temp.model.mean) - (outliers.sd*(temp.model.sd))
    
    #Step Three: Construct data array that removes any values above upper or below lower boundary
    outlier.data <- data.frame(intensity=intensity,response=response,lowerlimit=lowerboundary,upperlimit=upperboundary)
    outlier.data <- outlier.data[response < upperboundary & response > lowerboundary,]
    
    #Step Four: Put data back into original names for second estimation (now with no outlier data)
    number.of.outliers <- length(response)-length(outlier.data$intensity)
    intensity <- outlier.data$intensity
    response <- outlier.data$response
  }
  
  
  #Estimate Parameters
  logmodel<-mle2(response~dnorm(mean=alpha+log(intensity)/beta,sd=(alpha+log(intensity)/beta)*sigmaint),
                    optimizer="nlminb",
                    start=list(alpha=1, beta=1, sigmaint=1),
                    data=list(response=response,intensity=intensity))
  log.alpha <- coef(logmodel)[1]
  log.beta <- coef(logmodel)[2]
  log.sigmaint <- coef(logmodel)[3]
  
  log.alpha.se <- stdEr(logmodel)[1]
  log.beta.se <- stdEr(logmodel)[2]
  log.sigmaint.se <- stdEr(logmodel)[3]
  
  out = list("name"="log",
             "trials"=length(response),
             "model"=logmodel,
             "logLik"=as.numeric(logLik(logmodel)),
             "alpha"=log.alpha,
             "beta"=log.beta,
             "sigmaint"=log.sigmaint,
             "alpha.se"=log.alpha.se,
             "beta.se"=log.beta.se,
             "sigmaint.se"=log.sigmaint.se,
             "outliers"=remove.outliers,
             "num.outliers"=number.of.outliers,
             "intensity"=intensity,
             "response"=response)
  
  if(remove.outliers) {
    out$alpha.pre=temp.alpha
    out$beta.pre=temp.beta
    out$sigmaint.pre=temp.sigmaint
  }
  
  return(out) 
}

mlm.countmodel <- function(intensity, response, remove.outliers = FALSE, outliers.sd = 3.0)
{
  #Variable Initialization
  number.of.outliers<-0 
  
  #This function is only used if outliers are being removed. If outliers are not being removed,
  #this function will be skipped. 
  if(remove.outliers==TRUE)
  {
    #Step One: Estimate the Parameters over all data (i.e., data that might have outliers)
    temp.model<-mle2(response~dnorm(mean=alpha+intensity*beta,sd=(alpha+intensity*beta)^(1/sigmaint)),
                     optimizer="nlminb",
                     start=list(alpha=1, beta=1, sigmaint=1),
                     data=list(response=response,intensity=intensity))
    temp.alpha <- coef(temp.model)[1]
    temp.beta <- coef(temp.model)[2]
    temp.sigmaint <- coef(temp.model)[3]
    
    #Step Two: Create upper and lower boundaries that match each intensity's mean and SD
    temp.model.mean <- temp.alpha+intensity*temp.beta
    temp.model.sd <- temp.model.mean * temp.sigmaint
    upperboundary <- (temp.model.mean) + (outliers.sd*(temp.model.sd))
    lowerboundary <- (temp.model.mean) - (outliers.sd*(temp.model.sd))
    
    #Step Three: Construct data array that removes any values above upper or below lower boundary
    outlier.data <- data.frame(intensity=intensity,response=response,lowerlimit=lowerboundary,upperlimit=upperboundary)
    outlier.data <- outlier.data[response < upperboundary & response > lowerboundary,]
    
    #Step Four: Put data back into original names for second estimation (now with no outlier data)
    number.of.outliers <- length(response)-length(outlier.data$intensity)
    intensity <- outlier.data$intensity
    response <- outlier.data$response
  }
  
  
  #Estimate Parameters
  countmodel<-mle2(response~dnorm(mean=alpha+intensity*beta,sd=(alpha+intensity*beta)^(1/sigmaint)),
                   optimizer="nlminb",
                   start=list(alpha=1, beta=1, sigmaint=1),
                   data=list(response=response,intensity=intensity))
  count.alpha <- coef(countmodel)[1]
  count.beta <- coef(countmodel)[2]
  count.sigmaint <- coef(countmodel)[3]
  
  count.alpha.se <- stdEr(countmodel)[1]
  count.beta.se <- stdEr(countmodel)[2]
  count.sigmaint.se <- stdEr(countmodel)[3]
  
  out = list("name"="count",
             "trials"=length(response),
             "model"=countmodel,
             "logLik"=as.numeric(logLik(countmodel)),
             "alpha"=count.alpha,
             "beta"=count.beta,
             "sigmaint"=count.sigmaint,
             "alpha.se"=count.alpha.se,
             "beta.se"=count.beta.se,
             "sigmaint.se"=count.sigmaint.se,
             "outliers"=remove.outliers,
             "num.outliers"=number.of.outliers,
             "intensity"=intensity,
             "response"=response)
  
  if(remove.outliers) {
    out$alpha.pre=temp.alpha
    out$beta.pre=temp.beta
    out$sigmaint.pre=temp.sigmaint
  }
  
  return(out) 
}

mlm.discontmodel <- function(intensity, response, discontPoint = 0)
{
  #Estimate Parameters
  dismodel<-mle2(mlm.discontNLL,
                   optimizer="nlminb",
                   start=list(alpha=1, beta.a=1, beta.b=1, sigma.a=1, sigma.b=1),
                   data=list(discontPoint = discontPoint, response=response,intensity=intensity))
  dis.alpha <- coef(dismodel)[1]
  dis.betaA <- coef(dismodel)[2]
  dis.betaB <- coef(dismodel)[3]
  dis.sigmaA <- coef(dismodel)[4]
  dis.sigmaB <- coef(dismodel)[5]
  
  dis.alpha.se <- stdEr(dismodel)[1]
  dis.betaA.se <- stdEr(dismodel)[2]
  dis.betaB.se <- stdEr(dismodel)[3]
  dis.sigmaA.se <- stdEr(dismodel)[4]
  dis.sigmaB.se <- stdEr(dismodel)[5]
  
  return(list("name"="discont",
              "trials"=length(response),
              "model"=dismodel,
              "logLik"=as.numeric(logLik(dismodel)),
              "alpha"=dis.alpha,
              "betaA"=dis.betaA,
              "betaB"=dis.betaB,
              "sigmaA"=dis.sigmaA,
              "sigmaB"=dis.sigmaB,
              "alpha.se"=dis.alpha.se,
              "betaA.se"=dis.betaA.se,
              "betaB.se"=dis.betaB.se,
              "sigmaA.se"=dis.sigmaA.se,
              "sigmaB.se"=dis.sigmaB.se))
}


mlm.discontNLL <- function(alpha, beta.a, beta.b, sigma.a, sigma.b, discontPoint)
{
  res <- rep(0,length(intensity))
  for(i in 1:length(intensity)) 
  {
    if(intensity[i]<=discontPoint)
    {
      res[i]<- dnorm(response[i], (alpha*intensity[i]^beta.a), sigma.a*(alpha*intensity[i]^beta.a), log= T)
    }
    else
    {
      res[i] <- dnorm(response[i], (alpha*intensity[i]^beta.b), sigma.b*(alpha*intensity[i]^beta.b), log= T)
    }
  }
  nll.value <- -sum(res)
}
  
mlm.AIC<-function(mlm.model1, mlm.model2, critical = 3)
{ 
  if(min(mlm.model1$trials,mlm.model2$trials)<160)
  {
    aic.table<-AICctab(mlm.model1$model,mlm.model2$model,weights=TRUE,sort=FALSE,nobs=min(mlm.model1$trials,mlm.model2$trials))
    m1.dAIC <- aic.table$dAIC[1]
    m2.dAIC <- aic.table$dAIC[2]
  }
  else
  {
    aic.table<-AICtab(mlm.model1$model,mlm.model2$model,weights=TRUE,sort=FALSE)
    m1.dAIC <- aic.table$dAIC[1]
    m2.dAIC <- aic.table$dAIC[2]
  }
  
  dAIC <- max(m1.dAIC,m2.dAIC)
  
  better.model <- "neither"  
  if((m1.dAIC==0)&&(dAIC >= critical))
    better.model <- mlm.model1$name
  if((m2.dAIC==0)&&(dAIC >= critical))
    better.model <- mlm.model2$name
  
  m1.weight <- round(aic.table$weight[1],3)
  m2.weight <- round(aic.table$weight[2],3)
  
  weight.ratio = max(m1.weight/m2.weight, m2.weight/m1.weight)
  
  return(list("betterModel"=better.model,                 
              "dAIC"=dAIC,
              "m1weight"=m1.weight,
              "m2weight"=m2.weight,
              "wratio"=weight.ratio))                
}


mlm.likelihoodratio<-function(mlm.model, testAlpha = coef(mlm.model$model)[1], testBeta = coef(mlm.model$model)[2], testSigma = coef(mlm.model$model)[3])
{  
  model.ll<- -2*c(logLik(mlm.model$model))
  test.ll<- 2*mlm.model$model@minuslogl(testAlpha,testBeta,testSigma)
  degfree <- nargs()-1
  chisq.value <- abs(model.ll - test.ll)
  p.value<- pchisq(chisq.value,degfree,lower.tail=FALSE)
  
  return(list("modelLogLik"=model.ll,
              "testLogLik"=test.ll,
              "chiSq"=chisq.value,
              "degfree"=degfree,
              "pValue"=p.value))
}

mlm.waldtest<-function(estValue, testValue, estSE)
{
  degfree<- 1
  chisq.value<- ((estValue-testValue)^2)/(estSE^2)
  p.value <- pchisq(chisq.value,degfree,lower.tail=FALSE)
  return(list("chiSq"=chisq.value,
              "degfree"=degfree,
              "pValue"=p.value))
}

#intensity & response = vectors of data of the same length
#power, linear, log, and counting = vectors with 3 model parameters: (alpha, beta, sigma)
#discontinuous = vector with 6 values: (alpha, beta1, beta2, sigma1, sigma2, splitAt)
#outlier = a single number indicating the outlier sd cutoff (e.g., 2.5)
#filename = the output file, must be a pdf
generatePlots<-function(intensity, response, power=NA, linear=NA, log=NA, counting=NA, discontinuous=NA, outlier=NA, filename=NA) {

  if(is.na(outlier)) {
    outlier = 2.5
  }
  filename = 'myfig.pdf';
  value = 300 #the unit for the 2:3 ratio of the width to height in the output image
  #png(filename=filename,width=2*value,height=3*value,units="px",res=120) #used for png
  pdf(file=filename,width=6,height=9)
  par(mfrow=c(3,2),mgp = c(1.8, 0.5, 0),mar=c(3,3,3,1))
  #mgp=(the distance of the axis labels from the axis, the distance from the axis tick labels to the axis tick marks, the distance away from the graph for the axes)
  #mar=(bottom margin, the left margin, the top margin, the right margin)
  
  range = max(intensity)-min(intensity)
  padding = 1 #a percentage indicating how much padding to add to the x-axis
  
  x = seq(min(intensity)-padding*range,max(intensity)+padding*range,length.out=100) #the x values used to plot model lines and fan lines
  #If log is being plotted, automatically only include greater than 0
  if(!is.na(log)[1]) {
    x = x[x > 0]
  }

  allYValues = c()
  if(!is.na(power)[1]) {
    y = power[1]*x^power[2]
    thesd = y*power[3]
    power.y1 = y+thesd*outlier
    power.y2 = y-thesd*outlier
    allYValues = c(allYValues,power.y1,power.y2)
  }
  if(!is.na(linear)[1]) {
    y = linear[2]*x+linear[1]
    thesd = y*linear[3]
    linear.y1 = y+thesd*outlier
    linear.y2 = y-thesd*outlier
    print(linear.y2)
    print(y)
    allYValues = c(allYValues,linear.y1,linear.y2)
  }
  if(!is.na(log)[1]) {
    y = log[1]+log(x)/log[2]
    thesd = y*log[3]
    log.y1 = y+thesd*outlier
    log.y2 = y-thesd*outlier
    allYValues = c(allYValues,log.y1,log.y2)
  }
  if(!is.na(counting)[1]) {
    y = counting[2]*x+counting[1]
    thesd = y^(1/counting[3])
    counting.y1 = y+thesd*outlier
    counting.y2 = y-thesd*outlier
    allYValues = c(allYValues,counting.y1,counting.y2)
  }

  
  xlab = "Intensity"
  ylab = "Response"
  ylower = min(allYValues,na.rm=T)
  yupper = max(allYValues,na.rm=T)
  ylim = c(ylower,yupper) #used if you don't want the fan lines cut off in the figure 
  ylim = c(min(response),max(response))

plot(intensity,response,ylim=ylim,main="Raw Data",xlab=xlab,ylab=ylab,lwd=1,pch=21,bg="gray",panel.first=grid(lty=6))
  if(!is.na(power)[1]) {
    res = power[1]*intensity^power[2]
    thesd = res*power[3]
    q = data.frame(intensity,response,low=res-thesd*outlier,high=res+thesd*outlier)
    q = q[q$response > q$low & q$response < q$high,]
    plot(q$intensity,q$response,ylim=ylim,main="Power",bg="gray",lwd=1,pch=21,xlab=xlab,ylab=ylab,panel.first=grid(lty=6))
    lines(x,power[1]*x^power[2],col="blue",lwd=2)
    lines(x,power.y1,lty=2)
    lines(x,power.y2,lty=2)
  }
  if(!is.na(linear)[1]) {
    res = linear[2]*intensity+linear[1]
    thesd = res*linear[3]
    q = data.frame(intensity,response,low=res-thesd*outlier,high=res+thesd*outlier)
    q = q[q$response > q$low & q$response < q$high,]
    plot(q$intensity,q$response,ylim=ylim,main="Linear",bg="grey",lwd=1,pch=21,xlab=xlab,ylab=ylab,panel.first=grid(lty=6))
    lines(x,linear[2]*x+linear[1],col="blue",lwd=2)
    lines(x,linear.y1,lty=2)
    lines(x,linear.y2,lty=2)
  }
  if(!is.na(log)[1]) {
    res = log[1]+log(intensity)/log[2]
    thesd = res*log[3]
    q = data.frame(intensity,response,low=res-thesd*outlier,high=res+thesd*outlier)
    q = q[q$response > q$low & q$response < q$high,]
    plot(q$intensity,q$response,ylim=ylim,main="Log",bg="grey",lwd=1,pch=21,xlab=xlab,ylab=ylab,panel.first=grid(lty=6))
    lines(x,log[1]+log(x)/log[2],col="blue",lwd=2)
    lines(x,log.y1,lty=2)
    lines(x,log.y2,lty=2)
  }
  if(!is.na(counting)[1]) {
    res = counting[2]*intensity+counting[1]
    thesd = res^(1/counting[3])
    q = data.frame(intensity,response,low=res-thesd*outlier,high=res+thesd*outlier)
    q = q[q$response > q$low & q$response < q$high,]
    plot(q$intensity,q$response,ylim=ylim,main="Counting",bg="grey",lwd=1,pch=21,xlab=xlab,ylab=ylab,panel.first=grid(lty=6))
    lines(x,counting[2]*x + counting[1],col="blue",lwd=2)
    lines(x,counting.y1,lty=2)
    lines(x,counting.y2,lty=2)
  }
  if(!is.na(discontinuous)[1]) {
    #discontinuous parameters: alpha, beta1, beta2, sigma1, sigma2, splitAt
    splitAt = discontinuous[6]
    plot(intensity,response,ylim=ylim,main="Discontinuous",bg="grey",lwd=1,pch=21,xlab=xlab,ylab=ylab,panel.first=grid(lty=6))
    lines(x[x<=splitAt],discontinuous[1]*x[x<=splitAt]^discontinuous[2],col="cadetblue3",lwd=2)
    lines(x[x>=splitAt],discontinuous[1]*x[x>=splitAt]^discontinuous[3],col="cornflowerblue",lwd=2)
  }

  dev.off()
}






#JAGS is in a different syntax, so we first have to generate a JAGS model.
#By embedding all possible models in here, we can later just use a single function to get any model out
bayes.generateStringModel <- function(model, alpha.prior, alpha.mean, alpha.prec, beta.prior, beta.mean, beta.prec, sigma.prior, sigma.mean, sigma.prec)
{  
  #alpha-string
  if(identical(alpha.prior,"Normal")) alpha.model <- "alpha ~ dnorm"
  if(identical(alpha.prior,"Log Normal")) alpha.model <- "alpha ~ dlnorm"
  if(identical(alpha.prior,"Gamma")) alpha.model <- "alpha ~ dgamma"
  if(identical(alpha.prior,"Uniform")) alpha.model <- "alpha ~ dunif"
  alpha.string <- paste(alpha.model,"(",toString(alpha.mean),",",toString(alpha.prec),")", sep="")
  
  #beta-string
  if(identical(beta.prior,"Normal")) beta.model <- "beta ~ dnorm"
  if(identical(beta.prior,"Log Normal")) beta.model <- "beta ~ dlnorm"
  if(identical(beta.prior,"Gamma")) beta.model <- "beta ~ dgamma"
  if(identical(beta.prior,"Uniform")) beta.model <- "beta ~ dunif"
  beta.string <- paste(beta.model,"(",toString(beta.mean),",",toString(beta.prec),")", sep="")
  
  #sigma-string
  if(identical(sigma.prior,"Normal")) sigma.model <- "sigma ~ dnorm"
  if(identical(sigma.prior,"Log Normal")) sigma.model <- "sigma ~ dlnorm"
  if(identical(sigma.prior,"Gamma")) sigma.model <- "sigma ~ dgamma"
  if(identical(sigma.prior,"Uniform")) sigma.model <- "sigma ~ dunif"
  sigma.string <- paste(sigma.model,"(",toString(sigma.mean),",",toString(sigma.prec),")", sep="")
  
  #model
  if(identical(model,"Power"))
  {
    comment <- "#Power"
    mu.string <- "mu[i] <- alpha*pow(x[i],beta)"
    pre.string <- "prec[i] <- 1/pow(mu[i]*sigma,2)"
  }
  if(identical(model,"Linear"))
  {
    comment <- "#Linear"
    mu.string <- "mu[i] <- alpha+x[i]*beta"
    pre.string <- "prec[i] <- 1/pow(mu[i]*sigma,2)"
  }
  if(identical(model,"Log"))
  {
    comment <- "#Log"
    mu.string <- "mu[i] <- alpha+log(x[i])/beta"
    pre.string <- "prec[i] <- 1/pow(mu[i]*sigma,2)"
  }
  if(identical(model,"Count"))
  {
    comment <- "#Count"
    mu.string <- "mu[i] <- alpha+log(x[i])*beta"
    pre.string <- "prec[i] <- 1/pow(mu[i]^sigma,2)"
  }
  
  #Make Final String
  jags.stringmodel <- paste("model{",
                            alpha.string,
                            beta.string,
                            sigma.string,
                            "for(i in 1:n){",
                            mu.string,
                            pre.string,
                            "y[i] ~ dnorm(mu[i],prec[i]) } }", sep = " ")
  
  return(jags.stringmodel)
}

#Because differences in the models (e.g., power vs. linear) are already taken care of in the string, this single function will return the
#estimated parameters for all models that are pre-made in the string. 
bayes.estimate <- function(model.name, remove.outliers=FALSE, outliers.sd=3.0, intensity, response, string.model, n.adapt, n.burn, n.chains, n.saved, plotting=FALSE, filename="")
{
  #Initialize
  inits <- list('alpha'=1,'beta'=1,'sigma'=0.5)
  number.of.outliers<-0 
  parameters = c('alpha','beta','sigma')  
  n.adapt = n.adapt            
  n.burn = n.burn   
  n.chains = n.chains           
  n.saved = n.saved      
  n.thin = 1                  
  n.iter = ceiling((n.saved * n.thin) / n.chains) 
  
  if(remove.outliers==TRUE)
  {
    outlier.data <- bayes.outliers(model.name, outliers.sd, intensity, response)  
    number.of.outliers <- length(response)-length(outlier.data$response)  
    intensity <- outlier.data$intensity
    response <- outlier.data$response
  }
  
  #Estimate Parameters
  jags <- jags.model(textConnection(string.model),
                     data = list('x' = intensity,
                                 'y' = response,
                                 'n' = length(response)),
                     inits = inits,
                     n.chains = n.chains,
                     n.adapt = n.adapt)
  update(jags, n.burn)
  mcmcChains <- coda.samples(jags,
                             parameters,
                             n.iter = n.iter,
                             thin = n.thin)
  
  if(plotting) {
    pdf(file=filename,width=6,height=9) 
    plot(mcmcChains)
    dev.off()
  }
  
  model.dic <- dic.samples(jags,
                           n.iter = n.iter,
                           thin = n.thin)
  
  alpha <- summary(mcmcChains)$statistics[1]
  beta <- summary(mcmcChains)$statistics[2]
  sigma <-summary(mcmcChains)$statistics[3]
  
  alpha.ciplus <- summary(mcmcChains)$quantiles[1,1]
  alpha.ciminus <- summary(mcmcChains)$quantiles[1,5]
  beta.ciplus <- summary(mcmcChains)$quantiles[2,1]
  beta.ciminus <- summary(mcmcChains)$quantiles[2,5]
  sigma.ciplus <- summary(mcmcChains)$quantiles[3,1]
  sigma.ciminus <- summary(mcmcChains)$quantiles[3,5]
  
  out = list("name"="jags.model",
             "trials"=length(response),
             "num.outliers"=number.of.outliers,
             "string.model"=string.model,
             "chains"=mcmcChains,
             "alpha"=alpha,
             "beta"=beta,
             "sigma"=sigma,
             "alpha.ciplus"=alpha.ciplus,
             "alpha.ciminus"=alpha.ciminus,
             "beta.ciplus"=beta.ciplus,
             "beta.ciminus"=beta.ciminus,
             "sigma.ciplus"=sigma.ciplus,
             "sigma.ciminus"=sigma.ciminus,
             "model.dic"=model.dic)
  return(out)
}

#DIC model comparison
bayes.DIC<-function(dic1, dic2, model1.name, model2.name)
{ 
  dDIC <- diffdic(dic1, dic2)
  
  better.model <- "neither"  
  if(dDIC[1]<0)
    better.model <- model1.name
  if(dDIC[1]>0)
    better.model <- model2.name
  
  return(list("betterModel" = better.model,
              "diffDIC" = dDIC))              
}

bayes.outliers<-function(model.name, outliers.sd, intensity, response)
{
  #Step One: Estimate the Parameters over all data (i.e., data that might have outliers)
  if(identical(model.name,"Power"))   temp.model<-mle2(response~dnorm(mean=alpha*intensity^beta,sd=(alpha*intensity^beta)*sigma),
                                                       optimizer="nlminb",
                                                       start=list(alpha=1, beta=1, sigma=1),
                                                       data=list(response=response,intensity=intensity))
  
  if(identical(model.name,"Linear"))  temp.model<-mle2(response~dnorm(mean=alpha+intensity*beta,sd=(alpha+intensity*beta)*sigma),
                                                       optimizer="nlminb",
                                                       start=list(alpha=1, beta=1, sigma=1),
                                                       data=list(response=response,intensity=intensity))
  
  if(identical(model.name,"Log"))     temp.model<-mle2(response~dnorm(mean=alpha+log(intensity)/beta,sd=(alpha+log(intensity)/beta)*sigma),
                                                       optimizer="nlminb",
                                                       start=list(alpha=1, beta=1, sigma=1),
                                                       data=list(response=response,intensity=intensity))
  
  if(identical(model.name,"Count"))   temp.model<-mle2(response~dnorm(mean=alpha+intensity*beta,sd=(alpha+intensity*beta)^(1/sigma)),
                                                       optimizer="nlminb",
                                                       start=list(alpha=1, beta=1, sigma=1),
                                                       data=list(response=response,intensity=intensity))  
  temp.alpha <- coef(temp.model)[1]
  temp.beta <- coef(temp.model)[2]
  temp.sigma <- coef(temp.model)[3]
  
  #Step Two: Create upper and lower boundaries that match each intensity's mean and SD
  temp.model.mean <- temp.alpha*intensity^temp.beta
  temp.model.sd <- temp.model.mean * temp.sigma
  upperboundary <- (temp.model.mean) + (outliers.sd*(temp.model.sd))
  lowerboundary <- (temp.model.mean) - (outliers.sd*(temp.model.sd))
  
  #Step Three: Construct data array that removes any values above upper or below lower boundary
  outlier.data <- data.frame(intensity=intensity,response=response,lowerlimit=lowerboundary,upperlimit=upperboundary)
  outlier.data <- outlier.data[response < upperboundary & response > lowerboundary,]
  
  #Step Four: Put data back into original names for second estimation (now with no outlier data)
  number.of.outliers <- length(response)-length(outlier.data$intensity)
  intensity <- outlier.data$intensity
  response <- outlier.data$response
  
  out = list("model.name"=model.name,
             "outliers.sd"=outliers.sd,
             "intensity"=intensity,
             "response"=response)
  
  return(out)
}