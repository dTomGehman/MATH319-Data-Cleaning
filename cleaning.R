library(stringr)

rawtext = readLines("raw_html/2024.html")

top100 = function(text) {
  text = text[-(1:1000)]
  text = paste(text, collapse = "\n")
  text = str_remove(text, ".*Panel u.*Panel u.*>")
  text = str_remove_all(text, "\t")
  split_text = unlist(strsplit(text, "rank-"))
  return(split_text[2:length(split_text)])
}

top100(rawtext)
