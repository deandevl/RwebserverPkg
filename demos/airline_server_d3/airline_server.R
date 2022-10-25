library(httpuv)
library(data.table)
library(here)
library(jsonlite)
library(RwebserverPkg)

current_dir <- here()
index_path <- file.path(current_dir, "/demos/airline_server_d3/prod")
assets_path <- file.path(current_dir, "/demos/airline_server_d3/prod")
flights_file_path <- file.path(current_dir, "demos/flights/flights14.csv")

if(!base::file.exists(flights_file_path)){
  stop("Flight data csv file does not exist.")
}

airline_fun <- function(req_info){
  query_lst <- req_info$query_list
  airline <- query_lst[["airline"]]
  xmin <- strtoi(query_lst[["xmin"]], 0)
  xmax <- strtoi(query_lst[["xmax"]], 0)
  flights_df <- data.table::fread(flights_file_path)
  airline_delay_df <- flights_df[carrier == airline & (arr_delay > xmin & arr_delay < xmax), .(arr_delay)]

  return(jsonlite::toJSON(
    list(
      "arr_delay" = airline_delay_df$arr_delay,
      "data_min" = min(flights_df$arr_delay),
      "data_max" = max(flights_df$arr_delay)
    )
  ))
}

static_paths <- list("/assets" = assets_path)

route <- RwebserverPkg::Route$new(
  path = "/delay",
  handler = airline_fun,
  content_type = "text/plain"
)

airline_server <- RwebserverPkg::Server$new(
  index_path = index_path,
  routes = c(route),
  static_paths = static_paths
)

airline_server$start()

airline_server$list_servers()

airline_server$stop()
