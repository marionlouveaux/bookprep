#' Initialize a book template with named chapters and base content 
#'
#' @param path where to create the template     
#' @param chapters titles of Rmd files to include in the template    
#' @param references title of the references Rmd or NULL         
#' @importFrom xfun write_utf8
#'
#' @return used for side effect: file creation in path
#' @export
#'
#' @examples
#' # Create temporary directory for reproducible example
#' dir_tmp <- tempfile(pattern = "proj-")
#' dir.create(dir_tmp)
#' # browseURL(dir_tmp)
#' 
#' initialize_template(path = dir_tmp, 
#'                     chapters = c("Introduction", "Material and Methods",
#'                                  "Results", "Discussion"),
#'                                 references = NULL)
initialize_template <- function(path, chapters = c("Preface", "Introduction"),
                                references = "References") {
  rmd_tmp <- c(chapters, references)
  rmd_files <- sprintf("%02d-%s.Rmd", seq_along(rmd_tmp) -
    1, rmd_tmp)

  titles <- c(chapters, sprintf(
    "`r if (knitr::is_html_output()) '# %s {-}'`",
    references
  ))
  titles_first_level <- paste("#", titles)

  for (i in seq_along(rmd_files)) {
    file_tmp <- rmd_files[i]
    if (file.exists(file.path(path, file_tmp))) {
      stop("The file ", file_tmp, " exists.")
    } else {
      write_utf8(titles_first_level[i], con = file.path(path, file_tmp))
    }
  }
}
