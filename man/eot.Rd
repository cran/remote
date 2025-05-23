% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eot.R
\name{eot}
\alias{eot}
\alias{eot,RasterStackBrick-method}
\title{EOT analysis of a predictor and (optionally) a response RasterStack}
\usage{
\S4method{eot}{RasterStackBrick}(
  x,
  y = NULL,
  n = 1,
  standardised = TRUE,
  write.out = FALSE,
  path.out = ".",
  prefix = "remote",
  reduce.both = FALSE,
  type = c("rsq", "ioa"),
  verbose = TRUE,
  ...
)
}
\arguments{
\item{x}{a \verb{Raster*} object used as predictor}

\item{y}{a \verb{Raster*} object used as response. If \code{y} is
\code{NULL}, \code{x} is used as \code{y}}

\item{n}{the number of EOT modes to calculate}

\item{standardised}{logical. If \code{FALSE} the calculated r-squared values
will be multiplied by the variance}

\item{write.out}{logical. If \code{TRUE} results will be written to disk
using \code{path.out}}

\item{path.out}{the file path for writing results if \code{write.out} is \code{TRUE}.
Defaults to current working directory}

\item{prefix}{optional prefix to be used for naming of results if
\code{write.out} is \code{TRUE}}

\item{reduce.both}{logical. If \code{TRUE} both \code{x} and \code{y}
are reduced after each iteration. If \code{FALSE} only \code{y} is reduced}

\item{type}{the type of the link function. Defaults to \code{'rsq'} as in original
proposed method from \cite{van den Dool 2000}. If set to \code{'ioa'} index of agreement is
used instead}

\item{verbose}{logical. If \code{TRUE} some details about the
calculation process will be output to the console}

\item{...}{not used at the moment}
}
\value{
if n = 1 an \emph{EotMode}, if n > 1 an \emph{EotStack} of \code{n}
\emph{EotMode}s. Each \emph{EotMode} has the following components:
\itemize{
\item \emph{mode} - the number of the identified mode (1 - n)
\item \emph{eot} - the EOT (time series) at the identified base point.
Note, this is a simple numeric vector, not of class \code{ts}
\item \emph{coords_bp} - the coordinates of the identified base point
\item \emph{cell_bp} - the cell number of the indeified base point
\item \emph{cum_exp_var} - the (cumulative) explained variance of the considered EOT
\item \emph{r_predictor} - the \emph{RasterLayer} of the correlation coefficients
between the base point and each pixel of the predictor domain
\item \emph{rsq_predictor} - as above but for the coefficient of determination
\item \emph{rsq_sums_predictor} - as above but for the sums of coefficient of determination
\item \emph{int_predictor} - the \emph{RasterLayer} of the intercept of the
regression equation for each pixel of the predictor domain
\item \emph{slp_predictor} - same as above but for the slope of the
regression equation for each pixel of the predictor domain
\item \emph{p_predictor} - the \emph{RasterLayer} of the significance (p-value)
of the the regression equation for each pixel of the predictor domain
\item \emph{resid_predictor} - the \emph{RasterBrick} of the reduced data
for the predictor domain
}

Apart from \emph{rsq_sums_predictor}, all \emph{*_predictor} fields are
also returned for the \emph{*_response} domain,
even if predictor and response domain are equal. This is due to that fact,
that if not both fields are reduced after the first EOT is found,
these \emph{RasterLayers} will differ.
}
\description{
Calculate a given number of EOT modes either internally or between
RasterStacks.
}
\details{
For a detailed description of the EOT algorithm and the mathematics behind it,
see the References section. In brief, the algorithm works as follows:
First, the temporal profiles of each pixel \emph{xp} of the predictor domain
are regressed against the profiles of all pixels \emph{xr} in the
response domain.
The calculated coefficients of determination are summed up and the pixel
with the highest sum is identified as the 'base point' of the first/leading mode.
The temporal profile at this base point is the first/leading EOT.
Then, the residuals from the regression are taken to be the basis
for the calculation of the next EOT, thus ensuring orthogonality
of the identified teleconnections. This procedure is repeated until
a predefined amount of \emph{n} EOTs is calculated. In general,
\pkg{remote} implements a 'brute force' spatial data mining approach to
identify locations of enhanced potential to explain spatio-temporal
variability within the same or another geographic field.
}
\examples{
### EXAMPLE I
### a single field
\donttest{
data(vdendool)

## claculate 2 leading modes
nh_modes <- eot(x = vdendool, y = NULL, n = 2, 
                standardised = FALSE, 
                verbose = TRUE)

plot(nh_modes, y = 1, show.bp = TRUE)
plot(nh_modes, y = 2, show.bp = TRUE)
}
}
\references{
\bold{Empirical Orthogonal Teleconnections}\cr
H. M. van den Dool, S. Saha, A. Johansson (2000)\cr
Journal of Climate, Volume 13, Issue 8, pp. 1421-1435\cr
\doi{10.1175/1520-0442(2000)013<1421:EOT>2.0.CO;2}

\bold{Empirical Methods in Short-Term Climate Prediction}\cr
H. M. van den Dool (2007)\cr
Oxford University Press, Oxford, New York\cr
\doi{https://doi.org/10.1093/oso/9780199202782.001.0001}
}
