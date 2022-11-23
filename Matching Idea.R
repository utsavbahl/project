#Load Libraries
library(MatchIt)
library(tidyverse)
library(data.table)
library(rvest)
library(fuzzyjoin)
library(dplyr)
library(did2s)

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
#How do we solve for this issue? Convert all data in terms of matriculation
data <- data %>%
  mutate(year_g = year - 6)
tmp <- data %>%
  select(Name, Adm_Rate, Avg_Price_Pub, Avg_Price_Priv, year)
tmp2 <- data %>%
  select(-Adm_Rate, -Avg_Price_Pub, -Avg_Price_Priv, -year, year_g)
data <- merge(tmp, tmp2, by.x = c("Name","year"), by.y = c("Name","year_g"))

#Enter Test-Optional Years
optional_years <- optional_years %>%
 mutate(year = substr(year, 1,4)) 
optional_years$year = as.integer(optional_years$year)
optional_years <- optional_years %>%
  mutate (year = year + 1)
optional_years <- optional_years %>%
  filter(year >= 1997)
optional_years <- optional_years %>%
  rename(Name = Institution.Name,
         yeartreat = year) 
optional_years <- optional_years %>%
  subset(select = -c(Description))
data <- merge(x = data, y = optional_years, by = "Name", all.x = TRUE)
t2 <- data %>%
  subset(year >= yeartreat) %>%
  mutate(post = 1) %>%
  select(Name, year, post)
t2 <- merge(x = data, y = t1, by = c("Name", "year"), all.x = TRUE)
t2$post[is.na(t2$post)] = 0
data <- t2

#Further Cleaning of Data
data$Grad_Rate <- as.numeric(data$Grad_Rate)

data$Grad_White <- paste(data$Grad_White, data$Grad_White_2010, sep = "")
data$Grad_White <- gsub("NA", "", data$Grad_White)
data$Grad_White <- as.numeric(data$Grad_White)

data$Grad_Black <- paste(data$Grad_Black, data$Grad_Black_2010, sep = "")
data$Grad_Black <- gsub("NA", "", data$Grad_Black)
data$Grad_Black <- as.numeric(data$Grad_Black)

data$Grad_Asian <- paste(data$Grad_Asian, data$Grad_Asian_2010, sep = "")
data$Grad_Asian <- gsub("NA", "", data$Grad_Asian)
data$Grad_Asian <- as.numeric(data$Grad_Asian)



data <- read_csv("dataset.csv")
data <- data[,-1]
    
  

