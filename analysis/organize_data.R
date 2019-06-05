#' ---
#' title: "organize_data.R"
#' author: ""
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("useful_functions.R")

library(readr)
library(dplyr)

porn <- read_csv("analysis/input/xhamster.csv.tar.gz")
rankings <- read_csv2("analysis/input/rankings_xhamster.csv", 
                      col_names = c("tag", "occurence", "novelty", "popularity", 
                                    "user_reaction"),
                      skip = 1)

#creating independent tag categories for each case
tag_matrix <- NULL
tag_vnames <- NULL
for(tag in rankings$tag) {
  cat(tag)
  tag_matrix <- cbind(tag_matrix, grepl(tag, porn$channels))
  vname <- gsub("\\s+",".",tag)
  vname <- gsub("-","",vname)
  vname <- gsub("\\+","", vname)
  tag_vnames <- c(tag_vnames, vname)
  cat(" ")
  cat(vname)
  cat("\n")
}

colnames(tag_matrix) <- tag_vnames

porn <- cbind(porn, tag_matrix+1)

library(poLCA)

porn.subsample <- porn[sample(1:nrow(porn), 10000),]

temp <- poLCA(as.formula(paste("cbind(",paste(tag_vnames,collapse=","),")~1",sep="")), 
              porn.subsample, nclass=10)

summary(porn)

write_csv(porn, "analysis/output/porn_data.csv")
write_csv(rankings, "analysis/output/rankings_data.csv")
