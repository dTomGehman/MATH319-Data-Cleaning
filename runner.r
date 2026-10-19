library(tidyverse)

source("./cleaning.R")
df = clean()

#the df is too big to print, 
#but this sampling gives you an idea of what it contains.  
df[sample(nrow(df), 20), ]


#An example table that can be formed from the data:  
#In the last 10 years, which people/years have had the greatest shares of
#  all birds observed for that year?  
#That is the percentTotal:  of the species the whole community has observed, 
#  what proportion has each person observed?  
tib = tibble(df)
tib2 = tib %>% arrange(desc(percentTotal)) %>% head(n=30) %>%
  select(-c(Nchecklists, commonName, species, genus, date)) %>%
  mutate(allSpecies = round(as.integer(Nspecies) * 100 / as.double(percentTotal)))
print(tib2, n=30)

