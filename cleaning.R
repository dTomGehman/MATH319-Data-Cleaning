library(stringr)
library(magrittr)

#rawtext = readLines("raw_html/2024.html")

top100 = function(text) {
  text = text[-(1:1000)]
  text = paste(text, collapse = "\n")
  text = str_remove(text, ".*Panel u.*Panel u.*>")
  text = str_remove_all(text, "\t")
  split_text = unlist(strsplit(text, "rank-"))
  return(split_text[2:length(split_text)])
}

#k=top100(rawtext)
#l=top100(readLines("raw_html/2023.html"))

parseLine = function(textfrag) {
  rank=str_match(textfrag, ">(\\d*)\\.<")[2]
  name=str_match(textfrag, "h5 id=\"([A-Za-z (&amp;),-]+)\" class")[2]
  checklists=str_match(textfrag, ">\\n\\n\\n(\\d+)\\n\\n<")[2]
  Nspecies=str_match(textfrag, "species[\\s\\S]*>\\n\\n\\n(\\d+)\\n\\n<")[2]
  percentTotal=str_match(textfrag, "\n\n\n(\\d+\\.?\\d*)%")[2]
  temp = str_match(textfrag, 
      "ResultsStats-details-detail\">([A-Z][a-zA-Z '-]*) <em class=\"sci\">(([A-Z][a-z]*) [a-z-]*)</em> \\((.*(\\d\\d\\d\\d))\\)")
  commonName=temp[2]
  species=temp[3]
  genus=temp[4]
  date=temp[5]
  year=temp[6]
  
  return( c(rank, name, checklists, Nspecies, percentTotal, commonName, species, genus, date, year))
}

rawToDF = function(text) {
  df = data.frame(matrix(ncol=10, nrow=0))
  mmm=Map(parseLine, top100(text))
  for (row in mmm) {
    df = rbind(df, row)
  }
  colnames(df)= c("rank", "name", "Nchecklists", 
                "Nspecies", "percentTotal", "commonName", 
                "species", "genus", "date", "year")
  return(df)
}


df = data.frame(matrix(ncol=10, nrow=0))
for (year in 2025:2016){
  df %<>% rbind(rawToDF(readLines(sprintf("raw_html/%d.html", year))))
}

#the df is too big to print, 
#but this sampling gives you an idea of what it contains.  
df[sample(nrow(df), 20), ]

