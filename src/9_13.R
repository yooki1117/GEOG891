library(tidyverse)
rainfall <- c(0.0, 2.1, 2.5, .1, 0.0, 0.0, 6.8, 3.1, 2.2)
rainfall[1]
f.storm.test <- function(rainfallAmount){
  if (rainfallAmount >= 3){
  print("Big Storm")
} else {
  print ("Little Storm")
  }
}
for(i in rainfall){
  f.storm.test(i)
}
rainfall %>% purrr::map(., f.storm.test)
rainfall >= 3
max(rainfall)
which(rainfall == max(rainfall))

mydf <- read_csv("./data/ne_counties.csv")
glimpse(mydf)
max(mydf$MedValHous)
which(mydf$MedValHous == max(mydf$MedValHous))
which(mydf$MedValHous == max(mydf$MedValHous)) %>% mydf[.,]

newdf <- mydf %>% mutate(deviation = MedValHous - max(MedValHous))
newdf
newdf %>% ggplot(., aes(x = deviation)) +
  geom_histogram() +
  theme_minimal()

