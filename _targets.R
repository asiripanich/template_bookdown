# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("bookdown", "here"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Load the R scripts with your custom functions:
for (file in list.files("R", full.names = TRUE)) source(file)
# source("other_functions.R") # Source other scripts as needed. # nolint



# Replace the target list below with your own:
data_targets <- list(
  tar_target(
    name = data,
    command = tibble(x = rnorm(100), y = rnorm(100))
    #   format = "feather" # efficient storage of large data frames # nolint
  ),
  tar_target(
    name = model,
    command = lm(y ~ x, data = data)
  )
)

# Targets necessary to build the paper
global_paper_deps <-
  get_paper_deps()

paper_targets <- list(
  tar_target(
    config_file,
    "_bookdown.yml",
    format = "file"
  ),
  tar_file(
    paper_deps,
    unlist(global_paper_deps)
  ),
  tar_target(
    paper,
    render_with_deps(
      input = here::here(),
      config_file = config_file,
      deps = c(
        !!tar_knitr_deps_expr(global_paper_deps$rmd),
        paper_deps
      )
    )
  )
)

# run all targets
list(
  data = data_targets,
  paper = paper_targets
)
