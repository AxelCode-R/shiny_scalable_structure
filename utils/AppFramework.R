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
      private$create_app_rvs(input, output, session)
      private$server_load_backends(input, output, session)
    }
  ),
  private = list(
    tab_configs = NULL,
    tab_choices = NULL,
    tab_ns = NULL,
    tab_classes = list(),
    app_rvs = list(),

    ############################################################################
    ui_header = function() {
      shinydashboard::dashboardHeader(title = "Example Title")
    },

    ui_sidebar = function() {
      shinydashboard::dashboardSidebar(
        collapsed = FALSE,
        shinydashboard::sidebarMenu(
          id = "sidebar_tabs",
          lapply(
            X = private$tab_choices,
            FUN = function(tab) {
              tab_config <- private$tab_configs[[tab]]
              menuItem_args <- tab_config$menuItem_args
              if (isTRUE(tab_config$menuItem_dynamic_badge_label)) {
                menuItem_args$badgeLabel <- shiny::textOutput(
                  outputId = private$tab_ns[[tab]]("menuItemBadgeLabel"),
                  inline = TRUE
                )
              }
              menuItem_args$tabName <- tab
              do.call(what = shinydashboard::menuItem, args = menuItem_args)
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
    create_app_rvs = function(input, output, session) {
      private$app_rvs <- setNames(lapply(
        X = private$tab_choices,
        FUN = function(tab) {
          tab_config <- private$tab_configs[[tab]]
          env <- new.env()
          if (isTRUE(tab_config$menuItem_dynamic_badge_label)) {
            id <- "menuItemBadgeLabel"
            env[[id]] <- shiny::reactiveVal(value = "")
            output[[private$tab_ns[[tab]](id)]] <- shiny::renderText({
              env[[id]]()
            })
          }
          return(env)
        }
      ), private$tab_choices)
    },

    load_backends_helper = function(tab, input, output, session) {
      tab_config <- private$tab_configs[[tab]]
      if (!is.null(tab_config$subtab_configs)) {
        private$tab_classes[[tab]] <- SubTabFramework$new(
          ns = private$tab_ns[[tab]],
          app_rv = private$app_rvs[[tab]],
          subtab_configs = tab_config$subtab_configs
        )
      } else {
        private$tab_classes[[tab]] <- private$tab_configs[[tab]]$tab_class$new(
          ns = private$tab_ns[[tab]],
          app_rv = private$app_rvs[[tab]]
        )
      }
      output[[paste0("tab_ui_", tab)]] <- shiny::renderUI(
        expr = private$tab_classes[[tab]]$ui()
      )
      shiny::moduleServer(
        id = tab,
        module = private$tab_classes[[tab]]$server
      )
    },

    server_load_backends = function(input, output, session) {
      lapply(
        X = private$tab_choices,
        FUN = function(tab) {
          if (isFALSE(private$tab_configs[[tab]]$lazy_load)) {
            private$load_backends_helper(tab = tab, input, output, session)
          }
        }
      )

      shiny::observeEvent(
        eventExpr = input$sidebar_tabs,
        handlerExpr = {
          selected_tab <- input$sidebar_tabs
          if (!selected_tab %in% names(private$tab_classes)) {
            private$load_backends_helper(tab = selected_tab, input, output, session)
          }
        }
      )
    }
  )
)

