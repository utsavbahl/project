#Load Libraries
library(did2s)

#Simple TWFE Analysis with DiD Estimate
did2s(
  data = data,
  yname = "Grad_Aian",
  first_stage = ~ 0 | Name + year,
  second_stage = ~ i(post, ref=0),
  treatment = "post",
  cluster_var = "Name"
)


