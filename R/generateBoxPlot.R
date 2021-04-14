
library(tidyr)
library(dplyr)
library(ggplot2)

Rcpp::sourceCpp("src/cppFunctions.cpp")

#load data
dat <- read.csv('data/compounds.tsv', sep = '\t', stringsAsFactors = FALSE)
names(dat)[1] <- 'ID'
names(dat)[2] <- 'mw'

summary_all <- data.frame(poolSize = numeric(0), minRange = numeric(0))

# poolSize <- 10
for(i in c(5:30))
{
  poolSize <- i
  
  #order dat and assign to groups of POOL_SIZE
  dat <- dat[order(dat$mw),]
  dat$bin <- binValues(floor(nrow(dat)/poolSize), nrow(dat))

  #create groups
  dat$group <- -1
  for(bin in unique(dat$bin)){
    dat[dat$bin == bin,]$group <- c(1:nrow(dat[dat$bin == bin,]))
  }

  summary <- dat %>% dplyr::group_by(group) %>%
    dplyr::summarise(n = n(), minRange = getMinRange(mw)) %>%
    dplyr::ungroup()
  
  summary$poolSize <- poolSize
  summary_all <- rbind(summary_all, data.frame(poolSize = summary$poolSize, minRange = summary$minRange))
}

boxPlot <- ggplot(summary_all, aes(x = as.factor(poolSize), y = minRange)) +
  geom_boxplot() +
  # geom_jitter() +
  scale_y_continuous(breaks = c(1:20)) +
  xlab('Pool size') +
  ylab('Minium MW range')

