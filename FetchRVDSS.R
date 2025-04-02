#install.packages("httr")
library(httr)

headers <- "'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36'"
base_url <- "https://health-infobase.canada.ca/src/data/respiratory-virus-detections/"

url <- paste0(base_url, "RVD_WeeklyData.csv")

response <- httr::GET(url,add_headers(headers))
RVD_WeeklyData <- content(response, as = NULL, type = NULL, encoding = NULL)
RVD_WeeklyData$tests
