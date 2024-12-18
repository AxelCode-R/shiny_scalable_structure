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
          lazy_load = FALSE,
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
      private$load_backends_server(input, output, session)
    }
  ),

  private = list(
    ns = NULL,
    subtab_configs = NULL,
    subtab_choices = NULL,
    subtab_ns = NULL,
    subtab_classes = list(),

    load_backends_helper = function(subtab, input, output, session) {
      private$subtab_classes[[subtab]] <- private$subtab_configs[[subtab]]$subtab_class$new(
        ns = private$subtab_ns[[subtab]]
      )
      output[[paste0("subtab_ui_", subtab)]] <- shiny::renderUI(
        expr = private$subtab_classes[[subtab]]$ui()
      )
      shiny::moduleServer(
        id = subtab,
        module = private$subtab_classes[[subtab]]$server
      )
    },
    load_backends_server = function(input, output, session) {
      lapply(
        X = private$subtab_choices,
        FUN = function(subtab) {
          if (isFALSE(private$subtab_configs[[subtab]]$lazy_load)) {
            private$load_backends_helper(subtab = subtab, input, output, session)
          }
        }
      )

      shiny::observeEvent(
        eventExpr = input$subtabs_selection,
        handlerExpr = {
          selected_subtab <- input$subtabs_selection
          if (!selected_subtab %in% names(private$subtab_classes)) {
            private$load_backends_helper(subtab = selected_subtab, input, output, session)
          }
        }
      )
    }
  )
)
