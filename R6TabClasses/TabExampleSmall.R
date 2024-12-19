TabExampleSmall <- R6::R6Class(
  inherit = DataExampleSmall,
  public = list(
    initialize = function(ns, app_rv) {
      super$initialize()
      private$ns <- ns
      private$app_rv <- app_rv
    },
    ui = function() {
      shiny::div(
        shiny::p(paste0("hello example small   ", Sys.time())),
        shiny::h1("h1"),
        private$plot_ui()
      )
    },

    server = function(input, output, session) {
      private$plot_server(input, output, session)
      private$dynamic_sidebar_server(input, output, session)
    }
  ),

  private = list(
    app_rv = NULL,
    ns = NULL,
    timer = NULL,

    dynamic_sidebar_server = function(input, output, session) {
      shiny::observe({
        private$app_rv$menuItemBadgeLabel(
          paste0("myBadge ", round(private$timer(), 3))
        )
      })
    },

    plot_ui = function() {
      shiny::plotOutput(private$ns("plot"))
    },

    plot_server = function(input, output, session) {
      private$timer <- shiny::reactivePoll(
        intervalMillis = 1*10^3,
        session = session,
        checkFunc = function() {
          Sys.time()
        },
        valueFunc = function() {
          runif(1)
        }
      )
      output$plot <- shiny::renderPlot({
        trigger <- private$timer()
        plot(x = 1:100, y = runif(100))
      })
    }
  )
)
