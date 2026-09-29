library(stringr)
text2025 = readLines("raw_html/2025.html")
text2025 = text2025[-(1:1000)]
text2025 = paste(text2025, collapse = "\n")
text2025 = str_remove(text2025, ".*Panel u.*Panel u.*>")
text2025 = str_remove_all(text2025, "\t")
text2025_split = strsplit(text2025, "rank-")

