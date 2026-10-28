library(stringr) #for regular expressions
library(magrittr) #for pipes
library(anytime) #for dates
library(lubridate) #for dates

#Take a year's raw html and split it into 100 chunks to be parsed,
# one for each birder
top100 = function(text) {
  #cut first 1000 lines
  text = text[-(1:1000)]
  #remove extra space
  text = paste(text, collapse = "\n")
  #get rid of all text leading up to the first useful chunk
  text = str_remove(text, ".*Panel u.*Panel u.*>")
  #remove all tabs
  text = str_remove_all(text, "\t")
  #split by a keyword into 100 chunks
  split_text = unlist(strsplit(text, "rank-"))
  return(split_text[2:length(split_text)])
}

#parse each HTML chunk from top100(text) and return
# a vector to become a dataframe row
parseLine = function(textfrag) {
  #grab rank
  rank=str_match(textfrag, ">(\\d*)\\.<")[2]
  #grab username
  name=str_match(textfrag, "h5 id=\"(.+)\" class")[2]
  #grab number of checklists
  checklists=str_match(textfrag, ">\\n\\n\\n(\\d+)\\n\\n<")[2]
  #grab number of species
  Nspecies=str_match(textfrag, "species[\\s\\S]*>\\n\\n\\n(\\d+)\\n\\n<")[2]
  #grab percentage of total species
  percentTotal=str_match(textfrag, "\n\n\n(\\d+\\.?\\d*)%")[2]
  #grab chunk pertaining to last new species:  common name, scientific name, genus, date, year
  temp = str_match(textfrag, 
      "ResultsStats-details-detail\">([A-Z][a-zA-Z '-]*) <em class=\"sci\">(([A-Z][a-z]*) [a-z-]*)</em> \\((.*(\\d\\d\\d\\d))\\)")
  commonName=temp[2]
  species=temp[3]
  genus=temp[4]
  date=temp[5]
  year=temp[6]
  #take date as days from start of year
  dayCt= ( ymd(anydate(date))-ymd(sprintf("%s-1-1", year)) ) %>% 
    as.double() + 1
  
  return( c(rank, name, checklists, Nspecies, percentTotal, commonName, species, genus, date, year, dayCt))
}

#take a single HTML file and previous two functions to make one df
rawToDF = function(text) {
  #blank df
  df = data.frame(matrix(ncol=11, nrow=0))
  #get the top100 chunks and parse them
  mmm=Map(parseLine, top100(text))
  #bind it all into the df
  for (row in mmm) {
    df = rbind(df, row)
  }
  colnames(df)= c("rank", "name", "Nchecklists", 
                "Nspecies", "percentTotal", "commonName", 
                "species", "genus", "date", "year", "dayCt")
  return(df)
}

#read all HTML files in this repo and make them into one df
clean = function() {
  #blank df
  df = data.frame(matrix(ncol=11, nrow=0))
  #grab each file and call rawToDF; bind it all together
  for (year in 2025:2016){
    df %<>% rbind(rawToDF(readLines(sprintf("raw_html/%d.html", year))))
  }
  return(df)
}


