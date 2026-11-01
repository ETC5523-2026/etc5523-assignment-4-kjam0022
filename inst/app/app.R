library(shiny)
library(bslib)
library(ggplot2)
library(trashwheelexplorer)

# Choices come from the packaged data, so the app never reads an external file
wheel_choices <- sort(unique(trash_collections$name))
type_choices <- sort(unique(trash_collections$trash_type))
year_range <- range(trash_collections$year)

# Named colours: each wheel keeps its colour whichever wheels are selected
wheel_colours <- c(
  "Mister Trash Wheel" = "#0072B2",
  "Professor Trash Wheel" = "#D55E00",
  "Captain Trash Wheel" = "#009E73",
  "Gwynnda Trash Wheel" = "#CC79A7"
)

app_css <- "
:root { --accent: #0F4C5C; --soft: #EEF4F5; }
body { line-height: 1.55; }
h5 { color: var(--accent); font-weight: 600; }
.about-card { background: var(--soft); border: 0; border-left: 6px solid var(--accent); }
.card-header { font-weight: 600; color: var(--accent); }
"

ui <- page_sidebar(
  title = "Trash Wheel explorer: what do Baltimore's wheels collect?",
  fillable = FALSE,
  theme = bs_theme(version = 5, primary = "#0F4C5C"),
  tags$head(tags$style(HTML(app_css))),
  sidebar = sidebar(
    width = 300,
    h5("Choose what to compare"),
    checkboxGroupInput(
      "wheels", "Trash Wheels",
      choices = wheel_choices, selected = wheel_choices
    ),
    checkboxGroupInput(
      "types", "Rubbish types",
      choices = type_choices,
      selected = c("Cigarette Butts", "Plastic Bags", "Plastic Bottles")
    ),
    sliderInput(
      "years", "Years",
      min = year_range[1], max = year_range[2],
      value = year_range, step = 1, sep = ""
    )
  ),
  card(
    class = "about-card",
    card_body(
      p(strong("Who it is for: "),
        "an analyst at a Baltimore waterway-cleanup programme deciding which kinds of rubbish to target."),
      p(strong("Question: "),
        "Which types of rubbish does each Trash Wheel collect most per dumpster load, and has that changed over the years?")
    )
  ),
  card(
    full_screen = TRUE,
    card_header("Average rubbish items per dumpster collection"),
    plotOutput("trend_plot", height = "520px")
  ),
  layout_columns(
    col_widths = c(5, 7),
    card(
      card_header("Highest average for each rubbish type"),
      uiOutput("takeaways")
    ),
    card(
      card_header("Numbers behind the chart"),
      max_height = "380px",
      tableOutput("summary_table")
    )
  ),
  accordion(
    open = TRUE,
    accordion_panel(
      "Fields and controls",
      tags$ul(
        tags$li(strong("Trash Wheels: "),
                "the four wheels in the data. They began in different years: Mister 2014, Professor 2017, Captain 2018 and Gwynnda 2021."),
        tags$li(strong("Rubbish types: "),
                "the seven kinds of rubbish counted in each dumpster collection. Counts are estimates from samples."),
        tags$li(strong("Years: "),
                "drag the two ends to choose the first and last year to show."),
        tags$li(strong("Items per collection: "),
                "the average estimated number of items of that type in one dumpster load, using only collections where that type was recorded."),
        tags$li(strong("Collections recorded: "),
                "how many collections each average is based on.")
      )
    ),
    accordion_panel(
      "How to read the results",
      tags$ul(
        tags$li("Each panel is one rubbish type with its own vertical scale, because some types are counted in thousands and others in single figures. Compare lines within a panel, not between panels."),
        tags$li("A line shows how a wheel's average load changed year by year. A line that sits above the others means that wheel collects more of that type per load. A rising line means more of that type per load over time."),
        tags$li("The list beside the chart answers the question directly: which wheel had the highest average for each type, and in which year."),
        tags$li("Be careful where an average rests on few collections (see the table), and remember these are estimated counts of items collected, not a measure of how much rubbish is in the harbour.")
      )
    )
  )
)

server <- function(input, output, session) {
  
  # One shared calculation: the plot, the takeaways and the table all use it
  selected <- reactive({
    validate(
      need(length(input$wheels) > 0,
           "Choose at least one Trash Wheel in the sidebar."),
      need(length(input$types) > 0,
           "Choose at least one rubbish type in the sidebar.")
    )
    
    result <- summarise_trash(
      trash_collections,
      wheels = input$wheels,
      trash_types = input$types,
      years = input$years
    )
    
    validate(need(
      nrow(result) > 0,
      paste(
        "No recorded counts match this selection. Try widening the years or adding another wheel.",
        "The wheels began in different years (Mister 2014, Professor 2017, Captain 2018, Gwynnda 2021),",
        "and not every wheel records every rubbish type."
      )
    ))
    
    result
  })
  
  output$trend_plot <- renderPlot({
    ggplot(selected(), aes(year, items_per_collection, colour = name)) +
      geom_line(linewidth = 1) +
      geom_point(size = 2.5) +
      facet_wrap(~ trash_type, scales = "free_y") +
      scale_colour_manual(values = wheel_colours) +
      scale_x_continuous(breaks = function(x) {
        seq(ceiling(x[1]), floor(x[2]), by = if (diff(x) > 6) 2 else 1)
      }) +
      labs(
        x = NULL,
        y = "Estimated items per collection",
        colour = NULL,
        subtitle = "Each panel has its own vertical scale",
        caption = "Source: Baltimore Healthy Harbor via TidyTuesday (2024-03-05)"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "bottom",
        plot.title.position = "plot",
        strip.text = element_text(face = "bold"),
        panel.grid.minor = element_blank()
      )
  })
  
  output$takeaways <- renderUI({
    peaks <- selected() |>
      dplyr::group_by(trash_type) |>
      dplyr::slice_max(items_per_collection, n = 1, with_ties = FALSE) |>
      dplyr::ungroup()
    
    tags$ul(lapply(seq_len(nrow(peaks)), function(i) {
      tags$li(
        strong(peaks$trash_type[i]),
        paste0(
          ": highest at ", peaks$name[i], " in ", peaks$year[i],
          ", about ", format(round(peaks$items_per_collection[i]), big.mark = ","),
          " items per collection (", peaks$collections[i], " collections recorded)."
        )
      )
    }))
  })
  
  output$summary_table <- renderTable({
    selected() |>
      dplyr::arrange(trash_type, name, year) |>
      dplyr::transmute(
        Wheel = name,
        `Rubbish type` = trash_type,
        Year = as.character(year),
        `Collections recorded` = collections,
        `Items per collection` = format(round(items_per_collection), big.mark = ",")
      )
  }, striped = TRUE, spacing = "s", align = "lllrr")
}

shinyApp(ui, server)