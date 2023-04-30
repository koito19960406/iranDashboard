#' Create labels for the map
#'
#' @param selected_data A reactive object containing the selected_data data.
#'
#' @return A list of HTML formatted labels.
#' @importFrom glue glue
#' @importFrom htmltools HTML
create_labels <- function(selected_data, selected_year) {
  paste0(glue("<b>Province Name</b>: { selected_data$data$province_name } </br>"),
         glue("<b>{selected_data$subindicator_readable}: </b>"), " ",
         glue("{ round(selected_data$data[[selected_year]], 3)}"), sep = "") %>%
    lapply(HTML)
}

#' Create bins for the map
#'
#' @param selected_data A reactive object containing the selected_data data.
#' @param num_bin Number of bins
#'
#' @return A vector of bins.
#' @importFrom stats quantile
create_bins <- function(selected_data, num_bin, selected_year) {
  probs <- seq(0, 1, length.out = num_bin + 1)
  bins <- quantile(selected_data$data[[selected_year]], probs, na.rm = TRUE, names = FALSE)
  # Check for non-unique breaks and correct them
  if (length(unique(bins)) != length(bins)) {
    cat("Non-unique breaks detected, correcting...\n")
    bins <- seq(min(selected_data$data[[selected_year]], na.rm = TRUE),
                max(selected_data$data[[selected_year]], na.rm = TRUE),
                length.out = num_bin + 1)
  }
  return(bins)
}

#' helpers
#'
#' @description A fct function
#'
#' @param vec a vector
#' @return The return value, if any, from executing the function.
#'
#' @importFrom stats na.omit
#' @noRd
round_vec <- function(vec) {
  vec <- na.omit(vec)
  if (length(vec)>1){
    # Determine the minimum difference between elements in the vector
    min_difference <- min(diff(sort(vec)))

    # Determine the number of decimal places needed to show the minimum difference
    decimal_places <- max(0, -floor(log10(min_difference)))
    return(decimal_places)
  } else {
    return(nchar(vec[1])-2)
  }
  # # Find the magnitude of the largest element in the vector
  # max_magnitude <- max(abs(vec))
  #
  # # Adjust the number of decimal places based on the magnitude of the largest element
  # decimal_places <- min(decimal_places, floor(log10(max_magnitude)))
  #
  # # Return decimal_places
  # return(decimal_places)
}

