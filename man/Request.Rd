% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Request.R
\name{Request}
\alias{Request}
\title{Request class}
\description{
This class consolidates information on an http request received by the server
Its main purpose is to pass this object to a \link{Route} callback function.
}
\author{
Rick Dean
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{path}}{Is a string that is the request path.}

\item{\code{method}}{is a string that is the request method}

\item{\code{content_type}}{is a string that is the content type}

\item{\code{body}}{is the request body}

\item{\code{query_list}}{is an R named list of request query variables and their
respective values}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Request-new}{\code{Request$new()}}
\item \href{#method-Request-clone}{\code{Request$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Request-new"></a>}}
\if{latex}{\out{\hypertarget{method-Request-new}{}}}
\subsection{Method \code{new()}}{
Create a Request object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Request$new(
  path = NULL,
  method = NULL,
  content_type = NULL,
  body = NULL,
  query_list = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{path}}{http request path}

\item{\code{method}}{http request method}

\item{\code{content_type}}{http request content_type}

\item{\code{body}}{http request body}

\item{\code{query_list}}{http request query string as an R named list with query variables
and their respective values}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new \code{Request} object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Request-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Request-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Request$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
