AppReactiveLogger <- R6::R6Class(
  public = list(
    initialize = function(input, output, session) {
      private$rv_msgs <- shiny::reactiveVal(NULL)
    },

    logger_ui = function() {
      shiny::div(
        id = "logger_container",
        shiny::tags$script(src = "logger_script.js")
      )
    },

    logger_server = function(input, output, session) {
      shiny::observeEvent(
        eventExpr = private$rv_msgs(),
        handlerExpr = {
          last_msg <- private$rv_msgs()[[1]]
          shiny::insertUI(
            session = session,
            selector = "#logger_container",
            where = "beforeEnd",
            ui = {
              shiny::div(
                class = "logger_element",
                shiny::div(shiny::icon("triangle-exclamation"), last_msg$time, class = "logger_element_title"),
                shiny::div(last_msg$msg, class = "logger_element_text")
              )
            }
          )
        }
      )
    },

    log = function(msg, type = "message") {
      private$rv_msgs(
        c(
          list(list(time = format(Sys.time(), format = "%H:%M:%S"), msg = msg)),
          private$rv_msgs()
        )
      )
    }
  ),
  private = list(
    rv_msgs = NULL
  )
)
