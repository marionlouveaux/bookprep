# copy to a temporary file to avoid overwriting the package
index_tmp <- tempfile(pattern = "index-")

file.copy(from = system.file("book_skeleton/index.Rmd", package = "bookprep"), to = index_tmp)

index_modified <- find_and_replace(
  file = index_tmp,
  replacements = c(
    "book_title" = "My book",
    "author_name" = "Marion Louveaux",
    "creation_date" = "`r Sys.Date()`",
    "short_description" = "An example of book with {bookprep}.",
    "index_title" = "Context"
  )
)

index_lines <- readLines(index_modified)
test_that("find_and_replace works", {
  expect_equal(index_lines[2], 'title: \"My book\"')
  expect_equal(index_lines[3], 'author: "Marion Louveaux"')
})


test_that("find_and_replace gives error", {
  skip_if_translated()
  expect_error(
    object = find_and_replace(
      file = "non_existing_path",
      replacements = c(
        "book_title" = "My book",
        "author_name" = "Marion Louveaux",
        "creation_date" = "`r Sys.Date()`",
        "short_description" = "An example of book with {bookprep}.",
        "index_title" = "Context"
      )
    ), "The specified file does not exist."
  )
})
