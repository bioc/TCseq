% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DBresults.R
\name{DBresult}
\alias{DBresult}
\alias{DBresult.cluster}
\title{This function tests for differential expression}
\usage{
DBresult(
  object,
  group1 = NULL,
  group2 = NULL,
  contrasts = NULL,
  p.adjust = "fdr",
  top.sig = FALSE,
  pvalue = "paj",
  pvalue.threshold = 0.05,
  abs.fold = 2,
  direction = "both",
  result.type = "GRangesList"
)

DBresult.cluster(
  object,
  group1 = NULL,
  group2 = NULL,
  contrasts = NULL,
  p.adjust = "fdr",
  top.sig = FALSE,
  pvalue = "paj",
  pvalue.threshold = 0.05,
  abs.fold = 2,
  direction = "both",
  cluster,
  cmthreshold = NULL,
  result.type = "GRangesList"
)
}
\arguments{
\item{object}{a \code{TCA} object, for \code{DBresult},
\code{DBanalysis} should already be called on the object;
for \code{DBresult.cluster}, both \code{DBanalysis} and
\code{timeclust} should be already called.}

\item{group1}{character string giving the group to be compared with,
i.e., the denominator in the fold changes. group1 can be set NULL and 
will be ignored if the comparisons are passed to \code{contrasts}}

\item{group2}{a character vetor giving the other groups to 
compare with \code{group1}, i.e., the numerator in the fold changes.
group2 can be set NULL and will be ignored if the comparisons are 
passed to \code{contrasts}}

\item{contrasts}{a character vector, each string in
the vector gives a contrast of two groups with the format
"group2vsgroup1", group1 is the denominator level in the fold
changes and group2 is the numerator
level in the fold changes.}

\item{p.adjust}{character string specifying a correction method
for p-values. Options are "\code{holm}", "\code{hochberg}", 
"\code{hommel}", "\code{bonferroni}", "\code{BH}", "\code{BY}", 
"\code{fdr}", and "\code{none}".}

\item{top.sig}{logical if TRUE, only genomic regions with
given log2-fold changes and significance levels (p-value) 
will be returned. Log2-fold changes are defined by \code{abs.fold}
and \code{direction}; significance levels are defined by \code{pvalue} 
and \code{pvalue.threshold}}

\item{pvalue}{character string specify the type of p-values
used for defining the significance level(\code{PValue}
or adjusted p-value \code{paj})}

\item{pvalue.threshold}{a numeric value giving threshold of
selected p-value, Significant changes have lower
(adjusted) p-values than the threshold.}

\item{abs.fold}{a numeric value, the minimum absolute log2-fold
changes. The returned genomic regions have changes 
with absolute log2-fold changes exceeding \code{abs.fold}.}

\item{direction}{character string specify the direction of fold
changes. "\code{up}": positive fold changes; "\code{down}":
negative fold changes; "\code{both}": both positive and
negative fold changes.}

\item{result.type}{character string giving the data type of return
value. Options are "GRangesList" and "list".}

\item{cluster}{an integer giving the number of cluster from which 
genomic features are extracted.}

\item{cmthreshold}{a numeric value, this argument is applicable
only if \code{cmeans}' clustering method is selected when calling
\code{\link{timeclust}} function. if not NULL, the result table of
genomic features that belong to the defined \code{cluster} and
the membership values to this cluster exceed \code{cmthreshold}
are extracted.}
}
\value{
A list or a GRangesList.
If \code{result.type} is "GRangesList", a GRangesList is returned containing
the differential analysis results for all provided contrasts. Each GRanges 
object of the list is one contrast, the analysis results are contained in 4 
metadata columns:

\code{logFC} log2-fold changes between two groups.

\code{PValue} p-values.

\code{paj} adjusted p-values

\code{id} name of genomic features 

If \code{result.type} is "list", a list of data frames is returned.
Each data frame contains one contrast with the following columns:

\code{logFC} log2-fold changes between two groups.

\code{PValue} p-values.

\code{paj} adjusted p-values

\code{chr}  name of chromosomes

\code{start} starting positions of features in the 
chromosomes

\code{end} ending postitions of features in the chromosomes

\code{id} name of genomic features
}
\description{
This function is a wrapper for \code{\link{glmLRT}} in edgeR package. 
It performs likelihood ratio tests for given coefficinets contrasts 
after fitting read counts to a negative binomial glm by
\code{\link{DBanalysis}}. \code{DBresult} also extracts the
diffential analysis results of given contrasts at a chosen significance level. 
\code{DBresult.cluster} returns similar results but only 
contain genomic features belong to a given cluster.
}
\details{
This function uses \code{\link{glmLRT}} from edgeR which
perform likelihood ratio tests for the significance of changes.
For more deatils,
see \code{\link{glmLRT}}
}
\note{
If not NULL \code{group1}, \code{group2} and \code{contrasts},
result tables are extracted from comparisons in \code{constrasts}.
}
\examples{
data(tca_ATAC)
tca_ATAC <- DBanalysis(tca_ATAC)
### extract differntial analysis of 24h, 72h to 0h
# set the contrasts using the 'group1' and 'group2' paramters
res1 <- DBresult(tca_ATAC, group1 = '0h', group2 = c('24h', '72h'))
# one can get the same result by setting the contrasts using hte 'contrasts' parameter
res2 <- DBresult(tca_ATAC, contrasts = c('24hvs0h', '72hvs0h'))
# extract significant diffential events
res.sig <- DBresult(tca_ATAC, contrasts = c('24hvs0h', '72hvs0h'),
                   top.sig = TRUE)

# extract differntial analysis of 24h, 72h to 0h of a given cluster
tca_ATAC <- timecourseTable(tca_ATAC, filter = TRUE)
tca_ATAC <- timeclust(tca_ATAC, algo = 'cm', k = 6)
res_cluster1 <- DBresult.cluster(tca_ATAC, group1 = '0h',
                                 group2 = c('24h', '72h'),
                                 cluster = 1)



}
\seealso{
\code{\link{glmLRT}}
}
\author{
Mengjun Wu, Lei Gu
}
