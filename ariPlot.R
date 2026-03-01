library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_classic(base_size=12))

library(shellpipes)
startGraphics(height=4, width=8)
loadEnvironments()

summary(dis)

dat <- (dis
	|> transmute(date, pathogen
		, cases=confirmations
		, `%Pos` = percentP
	)
	|> pivot_longer(-c(date, pathogen)
		, names_to="metric"
	)
)

summary(dat)

base <- (ggplot(dat)
	+ aes(date, value, color=pathogen)
	+ geom_line()
	+ facet_wrap(~metric, scales="free", nrow=1)
	+ scale_color_brewer(palette="Dark2")
	+ theme(legend.position = c(0.9, 0.8))
	## + theme(panel.grid.major = element_line())
	+ ylab("")
)
print(base)
## print(base + dat |> filter(metric=="%Pos"))

quit()

## print(base + scale_y_log10() + facet_wrap(~ pathogen, scales="free"))
## print(base + facet_wrap(~ pathogen, scales="free"))

print(base + scale_y_log10())
## summary(dis)

(base + scale_y_log10()
	+ geom_line(data=dis, aes(date, percentP), color="blue")
) -> combplot

print(combplot + (long |> filter(category=="confirmations"))
	+ ylab("Confirmations / %Pos")
)

