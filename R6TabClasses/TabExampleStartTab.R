TabExampleStartTab <- R6::R6Class(
  public = list(
    initialize = function(ns) {
      private$ns <- ns
    },
    ui = function() {
      shiny::div(
        shiny::img(src = "ai_picture.jpg", height = "300px", width = "400px")
      )
    },

    server = function(input, output, session) {}
  ),

  private = list(
    ns = NULL
  )
)
