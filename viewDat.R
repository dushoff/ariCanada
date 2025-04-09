library(shellpipes)
library(dplyr)

rdsRead() |> mutate_if(is.character, as.factor) |> summary()
