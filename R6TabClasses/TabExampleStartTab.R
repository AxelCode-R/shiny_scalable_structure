TabExampleStartTab <- R6::R6Class(
  public = list(
    initialize = function(ns, app_rv) {
      private$ns <- ns
      private$app_rv <- app_rv
    },
    ui = function() {
      shiny::div(
        shiny::img(src = "ai_picture.jpg", height = "300px", width = "400px")
      )
    },

    server = function(input, output, session) {}
  ),

  private = list(
    ns = NULL,
    app_rv = NULL
  )
)
