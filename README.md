
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scrap

The scrap package is a collection of useful R functions and code
snippets. These are pieces I either wrote or (most likely) I
*discovered* on StackOverflow and that I found useful in multiple
occasions (\> 3) in my personal or professional projects.

## Installation

You can install scrap from github with:

``` r
# install.packages("devtools")
devtools::install_github("espinielli/scrap")
```

## Building the documentation

### Development

In order to build the relevant `pkgdown` web pages while developing,
execute the following code:

``` r

# How to build the pakgdown from behind proxied Internet
library(withr)
library(pkgdown)

with_options(list(pkgdown.internet = FALSE),
             build_site())
```
