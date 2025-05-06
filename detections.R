library(shellpipes)
rpcall("detections.Rout detections.R vnames.tsv rvdss_canada/data/season_2013_2014/respiratory_detections.csv rvdss_canada/data/season_2014_2015/respiratory_detections.csv rvdss_canada/data/season_2015_2016/respiratory_detections.csv rvdss_canada/data/season_2016_2017/respiratory_detections.csv rvdss_canada/data/season_2017_2018/respiratory_detections.csv rvdss_canada/data/season_2018_2019/respiratory_detections.csv rvdss_canada/data/season_2019_2020/respiratory_detections.csv rvdss_canada/data/season_2020_2021/respiratory_detections.csv rvdss_canada/data/season_2021_2022/respiratory_detections.csv rvdss_canada/data/season_2022_2023/respiratory_detections.csv rvdss_canada/data/season_2023_2024/respiratory_detections.csv rvdss_canada/data/season_2024_2025/respiratory_detections.csv")
manageConflicts()

library(purrr)
library(readr)
library(dplyr)

## Read in a list of files and make sure there are no readr “problems”
dl <- csvReadList(show_col_types=FALSE)
warn <- (map(dl, problems)
	|> bind_rows(.id="file")
)
## stopifnot(nrow(warn)==0)

## Give data _sets_ short names by flu year.
## A flu year goes from summer to summer is named after the later year
names(dl) <- sub(".*_[12][0-9]", "FY", names(dl))
names(dl) <- sub("/.*", "", names(dl))
print(names(dl))

## Collect and simplify names of data _fields_ using a weird corrections file
## Should we be using more standard “data dictionary” methods?
## Note that we are sequentially replacing, and that it seems a bit weird.
orig <- fields <- map(dl, names) |> unname() |> unlist() |> unique()
print(fields)
corr <- tsvRead(show_col_types=FALSE)
print(problems(corr))
for (r in 1:nrow(corr)){
	fields <- sub(corr[[r, "pat"]], corr[[r, "rep"]], fields)
}

tsvSave(data.frame(orig, fields) 
	|> filter(orig != fields)
	|> arrange(fields)
)

testFields <- grep("_tests", fields, value=TRUE)
## testFields <- sub("_tests", "", testFields)
posFields <- grep("_positive_tests", testFields, value=TRUE)
totFields <- setdiff(testFields, posFields)

posFields <- sub("_positive_tests", "", posFields)
pos <- posFields |> unique() |> sort()
tsvSave(data.frame(pos), ext="pos.Rout.tsv")

totFields <- sub("_tests", "", totFields)
tot <- totFields |> unique() |> sort()
tsvSave(data.frame(tot), ext="tot.Rout.tsv")

