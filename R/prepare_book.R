#' Prepare customised bookdown from skeleton and template
#' This function creates an Rstudio project in path, sets build type to "website", copies the content of book_skeleton at the root of the project, copies all files from the book template, modifies pre-defined variable book_title, author_name, creation_date, as well as any variable added by the user in replacements (index_title, index_content...), and inserts the content of index.txt in index.Rmd (here containing the user defined variables index_title and index_content).   
#'
#' @param path where to create the bookdown
#' @param template path to directory containing template files for chapters and index content
#' @inheritParams find_and_replace
#' @inheritParams prepare_files
#' @importFrom usethis create_project
#' @importFrom stringr str_replace
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
#' prepare_book(
#'   path = dir_tmp,
#'   template = system.file("book_template_example", package = "bookprep"),
#'   replacements = c(
#'     # replacements mandatory for the bookdown skeleton
#'     "book_title" = "My book",
#'     "author_name" = "Marion Louveaux",
#'     "creation_date" = "`r Sys.Date()`",
#'     "short_description" = "An example of book with {bookprep}.",
#'     # replacement specific to my template that you can add if you want
#'     "index_title" = "Context"
#'   )
#' )
prepare_book <- function(
                         path,
                         replacements = c(
                           "book_title" = "My book",
                           "author_name" = "Marion Louveaux",
                           "creation_date" = "`r Sys.Date()`",
                           "short_description" = "An example of book with {bookprep}.",
                           "index_title" = "Context"
                         ),
                         template = system.file("book_template_example", package = "bookprep"),
                         pattern = "[.]Rmd$|[.]yml$|[.]md$") {
  # Create project
  path <- normalizePath(path)
  create_project(path = path, open = FALSE)

  # Modify buildType: "BuildType: Package" to "BuildType: Website"
  rproj_path <- list.files(path, pattern = "[.]Rproj$", full.names = TRUE)
  if (length(rproj_path) != 0) { #rstudioapi available
    proj_lines <- readLines(rproj_path[1])
    proj_lines_modified <- str_replace(
      string = proj_lines,
      pattern = "BuildType: Package",
      replacement = "BuildType: Website"
    )
    writeLines(text = proj_lines_modified, con = list.files(path, pattern = "[.]Rproj$", full.names = TRUE))
  }

  # Add all files from book skeleton
  skeleton_dir <- system.file("book_skeleton", package = "bookprep")
  file.copy(from = list.files(skeleton_dir, full.names = TRUE), to = path, recursive = TRUE)

  # Add all files from book template (Rmd, css...) except index
  if (!dir.exists(template)) { # by default use the template of the package
    stop(template, " directory does not exist.") # means that user provided a incorrect path to a custom template
  }
  all_files_wo_index <- list.files(normalizePath(template), full.names = TRUE)
  all_files_wo_index <- all_files_wo_index[!grepl("^index", basename(all_files_wo_index))]
  file.copy(from = all_files_wo_index, to = path, recursive = TRUE)

  # Detect css files and modify _output.yml
  extra_css <- basename(all_files_wo_index)[grepl("[.]css$", basename(all_files_wo_index))]
  if (length(extra_css) != 0) {
    output_lines <- readLines(file.path(path, "_output.yml"))
    output_modified <- str_replace(
      string = output_lines,
      pattern = "css: style.css",
      replacement = paste0(
        "css: [style.css, ",
        paste(extra_css, collapse = ","), "]"
      )
    )
    writeLines(text = output_modified, con = file.path(path, "_output.yml"))
  }

  # Copy content from index.md or index.txt
  # NB: this content can contain variables such as index_title and index_content
  index_txt <- grep(
    pattern = "index[.](txt|md)$",
    list.files(template)
  )
  index_content_from_txt <- readLines(list.files(template, full.names = TRUE)[index_txt])
  index_rmd_path <- list.files(path, pattern = "^index[.]Rmd$", full.names = TRUE)

  # Concatenate and write current index.Rmd with content from index.md or index.txt
  new_index_content <- c(
    readLines(index_rmd_path),
    index_content_from_txt
  )
  writeLines(enc2utf8(new_index_content), con = index_rmd_path)

  # Modify files for replacements
  prepare_files(
    path = path,
    replacements = replacements,
    pattern = pattern
  )
}
