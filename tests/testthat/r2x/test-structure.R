library('r2x')
library('testthat')
library('xml2')

context('r2x/test-structure.R')

test_that("test r2x", {
    l <- list(a=1,b=2,c='test')
    attr(l, 'version') <- '1.0'
    x <- r2x(l, name="t1")
#    cat(x)
    doc <- read_xml(x)
#    show(doc)
    a <- xml_attrs(doc)
#    show(a)
    expect_true(length(a) == 1)
    expect_true(names(a) == 'version')
    expect_true(xml_name(doc) == 't1')
})

test_that("test inv r2x", {
    l <- list(a=1,b=2,c='test')
    attr(l, 'version') <- '1.0'
    x <- r2x(l, name="t1")
    #    cat(x)
    doc <- read_xml(x)

    k1 <- x2r(x)
    # show(k1)

    expect_true(attr(k1, 'version') == '1.0')
    expect_true(all(names(k1) == c('a', 'b', 'c')))
})

test_that("test numeric vectors", {
    l <- list(a=1:5,b=c(2, 3, 1, 2, 0, 1),c='1 test')
    attr(l, 'version') <- '1.0'
    x <- r2x(l, name="t1")
    ## cat(x)
    doc <- read_xml(x)

    k1 <- x2r(x)
    ## show(k1)

    expect_true(all(l$a == k1$a))
    expect_true(identical(l$b, k1$b))
    expect_true(identical(l$c, k1$c))
})
