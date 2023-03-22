# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tibble", "tidyverse", "here", "sf", "mapview", "gauntlet"
               ,"arcpullr", "leaflet", "leaflet.extras", "leaflet.extras2"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multiprocess")

# tar_make_future() configuration (okay to leave alone):
future::plan(future.callr::callr)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  #get_arc_data====
  tar_target(file_projects_spatial, here("data/project_locations_buffer.gpkg"), format = "file")
  ,tar_target(file_projects_spatial_union, here("data/project_locations_buffer_union.gpkg"), format = "file")
  ,tar_target(spatial_wetland, here("data/manual_wetland_extract_sm.gpkg"), format = "file")
  ,tar_target(spatial_truckflow,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/160"
              ))
  ,tar_target(spatial_highroute,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/139"
              ))
  ,tar_target(spatial_adaramps,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/129"
              ))
  ,tar_target(spatial_adacorners,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/131"
              ))
  ,tar_target(spatial_xwalk,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/307"
              ))
  ,tar_target(spatial_xwalk_ada,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/308"
              ))
  ,tar_target(spatial_sidewalk,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/132"
              ))
  ,tar_target(spatial_bike,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/136"
              ))
  ,tar_target(spatial_parknride,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/148"
              ))
  ,tar_target(spatial_transitstops,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/151"
              ))
  ,tar_target(spatial_socialequity,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/328"
              ))
  ,tar_target(spatial_fishbarriers,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/214"
              ))
  ,tar_target(spatial_fishpassage,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/215"
              ))
  ,tar_target(spatial_animalden,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/313"
              ))
  ,tar_target(spatial_resilience,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/344"
              ))
  ,tar_target(spatial_multirisk,
              query_and_filter_gis_layers(
                geo_file = file_projects_spatial_union
                ,arc_url = "https://gis.odot.state.or.us/arcgis1006/rest/services/transgis/catalog/MapServer/329"
              ))
  #crash_targets====
  ,tar_target(file_manual_crash, here("data/data_crash/odot_database_manual/data_list_subset.csv"), format = "file")
  ,tar_target(file_old_crash_attr, here::here("data/KBell_HV_ClackMultWash_2016_2020_20220519.xlsx"), format = "file")
  ,tar_target(spatial_crash, process_raw_crash(data_list_subset = file_manual_crash
                                               ,crash_attr = file_old_crash_attr))
  #map_targets=====
  ,tar_target(map_environ, make_map_environ())
  ,tar_target(map_transportation, make_map_transportation())
)



