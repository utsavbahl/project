# Load libraries
library(tidyverse)
library(broom)
library(factoextra)
library(ggdendro)

# Load dataset
data <- read.csv("educationdataset.csv")
source("Collecting Relevant Data.R")
source("Cleaning up Data.R")
if (c("X") %in% names(clean_data)) {
clean_data <-   clean_data %>%
    select(-X)
}

# Set significance threshold for slopes
pcrit <- 0.05

# Group by school
coeffs <- clean_data %>%
  lm(Grad_Rate ~ Name+Name:year - 1, data = .) %>%
  tidy %>%
  filter(str_detect(term, "year")) %>%
  mutate(term = str_replace_all(term,"\\:year","")) %>%
  mutate(term = str_replace_all(term,"^Name","")) %>%
  rename(school = term, slope = estimate) %>%
  filter(p.value < pcrit)

# Explore the estimates we've computed
coeffs %>%
  ggplot(aes(x = slope)) +
  geom_histogram()

# Cluster schools based on slope
whichmethod <- hcut
hcmethod <- "complete"
clustering <- hclust(dist(coeffs$slope), method=hcmethod)
clustering$labels <- coeffs$school
ggdendrogram(clustering) +
  theme(axis.text.y = element_blank()) +
  ggtitle("Hierarchical Clustering of School Slopes")
whichclust <- cutree(clustering, h = 0.002)
coeffs$cluster <- as.factor(whichclust)
