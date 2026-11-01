# Build the packaged dataset `trash_collections`.
# Source: TidyTuesday, Trash Wheel Collection Data (2024-03-05),
# originally from Baltimore's Healthy Harbor initiative.

url <- paste0(
  "https://raw.githubusercontent.com/rfordatascience/",
  "tidytuesday/main/data/2024/2024-03-05/trashwheel.csv"
)

# Download once and keep a copy so the build does not depend on the web
raw_path <- "data-raw/trashwheel.csv"
if (!file.exists(raw_path)) {
  download.file(url, raw_path, mode = "wb")
}

trash_collections <- readr::read_csv(raw_path, show_col_types = FALSE) |>
  janitor::clean_names() |>
  dplyr::mutate(date = lubridate::mdy(date)) |>
  tidyr::pivot_longer(
    cols = plastic_bottles:sports_balls,
    names_to = "trash_type",
    values_to = "count"
  ) |>
  # Readable labels for the app, e.g. "plastic_bottles" -> "Plastic Bottles"
  dplyr::mutate(trash_type = tools::toTitleCase(gsub("_", " ", trash_type)))

usethis::use_data(trash_collections, overwrite = TRUE)