R.utils::sourceDirectory(path = "R6TabClasses", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "R6DataClasses", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "utils", modifiedOnly = FALSE)

app <- AppFramework$new(
  tab_configs = list(
    example_small = list(
      tab_class = TabExampleSmall,
      sidebar_config = list(
        dynamic_badge_label = TRUE,
        text = "Example Small",
        icon = shiny::icon("calendar")
      )
    ),
    example_with_subtabs = list(
      tab_class = TabExampleHuge,
      sidebar_config = list(
        text = "Example Huge",
        icon = shiny::icon("calendar")
      )
    )
  )
)


shiny::shinyApp(ui = app$ui, server = app$server)

# ToDos:
# home screen
# different sized tabs examples
### small tab
### huge tab with subtubs and own classes for each tab
### examples sollen klar machen das namespace eigen ist (auch subtabs, vielleicht unterordner?)
