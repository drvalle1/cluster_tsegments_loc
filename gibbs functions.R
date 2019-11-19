sample.theta=function(dat,nclustmax,nloc,z,psi){
  theta=matrix(NA,nclustmax,nloc)
  for (i in 1:nclustmax){
    cond=z==i
    soma=sum(cond)
    if (soma==0) tmp=rep(0,nloc)
    if (soma==1) tmp=dat[cond,]
    if (soma >1) tmp=colSums(dat[cond,])
    theta[i,]=rdirichlet(1,tmp+psi)
  }
  theta
}
#----------------------------------------------
sample.v=function(z,nclustmax,gamma1){
  #get n
  n=rep(0,nclustmax)
  tmp=table(z)
  n[as.numeric(names(tmp))]=tmp

  #get ngreater
  seq1=nclustmax:1
  tmp=cumsum(n[seq1])[seq1]
  ngreater=tmp[-1]
  
  #get v's
  rbeta(nclustmax-1,n[-nclustmax]+1,ngreater+gamma1)
}
#----------------------------------------------
sample.z=function(dat,theta,phi,nobs,nclustmax,nloc,z,n){
  #pre-calculate some useful quantities
  ltheta=log(theta)
  lphi=log(phi)
  
  #determine the number of locations in each group
  tab=rep(0,nclustmax)
  tmp=table(z)
  tab[as.numeric(names(tmp))]=tmp
  
  #calculate log-probability
  tmp=matrix(NA,nobs,nclustmax)
  for (i in 1:nclustmax){
    ltheta1=matrix(ltheta[i,],nobs,nloc,byrow=T)
    tmp[,i]=rowSums(dat*ltheta1)+lphi[i]
  }

  #sample z
  lgamma.nloc.psi=lgamma(nloc*psi)
  lgamma.psi=lgamma(psi)
  soma.lgamma.dat.psi=rowSums(lgamma(dat+psi))
  lgamma.n.nloc.psi=lgamma(n+nloc*psi)
  calc.interm=lgamma.nloc.psi-nloc*lgamma.psi+soma.lgamma.dat.psi-lgamma.n.nloc.psi
  randunif=runif(nobs)
  z=HelperSampleZ(tab=tab,z=z-1,
                  lphi=lphi, LprobTmp=tmp, CalcInterm=calc.interm,
                  nclustmax=nclustmax, nloc=nloc,nobs=nobs,
                  dat=dat, n=n,
                  RandUnif=randunif)
  z+1
}
