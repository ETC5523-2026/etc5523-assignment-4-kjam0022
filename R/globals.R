# Column names used inside dplyr calls in summarise_trash(). They are not
# real variables, so we declare them to keep R CMD check quiet.
#' @importFrom utils globalVariables
NULL

utils::globalVariables(c("count", "name", "trash_type", "year"))