
## detections.Rout.tsv shows the things that my scripts suggest renaming; it should be empty now 2025 May 02 (Fri)
## detections.tot.Rout.tsv shows the things I pull out as denominators
## detections.pos.Rout.tsv shows the things I pull out as cases. It is currently missing non-pandemic h1n1.

----------------------------------------------------------------------

Copied over 2025 May 02 (Fri)

It looks like respiratory_detections is the up-to-date file for each year and covers all of the info we need. It seems to have redundant tabulation, but not checked.

It's not clear how best to line things up. The current code provides clean names (makes synonymous names the same). Would be good to simplify the base names and make code that sums over types of the 8 viruses and matches numerators to denominators


