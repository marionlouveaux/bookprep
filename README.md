
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bookprep

<!-- badges: start -->

![GitHub release (latest by
date)](https://img.shields.io/github/v/release/marionlouveaux/bookprep?style=plastic)
![GitHub](https://img.shields.io/github/license/marionlouveaux/bookprep?style=plastic)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4806181.svg)](https://doi.org/10.5281/zenodo.4806181)
[![R build
status](https://github.com/marionlouveaux/bookprep/workflows/R-CMD-check/badge.svg)](https://github.com/marionlouveaux/bookprep/actions)
[![Codecov test
coverage](https://codecov.io/gh/marionlouveaux/bookprep/branch/master/graph/badge.svg)](https://codecov.io/gh/marionlouveaux/bookprep?branch=master)
<!-- badges: end -->

<!-- Short description -->

The goal of {bookprep} is to prepare a {bookdown} project from a
customizable bookdown skeleton and, if needed, a template for the
chapters. {bookprep} helps creating reproducible yet flexible bookdown
projects, for instance to deliver data analyses to customers following a
standardized format.

## Installation

<!--

You can install the released version of bookprep from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("bookprep")
```
-->

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("marionlouveaux/bookprep")
```

## Example

<!-- Brief demo usage -->

``` r
library(bookprep)

# Create temporary directory for reproducible example
dir_tmp <- tempfile(pattern = "proj-")
dir.create(dir_tmp)
# browseURL(dir_tmp)

prepare_book(
  path = dir_tmp,
  template = system.file("book_template_example", package = "bookprep"),
  replacements = c(
    # replacements mandatory for the bookdown skeleton
    "book_title" = "My book",
    "author_name" = "Marion Louveaux",
    "creation_date" = "`r Sys.Date()`",
    "short_description" = "An example of book with {bookprep}.",
    # replacement specific to my template that you can add if you want
    "index_title" = "Context"
  )
)
#> v Setting active project to 'C:/Users/Marion/AppData/Local/Temp/Rtmp08qsHE/proj-56bc2b97f3b'
#> v Creating 'R/'
#> v Writing a sentinel file '.here'
#> * Build robust paths within your project via `here::here()`
#> * Learn more at <https://here.r-lib.org>
#> v Setting active project to '<no active project>'
#> [1] "C:\\Users\\Marion\\AppData\\Local\\Temp\\Rtmp08qsHE\\proj-56bc2b97f3b/_bookdown.yml"     
#> [2] "C:\\Users\\Marion\\AppData\\Local\\Temp\\Rtmp08qsHE\\proj-56bc2b97f3b/_output.yml"       
#> [3] "C:\\Users\\Marion\\AppData\\Local\\Temp\\Rtmp08qsHE\\proj-56bc2b97f3b/01-exploration.Rmd"
#> [4] "C:\\Users\\Marion\\AppData\\Local\\Temp\\Rtmp08qsHE\\proj-56bc2b97f3b/02-results.Rmd"    
#> [5] "C:\\Users\\Marion\\AppData\\Local\\Temp\\Rtmp08qsHE\\proj-56bc2b97f3b/index.Rmd"         
#> [6] "C:\\Users\\Marion\\AppData\\Local\\Temp\\Rtmp08qsHE\\proj-56bc2b97f3b/README.md"
```

## See also

<!-- Related packages -->

{bookdown}: <https://bookdown.org/>

## How to cite

Please cite as:  
Marion Louveaux. (2021, May 26). bookprep: an R package to reproducibly
prepare a {bookdown} project from a customizable skeleton and a template
(Version v1.0.0). Zenodo. <http://doi.org/10.5281/zenodo.4806181>

## Code of Conduct

Please note that the bookprep project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
