R.utils::sourceDirectory(path = "R6TabClasses", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "R6DataClasses", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "utils", modifiedOnly = FALSE)

app <- AppFramework$new(
  tab_configs = list(
    example_start_tab = list(
      tab_class = TabExampleStartTab,
      menuItem_args = list(
        selected = TRUE,
        text = "Start Tab",
        icon = shiny::icon("home")
      )
    ),
    example_small = list(
      tab_class = TabExampleSmall,
      menuItem_dynamic_badge_label = TRUE,
      menuItem_args = list(
        text = "Example Small",
        icon = shiny::icon("calendar")
      )
    ),
    example_huge = list(
      tab_class = TabExampleHuge,
      menuItem_args = list(
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
