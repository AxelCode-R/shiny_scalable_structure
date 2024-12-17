TabExampleHuge <- R6::R6Class(
  inherit = DataExampleHuge,

  public = list(
    initialize = function(ns) {
      super$initialize()
      private$ns <- ns
    },
    ui = function() {
      shiny::div(paste0("hallo ex2   ", Sys.time()))
    },
    server = function(input, output, session) {

    }
  ),

  private = list(
    ns = NULL

  )
)
