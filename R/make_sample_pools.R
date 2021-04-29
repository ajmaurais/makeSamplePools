
library(tidyr)
library(dplyr)

Rcpp::sourceCpp("src/cppFunctions.cpp")

#load data
dat <- read.csv('data/compounds.tsv', sep = '\t', stringsAsFactors = FALSE)
names(dat)[1] <- 'ID'
names(dat)[2] <- 'mw'

POOL_SIZE <- 20

#order dat and assign to groups of POOL_SIZE
dat <- dat[order(dat$mw),]
dat$bin <- binValues(floor(nrow(dat)/POOL_SIZE), nrow(dat))

#create groups
dat$group <- -1
for(bin in unique(dat$bin)) {
  dat[dat$bin == bin,]$group <- c(1:nrow(dat[dat$bin == bin,]))
}

summary <- dat %>% dplyr::group_by(group) %>%
  dplyr::summarise(n = n(), minRange = getMinRange(mw)) %>%
  dplyr::ungroup()

output <- dat
output <- output[order(output$group),]
write.table(output, file = 'results/compound_groups.tsv', sep = '\t', row.names = F, quote = F)
write.table(summary, file = 'results/groups_summary.tsv', sep = '\t', row.names = F, quote = F)

output2 <- output %>% dplyr::select(-mw) %>%
  tidyr::spread(key = group, value = ID)

#write.table(output2, file = 'results/compound_groups_wide.tsv', sep = '\t', row.names = FALSE)
