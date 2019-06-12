#' ---
#' title: "organize_data.R"
#' author: ""
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("useful_functions.R")

install.packages("dplyr")
install.packages("poLCA")
install.packages("ggplot2")

library(readr)
library(dplyr)
library(poLCA)
library(ggplot2)

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

#Creating supercategories, 1 is false, 2 is true (for poLCA)
#Creating ethnicity supercategory
porn$ethnicity <- ifelse(porn$Arab > 1, 2,
                  ifelse(porn$Brazilian > 1, 2,
                  ifelse(porn$British > 1, 2,
                  ifelse(porn$Chinese > 1, 2,
                  ifelse(porn$Czech > 1, 2,
                  ifelse(porn$Danish > 1, 2,
                  ifelse(porn$French > 1, 2,
                  ifelse(porn$German > 1, 2,
                  ifelse(porn$Indian > 1, 2,
                  ifelse(porn$Italian > 1, 2,
                  ifelse(porn$Japanese > 1, 2,
                  ifelse(porn$Korean > 1, 2,
                  ifelse(porn$Russian > 1, 2,
                  ifelse(porn$Swedish > 1, 2,
                  ifelse(porn$Thai > 1, 2,
                  ifelse(porn$Turkish > 1, 2, 1))))))))))))))))

#creating Race supercategory
porn$Race <- ifelse(porn$Asian > 1, 2,
             ifelse(porn$Black.and.Ebony > 1, 2,
             ifelse(porn$Latin > 1, 2,
             ifelse(porn$Interracial > 1, 2, 1))))

#creating Sex Act supercategory
porn$sex.act <- ifelse(porn$Anal > 1, 2, 
                ifelse(porn$Blowjobs > 1, 2, 
                ifelse(porn$Bukkake > 1, 2,
                ifelse(porn$Cream.Pie > 1, 2,
                ifelse(porn$Cumshots > 1, 2, 
                ifelse(porn$Double.Penetration > 1, 2,
                ifelse(porn$Face.Sitting > 1, 2,
                ifelse(porn$Facials > 1, 2,
                ifelse(porn$Fingering > 1, 2,
                ifelse(porn$Gangbang > 1, 2,
                ifelse(porn$Group.Sex > 1, 2,
                ifelse(porn$Handjobs > 1, 2,
                ifelse(porn$Masturbation > 1, 2,
                ifelse(porn$Threesomes > 1, 2, 1))))))))))))))

#Creating Hair color supercategory
porn$hair <- ifelse(porn$Blondes > 1, 2, 
             ifelse(porn$Redheads > 1, 2,
             ifelse(porn$Brunettes > 1, 2, 1)))
#Creating Fetish supercategory
porn$fetish <- ifelse(porn$Foot.Fetish > 1, 2,
               ifelse(porn$BBW > 1, 2,
               ifelse(porn$Gaping > 1, 2,
               ifelse(porn$Lingerie > 1, 2,
               ifelse(porn$Stockings > 1, 2,
               ifelse(porn$Squirting > 1, 2,
               ifelse(porn$Latex > 1, 2, 1)))))))

#creating BDSM supercategory
porn$bdsm.super <- ifelse(porn$BDSM > 1, 2,
                   ifelse(porn$Spanking > 1, 2,
                   ifelse(porn$Femdom > 1, 2,
                   ifelse(porn$Cuckold > 1, 2, 1))))

#creating age supercategory
porn$age <- ifelse(porn$MILFs > 1, 2,
            ifelse(porn$Grannies > 1, 2,
            ifelse(porn$Matures > 1, 2,
            ifelse(porn$OldYoung > 1, 2, 1))))

#creating voyeur supercateogory
porn$voyeur.super <- ifelse(porn$Voyeur > 1, 2,
                     ifelse(porn$Public.Nudity > 1, 2,
                     ifelse(porn$Hidden.Cams > 1, 2,
                     ifelse(porn$Flashing > 1, 2,
                     ifelse(porn$Upskirts > 1, 2,
                     ifelse(porn$Beach > 1, 2, 1))))))

#creating trans supercategory
porn$trans <- ifelse(porn$Ladyboys > 1, 2, 
              ifelse(porn$Shemales > 1, 2, 1))

#creating gay supercategory
porn$gay <- ifelse(porn$Black.Gays > 1, 2, 
            ifelse(porn$Gays > 1, 2, 
            ifelse(porn$Men > 1, 2, 1)))

#creating breasts supercategory
porn$breasts <- ifelse(porn$Big.Boobs > 1, 2, 
                ifelse(porn$Nipples > 1, 2, 
                ifelse(porn$Tits > 1, 2, 1)))

#creating animation supercategory
porn$animation <- ifelse(porn$Cartoons > 1, 2,
                  ifelse(porn$Hentai > 1, 2, 1))

#list of leftover tags: Amateur, Sex Toys, Vintage, Pornstars, Massage, Celebrities, Lesbians, Close-ups,
#Strapon, Showers, Babes, Hairy, Bisexuals, Hardcore, Webcams, Funny, Teens, POV, Swingers, Softcore




#Create subsample
porn.subsample <- porn[sample(1:nrow(porn), 5000),]

#swap porn for porn.subsample and vice versa; porn will take much longer
temp <- poLCA(as.formula(paste("cbind(",paste(tag_vnames,collapse=","),")~1",sep="")), 
              porn, nclass=10)

#Creating scatterplot
ggplot(porn.subsample, aes(x=upload_date, y=nb_views))+
  geom_jitter(alpha=0.5)+
  geom_smooth(method="loess")+
  scale_y_log10()


