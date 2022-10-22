#Load Libraries
library(tidyverse)
library(data.table)

#Create TWFE
year_d <- clean_data$year <- factor(clean_data$year)
Name_d <- clean_data$Name <- factor(clean_data$Name)
#Note 1997 is the reference year

#Run Regression
coefficients <- clean_data[,as.list(coef(lm(Grad_Rate~year + Adm_Rate))), by=Name]
coefficients <- rename(coefficients, year_c = year) 


#Checking for Common Slopes
coefficient_distances <- order(clean_data)
coefficient_distances <- diff(clean_data$year_c, lag = 1, )
