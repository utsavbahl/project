# Load libraries
library(tidyverse)
library(data.table)

# Define names of columns to keep
keeps <- c("INSTNM", "C150_4", "OMAWDP6_FTFT", "C150_4_WHITE", "C150_4_BLACK", "C150_4_ASIAN", "C150_4_HISP", "C150_4_AIAN", "ADM_RATE", "NPT4_PUB", "NPT4_PRIV", "C150_4_WHITENH", "C150_4_BLACKNH", "C150_4_API", "C150_4_HISPOLD", "C150_4_AIANOLD")

# Define a helper data structure to keep track of years/names of files
yearone <- 1996:2019
yeartwo <- 1997:2020
files <- paste0("MERGED",yearone,"_",substr(yeartwo,3,4),"_PP.csv")
files <- paste0("Education Dataset Indep Study/",files)

# Define function to read one file
loadFile <- function(i){
  data <- fread(files[i], select = keeps)
  data <- data %>%
    mutate(year = yeartwo[i])
  return(data)
}

# Apply to each file
data <- lapply(1:length(files), loadFile) %>%
  bind_rows()

#Export and Save Data
write.csv(data, "educationdataset.csv")
