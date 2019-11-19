plot(res$phi[ngibbs,],type='h')

fim=data.frame(zestim=res$z[ngibbs,],ztrue=z.true)
fim1=table(fim); fim1
ordem=c(1,8,3,5,6,4,2,7)
fim1[ordem,]

compare=function(true1,estim1){
  rango=range(c(true1,estim1))
  plot(true1,estim1,ylim=rango,xlim=rango)
  lines(rango,rango,col='red')
}

theta1=matrix(res$theta1[ngibbs,],nrow=nclustmax)
compare(theta1.true,theta1[ordem,])

theta2=matrix(res$theta2[ngibbs,],nrow=nclustmax)
compare(theta2.true,theta2[ordem,])

theta3=matrix(res$theta3[ngibbs,],nrow=nclustmax)
compare(theta3.true,theta3[ordem])

