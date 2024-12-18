TabExampleHuge <- R6::R6Class(
  inherit = DataExampleHuge,

  public = list(
    initialize = function(ns) {
      super$initialize()
      private$ns <- ns
      private$subtab_config <- c(
        subtab1 = list(
          title = "First Tab"
        ),
        subtab2 = list(
          title = "Secound Tab"
        )
      )
      private$subtab_choices <- names(private$subtab_config)
    },
    ui = function() {
      shiny::div(
        paste0("hallo ex2   ", Sys.time()),
        shiny::tabsetPanel(
          lapply(
            X = private$subtab_choices,
            FUN = function(subtab) {
              subtab_config <- private$subtab_config[[subtab]]
              subtab_config$value <- subtab
              do.call(shiny::tabPanel, args = subtab_config)
            }
          )
        )
      )
    },
    server = function(input, output, session) {

    }
  ),

  private = list(
    ns = NULL,
    subtab_config = NULL,
    subtab_choices = NULL

  )
)
