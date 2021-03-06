# beluga
#


source('pen-s-functions.R')

dd <- read.csv('whale.csv')

y0 <- dd$Bouts2 # Nursing2 # 1
x0 <- dd$Period1
i0 <- !is.na(y0)
x0 <- x0[i0]
y0 <- y0[i0]
n <- length(x0)
x0 <- x0 / n



set.seed(123)
ii <- sort(sample(n, 100, repl=FALSE))
x <- x0[ii]
y <- y0[ii]
n <- length(x)

# x <- x0
# y <- y0

plot(y ~ x, pch=19, cex=.7, col='gray')


p <- 3
num.knots <- max(5, min(floor(length(unique(x))/4), 15))
knots <- quantile(unique(x),seq(0,1,length=num.knots+2))[-c(1,(num.knots+2))]
xpoly <- rep(1,n)
for (j in 1:p) xpoly <- cbind(xpoly,x^j)
xspline <- outer(x, knots, "-")
xspline <- pmax(xspline, 0)^p
X <- cbind(xpoly,xspline)
D <- diag(c(rep(0,ncol(xpoly)),rep(1,ncol(xspline))))

lambdas <- seq(1e-8, 3, length=100) # exp(seq(-20, 0, length=100))
ll <- length(lambdas)

tmp.ls <- pen.ls.gcv(y, X, D, lambdas)
(tmp.ls$lam)

plot(y ~ x, pch=19, col='gray', cex=.7)
lines(x, tmp.ls$yhat, lwd=2)


# tuning constants for the S-estimator
cc <- 1.54764
b <- .5

# cc <- .3
# b <- .24

# Cubic polynomials
NNN <- NN <- 100 # ??

tmp.m <- pen.m.rcv(y=y, X=X, N=NN, D=D, lambdas=lambdas, num.knots=num.knots, p=p, epsilon=1e-6)
(tmp.m$lam)

plot(y ~ x, pch=19, col='gray', cex=.7)
lines(x, tmp.ls$yhat, lwd=2)
lines(x, tmp.m$yhat, col="red", lwd=2)


tmp.s <- pen.s.rgcv(y, X, D, lambdas, num.knots, p, NN, cc, b, NNN)
(tmp.s$lam)

plot(y ~ x, pch=19, col='gray', cex=.7)
lines(x, tmp.ls$yhat, lwd=2)
lines(x, tmp.m$yhat, col="red", lwd=2)
lines(x, tmp.s$yhat, col="blue", lwd=2)

