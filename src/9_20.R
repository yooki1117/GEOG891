library(tidyverse)
library(GISTools)
data(tornados)
library(tmap)
library(sf)
library(sp)

streams <- sf::read_sf("./data/Streams_303_d_.shp")
tm_shape(streams) + tm_lines()

counties <- sf::read_sf("./data/County_Boundaries-_Census.shp")
counties_areas <- sf::st_area(counties)

x <- counties%>%mutate(myArea = st_area(.))
lc <- counties %>% dplyr::filter(., NAME10 == "Lancaster")

lc_303ds <- sf::st_intersection(streams, lc)

tm_shape(lc_303ds) + tm_lines()
tm_shape(lc_303ds) + tm_lines(col = "blue")
tm_shape(lc_303ds) + tm_lines(col = "Waterbody_")

buffs <- sf::st_buffer(lc_303ds, dist = 1000)
tm_shape(buffs) + tm_polygons(col = "Waterbody_")

parks <- sf::read_sf("./data/State_Park_Locations.shp")
lc_parks <- sf::st_intersection(lc, parks)
tm_shape(lc_parks) + tm_dots(col = "AreaName", size = "Acres")

tm_shape(lc_303ds) + tm_lines(col = "Waterbody_") +
  tm_shape(lc_parks) + tm_dots(col = "AreaName", size = 1)


buffstream <- sf::st_buffer(lc_303ds, dist = 804.6) ##0.5mile = 804.6...
intersect_parks <- sf::st_intersection(lc_parks, buffstream)
filpoint <- intersect_parks %>% dplyr::filter(., AreaName == "Branched Oak SRA")
filline <- lc_303ds %>% dplyr::filter(., Waterbody_ == "Middle Oak Creek" | Waterbody_ == "Oak Creek")
tm_shape(filline) + tm_lines(col = "Waterbody_", scale = 1) + 
  tm_shape(intersect_parks) + tm_dots(col = "AreaName", size = 1)


torn_sf <- st_as_sf(torn)
us_states_sf <- st_as_sf(us_states)
tm_shape(us_states_sf)+tm_polygons("grey90")+
tm_shape(torn_sf)+tm_dots(col = "red", size = 0.04, shape = 1, alpha =0.5)+
  tm_shape(us_states_sf)+tm_borders(col="black")+tm_layout(frame = F)

counties %>% as_Spatial() %>% poly.areas()
parks_p <- sf::st_transform(parks, 26914)
counties_p <- sf::st_transform(counties, 26914)

counties %>% as_Spatial() %>% poly.areas()
counties %>% sf::st_transform(., 26914) %>% sf::st_area()

lc_303ds_p <- sf::st_transform(lc_303ds, 26914)
lc_parks_p <- sf::st_transform(lc_parks, 26914)

proj <- sf::st_distance(lc_303ds_p, lc_parks_p)
unproj <- sf::st_distance(lc_303ds, lc_parks)
proj
unproj
diff_1 <- proj-unproj
hist(diff_1)


##9/23

require(GISTools)
require(tmap)
data(newhaven)
tmap_mode('view')
tmap_options(check.and.fix = TRUE)
tm_shape(blocks) + tm_borders() + tm_shape(breach) + tm_dots(col='navyblue')

choose_bw <- function(spdf) {
  X <- coordinates(spdf)
  sigma <- c(sd(X[,1]), sd(X[,2])) * (2/(3*nrow(X)))^(1/6)
  return(sigma)
}

packageurl <- "https://cran.rstudio.com/bin/windows/contrib/3.2/tmap_1.4-1.zip"
install.packages(packageurl, repos=NULL, type="source")
library(tmaptools)
tmap_mode('view')
breach_dens <- smooth_map(breach, cover = blocks, bandwidth = choose_bw(breach))
tm_shape(breach_dens$raster) +tm_raster()
?tmap
