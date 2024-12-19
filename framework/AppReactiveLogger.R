AppReactiveLogger <- R6::R6Class(
  public = list(
    initialize = function(controlbarItem_OutputId, input, output, session) {
      private$controlbarItem_OutputId <- controlbarItem_OutputId

      private$rv_errors <- shiny::reactiveVal(NULL)
      output[[private$controlbarItem_OutputId]] <- shiny::renderUI({
        shiny::div(
          style = "",
          shiny::tagList(lapply(
            X = private$rv_errors(),
            FUN = function(e) {
              shiny::div(
                class = "logger_tab",
                shiny::div(e$time, class = "logger_text_title"),
                shiny::div(e$msg, class = "logger_text_elapsable logger_text")
              )
            }
          )),
          shiny::tags$script(shiny::HTML("
            function initToggleText() {
              var textElements = document.querySelectorAll('.logger_text_elapsable');
              textElements.forEach(function(element) {
                element.addEventListener('click', function() {
                  element.classList.toggle('logger_text_ellapsed');
                });
              });
            }
            initToggleText();
          "))
        )
      })
    },

    log_error = function(e) {
      private$rv_errors(
        c(
          list(list(time = format(Sys.time(), format = "%H:%M:%S"), msg = e)),
          private$rv_errors()
        )
      )
    }
  ),
  private = list(
    controlbarItem_OutputId = NULL,
    rv_errors = NULL
  )
)
