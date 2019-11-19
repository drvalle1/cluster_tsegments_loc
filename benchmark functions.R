library(microbenchmark)

microbenchmark(
  z=sample.z(dat=dat,theta=theta,phi=phi,
             nobs=nobs,nclustmax=nclustmax,nloc=nloc,z=z,n=n),
  v=sample.v(z=z,nclustmax=nclustmax,gamma1=gamma1),
  phi=GetPhi(vec=c(v,1),nclustmax=nclustmax),

  theta=sample.theta(dat=dat,nclustmax=nclustmax,nloc=nloc,z=z,psi=psi)
  #to avoid numerical issues
)


