
library(ggplot2)

#load data
dat <- read.csv('data/compounds.tsv', sep = '\t', stringsAsFactors = FALSE)
names(dat)[1] <- 'ID'
names(dat)[2] <- 'mw'

hist <- ggplot(dat, aes(mw)) +
  geom_histogram(binwidth = 5)