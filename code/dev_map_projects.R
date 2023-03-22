
library(tidyverse)
library(sf)
library(mapview)
library(gauntlet)
library(here)
library(targets)

#load all data targets==========================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tar_load(spatial_highroute)
tar_load(spatial_adacorners)
tar_load(spatial_adaramps)
tar_load(spatial_bike)
tar_load(spatial_sidewalk)
tar_load(spatial_socialequity)
tar_load(spatial_transitstops)
tar_load(spatial_truckflow)
tar_load(spatial_xwalk)
tar_load(spatial_xwalk_ada)
tar_load(spatial_parknride)
tar_load(file_projects_spatial)
tar_load(spatial_fishbarriers)
tar_load(spatial_fishpassage)
tar_load(spatial_animalden)
tar_load(spatial_resilience)
tar_load(spatial_multirisk)
tar_load(spatial_crash)
tar_load(spatial_wetland)
project_locations = file_projects_spatial %>%
  read_sf() %>%
  st_transform(4326) %>%
  quick_buffer(rad = -500)

#perfrom additional processing==================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#transportation related
{
spatial_xwalk = spatial_xwalk %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B155AEA5E-5E48-4232-ABE1-805F25822FD6%7D"> Link to TransGis Description </a>')
spatial_xwalk_ada = spatial_xwalk_ada %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7BC9B38381-C38B-4A17-AB66-39DF589B789B%7D"> Link to TransGis Description </a>')
spatial_adaramps = spatial_adaramps %>%
  rename_with(~str_remove(.x, "ada2_curb_ramp.")) %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B6D6A7062-34AE-4E7F-9B17-FD4D9A4C6318%7D"> Link to TransGis Description </a>')
spatial_adacorners = spatial_adacorners %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B7B039BB4-78D4-4C42-98FC-7B3232EE3EBE%7D"> Link to TransGis Description </a>')
spatial_bike = spatial_bike  %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B22C6BB0B-57C6-4FBD-AE15-C3458E600A61%7D"> Link to TransGis Description </a>')
spatial_sidewalk = spatial_sidewalk %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7BDB6B03B9-029D-42E0-96ED-10E130B56F42%7D"> Link to TransGis Description </a>')
spatial_transitstops = spatial_transitstops %>%
  mutate(url = 'NA')
spatial_truckflow = spatial_truckflow %>%
  mutate(url = 'NA') %>%
  select(!starts_with("CLASS"))
spatial_socialequity = spatial_socialequity %>%
  mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B5A2D861F-FB41-428C-B80C-6A679F53DA81%7D"> Link to TransGis Description </a>')
spatial_parknride = spatial_parknride %>%
  mutate(url = 'NA')
spatial_crash = spatial_crash %>%
  mutate(url = 'NA') %>%
  st_filter(project_locations) %>%
  st_jitter(.00005)
}

#environment focused
{
  spatial_fishbarriers = spatial_fishbarriers %>%
    mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B22B9E8F3-C90E-4BF7-B782-CA5F4A66A036%7D"> Link to TransGis Description </a>')
  spatial_fishpassage = spatial_fishpassage %>%
    mutate(url = 'NA')
  spatial_animalden = spatial_animalden %>%
    mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B5343AF4A-59FC-4D9F-8BE6-A6779C0AF939%7D"> Link to TransGis Description </a>')
  spatial_resilience = spatial_resilience %>%
    mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7B12A3BB04-F1E5-40C6-9EE1-9EFFFF2A7940%7D"> Link to TransGis Description </a>')
  spatial_multirisk = spatial_multirisk %>%
    mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7BB7B3539B-48A6-45D2-82E2-8E3F9803178F%7D"> Link to TransGis Description </a>')
  spatial_wetland = spatial_wetland %>%
    read_sf() %>%
    mutate(url = '<a href = "https://geoportalprod-ordot.msappproxy.net/geoportal/catalog/search/resource/details.page?uuid=%7BA4AACAFB-0B85-4501-B640-31D3A646A0DF%7D"> Link to TransGis Description </a>')
}

#map============================================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  mapview(spatial_sidewalk, zcol = "NEED_IND", lwd = 3, homebutton = F, label = "Sidewalk", layer.name = "Sidewalk")  +
    mapview(spatial_xwalk, homebutton = F, label = "Crosswalks", layer.name = "Crosswalks") +
    mapview(spatial_xwalk_ada, homebutton = F, label = "Crosswalks ADA", layer.name = "Crosswalks ADA") +
    mapview(spatial_adacorners, zcol = "A1_TYP_DS", homebutton = F, label = "ADA Corners", layer.name = "ADA Corners") +
    mapview(spatial_adaramps, zcol = "A2_FNCNDDS", homebutton = F, label = "ADA Ramps", layer.name = "ADA Ramps") +
    mapview(spatial_bike, zcol = "TYP_CD", homebutton = F, lwd = 3, label = "Bike Facilites", layer.name = "Bike Facilites") +
    mapview(spatial_transitstops, homebutton = F, col.regions = "orange", label = "Transit Stops", layer.name = "Transit Stops")  +
    mapview(spatial_parknride, homebutton = F, col.regions = "green", label = "LOT_NM", layer.name = "Park and Rides")  +
    mapview(spatial_truckflow, zcol = "TRK_AADT", lwd = 3, homebutton = F, layer.name = "Truck Flow")  +
    mapview(spatial_socialequity, zcol = "Category", homebutton = F, layer.name = "Social Equity Index") +
    mapview(spatial_crash, homebutton = F, label = "label", layer.name = "Truck Inv. Crashes") +
    mapview(project_locations, homebutton = F, col.regions = "green", color = "black", lwd = 2, alpha.regions = .2, label = "Project Location", layer.name = "Project Locations")
}

{
  mapview(spatial_fishbarriers, homebutton = F, label = "Fish Barriers", layer.name = "Fish Barriers")  +
    mapview(spatial_fishpassage, homebutton = F, label = "Fish Passages", layer.name = "Fish Passages") +
    mapview(spatial_resilience, homebutton = F, zcol = "TIER", lwd = 3, label = "Resilience", layer.name = "Resilience Corridor") +
    mapview(spatial_multirisk, homebutton = F, zcol = "Climate Risk", lwd = 3, layer.name = "Climate Risk") +
    mapview(spatial_wetland, homebutton = F, label = "Wetlands", layer.name = "Wetlands")
}





















