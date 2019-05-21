#' ---
#' title: "organize_data.R"
#' author: ""
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("useful_functions.R")

library(readr)

porn <- read_csv("analysis/input/xhamster.csv.tar.gz")
rankings <- read_csv2("analysis/input/rankings_xhamster.csv", 
                      col_names = c("tag", "occurence", "novelty", "popularity", 
                                    "user_reaction"),
                      skip = 1)

tag_matrix <- NULL
for(tag in rankings$tag) {
  cat(tag)
  tag_matrix <- cbind(tag_matrix, grepl(tag, porn$channels))
  cat("\n")
}

colnames(tag_matrix) <- rankings$tag

porn <- cbind(porn, tag_matrix)

write_csv(porn, "analysis/output/porn_data.csv")
write_csv(rankings, "analysis/output/rankings_data.csv")
