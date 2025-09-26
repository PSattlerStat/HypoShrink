HypoCheck<-function(H,y)
{if(dim(H)[1]!=length(y))
{stop("Dimension of matrix and vector must match.")}
  if(!is.numeric(H)|!is.numeric(y))
  {stop("Matrix and vector must be numeric.")}
  if(!is.matrix(H)|!is.vector(y))
  {stop("The hypotheses has to be expressed through a hypothesis matrix and the
        corresponding vector.")}
}
