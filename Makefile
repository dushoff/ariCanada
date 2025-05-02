## This is ariCanada (play with data from RVDSS)

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt README.md"

######################################################################

## Link the Canada surveillance data
## Sources += rvdss.md ## Still at old home
Ignore += rvdss_canada
rvdss_canada.update: | rvdss_canada
	cd $| && git pull
rvdss_canada:
	git clone https://github.com/dajmcdon/rvdss-canada $@
rvdss_canada/data/%: | rvdss_canada ;

######################################################################

## Describe the respiratory_detections files
Sources += vnames.tsv
## detections.Rout.tsv: detections.R  vnames.tsv
## detections.tot.Rout.tsv: detections.R  vnames.tsv
## detections.pos.Rout.tsv: detections.R  vnames.tsv
detections.Rout: detections.R vnames.tsv
	$(pipeR)
detections.Rout: $(wildcard rvdss_canada/data/season*/respiratory_detections.csv)

## Some notes
Sources += rvdss.md

######################################################################

## Not touched since MD Brin talk.

## We have 12 years of two major things plus hcov; only 1.5 years of sars afaict

Ignore += detections.csv
## Can't easily be processed together bc pdm09 stuff changes (maybe other stuff as well)
detections.csv: rvdss_canada rvdss_canada/data
	cat $</data/season*/respiratory_detections.csv > $@

## Playing around only (2024 flu year is over) 
lastYear.Rout: lastYear.R rvdss_canada/data/*_*_2024/respiratory_detections.csv
	$(pipeR)

lastYear.plots.Rout: firstplot.R lastYear.rds
	$(pipeR)

## For years with sarscov2 (flu years 2023 and 2024; 2025 has a different name)
## 2023.fourpath.Rout: fourpath.R
## Getting very hacky! Some years don't have the flu total...
impmakeR += fourpath
%.fourpath.Rout: fourpath.R rvdss_canada/data/*_*_%/respiratory_detections.csv
	$(pipeR)

impmakeR += twopath
## 2014.twopath.Rout: twopath.R
%.twopath.Rout: twopath.R rvdss_canada/data/*_*_%/respiratory_detections.csv
	$(pipeR)

impmakeR += firstplot
## 2024.fourpath.firstplot.Rout: firstplot.R
## 2023.fourpath.firstplot.Rout: firstplot.R
## 2014.twopath.firstplot.Rout: firstplot.R twopath.R
%.firstplot.Rout: firstplot.R %.rda
	$(pipeR)

impmakeR += secondplot
## 2024.fourpath.secondplot.Rout: secondplot.R
## 2023.fourpath.secondplot.Rout: secondplot.R
## 2014.twopath.secondplot.Rout: secondplot.R twopath.R
%.secondplot.Rout: secondplot.R %.rda
	$(pipeR)

rvdssYears = 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024
rvdssBrin = $(rvdssYears:%=%.twopath.firstplot.Rout.pdf)
Ignore += rvdssBrin.pdf
rvdssBrin.pdf: $(rvdssBrin)
	$(pdfcat)

brin.Rout: brin.R 2014.twopath.R

######################################################################

## Trying to fetch on our own
Sources += $(wildcard *.R)

autopipeR = defined

## FetchRVDSS.Rout: FetchRVDSS.R

viewDat.Rout: viewDat.R FetchRVDSS.rds

######################################################################

iscr = detections.R firstplot.R fourpath.R lastYear.R secondplot.R twopath.R
iscr:
	cd ../betaTesting && mv $(iscr) $(CURDIR)

######################################################################

### Makestuff

Sources += Makefile README.md

Ignore += makestuff
msrepo = https://github.com/dushoff

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Makefile: makestuff/00.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/gitbranch.mk
-include makestuff/visual.mk
