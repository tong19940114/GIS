library(sf)
library(here)
library(tidyverse)
library(janitor)
library(dplyr)
library(maptools)
library(RColorBrewer)
library(classInt)
library(sp)
library(rgeos)
library(tmap)
library(tmaptools)
library(rgdal)
library(geojsonio)

worldmap <- st_read(here("Raw_Data",
             "World_Countries_(Generalized)",
             "World_Countries__Generalized_.shp"))

worldData<- read.csv(here::here("Raw_Data","Gender Inequality Index (GII)_edited.csv"), 
                         header = TRUE, sep = ",",  
                         encoding = "latin1",na="N/A")


worldData_10_19<- worldData %>% 
  dplyr::select(contains("HDI.Rank"), 
                contains("Country"),
                contains("2010"),
                contains("2019")) 


worldData_10_19$df <- as.numeric(worldData_10_19$X2010) - as.numeric(worldData_10_19$X2019)  

worldmap$COUNTRYAFF <- countrycode(worldmap$COUNTRYAFF, origin = "country.name", destination = "iso3c")

worldData_10_19$cowcodes <- worldData_10_19$Country
worldData_10_19$cowcodes <- countrycode(worldData_10_19$Country , origin = "country.name", destination = "iso3c")



Worlddf <- worldmap %>% 
left_join(., 
          worldData_10_19,
          by = c("COUNTRYAFF" = "cowcodes"))


library(tmap)
tmap_mode("plot")
Worlddf %>%
  qtm(.,fill = "df")

# no title shows, why
tm_layout(legend.position = c("left", "bottom"), 
          title= 'global gender inequality', 
          title.position = c('left', 'top'))

  
