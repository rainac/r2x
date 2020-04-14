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

test_that("test r2x", {
  l <- list(a=1,b=2,c='test')
  l <- list(a=l,a=1,b=2,b=l,c=l)
  x <- r2x(l)
  doc <- read_xml(x)
  y1 <- x2r(x)
  y2 <- x2r(doc)
  cat(sprintf('x=%s,y=%s\n',
              paste(deparse(y1),collapse=''),
              paste(deparse(y2),collapse='')))
  expect_true(identical(y1, y2))
  expect_true(TRUE)
  z <- read_xml(r2x(y1))
  expect_true(identical(y1, x2r(z)))
})

test_that("test r2x", {
  l <- list(a=1,b=2,c='test')
  l <- list(a=list(),a=1,b=2,b=list(),c=l)
  x <- r2x(l)
  doc <- read_xml(x)
  y1 <- x2r(x)
  expect_true(TRUE)
})

test_that("test r2x", {
  l <- list(a=1,b=2,c='test')
  l <- list(a=list(),a=1,b=2,b=list(),c=l)
  x <- r2x(l, namespace='http://example.com/xmlns/test/')
  doc <- read_xml(x)
  y1 <- x2r(x)
  show(doc)
  expect_true(TRUE)
})

test_that("test r2x", {
  l <- list(a=1,b=2,c='test')
  l <- list(a=list(),`ca:a`=1,b=2,b=list(),`ca:c`=l)
  x <- r2x(l, namespace='http://example.com/xmlns/test/', namespaces=list(ca = 'http://example.com/xmlns/test/ca/'))
  show(x)
  doc <- read_xml(x)
  y1 <- x2r(x)
  show(doc)
  expect_true(TRUE)
})
