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
