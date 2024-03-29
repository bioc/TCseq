% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Classes.R
\docType{class}
\name{TCA-class}
\alias{TCA-class}
\alias{TCA}
\alias{TCAFromSummarizedExperiment}
\title{TCA class and constructor}
\usage{
TCA(design, counts = matrix(0L, 0L, 0L), genomicFeature, zero.based = TRUE)

TCAFromSummarizedExperiment(se, genomicFeature = NULL)
}
\arguments{
\item{design}{a data frame containing information of
samples/libraries. For time course analysis, design table should 
contain at least three columns (case insensitive): \code{sampleid},
\code{timepoint} and \code{group} providing time point and group
information of each sample/library. If \code{counts} is not provided
when creating \code{TCA} object, an optional column \code{bamfile} can 
be used to provide BAM filename of each sample/library and generate 
count table using \code{\link{countReads}} function later.}

\item{counts}{an integer matrix containing read counts. Rows
correspond to genomic features and columns to samples/libraries. 
The name of column s should be the same as the time points 
in \code{design}.}

\item{genomicFeature}{a data frame or a GRanges object containing
genomic coordinates of features of interest (e.g. genes in RNA-seq,
binding regions in ChIP-seq). If genomicFeature is a data frame,
four columns are required in \code{genomicFeature}: \code{id},
\code{chr}, \code{start}, \code{end}; if genomicFeature is a Granges
object, the metadata column "\code{id}" is required. For
\code{TCAFromSummarizedExperiment}, genomicFeature must be
provided if \code{se} is a SummarizedExperiment object.}

\item{zero.based}{Logical. If TRUE, the start positions of the
genomic ranges in the returned \code{TCA} object are \emph{0-based},
if FALSE, the start positions will be \emph{1-based}.}

\item{se}{A SummarizedExperiment or a RangedSummarizedExperiment
object. The object might contain multiple assays in the assay list, 
only the first one will be taken to construct TCA object. 
For SummarizedExperiment object, \code{genomicFeature}
must be provided while for RangedSummarizedExperiment object,
the genomic features will be extracted directly from the object.}
}
\value{
A TCA object
}
\description{
\code{TCA} is a S4 class for storing input data, results of
differential analysis and clustering analysis. A \code{TCA} object
can be created by the constructor function taking a table of sample
information, a table of the genomic coordinates of features, and read
count table (optional).
}
\details{
A TCA object can be created without providing read counts,
read counts can be provided by \code{\link{counts}} or generated by
\code{\link{countReads}}. For the read counts, the number of rows 
should equal to that in '\code{genomicFeature} and the number of columns 
should equal to number of rows in \code{design}; in addition, the name 
of column names should be the same as the time points in \code{design}. 
Input data and analysis results in a TCA object can be accessed by using 
corresponding accessors and functions.
The TCA objects also have a show method printing a compact summary of
their contents see \code{\link{counts}}, \code{\link{TCA.accessors}},
\code{\link{DBresult}}, \code{\link{tcTable}}, \code{\link{timeclust}}.
\code{clust}
}
\examples{
#create data frame of experiment design: 4 time points and 2 replicates for each time point.
d <- data.frame(sampleID = 1:8, group = rep(c(1, 2, 3, 4), 2),
               timepoint = rep(c('0h', '24h', '48h', '72h'), 2))


#create data frame of genomic intervals of interest
gf <- data.frame(chr = c(rep('chr1', 3), rep('chr2', 2), rep('chr4', 2)),
                start = seq(100, 2000, by = 300),
                end = seq(100, 2000, by = 300) + 150,
                id = paste0('peak', 1:7))
tca <- TCA(design = d, genomicFeature = gf)
genomicFeature(tca)

#if count table is available
c <- matrix(sample(1000, 56), nrow = 7, dimnames = list(paste0('peak', 1:7), 1:8))
tca <- TCA(design = d, counts = c, genomicFeature = gf)
# replace the count table of a \code{TCA} object
c2 <- matrix(sample(500, 56), nrow = 7, dimnames = list(paste0('peak', 1:7), 1:8))
counts(tca) <- c2


}
\seealso{
\code{\link{counts}}, \code{\link{TCA.accessors}},
\code{\link{DBresult}}, \code{\link{timeclust}}, \code{\link{clust}}
}
\author{
Mengjun Wu
}
