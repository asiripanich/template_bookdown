#' @title Render bookdown and force Rmd file dependencies
#' @param input
#' @param config_file
#' @param output_format
#' @return
#' @author Shir Dekel
#' @url https://github.dev/shirdekel/phd_thesis
#' @export
render_with_deps <- function(input,
                             config_file,
                             deps) {
  bookdown::render_book(
    input = input,
    config_file = config_file,
    output_format = "all"
  )

#   file.remove(list.files(pattern = "*\\.(log|mtc\\d*|maf|aux|bcf|lof|lot|out|toc)$"))

  "compiled_paper"
}

get_paper_deps <- function() {
  rmd <-
    here::here("_bookdown.yml") |>
    yaml::read_yaml() |>
    purrr::pluck("rmd_files")

  output <- here::here("_output.yml")

  tibble::lst(rmd, output)
}