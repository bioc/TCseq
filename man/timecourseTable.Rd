% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timecourseTable.R
\name{timecourseTable}
\alias{timecourseTable}
\title{constructs time course table for clustering analysis}
\usage{
timecourseTable(
  object,
  value = "expression",
  control.group = NULL,
  lib.norm = TRUE,
  norm.method = "rpkm",
  subset = NULL,
  filter = FALSE,
  pvalue = "fdr",
  pvalue.threshold = 0.05,
  abs.fold = 2,
  direction = "both",
  ...
)
}
\arguments{
\item{object}{a \code{TCA} object returned by \code{DBanalysis}.}

\item{value}{a character string, either "\code{expression}" or
"\code{FC}". "\code{expression}" is the mean normalized read
counts of replicates, "\code{FC}" is the log2-fold changes
compared to the first time point.}

\item{control.group}{a character string giving the time point to 
be compared with, i.e., the denominator in the fold changes. It 
should match one of the time points in the \code{design} table 
in the \code{TCA} object.}

\item{lib.norm}{logical indicating whether or not use effective
library size (see "Details" in \code{\link{counts}}).}

\item{norm.method}{a character string specifying the normalization
method if \code{value} is "\code{expression}"}

\item{subset}{an optinal character vector giving a subset of
genomic features, if not NULL, time course table is generated
for only this subset of genomic features.}

\item{filter}{logical, whether to drop the genomic features
shows no significant changes (defined by \code{pvalue},
\code{pvalue.threshold},\code{abs.fold} and \code{direction})
between any two time points.}

\item{pvalue}{character string specify the type of p-values:
"\code{none}" is unadjusted p-value or one of adjusted p-value 
"\code{holm}", "\code{hochberg}", "\code{hommel}", "\code{bonferroni}", 
"\code{BH}", "\code{BY}", "\code{fdr}".}

\item{pvalue.threshold}{a numeric value giving threshold of
selected p-value, significant changes have lower
(adjusted) p-values than the threshold.}

\item{abs.fold}{a numeric value, the least minimum log2-fold
changes. The returned genomic regions have changes 
with absolute log2-fold changes exceeding \code{abs.fold}.}

\item{direction}{character string specify the direction of fold
changes. "\code{up}": positive fold changes; "\code{down}":
negative fold changes; "\code{both}": both positive and
negative fold changes.}

\item{...}{additional arguments passing to \code{\link{rpkm}},
\code{\link{cpm}}}
}
\value{
A \code{TCA} object
}
\description{
This function constructs a time course table of which rows
are genomic features and columns time points.
values can be normalized expression levels or log2-fold
changes compared to a control time point. The time course
table is used for clustering analysis.
}
\note{
If "\code{expression}" in \code{value} is chosen, the average 
normalized expression values of replicates for each group will 
be calculated and returned.
}
\examples{
data(tca_ATAC)
tca_ATAC <- DBanalysis(tca_ATAC)
tca_ATAC <- timecourseTable(tca_ATAC, value = 'expression',
                            lib.norm = TRUE, norm.method = 'rpkm')

}
\author{
Mengjun Wu
}
