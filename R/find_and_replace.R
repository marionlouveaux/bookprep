#' Find and replace all variables in one of the files of the book skeleton
#'
#' @param file path of a file from skeleton: _bookdown.yml, _output.yml, index.Rmd, README.md
#' @param replacements a vector of correspondences between an input and an output. Input is fixed and corresponds to: book_title, author_name, creation_date, short_description and index_title
#' @importFrom stringr str_replace_all
#'
#' @return path of the modified file
#' @export
#'
#' @examples
#' # copy to a temporary file to avoid overwriting the package
#' index_tmp <- tempfile(pattern = "index-")
#' 
#' file.copy(from = system.file("book_skeleton/index.Rmd", package = "bookprep"), to = index_tmp)
#' 
#' find_and_replace(
#'   file = index_tmp,
#'   replacements = c(
#'     "book_title" = "My book",
#'     "author_name" = "Marion Louveaux",
#'     "creation_date" = "`r Sys.Date()`",
#'     "short_description" = "An example of book with {bookprep}.",
#'     "index_title" = "Context"
#'   )
#' )
find_and_replace <- function(file, replacements = c(
                               "book_title" = "My book",
                               "author_name" = "Marion Louveaux",
                               "creation_date" = "`r Sys.Date()`",
                               "short_description" = "An example of book with {bookprep}.",
                               "index_title" = "Context"
                             )) {
  file <- normalizePath(file, mustWork = FALSE)
  if (!file.exists(file)) {
    stop("The specified file does not exist.")
  }

  original_text <- readLines(con = file)
  modified_text <- str_replace_all(
    string = original_text,
    replacements
  )

  writeLines(enc2utf8(modified_text), con = file)
  file
}
