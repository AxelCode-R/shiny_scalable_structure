AppFramework <- R6::R6Class(
  public = list(
    initialize = function(tab_configs) {
      private$tab_configs <- tab_configs
      private$tab_choices <- names(tab_configs)
      private$tab_ns <- setNames(
        lapply(private$tab_choices, shiny::NS),
        private$tab_choices
      )
    },
    ui = function() {
      shinydashboard::dashboardPage(
        private$ui_header(),
        private$ui_sidebar(),
        private$ui_body()
      )
    },
    server = function(input, output, session) {
      private$server_load_backends(input, output, session)
    }
  ),
  private = list(
    tab_configs = NULL,
    tab_choices = NULL,
    tab_ns = NULL,
    tab_classes = list(),
    ############################################################################
    ui_header = function() {
      shinydashboard::dashboardHeader(title = "Example Title")
    },
    ui_sidebar = function() {
      shinydashboard::dashboardSidebar(
        shinydashboard::sidebarMenu(
          id = "sidebar_tabs",
          lapply(
            X = private$tab_choices,
            FUN = function(tab) {
              sidebar_config <- private$tab_configs[[tab]]$sidebar_config
              if (isTRUE(sidebar_config$dynamic_badge_label)) {
                sidebar_config$badgeLabel <- shiny::textOutput(private$tab_ns[[tab]]("sidebar_badgeLabel"), inline = TRUE)
              }
              sidebar_config$dynamic_badge_label <- NULL
              sidebar_config$tabName <- tab
              do.call(what = shinydashboard::menuItem, args = sidebar_config)
            }
          )
        )
      )
    },
    ui_body = function() {
      shinydashboard::dashboardBody(
        do.call(
          what = shinydashboard::tabItems,
          args = lapply(
            X = private$tab_choices,
            FUN = function(tab) {
              shinydashboard::tabItem(
                tabName = tab,
                shiny::uiOutput(outputId = paste0("tab_ui_", tab))
              )
            }
          )
        )
      )
    },
    ############################################################################
    server_load_backends = function(input, output, session) {
      shiny::observeEvent(
        eventExpr = input$sidebar_tabs,
        handlerExpr = {
          selected_tab <- input$sidebar_tabs
          if (!selected_tab %in% names(private$tab_classes)) {
            private$tab_classes[[selected_tab]] <- private$tab_configs[[selected_tab]]$tab_class$new(
              ns = private$tab_ns[[selected_tab]]
            )
            output[[paste0("tab_ui_", selected_tab)]] <- shiny::renderUI(private$tab_classes[[selected_tab]]$ui())
            shiny::moduleServer(
              id = selected_tab,
              module = private$tab_classes[[selected_tab]]$server
            )
          }
        }
      )
    }
  )
)

