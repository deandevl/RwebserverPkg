library(R6)

#' Request class
#'
#' @description This class consolidates information on an http request received by the server
#'   Its main purpose is to pass this object to a \link{Route} callback function.
#' @import R6
#'
#' @author Rick Dean
#'
#' @export
Request <- R6::R6Class(
  'Request',
  public = list(
    #' @field path Is a string that is the request path.
    path = NULL,

    #' @field method is a string that is the request method
    method = NULL,

    #' @field content_type is a string that is the content type
    content_type = NULL,

    #' @field body is the request body
    body = NULL,

    #' @field query_list is an R named list of request query variables and their
    #'   respective values
    query_list = NULL,

    #' @description
    #' Create a Request object
    #' @param path http request path
    #' @param method http request method
    #' @param content_type http request content_type
    #' @param body http request body
    #' @param query_list http request query string as an R named list with query variables
    #'   and their respective values
    #' @return A new `Request` object
    initialize = function(path=NULL, method=NULL, content_type=NULL, body=NULL, query_list=NULL){
      self$path <- path
      self$method <- method
      self$content_type <- content_type
      self$body <- body
      self$query_list = query_list
    }
  )
)
