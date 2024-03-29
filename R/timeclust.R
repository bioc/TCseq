#' time couse data clustering
#'
#' This function performs clustering analysis of the time course data.
#'
#' @param x a \code{TCA} object returned from
#' \code{\link{timecourseTable}} or a matrix
#'
#' @param algo a character string giving a clustering method. Options
#' are "\code{km}" (kmeans), "\code{pam}" (partitioning around medoids),
#' "\code{hc}" (hierachical clustering), "\code{cm}" (cmeans).
#'
#' @param k a numeric value between \eqn{1} and \eqn{n - 1} (\eqn{n}
#' is the number of data points to be clustered).
#' 
#' @param dist a character string specifying either "\code{distance}" or 
#' "\code{correlation}" will be used to measure the distance between data points.
#' 
#' @param dist.method a character string. It can be chosen from one of 
#' the correlation methods in \code{\link{cor}} function ("\code{pearson}", 
#' "\code{spearman}", "\code{kendall}") if \code{dist} is "\code{correlation}", 
#' or one of the distance measure methods in \code{\link{dist}} function 
#' (for example, "\code{euclidean}", "\code{manhattan}") if \code{dist} is 
#' "\code{distance}".
#'
#' @param centers a numeric matrix giving intial centers for kmeams,
#' pam or cmeans. If given, number of rows of the matrix must be equal
#' to k.
#'
#' @param standardize logical, if TRUE, z-score transformation will
#' performed on the data before clustering. See 'Details' below.
#'
#' @param ... additional arguments passing to \code{\link{kmeans}},
#' \code{\link{pam}}, \code{\link{hclust}}, \code{\link{cmeans}}
#'
#' @details
#' two types of clustering methods are provided: hard clustering
#' (\code{\link{kmeans}}, \code{\link{pam}}, \code{\link{hclust}})
#' and soft clustering(\code{\link{cmeans}}). In hard clustering,
#' a data point can only be allocated to exactly one cluster
#' (for \code{\link{hclust}}, \code{\link{cutree}} is used to cut
#' a tree into clusters), while in soft clustering (also known as
#' fuzzy clustering), a data point can be assigned to multiple
#' clusters, membership values are used to indicate to what
#' degree a data point belongs to each cluster.
#'
#' To better capture the differences of temporal patterns rather 
#' than expression levels, z-score transformation can be applied 
#' to covert the the expression values to z-scores by performing 
#' the following formula:
#'
#' \deqn{z = \frac{x - \mu}{\sigma}}
#'
#' \eqn{x} is the value to be converted (e.g., expression value of a
#' genomic feature in one condition), \eqn{\mu} is the population
#' mean (e.g., average expression value of a genomic feature across
#' different conditions), \eqn{\sigma} is the standard deviation
#' (e.g., standard deviation of the expression values of a genomic 
#' feature across different conditions).
#'
#'
#' @return
#' If x is a \code{TCA} object, a \code{TCA} object will be returned.
#' If x is a matrix, a \code{clust} object will be returned
#'
#' @examples
#'
#' example.mat <- matrix(rnorm(1600,sd=0.3), nrow = 200,
#'             dimnames = list(paste0('peak', 1:200), 1:8))
#' clust_res <- timeclust(x = example.mat, algo = 'cm', k = 4) 
#' # return a clust object
#' 
#' @author
#' Mengjun Wu
#'
#' @seealso \code{\link{clust}}, \code{\link{kmeans}},
#' \code{\link{pam}}, \code{\link{hclust}}, \code{\link{cutree}}
#'
#' @export
timeclust <- function(x, algo, k, dist = "distance", dist.method = "euclidean", 
                      centers = NULL, standardize = TRUE, ...) {
  if (is.matrix(x)) {
    data.tmp <- x
  }else{
    data.tmp <- x@tcTable
  }
  if (standardize) {
    for (i in seq_len(nrow(data.tmp))) {
      data.tmp[i, ] <- (data.tmp[i, ] - mean(data.tmp[i, ], na.rm = TRUE))/sd(data.tmp[i, ], na.rm = TRUE)
    }
    data.tmp <- data.tmp[complete.cases(data.tmp), ]
  }
  object <- new("clust")
  object@method <- algo
  object@dist <- dist
  object@data <- data.tmp
  
  res <- .timeclust(data = data.tmp, algo = algo, k = k, 
                    dist = dist, dist.method = dist.method,
                    centers = centers, ...)
  
  if (algo == "cm") {
    object@cluster <- res$cluster
    object@membership <- res$membership
    object@centers <- res$centers
  } else {
    object@cluster <- res$cluster
    object@centers <- res$centers
  }
  if (is.matrix(x)) {
    object
  } else {
    x@clusterRes <- object
    x
  }
}

# perform time course clustering
.timeclust <- function(data, algo, k, centers = NULL,
                       dist = "distance", dist.method = "euclidean", ...) {
  if (!algo %in% c("pam", "km", "hc", "cm")) {
    stop("clustering method should be one of 'pam','km','hc','cm'")
  }
  if (!dist %in% c("distance", "correlation")) {
    stop("Distance can only be one of either 'distance' or 'correlation'")
  }
  if (!dist.method %in% c("pearson", "kendall", "spearman", "euclidean", "maximum", 
                          "manhattan", "canberra", "binary", "minkowski")) {
    stop("Distance metric should either one of correlation measures in cor function or 
         one of the distance measures in dist function")
  }
  if (algo == "km") {
    if(dist.method != "euclidean"){
      stop("kmeans only support euclidean metric; for other distance metrices, please see the help page")
    }
  }
  if (algo == "cm" ) {
    if(!dist.method %in% c("euclidean", "manhattan")){
      stop("cmeans only support euclidean or mahattan distance metrics")
    }
  }
  
  d <- NULL
  if (algo %in% c("pam", "hc")) {
    if (dist == "correlation") {
      d <- as.dist(1 - cor(t(data), method = dist.method))
    }
    if (dist == "distance") {
      d <- dist(data, method = dist.method)
    }
  }
  clustres <- list()
  if (algo != "hc") {
    if (!is.null(centers)) {
      if (nrow(centers) != k) {
        stop("Number of rows of centers must be equal to k")
      }
    }
  }
  clustres <- switch(algo, km = {
    if (!is.null(centers)) {
      res <- kmeans(data, centers = centers, ...)
    } else {
      res <- kmeans(data, centers = k, ...)
    }
    clustres$cluster <- res$cluster
    clustres$centers <- res$centers
    clustres
  }, pam = {
    if (!is.null(centers)) {
      ind <- data[, 1] %in% centers[, 1]
      ind <- which(ind)
      if (length(ind) != k) {
        stop("For 'pam', centers must be chosen from the data")
      } else {
        res <- pam(d, k = k, medoids = ind, ...)
      }
    }
    res <- pam(d, k = k, ...)
    clustres$cluster <- res$clustering
    clustres$centers <- data[res$medoids, ]
    clustres
  }, hc = {
    tree <- hclust(d, ...)
    res <- cutree(tree, k = k)
    clustres$cluster <- res
    clustres$centers <- matrix(0, 0, 0)
    clustres
  }, cm = {
    if (!is.null(centers)) {
      res <- cmeans(data, centers = centers, ...)
    } else {
      res <- cmeans(data, centers = k, ...)
    }
    clustres$cluster <- res$cluster
    clustres$centers <- res$centers
    clustres$membership <- res$membership
    clustres
  })
  clustres
}
