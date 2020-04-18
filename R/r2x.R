renderval <- function(obj) {
    paste(if (is.character(obj)) {
              sprintf('%s', obj)
          } else if (is.numeric(obj)) {
              sprintf('%g', obj)
          } else {
              sprintf('%s', obj)
          }, collapse=' ')
}

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

setattr <- function(val, alist) {
    r <- val
    lapply(names(alist), function(n) attr(r, n) <<- alist[[n]])
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
        if (suppressWarnings(!is.na(as.numeric(l)))) {
            as.numeric(l)
        } else {
            l
        }
    }
    if (!is.null(atts)) {
        attributes(l) <- atts
    }
    l
}

x2r <- function(doc) {
    if (is.character(doc) && nchar(doc) < 1000 && file.exists(doc)) {
        doc <- xml2::read_xml(doc)
    }
    l <- xsltcodeeval('to-R-structure-txt.xsl', doc)
    l <- postprocess(l)
}
