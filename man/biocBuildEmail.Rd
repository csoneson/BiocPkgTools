% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/biocBuildEmail.R
\name{biocBuildEmail}
\alias{biocBuildEmail}
\alias{sentHistory}
\title{Create and copy e-mail package notification template to clipboard}
\usage{
biocBuildEmail(
  pkg,
  version = c("release", "devel"),
  PS = character(1L),
  dry.run = TRUE,
  emailTemplate = .getTemplatePath(),
  core.name = NULL,
  core.email = NULL,
  core.id = NULL,
  textOnly = FALSE,
  resend = FALSE,
  verbose = FALSE,
  credFile = "~/.blastula_creds"
)

sentHistory()
}
\arguments{
\item{pkg}{character(1) The name of the package in trouble}

\item{version}{character() A vector indicating which version of Bioconductor
the package is failing in (either 'release' or 'devel'; defaults to both)}

\item{PS}{character(1) Postscript, an additional note to the recipient of
the email (i.e., the package maintainer)}

\item{dry.run}{logical(1) Display the email without sending to the recipient.
It only works for HTML email reports and ignored when `textOnly=TRUE`}

\item{emailTemplate}{character(1) The path to the email template. The default
path lies in the 'inst' package folder.}

\item{core.name}{character(1) The full name of the core team member}

\item{core.email}{character(1) The Roswell Park email of the core team
member}

\item{core.id}{character(1) The internal identifier for the Roswell employee.
This ID usually matches `^[A-Z]{2}[0-9]{5}` for more recent identifiers.}

\item{textOnly}{logical(1) Whether to return the text of the email only.
This avoids the use of the 'blastula' package and adds the text to the
system clipboard if the `clipr` package is installed (default: FALSE)}

\item{resend}{logical(1) Whether to force a resend of the email}

\item{verbose}{logical(1) Whether to output full email information from
'smtp_send' (when `dry.run` is `FALSE` and 'blastula' is installed)}

\item{credFile}{character(1) An optional file generated by the
`blastula::create_smtp_creds_file` function containing email auth info
 (default: "~/.blastula_creds").}
}
\value{
A character string of the email
}
\description{
The \code{biocBuildEmail} function provides a template for notifying
maintainers of errors in the Bioconductor Build System (BBS). This
convenience function returns the body of the email from a template
within the package and provides a copy in the clipboard.
}
\section{sentHistory}{
 Check the history of emails sent
}

