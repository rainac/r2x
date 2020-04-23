renderval <- function(obj) {
    paste(if (is.character(obj)) {
              sprintf('%s', obj)
          } else if (is.numeric(obj)) {
              sprintf('%.16g', obj)
          } else {
              sprintf('%s', obj)
          }, collapse=' ')
}

#' Convert named list to XML document
#'
#' Converts a named list directly to an XML document. The list names
#' are converted to XML element names. Attributes are mapped to XML
#' attributes.
#'
#' The conversion is done by generating XML text directly. If a parsed
#' XML document is desired use read_xml().
#'
#' The inverse operation is called x2r.
#'
#' @param obj Named list
#' @param name Name of the top-level element
#' @param namespace Set namespace URI of XML elements in the default namespace
#' @param namespaces Named list of namespace URIs for setting namespace prefixes
#' @return XML document in text form.
#' @examples
#' mylist <- list(a=list(b=1,b=2.0))
#' doctext <- r2x(mylist)
#' doc <- read_xml(doctext)
r2x <- function(obj, name='r2x', namespace = NULL, namespaces = list()) {
    tag <- sprintf('%s', name)
    s <- sprintf('<%s', tag, class(obj))
    if (!is.null(namespace)) {
        s <- c(s, sprintf(' xmlns="%s"', namespace))
    }
    if (length(namespaces)>0) {
        s <- c(s, ' ', paste(lapply(names(namespaces), function(n) sprintf('xmlns:%s', n)),
                             lapply(namespaces, function(n) sprintf('"%s"', n)),
                             collapse=' ', sep='='))
    }
    fullnames <- names(obj)
    fullnames <- lapply(fullnames, function(n) {
        if (nchar(n) == 0) tag
        else n
    })

    attrstr <- ''
    avals <- attributes(obj)
    if (!is.null(avals)) {
        anames <- names(avals)
        anames <- anames[anames != 'names']
        attribs <- lapply(anames, function(n) {
            sub <- avals[[n]]
            sprintf('%s="%s"', n, renderval(sub))
        })
        attrstr <- paste(attribs, collapse=' ')
    }

    if (is.list(obj)) {
        s <- c(s, sprintf(' %s>', attrstr))
        if (length(obj)>0) {
            ns <- names(obj)
            subs <- lapply(1:length(obj), function(n) {
                name <- ns[[n]]
                sub <- obj[[n]]
                r2x(sub, name)
            })
            s <- c(s, paste0(subs, collapse=''))
        }
    } else {
        s <- c(s, sprintf(' class="%s" %s>', class(obj), attrstr))
        s <- c(s, renderval(obj))
    }
    s <- c(s, sprintf('</%s>', tag))
    paste0(s, collapse='')
}

element <- seta <- function(..., val) {
    r <- val
    alist <- list(...)
    attributes(r) <- append(attributes(r), alist)
    r
}

xsltproc <- function(xslurl, xmlurl) {
    xslfurl <- system.file(sprintf("xsl/%s", xslurl), package = "r2x")
    xsldoc <- xml2::read_xml(xslfurl)
    if ('xml_document' %in% class(xmlurl)) {
        xdoc   <- xmlurl
        xmlurl <- '<document>'
    } else {
        xdoc   <- xml2::read_xml(xmlurl)
    }

    res <- xslt::xml_xslt(xdoc, xsldoc)
    res
}

xsltcodeeval <- function(xsl, xml) {
    code <- xsltproc(xsl, xml)
    estr <- NULL
    local({
        tryCatch({
            e <- eval(parse(text=code))
            estr <<- e
        }, error = function(e) {
            cat(sprintf('error: %s in code %s\n', e, code))
        })
    })
    estr
}

postprocess <- function(l) {
    atts <- attributes(l)
    if (!is.null(atts)) {
        rem <- names(atts) %in% c('class')
        atts <- atts[!rem]
    }
    l <- if (is.list(l)) {
        lapply(l, postprocess)
    } else {
        tlist <- strsplit(l, ' ')[[1]]
        vlist <- suppressWarnings(as.numeric(tlist))
        if (!any(is.na(vlist))) {
            vlist
        } else {
            l
        }
    }
    if (!is.null(atts)) {
        attributes(l) <- atts
    }
    l
}

#' Convert XML document to named list in R code
#'
#' Converts an XML document to a named list directly, in R source
#' code.  This is done by naming the elements the same as the names of
#' the list. XML attributes are mapped to R attributes.
#'
#' The conversion is done by an XSLT stylesheet, which is why the xslt
#' package is required.
#'
#' The generated source code is also used by the x2r function, which
#' also parses and evaluates code returning the list.
#'
#' @param doc XML document in parsed or text form.
#' @return Named list representing the document, R source code.
#' @examples
#' doctext <- '<a><b type="int">1</b><b type="float">2.0</b></a>'
#' doc <- read_xml(doctext)
#' r2x_deparse(doc)
r2x_deparse <- function(doc) {
    if (is.character(doc) && nchar(doc) < 1000 && file.exists(doc)) {
        doc <- xml2::read_xml(doc)
    }
    xsltproc('to-R-structure-txt.xsl', doc)
}

#' Convert XML document to named list
#'
#' Converts an XML document to a named list directly. This is done by
#' naming the elements the same as the names of the list. XML
#' attributes are mapped to R attributes.
#'
#' The conversion is done by an XSLT stylesheet, which is why the xslt
#' package is required. The XSLT generates the R code of the document
#' structure, which is sourced.
#'
#' The generated R source code is available by calling
#' r2x_deparse. The inverse operation is called r2x.
#'
#' @param doc XML document in parsed or text form.
#' @return Named list representing the document.
#' @examples
#' doctext <- '<a><b type="int">1</b><b type="float">2.0</b></a>'
#' doc <- read_xml(doctext)
#' x2r(doc)
x2r <- function(doc) {
    if (is.character(doc) && nchar(doc) < 1000 && file.exists(doc)) {
        doc <- xml2::read_xml(doc)
    }
    l <- xsltcodeeval('to-R-structure-txt.xsl', doc)
    l <- postprocess(l)
}
