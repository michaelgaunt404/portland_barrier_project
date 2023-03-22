
process_raw_crash = function(data_list_subset, crash_attr){

  crash = readxl::read_excel(crash_attr)

  index_vchl_event = bind_rows(
    crash %>%
      select(starts_with("VHCL_EVNT_1")) %>%
      unique() %>%
      rename_with(~str_remove_all(.x, "_1"))
    ,crash %>%
      select(starts_with("VHCL_EVNT_2")) %>%
      unique() %>%
      rename_with(~str_remove_all(.x, "_2"))
    ,crash %>%
      select(starts_with("VHCL_EVNT_3")) %>%
      unique() %>%
      rename_with(~str_remove_all(.x, "_3"))
  ) %>%
    unique()

  index_crash_cause = bind_rows(
    crash %>%
      select(starts_with("CRASH_CAUSE_1")) %>%
      unique() %>%
      rename_with(~str_remove_all(.x, "_1")) %>%
      mutate(across(everything(), as.character))
    ,crash %>%
      select(starts_with("CRASH_CAUSE_2")) %>%
      unique() %>%
      rename_with(~str_remove_all(.x, "_2")) %>%
      mutate(across(everything(), as.character))
    ,crash %>%
      select(starts_with("CRASH_CAUSE_3")) %>%
      unique() %>%
      rename_with(~str_remove_all(.x, "_3")) %>%
      mutate(across(everything(), as.character))
  ) %>%
    unique()

  index_vchl_cause = crash %>%
    select(starts_with("VHCL_CAUSE_1")) %>%
    unique()

  index_mvmnt = crash %>%
    select(starts_with("MVMNT_")) %>%
    unique()

  index_collision_type = crash %>%
    select(starts_with("COLLIS_TYP")) %>%
    unique()

  index_crash_severity =  crash %>%
    select(starts_with("CRASH_SVRTY")) %>%
    unique()


  data_list_subset = data_list_subset %>%
    read.csv()

  data_list_subset_pro = data_list_subset %>%
    # filter(record_type == 1) %>%
    select(crash_id, record_type, route_number, route_type
           ,collision_type, crash_severity
           ,vehicle_type_code
           ,total_vehicle_count, crash_year, highway_number, highway_suffix
           ,starts_with("crash_level_cause_1"), starts_with("collision_type"), starts_with("vehicle_movement_code")
           ,starts_with("vehicle_cause_1"), starts_with("vehicle_event_1")
           ,starts_with("latitude"), starts_with("longitude")) %>%
    mutate(longitude = str_glue("-{abs(longitude_degrees)+(longitude_minutes/60)+(longitude_seconds/3600)}")
           ,latitude = str_glue("{latitude_degrees+(latitude_minutes/60)+(latitude_seconds/3600)}")) %>%
    arrange(crash_id, record_type)

  temp_comp = merge(
    data_list_subset_pro %>%
      filter(record_type == 2) %>%
      janitor::remove_empty("cols") %>%
      merge(index_vchl_cause, by.x = "vehicle_cause_1_code", by.y = "VHCL_CAUSE_1_CD", all.x = T) %>%
      merge(index_vchl_event, by.x = "vehicle_event_1_code", by.y = "VHCL_EVNT_CD", all.x = T) %>%
      merge(index_mvmnt, by.x = "vehicle_movement_code", by.y = "MVMNT_CD", all.x = T) %>%
      select(crash_id,vehicle_type_code,  ends_with("DESC"))
    ,data_list_subset_pro %>%
      filter(record_type == 1) %>%
      janitor::remove_empty("cols") %>%
      merge(index_crash_cause, by.x = "crash_level_cause_1_code", by.y = "CRASH_CAUSE_CD", all.x = T) %>%
      merge(index_collision_type, by.x = "collision_type", by.y = "COLLIS_TYP_CD", all.x = T) %>%
      select(!c(crash_level_cause_1_code, collision_type, crash_severity, record_type
                ,starts_with("longitude_"),starts_with("latitude_")))
    ,by = "crash_id") %>%
    mutate(label = str_glue("{crash_id} - {route_number} - {crash_year}
                          <br>Cause and collision type: {CRASH_CAUSE_SHORT_DESC} - {COLLIS_TYP_SHORT_DESC}
                          <br>Veh Code/MVMNT: {vehicle_type_code} - {MVMNT_SHORT_DESC}")) %>%
    st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
}
