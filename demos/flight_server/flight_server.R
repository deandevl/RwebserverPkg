library(httpuv)
library(data.table)
library(here)
library(jsonlite)
library(RwebserverPkg)

current_dir <- here()
index_path <- file.path(current_dir, "/demos/flight_server")
assets_path <- file.path(current_dir, "/demos/flight_server/assets")
flights_file_path <- file.path(current_dir, "/demos/flights/flights14.csv")

if(!base::file.exists(flights_file_path)){
  stop("Flight data csv file does not exist.")
}

flight_column_names_fun <- function(req_info){
  flights_df <- data.table::fread(flights_file_path)
  flights_cols <- names(flights_df)
  return(jsonlite::toJSON(list("columnNames" = flights_cols)))
}

static_paths <- list("/assets" = assets_path)

route <- RwebserverPkg::Route$new(
  path = "/flight_info",
  handler = flight_column_names_fun,
  content_type = "text/plain"
)

flight_server <- RwebserverPkg::Server$new(
  index_path = index_path,
  routes = c(route),
  static_paths = static_paths
)

flight_server$start()

flight_server$list_servers()

flight_server$stop()
