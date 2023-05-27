
# ------------------------------------------------------------------------------
# Rotation with i-hat och j-hat
a <- c(1,2)
b <- c(3,4)
a %*% b

a <- c(1,3)
b <- c(-2,1)
a %*% b

(2*a) %*% b
2*(a %*% b)

ihat <- c(1,0)
jhat <- c(0,1)
x <- c(1.5, 1)

plot(x = -3:3, y = -3:3, type = "n"); grid()
arrows(x0 = 0, x1 = ihat[1], y0 = 0, y1 = ihat[2])
arrows(x0 = 0, x1 = jhat[1], y0 = 0, y1 = jhat[2])
segments(x0 = 0, x1 = x[1], y0 = 0, y1 = x[2], lty = "dashed")

R <- cbind(c(0,-1), c(1, 0)); R %*% x
segments(x0 = 0, x1 = (R%*%x)[1], y0 = 0, y1 = (R%*%x)[2], lty = "dashed", col = 3)
R <- cbind(c(-1,0), c(0, -1)); R %*% x
segments(x0 = 0, x1 = (R%*%x)[1], y0 = 0, y1 = (R%*%x)[2], lty = "dashed", col = 4)
R <- cbind(c(0, 1), c(-1,0)); R %*% x
segments(x0 = 0, x1 = (R%*%x)[1], y0 = 0, y1 = (R%*%x)[2], lty = "dashed", col = 5)
Sheer <- cbind(ihat, c(1,1)); Sheer %*% x
segments(x0 = 0, x1 = (Sheer%*%x)[1], y0 = 0, y1 = (Sheer%*%x)[2], lty = "dashed", col = 7)

# Rotate something at 90'
set.seed(1)
z1 <- rnorm(15, 0, .5)
z2 <- z1 + rnorm(15, 0, .5)
plot(z1 ~ z2, xlim = c(-2,2), ylim = c(-2,2), col = 2)
grid()
arrows(x0 = 0, x1 = ihat[1], y0 = 0, y1 = ihat[2])
arrows(x0 = 0, x1 = jhat[1], y0 = 0, y1 = jhat[2])
Z <- cbind(z1, z2)
points(x = t(R %*% t(Z))[,1], y= t(R %*% t(Z))[,2], pch = 20, col = 6)
# ------------------------------------------------------------------------------

# Dot product
c(1,2) %*% c(3,2) # positiva tal -> samma riktning
c(1, 1) %*% c(-1,-1) # negativa tal -> olika riktning
c(0, 1) %*% c(1,0) # 0 -> ortogonala

ihat <- c(1,0)
jhat <- c(0,1)
T <-  c(1,1)
v <- c(1,3)
w <- c(3,2)

plot(x = NULL, y = NULL, xlim = c(-5,5), ylim = c(-5,5))
grid()
segments(x0=0,y0=0, x1 = v[1], y1 = v[2], col = "grey")
segments(x0=0,y0=0, x1 = w[1], y1 = w[2], col = "grey")

# Från 2d till 1d:
# uhat kommer ge oss x och y kooridnat för ihat och yhat
T %*% v
T %*% w

# Cross product: v X W
# En krossprodukt ger en area av två vektorer
# om den första termen är till höger om den andra termen -> positiv area
# om den första termen är till vänster om den andra termen -> negativ area
# För en 2*2 matrix: det(M) = crossprodukt
# arean kommer vara negativ ifall den första vektorn är till vänster
# arean kommer vara mindre för vektorer som är mer lika varandra
# större ifall dom är olika eller ortogonala

# en krossprodukt är en vektor, där v*w ger längden för vektorn 
# denna vektor är ortogonal till v och w
v <- c(-3,1)
w <- c(2,1)
vw <- cbind(v,w)
det(vw)
crossprod(v,w)

plot(x = NULL, y = NULL, xlim = c(-5,5), ylim = c(-5,5))
grid()
segments(x0=0,y0=0, x1 = v[1], y1 = v[2], col = "grey")
segments(x0=0,y0=0, x1 = w[1], y1 = w[2], col = "grey")

# 
v <- c(3,1)
w <- c(2,-1)
vw <- cbind(v,w)
det(vw)
crossprod(v,w)

# Change of basis
# 3x + 2y = -4
# -1x + 2y = -2

X <- matrix(c(3,-1, 2,2), byrow = F, ncol = 2)
y <- c(-4,-2)

plot(x = NULL, y = NULL, xlim = c(-5,5), ylim = c(-5,5))
grid()
segments(x0=0,y0=0, x1 = X[1,1], y1 = X[2,1], col = "grey")
segments(x0=0,y0=0, x1 = X[1,2], y1 = X[2,2], col = "grey")
segments(x0=0,y0=0, x1 = y[1], y1 = y[2], col = "grey")

# Basbyten
# i hat och j hat är våra kooridnat/basvektorer.
# origo är det enda som är samma över alla basvektorer
x <- c(-1, 2)
j <- matrix(c(2,1,-1,1), byrow = F, ncol = 2)
j_ <- solve(j) # inverse
j_ %*% c(3,2)

# Vi har A, en matris som beskriver hur v ser ut i ij-basvektorer. 
# Vi har en vektor x som är skriven med ij-koordinater
# A %*% v -> hur placerar vi v i ij-land.
# A^{-1} %*% x -> hur placerar vi x i v-land

# ------------------------------------------------------------------------------
# Eigen
# Eigenvectors är vektorer som inte avviker fårn sitt span
# vid en transformering
# En eigenvektor ger ockås axeln för transformeringen
# A * v = lambda * V
# där A är en transformering
# v är en eigenvektor
# lambda är en eigenvalue
# Ofta skriver vi om till 
# A %*% v = (lambda %*% I) %*% v, där I är en identitetsmatris.
# Sedan kan vi skriva om till (A-lambda %*% I)%*% v = 0


