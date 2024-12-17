tab_sidebar_config_example_small = function() {
  list(
    text = "example_small",
    icon = shiny::icon("calendar"),
    dynamic_badge_label = TRUE
  )
}


Tab_example_small <- R6::R6Class(
  inherit = Data_example_small,

  public = list(
    initialize = function(tab, ns) {
      super$initialize()
      private$tab <- tab
      private$ns <- ns
    },
    ui = function() {
      shiny::div(
        paste0("hallo ex1   ", Sys.time()),
        private$plot_ui()
      )
    },

    server = function(input, output, session) {
      # shiny::moduleServer(
      #   id = private$tab,
      #   module = function(input, output, session) {
          private$plot_server(input, output, session)
          private$dynamic_sidebar_server(input, output, session)
      #   }
      # )
    }
  ),

  private = list(
    tab = NULL,
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
