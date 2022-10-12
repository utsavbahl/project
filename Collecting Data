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

# Check year by year to see NA percentage of first data column (OMAWDP6_FTFT)
nullcheck <- data %>%
  group_by(year) %>%
  summarize(nullprob_grad = sum(C150_4 == "NULL")/n(), nullprob_black = sum(C150_4_BLACK == "NULL")/n())

#Calling Libraries
library(tidyverse)
library(rvest)


#Define URL
fisk_URL <- read_html("https://support.collegeplannerpro.com/hc/en-us/articles/115001731071-Which-schools-are-covered-by-the-Fiske-Guide-")

#Scrape Data
Fiskcolleges <- fisk_URL %>%
  html_nodes("td") %>%
  html_text

#Make into Data Set
Fiskcolleges <- as.data.frame(Fiskcolleges)
colnames(Fiskcolleges)[1] = "INSTNM"

#Table of Colleges in the Original Data
colleges <- data %>%
  select(INSTNM)

#Compare Colleges
library(fuzzyjoin)
library(dplyr)
Samecolleges <- stringdist_join(Fiskcolleges, colleges,
                by = 'INSTNM',
                mode = 'left',
                method = "jw",
                max_dist = 0.08)
Samecolleges <- unique(Samecolleges)

#Select Good Colleges
goodcolleges <- Samecolleges %>%
  filter(INSTNM.x == INSTNM.y) %>%
  pull(INSTNM.y)

#Check for NULLs
nullcheck2 <- data %>%
  filter(INSTNM %in% goodcolleges) %>%
  group_by(INSTNM, year) %>%
  summarize(nullprob_grad = sum(C150_4 == "NULL")/n(), nullprob_black = sum(C150_4_BLACK == "NULL")/n(), nullprob_black_before = sum(C150_4_BLACKNH == "NULL")/n()) %>%
  filter(nullprob_black == 0) %>%
  group_by(year) %>%
  filter(row_number() == 1)

nullcheck3 <- data %>%
  filter(INSTNM %in% goodcolleges) %>%
  group_by(year) %>%
  summarize(probpre2010 = sum(C150_4_BLACKNH == "NULL")/n())
