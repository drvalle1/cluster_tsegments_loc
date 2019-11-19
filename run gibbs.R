rm(list=ls(all=TRUE))
library('Rcpp')
library('MCMCpack')
set.seed(1)

setwd('U:\\GIT_models\\cluster_tsegments_loc')
sourceCpp('aux1.cpp')
source('gibbs functions.R')
source('gibbs sampler.R')

dat=read.csv('fake data.csv',as.is=T)
dat=data.matrix(dat)

#priors
psi=0.01
gamma1=0.1

#starting values
nclustmax=20

#store results
ngibbs=1000
nburn=ngibbs/2
res=cluster_tsegments_loc(psi=psi,gamma1=gamma1,nclustmax=nclustmax,
                          dat=dat,ngibbs=ngibbs,nburn=nburn)

