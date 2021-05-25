# Create temporary directory for reproducible example
dir_tmp <- tempfile(pattern = "proj-")
dir.create(dir_tmp)
# browseURL(dir_tmp)

# usethis::proj_set(path = dir_tmp, force = TRUE)
# usethis::create_project(path = dir_tmp, rstudio = TRUE, open = FALSE)

# usethis::with_project(
withr::with_dir(
  dir_tmp,
  prepare_book(
    path = dir_tmp,
    template = system.file("book_template_example", package = "bookprep"),
    replacements = c(
      # replacements mandatory for the bookdown skeleton
      "book_title" = "My book",
      "author_name" = "Marion Louveaux",
      "creation_date" = "`r Sys.Date()`",
      "short_description" = "An example of book with {bookprep}.",
      # replacement specific to my template (variable in index.md)
      "index_title" = "Context"
    )
  )
)


test_that("prepare_book works", {
  expect_true(file.exists(file.path(dir_tmp, "index.Rmd")))

  # checks that Rproj exists
  rproj_path <- list.files(dir_tmp, pattern = "[.]Rproj$", full.names = TRUE)
  if (length(rproj_path) != 0){
    expect_length(rproj_path, 1)
    # Checks that build type is website in Rproj
    rproj_content <- readLines(rproj_path)
    expect_equal(rproj_content[14], "BuildType: Website")
  }
  # Checks that there is an extra.css file in the book template example
  css_path <- list.files(system.file("book_template_example", package = "bookprep"),
                         pattern = "extra[.]css$")
  expect_length(css_path, 1)
  # Checks that the extra.css is in the _output.yml 
  outputyml_path <- list.files(dir_tmp, pattern = "_output[.]yml$", full.names = TRUE) 
  outputyml_content <- readLines(outputyml_path)
  expect_length(grep(outputyml_content[2], pattern = "extra[.]css"), 1)
  
  
  # Checks that there is an extra.bib file in the book template example
  bib_path <- list.files(system.file("book_template_example", package = "bookprep"),
                         pattern = "extra[.]bib$")
  expect_length(bib_path, 1)
  # Checks that the extra.bib is in the index.Rmd    
  index_path <- list.files(dir_tmp, pattern = "index[.]Rmd$", full.names = TRUE) 
  index_content <- readLines(index_path)
  expect_length(grep(index_content[7], pattern = "extra[.]bib"), 1)
  
  
  # Checks that content of index.md has been copied in index.Rmd and index_title replaced 
  
  index_path <- list.files(dir_tmp, pattern = "index[.]Rmd$", full.names = TRUE) 
  index_content <- readLines(index_path)
  expect_equal(index_content[12], paste0("# ", "Context"))
  expect_equal(index_content[13], "")
  expect_equal(index_content[14], "Write here what you want to see in the <span class=\"red\">index</span>")
})


test_that("initialize_template gives error", {
  skip_if_translated()
  expect_error(object = prepare_book(path = dir_tmp,
                                     template = "non_existing_path"
                                     ),
               ".* directory does not exist."
               )
})
