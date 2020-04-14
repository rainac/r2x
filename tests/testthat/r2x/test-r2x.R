library('r2x')
library('testthat')
library('xml2')

test_that("test r2x", {
    l <- list(a=1,b=2,c='test')
    x <- r2x(l)
    doc <- read_xml(x)
    show(doc)
    expect_true(TRUE)
})

test_that("test r2x", {
    l <- list(a=1,b=2,c='test')
    l <- list(a=l,b=l,c=l)
    x <- r2x(l)
    show(x)
    doc <- read_xml(x)
    show(doc)
    expect_true(TRUE)
})

test_that("test r2x", {
  l <- list(a=1,b=2,c='test')
  l <- list(a=l,a=1,b=2,b=l,c=l)
  x <- r2x(l)
  show(x)
  doc <- read_xml(x)
  show(doc)
  expect_true(TRUE)
})
