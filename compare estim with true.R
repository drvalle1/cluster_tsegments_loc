plot(res$phi[ngibbs,],type='h')

fim=data.frame(zestim=res$z[ngibbs,],ztrue=z.true)
fim1=table(fim); fim1
ordem=numeric()
for (i in 1:ncol(fim1)){
  ind=which(fim1[,i]==max(fim1[,i]))
  ordem=c(ordem,ind)
}
fim1[ordem,]

compare=function(true1,estim1){
  rango=range(c(true1,estim1))
  plot(true1,estim1,ylim=rango,xlim=rango)
  lines(rango,rango,col='red')
}

theta1=matrix(res$theta[ngibbs,],nrow=nclustmax)
compare(theta.true,theta1[ordem,])