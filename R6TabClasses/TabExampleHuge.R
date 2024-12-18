TabExampleHuge <- R6::R6Class(
  inherit = DataExampleHuge,

  public = list(
    initialize = function(ns) {
      super$initialize()
      private$ns <- ns
      private$subtab_configs <- list(
        subtab1 = list(
          subtab_class = SubTabExample1,
          tabPanel_args = list(
            title = "First Tab",
            selected = TRUE
          )
        ),
        subtab2 = list(
          subtab_class = SubTabExample2,
          tabPanel_args = list(
            title = "Secound Tab"
          )
        )
      )
      private$subtab_choices <- names(private$subtab_configs)
      private$subtab_ns <- setNames(
        lapply(
          X = private$subtab_choices,
          FUN = function(subtab) {
            shiny::NS(private$ns(subtab))
          }
        ),
        private$subtab_choices
      )
    },
    ui = function() {
      shiny::div(
        paste0("hello example huge   ", Sys.time()),
        shiny::tabsetPanel(
          id = private$ns("subtabs_selection"),
          !!!lapply(
            X = private$subtab_choices,
            FUN = function(subtab) {
              tabPanel_args <- private$subtab_configs[[subtab]]$tabPanel_args
              tabPanel_args$value <- subtab
              tabPanel_args <- c(
                tabPanel_args,
                list(shiny::uiOutput(outputId = private$ns(paste0("subtab_ui_", subtab))))
              )
              do.call(shiny::tabPanel, args = tabPanel_args)
            }
          )
        )
      )
    },
    server = function(input, output, session) {
      shiny::observeEvent(
        eventExpr = input$subtabs_selection,
        handlerExpr = {
          selected_subtab <- input$subtabs_selection
          if (!selected_subtab %in% names(private$subtab_classes)) {
            private$subtab_classes[[selected_subtab]] <- private$subtab_configs[[selected_subtab]]$subtab_class$new(
              ns = private$subtab_ns[[selected_subtab]]
            )
            output[[paste0("subtab_ui_", selected_subtab)]] <- shiny::renderUI(
              expr = private$subtab_classes[[selected_subtab]]$ui()
            )
            shiny::moduleServer(
              id = selected_subtab,
              module = private$subtab_classes[[selected_subtab]]$server
            )
          }
        }
      )
    }
  ),

  private = list(
    ns = NULL,
    subtab_configs = NULL,
    subtab_choices = NULL,
    subtab_ns = NULL,
    subtab_classes = list()
  )
)
