# Load libraries
library(tidyverse)
library(data.table)

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
