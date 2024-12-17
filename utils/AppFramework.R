AppFramework <- R6::R6Class(
  public = list(
    initialize = function(tab_choices) {
      private$tab_choices <- tab_choices
      private$tab_ns <- lapply(tab_choices, shiny::NS)
      names(private$tab_ns) <- tab_choices
    },
    main_ui = function() {
      shinydashboard::dashboardPage(
        private$ui_header(),
        private$ui_sidebar(),
        private$ui_body()
      )
    },
    main_server = function(input, output, session) {
      private$server_load_backends(input, output, session)
    }
  ),
  private = list(
    tab_choices = NULL,
    tab_ns = NULL,
    tab_classes = list(),
    ############################################################################
    ui_header = function() {
      shinydashboard::dashboardHeader(title = "Lazy Loading Tabs")
    },
    ui_sidebar = function() {
      shinydashboard::dashboardSidebar(
        shinydashboard::sidebarMenu(
          id = "sidebar_tabs",
          lapply(
            X = private$tab_choices,
            FUN = function(tab) {
              sidebar_config <- eval(parse(text = paste0("tab_sidebar_config_", tab, "()")))
              sidebar_config$badgeLabel <- shiny::textOutput(private$tab_ns[[tab]]("sidebar_badgeLabel"), inline = TRUE)
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
          selected_tab <- grep(gsub("tab_sidebar_", "", input$sidebar_tabs), private$tab_choices, value = TRUE)
          if (!selected_tab %in% names(private$tab_classes)) {

            private$tab_classes[[selected_tab]] <- do.call(
              what = eval(parse(text = paste0("Tab_", selected_tab, "$new"))),
              args = list(tab = selected_tab, ns = private$tab_ns[[selected_tab]])
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

