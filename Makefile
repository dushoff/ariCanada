## This is ariCanada (play with data from RVDSS)

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt README.md"

######################################################################

Sources += $(wildcard *.R)

autopipeR = defined

## FetchRVDSS.Rout: FetchRVDSS.R

viewDat.Rout: viewDat.R FetchRVDSS.rds

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
