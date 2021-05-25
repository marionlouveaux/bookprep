# Create temporary directory for reproducible example
dir_tmp <- tempfile(pattern = "proj-")
dir.create(dir_tmp)
# browseURL(dir_tmp)

# prepare_files() requires a directory with some files inside to look for replacements
file.copy(from = system.file("book_skeleton", package = "bookprep"), to = dir_tmp, recursive = TRUE)

modified_files <- prepare_files(
  path = dir_tmp,
  replacements = c(
    "book_title" = "My book",
    "author_name" = "Marion Louveaux",
    "creation_date" = "`r Sys.Date()`",
    "short_description" = "An example of book with {bookprep}.",
    "index_title" = "Context"
  )
)


test_that("prepare_files works", {
  # index modified
  index_lines <- modified_files[grep(pattern = "index[.]Rmd", x = modified_files)]
  index_content <- readLines(index_lines)
  expect_equal(index_content[3], 'author: "Marion Louveaux"')

  # _output.yml modified
  output_lines <- modified_files[grep(pattern = "_output[.]yml", x = modified_files)]
  output_content <- readLines(output_lines)
  expect_equal(output_content[6], '        <li><a href=\"./\">My book</a></li>')
})
