
#https://rspatialdata.github.io/osm.html
#https://rforjournalists.com/2020/12/15/how-to-access-open-street-map-in-r/

library(osmdata)
library(dplyr)
library(sf)
library(ggplot2)
library(leaflet)



cr_bb<- getbb("Costa Rica") 

#coords <- matrix(c(-85.9417, 8.2250, -82.5461, 11.2171), byrow = TRUE, nrow = 2, ncol = 2, dimnames = list(c('x','y'),c('min','max'))) 
#location <- coords %>% opq()


location2 <- cr_bb %>%
  opq()

#available_features()


cr_roads_primary <- location2 %>%
  add_osm_feature(key = "highway", value = "primary") %>%
  osmdata_sf()

cr_roads_secondary <- location2 %>%
  add_osm_feature(key = "highway", value = "secondary") %>%
  osmdata_sf()

cr_roads_tertiary <- location2 %>%
  add_osm_feature(key = "highway", value = "tertiary") %>%
  osmdata_sf()

cr_roads_residential <- location2 %>%
  add_osm_feature(key = "highway", value = "residential") %>%
  osmdata_sf()


cr_roads_unclassified <- location2 %>%
  add_osm_feature(key = "highway", value = "unclassified") %>%
  osmdata_sf()

cr_roads_path <- location2 %>%
  add_osm_feature(key = "highway", value = "path") %>%
  osmdata_sf()

CR_Unclassified <- cr_roads_unclassified$osm_lines

p <- leaflet(cr_roads_path$osm_lines) %>%
  addTiles() %>%
  addPolylines(color = "green")
p

roads1 <- cr_roads_primary$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]


roads2<- cr_roads_secondary$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads3 <- cr_roads_tertiary$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads4 <- cr_roads_unclassified$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]



roads5 <- cr_roads_path$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads6 <- cr_roads_residential$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]


cr_roads <- rbind(roads1, roads2, roads3, roads4, roads5, roads6)%>%
  st_as_sf()

st_write(cr_roads, "OSMCR_roads.shp")


p2 <- leaflet(cr_roads_residential$osm_lines) %>%
  addTiles() %>%
  addPolylines(color = "blue")
p2

p3 <- leaflet(cr_roads) %>%
  addTiles() %>%
  addPolylines(color = "green")
p3

