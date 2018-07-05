library(sqldf)
library(robustbase)
library(ggplot2)
library(plyr)
library(MASS)
library(lsr)
library(stargazer)



vif.mer <- function (fit) {
    ## adapted from rms::vif
    
    v <- vcov(fit)
    nam <- names(fixef(fit))

    ## exclude intercepts
    ns <- sum(1 * (nam == "Intercept" | nam == "(Intercept)"))
    if (ns > 0) {
        v <- v[-(1:ns), -(1:ns), drop = FALSE]
        nam <- nam[-(1:ns)]
    }
    
    d <- diag(v)^0.5
    v <- diag(solve(v/(d %o% d)))
    names(v) <- nam
    v
}

# Detect outliers
outliers = function(data){
  lowerq = quantile(data)[2]
  upperq = quantile(data)[4]
  iqr = upperq - lowerq
  mild.threshold.upper = (iqr * 1.5) + upperq
  mild.threshold.lower = lowerq - (iqr * 1.5)
  extreme.threshold.upper = (iqr * 3) + upperq
  extreme.threshold.lower = lowerq - (iqr * 3)
  return(list(mild.threshold.upper=mild.threshold.upper,
              extreme.threshold.upper=extreme.threshold.upper,
              mild.threshold.lower=mild.threshold.lower,
              extreme.threshold.lower=extreme.threshold.lower))
}

fancy.threshold = function(x, 
                           at.least=0.015, 
                           at.most=0.025, 
                           wiggle.left=0.005,
                           wiggle.right=0.005){
  require(robustbase)
  theta = median(x)-Qn(x,constant=3.476)*log(2)
  alpha = 0
  for (i in 2:(max(x)/median(x))){
    t = table( x > i*median(x) )
    if(t[2]/sum(t) > at.least & t[2]/sum(t) < at.most){
      alpha = i
      break
    }  
  }
  if (!alpha){
    for (i in 2:(max(x)/median(x))){
      t = table( x > i*median(x) )
      if(t[2]/sum(t) > (at.least-wiggle.left) & t[2]/sum(t) < (at.most+wiggle.right)){
        alpha = i
        break
      }  
    }  
  }
  return (alpha*(1+2/length(x))*median(x)+theta)
}


# Remove outliers (From an long right tailed dist)
# New method, choose 3 * IQR or top ~1%, whichever is less.
# Given a vector
remove.outliers.tailed = function(x, list.col.names) {
  thresholds = list()
  y = x
  size = nrow(y)
  for (c.name in list.col.names){
    print(c.name)
    c = which(names(x)==c.name)
    o = outliers(x[[c]])
    thres = o$extreme.threshold.upper

    qs = quantile(x[[c]], probs = seq(0, 1, 0.005))
    thres_alt = unname(qs[198])

    #Pick threshold that removes the least amount of data.
    if((sum(y[[c]] > thres)/size) > (sum(y[[c]] > thres_alt)/size))
    {
      thresholds = c(thresholds, thres_alt)
      y = y[y[[c]] <= thres_alt,]
    }
    else
    {
      thresholds = c(thresholds, thres)
      y = y[y[[c]] <= thres,]
    }

  }
  names(thresholds) = list.col.names
  print(thresholds)
  return (y)

  #thres = outliers(vec)
  #start = thres$extreme.threshold.upper
  #while(sum(vec > start)/length(vec) > .01)
  #{
  #  start = start + 1
  #}

  #return(vec[vec <= start])
}

#David think bootstrap sampling is a good way to do this more generally


remove.outliers = function(x, list.col.names){
  thresholds = list()
  y = x
  for (c.name in list.col.names){
    print(c.name)
    c = which(names(x)==c.name)
    o = outliers(x[[c]])
    thresholds = c(thresholds, o$extreme.threshold.upper)
    y = y[y[[c]]<o$extreme.threshold.upper,]
  }
  names(thresholds) = list.col.names
  print(thresholds)
  return (y)
}

remove.outliers.fancy = function(x, list.col.names, ...){
  thresholds = list()
  y = x
  for (c.name in list.col.names){
    c = which(names(x)==c.name)
    thresholds = c(thresholds, fancy.threshold(x[[c]], ...))
    y = y[y[[c]]<fancy.threshold(x[[c]], ...),]
  }
  names(thresholds) = list.col.names
  print(thresholds)
  return (y)
}