#' Launch the Trash Wheel explorer app
#'
#' Opens a Shiny app for exploring which types of rubbish each of
#' Baltimore's Trash Wheels collects per dumpster load, and how this has
#' changed over the years. The app uses the packaged [trash_collections]
#' data and [summarise_trash()].
#'
#' @return No return value; called for its side effect of launching the app.
#' @export
#' @importFrom bslib bs_theme
#' @importFrom ggplot2 ggplot
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  app_dir <- system.file("app", package = "trashwheelexplorer")
  if (app_dir == "") {
    stop("Could not find the app. Try re-installing `trashwheelexplorer`.",
         call. = FALSE)
  }
  shiny::runApp(app_dir)
}