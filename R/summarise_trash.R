#' Summarise rubbish collected by the Trash Wheels
#'
#' Summarises the estimated item counts in [trash_collections] for chosen
#' wheels, rubbish types and years. When a rubbish type was not recorded for
#' a collection, that collection is left out of the type's summary rather
#' than being counted as zero.
#'
#' @param data A data frame in the same format as [trash_collections], with
#'   columns `name`, `year`, `dumpster`, `trash_type` and `count`.
#' @param wheels Character vector of Trash Wheel names to include. The
#'   default `NULL` keeps all wheels.
#' @param trash_types Character vector of rubbish types to include. The
#'   default `NULL` keeps all types.
#' @param years Numeric vector of length two giving the first and last year
#'   to include. The default `NULL` keeps all years.
#'
#' @return A data frame with one row per wheel, year and rubbish type:
#'   * `name`: Trash Wheel name
#'   * `year`: year of collection
#'   * `trash_type`: rubbish type
#'   * `collections`: number of dumpster collections that recorded the type
#'   * `total_items`: estimated total items collected
#'   * `items_per_collection`: mean estimated items per collection
#'
#'   The data frame has zero rows when no recorded counts match the
#'   selection.
#' @export
#' @examples
#' summarise_trash(
#'   trash_collections,
#'   wheels = "Mister Trash Wheel",
#'   years = c(2020, 2023)
#' )
#'
#' # Cigarette butts per collection for every wheel in 2022
#' summarise_trash(
#'   trash_collections,
#'   trash_types = "Cigarette Butts",
#'   years = c(2022, 2022)
#' )
summarise_trash <- function(data, wheels = NULL, trash_types = NULL, years = NULL) {
  required <- c("name", "year", "dumpster", "trash_type", "count")
  missing_cols <- setdiff(required, names(data))
  if (length(missing_cols) > 0) {
    stop("`data` is missing required column(s): ",
         paste(missing_cols, collapse = ", "), call. = FALSE)
  }
  if (!is.null(years) && (!is.numeric(years) || length(years) != 2)) {
    stop("`years` must be a numeric vector of length 2 (first and last year).",
         call. = FALSE)
  }
  
  # A missing count means "not recorded", not "zero items"
  data <- dplyr::filter(data, !is.na(count))
  
  if (!is.null(wheels)) {
    data <- dplyr::filter(data, name %in% wheels)
  }
  if (!is.null(trash_types)) {
    data <- dplyr::filter(data, trash_type %in% trash_types)
  }
  if (!is.null(years)) {
    data <- dplyr::filter(data, year >= min(years), year <= max(years))
  }
  
  data |>
    dplyr::group_by(name, year, trash_type) |>
    dplyr::summarise(
      collections = dplyr::n(),
      total_items = sum(count),
      items_per_collection = mean(count),
      .groups = "drop"
    )
}