#Load Libraries
library(MatchIt)
library(tidyverse)
library(data.table)
library(rvest)
library(fuzzyjoin)
library(dplyr)

#Load Relevant Data
data <- read.csv("educationdataset.csv")
optional_years <- read.csv("optionalschoolsandyears.csv")
optional_years <- optional_years %>%
  subset(select = -c(X))
data <- data %>%
  subset(select = -c(X))

#Run Relevant Code
fisk_URL <- read_html("https://support.collegeplannerpro.com/hc/en-us/articles/115001731071-Which-schools-are-covered-by-the-Fiske-Guide-")

Fiskcolleges <- fisk_URL %>%
  html_nodes("td") %>%
  html_text

Fiskcolleges <- as.data.frame(Fiskcolleges)
colnames(Fiskcolleges)[1] = "INSTNM"

colleges <- data %>%
  select(INSTNM)

Samecolleges <- stringdist_join(Fiskcolleges, colleges,
                                by = 'INSTNM',
                                mode = 'left',
                                method = "jw",
                                max_dist = 0.08)
Samecolleges <- unique(Samecolleges)

goodcolleges <- Samecolleges %>%
  filter(INSTNM.x == INSTNM.y) %>%
  pull(INSTNM.y)

data <- data %>%
  filter(INSTNM %in% goodcolleges) 
data[data == "NULL"] <- NA

data <- data %>%
  rename(Grad_Rate = C150_4,
         Name = INSTNM,
         Grad_White = C150_4_WHITE,
         Grad_Black = C150_4_BLACK,
         Grad_Asian = C150_4_ASIAN,
         Grad_Hispanic = C150_4_HISP,
         Grad_Aian = C150_4_AIAN,
         Adm_Rate = ADM_RATE,
         Avg_Price_Pub = NPT4_PUB,
         Avg_Price_Priv = NPT4_PRIV,
         Grad_White_2010 = C150_4_WHITENH,
         Grad_Black_2010 = C150_4_BLACKNH,
         Grad_Asian_2010 = C150_4_API,
         Grad_Hispanic_2010 = C150_4_HISPOLD,
         Grad_Aian_2010 = C150_4_AIANOLD) 
data <- data %>%
  subset(select = -c(OMAWDP6_FTFT))

#Bring in Years Schools Went Test-Optional
#Because treatment has to be the same across all units, otherwise we are violating a key SUTVA assumption, I will now remove all units which did not go fully test-optional
optional_years <- optional_years %>%
  filter(Description == "Test-optional")

#The graduation rate is for the class of N-6 years. So, the row for 1997 will show the characteristics of the school in 1997 + the graduation rate of the class of 1991.
#How do we solve for this issue?
data <- data %>%
  mutate(year_g = year - 6)

#Ok I want the grad_rate for 1991 to be with its 1991 class information
#I also want that 

Maybethis <- data %>%
  group_by(Name, year) %>%
  mutate(Adm_Rate=lag(Adm_Rate, n = 6L))
#Not sure how to do this

