#' Modify all variables in files from the book skeleton
#'
#' @param path path to directory (skeleton) containing all files to modify
#' @param pattern regex to identify files to prepare (by default, all Rmd, yml and md files)
#' @inheritParams find_and_replace
#' @importFrom purrr map
#'
#' @return path from each modified file
#'
#' @examples
#'
#' # Create temporary directory for reproducible example
#' dir_tmp <- tempfile(pattern = "proj-")
#' dir.create(dir_tmp)
#' # browseURL(dir_tmp)
#' 
#' # prepare_files() requires a directory with some files inside to look for replacements
#' file.copy(from = system.file("book_skeleton", package = "bookprep"), to = dir_tmp, recursive = TRUE)
#' 
#' bookprep:::prepare_files(
#'   path = dir_tmp,
#'   replacements = c(
#'     "book_title" = "My book",
#'     "author_name" = "Marion Louveaux",
#'     "creation_date" = "`r Sys.Date()`",
#'     "short_description" = "An example of book with {bookprep}.",
#'     "index_title" = "Context"
#'   )
#' )
prepare_files <- function(path, replacements = c(
                            "book_title" = "My book",
                            "author_name" = "Marion Louveaux",
                            "creation_date" = "`r Sys.Date()`",
                            "short_description" = "An example of book with {bookprep}.",
                            "index_title" = "Context"
                          ),
                          pattern = "[.]Rmd$|[.]yml$|[.]md$") {
  all_files_in_path <- list.files(path, full.names = TRUE, recursive = TRUE)
  files_to_modify <- grep(
    pattern = pattern,
    all_files_in_path
  )
  map(
    all_files_in_path[files_to_modify],
    ~ find_and_replace(file = .x, replacements = replacements)
  )
  all_files_in_path[files_to_modify]
}
