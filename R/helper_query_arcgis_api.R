
query_and_filter_gis_layers = function(arc_url, geo_file){
  temp_geometry = sf::read_sf(geo_file) %>%
    st_transform(4326) #%>%
  # quick_buffer(radius = -500)

  temp_query_data = arcpullr::get_spatial_layer(
    url = arc_url) %>%
    st_make_valid() %>%
    st_filter(temp_geometry)
}
























