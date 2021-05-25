# Create temporary directory for reproducible example
dir_tmp <- tempfile(pattern = "proj-")
dir.create(dir_tmp)
# browseURL(dir_tmp)

initialize_template(path = dir_tmp, 
                    chapters = c("Introduction", "Material and Methods",
                                 "Results", "Discussion"),
                                references = NULL)

test_that("initialize_template works", {
  expect_true(file.exists(file.path(dir_tmp, "00-Introduction.Rmd")))
  expect_length(list.files(dir_tmp), 4)
  results_content <- readLines(file.path(dir_tmp, "02-Results.Rmd"))
  expect_equal(results_content[1], paste0("# ", "Results"))
})
