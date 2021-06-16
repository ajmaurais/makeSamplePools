
# To install ChemmineR:
# > BiocManager::install("ChemmineR")
# might need to also install open-babel
# $ brew install open-babel

library(ChemmineR)

# Create example file with SMILES
dir.create('tables', recursive = T)
data(smisample); smiset <- smisample
write.SMI(smiset[1:4], file="tables/smiles.tsv") 
smiset <- read.SMIset("tables/smiles.tsv")

# extract data from sdf object
sdf <- smiles2sdf(smiset)
# plot(sdf)
# formulas <- MF(sdf, addH=T)
# mono.masses <- exactMassOB(sdf)

# create and write table of compounds
dat <- data.frame(id = cid(smiset), formula = MF(sdf, addH=T), mono.masses = exactMassOB(sdf))
write.table(dat, file = 'tables/mono_masses_example.tsv', sep = '\t', row.names = F, quote = F)

