library('testthat')

res <- test_dir('r2x')
res <- as.data.frame(res)
if (all(res[,'failed'] == 0) && all(res[,'error'] == FALSE)) {
} else {
  stop('failed')
}
