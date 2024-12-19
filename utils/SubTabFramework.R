SubTabFramework <- R6::R6Class(
  public = list(
    initialize = function(ns, app_rv, subtab_configs) {
      private$app_rv <- app_rv
      private$ns <- ns
      private$subtab_configs <- subtab_configs
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
    app_rv = NULL,
    ns = NULL,
    subtab_configs = NULL,
    subtab_choices = NULL,
    subtab_ns = NULL,
    subtab_classes = list(),

    load_backends_helper = function(subtab, input, output, session) {
      app_rv <- list2env(as.list(private$app_rv))
      app_rv$TabsetPanelSelectedTrigger <- shiny::reactiveVal(0)
      shiny::observeEvent(
        eventExpr = input$subtabs_selection,
        handlerExpr = {
          shiny::req(input$subtabs_selection == subtab)
          app_rv$TabsetPanelSelectedTrigger(app_rv$TabsetPanelSelectedTrigger() + 1)
        }
      )

      subtab_config <- private$subtab_configs[[subtab]]
      private$subtab_classes[[subtab]] <- subtab_config$subtab_class$new(
        ns = private$subtab_ns[[subtab]],
        app_rv = app_rv
      )
      #ui <- private$subtab_classes[[subtab]]$ui()
      output[[paste0("subtab_ui_", subtab)]] <- shiny::renderUI(
        expr = {
          shiny::div(
            if (!is.null(subtab_config$css_files)) {
              shiny::tags$style(shiny::HTML({
                css <- trimws(unlist(lapply(paste0("www/", subtab_config$css_files), readLines)), which = "right")
                add_ns <- grepl("\\{$", css)
                css[add_ns] <- paste0("#", private$ns(paste0("subtab_ui_", subtab)), " ", css[add_ns])
                css
              }))
            },
            private$subtab_classes[[subtab]]$ui()
          )
        }
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
