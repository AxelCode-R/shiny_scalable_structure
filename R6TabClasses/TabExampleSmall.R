TabExampleSmall <- R6::R6Class(
  inherit = DataExampleSmall,
  public = list(
    initialize = function(ns) {
      super$initialize()
      private$ns <- ns
    },
    ui = function() {
      shiny::div(
        paste0("hello example small   ", Sys.time()),
        private$plot_ui()
      )
    },

    server = function(input, output, session) {
      private$plot_server(input, output, session)
      private$dynamic_sidebar_server(input, output, session)
    }
  ),

  private = list(
    ns = NULL,
    timer = NULL,

    dynamic_sidebar_server = function(input, output, session) {
      output$sidebar_badgeLabel <- shiny::renderText({
        paste0("myBadge ", round(private$timer(), 3))
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
