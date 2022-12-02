#Load Libraries
library(did2s)
library(fixest)

#Simple TWFE Analysis with DiD Estimate
static <- did2s(
  data = data,
  yname = "Grad_Rate",
  first_stage = ~ 0 | Name + year,
  second_stage = ~ i(post, ref=FALSE),
  treatment = "post",
  cluster_var = "Name"
)

#Event-Study
fixest::iplot(esti, main = "Event study: Staggered treatment", xlab = "Relative time to treatment", col = "steelblue", ref.line = -0.5)

#Create Reference
data <- data %>%
  mutate(reference = yeartreat - 1997)
  
event = event_study(
  data = data,
  yname = "Grad_Rate",
  idname = "Name",
  gname = "yeartreat",
  tname = "year",
  xformla = NULL,
  weights = NULL,
  estimator = c("all")
)
plot_event_study(event, horizon = c(-5,10))



