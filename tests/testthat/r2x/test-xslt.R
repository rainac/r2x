library('testthat')
library('xml2')
library('r2x')
library('xslt')

context('r2x/test-xslt.R')

test_that("test r2x xslt transform", {

    copy_xsl <- element(
        version = '1.0',
        val = list(
            `xsl:output` = element(
                method = 'xml'
            ),
            `xsl:template` = element(
                match = '/',
                val = list(
                    `xsl:apply-templates` = element(
                        select = 'node()'
                    )
                )
            ),
            `xsl:template` = element(
                match = '@*|node()',
                val = list(
                    `xsl:copy` = list(
                        `xsl:apply-templates` = element(
                            select = '@*|node()'
                        )
                    )
                )
            )
        )
    )

    as.xslt <- function(xsldef) {
        read_xml(r2x(xsldef,
                     name = 'xsl:stylesheet',
                     namespaces = list(xsl = 'http://www.w3.org/1999/XSL/Transform')))
    }

    example_xml <- element(a=1,b=2,c=3,
                           val=list(
                               e1 = element(a=2,b=3,c=4,
                                            val=list(e2 = element(a=2,b=3,c=4)))))

    xslt_doc <- as.xslt(copy_xsl)
    xml_doc <- read_xml(r2x(example_xml))
    result <- xml_xslt(xml_doc, xslt_doc)

    expect_true(identical(r2x_deparse(xml_doc),
                          r2x_deparse(result)))

})
