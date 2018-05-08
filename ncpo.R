########## Set Up ########## 
# Set working directory
setwd("~/Documents/GitHub/python_ncpo")

# Load packages
packages <- c("readr", "dplyr", "ggplot2", "lubridate", "plyr", "tidyr", "stringr")

load.packages <- function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
}

lapply(packages, load.packages)

#######
filelist = list.files(path="ncpo/", pattern = ".*txt")

text <- lapply(filelist, function(x) {read_file(paste("ncpo/", x, sep="")) })
       

text <- stringr::str_replace_all(text,"[\t]", " ")
text <- stringr::str_replace_all(text,"\n", " ")

head <- gsub("^.*Body\n|Classification.*$","", text)


head<- str_extract("^.*Body\n|Classification.*$", text)

body <- gsub("^.*ราชกิจจานุเบกษา", "",text)

head <- gsub("^.*เรื่อง|^.*$", "",text)

date <- gsub("^.*ราชกิจจานุเบกษา|คำ.*$", "",text)

###
df <- data.frame(doc_id = seq.int(length(text)), text = text)


#devtools::install_github("pichaio/thainltk")
library(thainltk)
tt <- thaiTokenizer(skipSpace = T)

tokenize <- function(x){
  texts <- lapply(x, tt)
  tokens <- sapply(texts, function(k){
    paste(k, collapse=" ")
  })
  result <- gsub("”|“", "", tokens)
  return(result)
}


df$text <- tokenize(df$text)


date <- grep("^.*ราชกิจจานุเบกษา", text, value=T)


date[1]

