#' Check the CRAN build report page and email a notification
#'
#' The \code{CRANstatus} function allows users to check the status of a package
#' and send an email report of any failures.
#'
#' @inheritParams biocBuildEmail
#'
#' @param to.mail The email of the CRAN report recipient
#'
#' @export
CRANstatus <-
    function(pkg, core.name = NULL, core.email = NULL, core.id = NULL,
        to.mail = "maintainer@bioconductor.org", dry.run = TRUE,
        emailTemplate = .getTemplatePath("cranreport")) {

    stopifnot(is.character(pkg), identical(length(pkg), 1L), !is.na(pkg))

    if (!requireNamespace("blastula", quietly = TRUE))
        stop("Install the 'blastula' package to send HTML emails or use\n",
            "  'textOnly=TRUE'")
    if (!requireNamespace("kableExtra", quietly = TRUE))
        stop("Install the 'kableExtra' package to create HTML tables")

    core.list <- .getUserInfo(core.email = core.email, core.name = core.name,
        core.id = core.id)
    core.name <- core.list[["core.name"]]
    core.email <- core.list[["core.email"]]
    core.id <- core.list[["core.id"]]


    URL <- paste0("https://cran.r-project.org/web/checks/check_results_",
        pkg, ".html")

    bfc <- .get_cache()
    rnameid <- paste0(pkg, "CheckResults")
    rid <- BiocFileCache::bfcquery(bfc, rnameid, "rname", exact = TRUE)$rid
    if (!length(rid))
        htmlfile <- BiocFileCache::bfcadd(bfc, rname = rnameid, rtype = "web",
            fpath = URL)
    else
        htmlfile <- BiocFileCache::bfcrpath(bfc, rids = rid)

    updater <- BiocFileCache::bfcneedsupdate(bfc, names(htmlfile))

    if (updater)
        BiocFileCache::bfcdownload(bfc, names(htmlfile), ask = FALSE)

    html <- xml2::read_html(htmlfile)
    cran_results <- rvest::html_table(html)[[1L]]

    status <- cran_results[["Status"]]

    mail <- paste0(readLines(emailTemplate), collapse = "\n")
    maildate <- format(Sys.time(), "%B %d, %Y")
    send <- sprintf(mail, pkg, maildate, pkg, pkg, "cran_results", URL)

    if ("ERROR" %in% toupper(status)) {

        titletext <- paste0(pkg, " has at least one ERROR")
        tfile <- tempfile(fileext = ".Rmd")
        writeLines(send, tfile)
        print(repmail <- blastula::render_email(tfile))
        if (!dry.run) {
            blastula::smtp_send(email = repmail,
                from = core.email, to = to.mail, subject = titletext,
                credentials = blastula::creds(
                    user = paste0(core.id, "@roswellpark.org"),
                    provider = "office365",
                    sender_name = core.name,
                    use_ssl = FALSE
                )
            )
            message("Email sent to: ", to.mail)
        }
        c(OK = FALSE)

    } else {

        c(OK = TRUE)
    }
}
