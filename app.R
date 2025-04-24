
R.utils::sourceDirectory(path = "R6DataClasses", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "R6TabClasses", modifiedOnly = FALSE)
R.utils::sourceDirectory(path = "framework", modifiedOnly = FALSE)

app <- AppFramework$new(
  global_css_files = c("styles_global.css", "logger_style.css"),
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
      #lazy_load = FALSE,
      menuItem_dynamic_badge_label = TRUE,
      menuItem_args = list(
        text = "Example Small",
        icon = shiny::icon("calendar")
      ),
      css_files = c("styles.css", "styles2.css")
    ),
    example_huge = list(
      #lazy_load = FALSE,
      menuItem_dynamic_badge_label = TRUE,
      menuItem_args = list(
        text = "Example Huge",
        icon = shiny::icon("calendar")
      ),
      subtab_configs = list(
        subtab1 = list(
          subtab_class = SubTabExample1,
          tabPanel_args = list(
            title = "First Tab",
            selected = TRUE
          ),
          css_files = "styles.css"
        ),
        subtab2 = list(
          subtab_class = SubTabExample2,
          lazy_load = FALSE,
          tabPanel_args = list(
            title = "Secound Tab"
          )
        )
      )
    )
  )
)


shiny::shinyApp(ui = app$ui, server = app$server)

# todo
# safely_reactivePoll
# grid layout function
