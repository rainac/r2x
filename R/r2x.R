renderval <- function(obj) {
    if (is.character(obj)) {
        sprintf('%s', obj)
    } else if (is.numeric(obj)) {
        sprintf('%g', obj)
    } else {
        sprintf('%s', paste0(obj))
    }
}

r2x <- function(obj, name='r2x') {
    tag <- sprintf('%s', name)
    s <- sprintf('<%s class="%s"', tag, class(obj))
    fullnames <- names(obj)
    fullnames <- lapply(fullnames, function(n) {
        if (nchar(n) == 0) tag
        else n
    })

    if (is.list(obj)) {
        asAttr <- sapply(obj, function(sub) {
            !is.list(sub)
        })
        avals <- obj[asAttr]
        ovals <- obj[!asAttr]
        attribs <- lapply(names(avals), function(n) {
            sub <- avals[[n]]
            sprintf('%s="%s"', n, renderval(sub))
        })
        attr <- paste(attribs, collapse=' ')
        s <- c(s, sprintf(' %s>', attr))
        subs <- lapply(names(ovals), function(n) {
            sub <- ovals[[n]]
            r2x(sub, n)
        })
        s <- c(s, paste0(subs, collapse=''))
    } else {
        s <- c(s, sprintf('>'))
        s <- c(s, renderval(obj))
    }
    s <- c(s, sprintf('</%s>', tag))
    paste0(s, collapse='')
}


xsltproc <- function(xslurl, xmlurl) {
    xslfurl <- system.file(sprintf("xsl/%s", xslurl), package = "r2x")
    xsldoc <- read_xml(xslfurl)
    if ('xml_document' %in% class(xmlurl)) {
        xdoc   <- xmlurl
        xmlurl <- '<document>'
    } else {
        xdoc   <- read_xml(xmlurl)
    }

    res <- xml_xslt(xdoc, xsldoc)
    res
}

xsltcodeeval <- function(xsl, xml) {
    code <- xsltproc(xsl, xml)
    show(code)
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

x2r <- function(doc) {
    if (is.character(doc) && nchar(doc) < 1000 && file.exists(doc)) {
        doc <- read_xml(doc)
    }
    xsltcodeeval('to-R-structure-txt.xsl', doc)
}
