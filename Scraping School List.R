#Load Packages
library(rJava)
library(tabulizer)
library(tidyverse)

#Collate Table Locations
coordinates_of_tables <- list(
  c(100, 72, 715, 541),
  c(75, 72, 725, 541),
  c(75, 72, 725, 541),
  c(75, 72, 194.5, 541)
)

#Extract Tables
optional_years <- extract_tables(
  file   = "PDF of Schools_Years.pdf", 
  pages = 1:4,
  area = coordinates_of_tables,
  guess = FALSE,
  method = "decide", 
  output = "data.frame")

#Collect Relevant Data
optional_years1 <- optional_years %>%
  pluck(1) %>%
  as_tibble()

optional_years2 <- optional_years %>%
  pluck(2) %>%
  as_tibble()

optional_years3 <- optional_years %>%
  pluck(3) %>%
  as_tibble()

optional_years4 <- optional_years %>%
  pluck(4) %>%
  as_tibble()

#Merge Data
optional_schools <- rbind(optional_years1, optional_years2, optional_years3, optional_years4)

#Clean Up
optional_schools <- optional_schools %>%
  subset(select = -c(State)) %>%
  rename(year = First.Year) 
#mutate() imagine I want to like add the 19 + last two digits for year, how does one do so???