#Load Packages
library(rJava)
library(tabulizer)
library(tidyverse)

#Create Table
optional_schools <- extract_tables(
  file = "PDF of Schools_Years.pdf",
  method = "decide",
  output = "data.frame"
)

earlier_adopters <- optional_schools %>%
  pluck(1) %>%
  as_tibble()


