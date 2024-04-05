
#https://rspatialdata.github.io/osm.html
#https://rforjournalists.com/2020/12/15/how-to-access-open-street-map-in-r/

## Paquetes
library(osmdata)
library(dplyr)
library(sf)
library(leaflet)

## Definir la extensión de la busqueda en OSM
cr_bb<- getbb("Costa Rica") 
location <- cr_bb %>%
  opq()

## Descargar la información de caminos, considerando varias claves.

cr_roads_primary <- location %>%
  add_osm_feature(key = "highway", value = "primary") %>%
  osmdata_sf()

cr_roads_secondary <- location %>%
  add_osm_feature(key = "highway", value = "secondary") %>%
  osmdata_sf()

cr_roads_tertiary <- location %>%
  add_osm_feature(key = "highway", value = "tertiary") %>%
  osmdata_sf()

cr_roads_residential <- location2 %>%
  add_osm_feature(key = "highway", value = "residential") %>%
  osmdata_sf()

cr_roads_unclassified <- location %>%
  add_osm_feature(key = "highway", value = "unclassified") %>%
  osmdata_sf()

cr_roads_path <- location %>%
  add_osm_feature(key = "highway", value = "path") %>%
  osmdata_sf()

## Crear objetos sf con solo las columnas de interés

roads1 <- cr_roads_primary$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads2<- cr_roads_secondary$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads3 <- cr_roads_tertiary$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads4 <- cr_roads_unclassified$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads5 <- cr_roads_path$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

roads6 <- cr_roads_residential$osm_lines[, c("osm_id", "name", "highway", "surface", "geometry")]

## unir objetos sf para tener una capa final

cr_roads <- rbind(roads1, roads2, roads3, roads4, roads5, roads6)%>%
  st_as_sf()

## guardar la capa final
st_write(cr_roads, "OSMCR_roads.shp")

## Simple visualización de la capa final con "leaflet"

map <- leaflet(cr_roads) %>%
  addTiles() %>%
  addPolylines(color = "green")
map

