tab_sidebar_config_example_with_subtabs = function() {
  list(
    text = "example_with_subtabs",
    icon = shiny::icon("calendar")
  )
}


Tab_example_with_subtabs <- R6::R6Class(
  inherit = Data_example_with_subtabs,

  public = list(
    initialize = function(tab, ns) {
      super$initialize()
      private$ns <- ns
      private$tab <- tab
    },
    ui = function() {
      shiny::div(paste0("hallo ex2   ", Sys.time()))
    },
    server = function(input, output, session) {

    }
  ),

  private = list(
    ns = NULL,
    tab = NULL

  )
)
