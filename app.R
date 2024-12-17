R.utils::sourceDirectory(path = "R6_data_classes", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "R6_tab_classes", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "utils", modifiedOnly = FALSE)

app <- AppFramework$new(
  tab_configs = list(
    example_small = list(
      sidebar_config = list(
        text = "example_small",
        icon = shiny::icon("calendar"),
        dynamic_badge_label = TRUE
      )
    ),
    "example_with_subtabs"
  )
)


shiny::shinyApp(ui = app$main_ui, server = app$main_server)

# ToDos:
# home screen
# different sized tabs examples
### small tab
### huge tab with subtubs and own classes for each tab
### examples sollen klar machen das namespace eigen ist (auch subtabs, vielleicht unterordner?)
