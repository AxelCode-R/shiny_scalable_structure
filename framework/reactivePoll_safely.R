reactivePoll_safely <- function(
    session,
    logger = NULL,
    intervalMillis = 10000,
    checkFunc = function() {runif(1)},
    valueFunc = function() {runif(1)},
    errorReturn = NULL
  ) {
  shiny::reactivePoll(
    intervalMillis = intervalMillis,
    session = session,
    checkFunc = function() {
      tryCatch({
        checkFunc()
      }, error = function(e) {
        logger$log(paste0("Error in reactivePoll check: ", e$message))
        return(NULL)
      })
    },
    valueFunc = function() {
      tryCatch({
        valueFunc()
      }, error = function(e) {
        logger$log(paste0("Error in reactivePoll value: ", e$message))
        errorReturn
      })
    }
  )
}
