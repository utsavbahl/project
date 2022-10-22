#Load Libraries
library(tidyverse)

#Re-Naming Columns
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


#Select Relevant Data and Clean NULL
clean_data <- data %>%
  filter(Name %in% goodcolleges) 
clean_data[clean_data == "NULL"] <- NA




  
