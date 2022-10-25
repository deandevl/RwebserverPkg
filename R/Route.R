library(R6)

#' Route class
#'
#' @description This class represents assigning an R function to an http request path
#'
#'
#' @examples
#' Route$new(path="/flight_column_names", handler = getColumnNames, content_type = "text/plain")
#'
#' @import R6
#'
#' @author Rick Dean
#'
#' @export
Route <- R6::R6Class(
  'Route',
  public = list(
    #' @field path Is a string that sets the http request path.
    path = NULL,

    #' @field handler Is the \code{Route} function handler which optionally accepts
    #'  a \code{\link{Request}} argument.
    handler = NULL,

    #' @field content_type Is the MIME content type returned by the function. Common MIME types are
    #'  listed \href{https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types}{here}.
    #'  The default MIME type is "text/plain".
    content_type = NULL,

    #' @description
    #' Create a Route object
    #' @param path http request path.
    #' @param handler A callback function that executes when the \code{path} request is received.
    #' @param content_type A string that defines the MIME type of the content returned by \code{handler}.
    #' @return A new `Route` object
    initialize = function(path = NULL, handler = NULL, content_type = 'text/plain'){
      self$path <- path
      self$handler <- handler
      self$content_type <- content_type

      if(is.null(path)){
        stop('The Route class requires an http request path.')
      }
      if(is.null(handler)){
        stop('The Route class requires a handler function.')
      }
    }
  )
)
