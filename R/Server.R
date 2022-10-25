library(R6)
library(httpuv)

#'Server class
#'
#' Class provides an http server that connects R language resources with javascript applications.
#'
#' @description The package is based on \href{https://cran.r-project.org/web/packages/httpuv/index.html}{httpuv::}.
#'  It is designed to host static resources such as html, javascript, css, etc along with specific route requests
#'  to perform various R based actions or respond with various content(i.g. JSON strings, images, etc).  The server
#'  is designed to work in a local host environment (i.e. url = 127.0.0.1) as part of an html/javascript project that
#'  needs a link to R language capabilities and its associated packages.
#'
#' @import R6
#' @import httpuv
#'
#' @author Rick Dean
#'
#' @export
Server <- R6::R6Class(

  public = list(
    #' @field index_path A string that defines the full directory path to an \code{index.html} file defining the server's
    #'   root path (i.e. "\"). The root html file is assumed to be named "index.html".
    index_path = NULL,

    #' @field port An integer that defines the port number for the server. The default is 8080.
    port = 8080,

    #' @field routes A vector of \code{RserverPkg::Route} objects that define the request paths that the server will respond to.
    #'   Each \code{RserverPkg::Route} object should define the path, callback function that optionally returns content, and the
    #'   content's MIME content type. The callback function can be defined to receive a \code{RserverPkg::Request} object argument.
    routes = NULL,

    #' @field static_paths A named list that defines the locations of static resources (.css, .html, .js files) for hosting by the
    #'   server. The list name is the web path (e.g. "/content") and the value is the full directory path to the resources
    #'   (e.g. F:/web_server/content).
    static_paths = NULL,

    #' @description Defines the classes' public fields
    #' @param index_path A string that defines the full directory path to an \code{index.html} file defining the server's
    #'   root path (i.e. "\").
    #' @param port An integer that defines the port number for the server.
    #' @param routes A vector of \code{RserverPkg::Route} objects that define the request paths that the server will respond to.
    #' @param static_paths A named list that defines the locations of static resources (.css, .html, .js files) for hosting by the
    #'   server.
    initialize = function(index_path = NULL, port = 8080, routes = NULL, static_paths = NULL){
      self$index_path <- index_path
      self$port <- port
      self$routes <- routes
      self$static_paths <- static_paths

      if(!is.null(self$index_path)) {
        private$static_path_lst[["/"]] <-  httpuv::staticPath(self$index_path, indexhtml = TRUE, fallthrough = TRUE)
      }

      if(!is.null(self$static_paths)){
        web_path_names <- names(self$static_paths)
        for(path in web_path_names){
          private$static_path_lst[[path]] <- httpuv::staticPath(self$static_paths[[path]], indexhtml = FALSE)
        }
      }

      if(!is.null(self$routes)){
        for(route in self$routes){
          private$routes_lst[[route$path]] <- list("handler" = route$handler, "content_type" = route$content_type)
        }
      }
    },
      #' @description  Start the server
    start = function(){
      print(paste0("Server is listening on port ", self$port))

      app = list(
        call = function(req){
          req_path <- req$PATH_INFO
          if(!is.null(self$routes) & req_path %in% names(private$routes_lst)) {
            query_final_lst <- list()
            if(nchar(req$QUERY_STRING) > 1) {
              query_str <- substring(req$QUERY_STRING,2)
              query_lst <- strsplit(query_str, "&", fixed = TRUE)[[1]]

              for(i in seq_along(query_lst)){
                parts <- strsplit(query_lst[[i]], "=", fixed = TRUE)[[1]]
                query_final_lst[parts[[1]]] <- URLdecode(parts[[2]])
              }
            }

            request_info <- RwebserverPkg::Request$new(
              path = req$PATH_INFO,
              method = req$REQUEST_METHOD,
              content_type = req$CONTENT_TYPE,
              body = paste0(req$rook.input$read_lines(),collapse = ""),
              query_list = query_final_lst
            )
            route <- private$routes_lst[[req_path]]

            return(
              list(
                status = 200L,
                headers = list(
                  'Content-Type' = route$content_type
                ),
                body = route$handler(request_info)
              )
            )
          }else {
            return (
              list(
                status = 404L,
                headers = list(
                  "Content-Type" = "text/plain"
                ),
                body = paste0("404 Not Found: ", req_path)
              )
            )
          }
        },
        staticPaths = private$static_path_lst
      )

      private$server <- httpuv::startServer(host = "127.0.0.1", port = self$port, app = app)
    },

    #' @description  Stop the server
    stop = function(){
      print(paste0("Stopping the server on port ", self$port))
      httpuv::stopServer(server = private$server)
    },

    #' @description List the current servers
    list_servers = function(){
      httpuv::listServers();
    }
  ),
  private = list(
    server = NULL,
    static_path_lst = list(),
    routes_lst = list()
  )
)


