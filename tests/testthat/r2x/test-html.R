library('testthat')
library('xml2')
library('r2x')

context('r2x/test-html.R')

test_that("test HTML5 doc", {

    N <- 50
    A <- matrix(rnorm(1:(N*N)), N, N)

    png(imgfile <- tempfile())
    plot(log(abs(eigen(A)$values)), type = 'l')
    dev.off()

    imgdata <- readBin(imgfile, 'raw', file.size(imgfile))
    unlink(imgfile)

    imgdata <- base64enc::base64encode(imgdata)

    htmldef <- element(
        lang = 'en',
        style = 'font-family: sans-serif',
        list(
            head = list(
                title = 'Test',
                style = '
                  h1 { color: black; }
                  h2 { color: blue; }
                  h3 { color: green; }
                 '
            ),
            body = list(
                div = list(
                    h2 = 'First Section',
                    p = 'First paragraph.',
                    div = element(
                        style = 'text-align: center',
                        list(
                            img = element(
                                width='72%',
                                src = sprintf('data:image/png;base64,%s', imgdata)
                            ),
                            p = element(
                                style = 'font-style: italic',
                                'Figure caption.')
                        )
                    )
                ),
                div = list(
                    h2 = 'Second section',
                    p = 'Second section, first paragraph',
                    p = 'Second section, second paragraph'
                )
            )
        )
    )

    html <- r2x(htmldef,
                name = 'html',
                namespace = 'http://www.w3.org/1999/xhtml')

    fl <- strsplit(html, split = '\n')[[1]][[1]]

    expect_true(grepl('lang="en"', fl))

    as.html.file <- function(html) {
        writeLines(html,
                   con = (outfile <- tempfile('rep', fileext = '.html')))
        outfile
    }

    viewer = getOption('viewer')

    if (!is.null(viewer)) {
        viewer(outfile <- as.html.file(html))
        Sys.sleep(0.2)
        unlink(outfile)
    }

    expect_true(TRUE)
})
