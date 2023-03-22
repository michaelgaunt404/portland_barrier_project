


library(targets)
library(tarchetypes)
library(gauntlet)

packages = c("tibble", "tidyverse", "here", "sf", "mapview", "gauntlet"
               ,"arcpullr", "leaflet", "leaflet.extras", "leaflet.extras2")

gauntlet::package_load(packages)

map_environ = make_map_environ()

map_transportation = make_map_transportation()
