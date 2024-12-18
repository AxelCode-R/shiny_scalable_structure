SubTabExample1 <- R6::R6Class(
  public = list(
    initialize = function(ns) {
      private$ns <- ns
    },
    ui = function() {
      shiny::div(
        shiny::p(paste0("SubTabExample1 ", Sys.time()))
      )
    },

    server = function(input, output, session) {}
  ),

  private = list(
    ns = NULL
  )
)
