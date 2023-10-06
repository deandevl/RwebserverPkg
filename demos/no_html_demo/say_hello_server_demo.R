library(httpuv)
library(RwebserverPkg)

say_hello <- function(req_info){
  query_lst <- req_info$query_list
  name <- query_lst[["name"]]

  return (paste0("Hello ", name))
}

route <- RwebserverPkg::Route$new(
  path = "/say_hello",
  handler = say_hello,
  content_type = "text/plain"
)

say_hello_server <- RwebserverPkg::Server$new(
  index_path = NULL,
  port = 8080,
  routes = c(route)
)
# start the server, then from a browser enter 'http://localhost:8080/say_hello' in the address bar
say_hello_server$start()

say_hello_server$list_servers()

say_hello_server$stop()
