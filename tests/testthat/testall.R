library('testthat')

context('all tests')

test_that('r2x works', {
    res <- test_dir('r2x')
    res <- as.data.frame(res)
    expect_true(all(res[,'failed'] == 0) && all(res[,'error'] == FALSE))
})
