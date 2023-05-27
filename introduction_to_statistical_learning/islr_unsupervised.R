
set.seed(1)
x  <- matrix(rnorm(50*2), ncol = 2)
x[1:25, 1] <- x[1:25, 1] + 3
x[1:25, 2] <- x[1:25, 2] - 4

x; D_x <- dist(scale(x)); str(D_x)

hc_c <- hclust(D_x, method = "complete")
hc_a <- hclust(D_x, method = "average")
hc_s <- hclust(D_x, method = "single")

par(mfrow = c(1,3))
plot(hc_c, main = "Complete Linkage", xlab = "" , sub="", cex=.9)
plot(hc_a, main = "Average Linkage" , xlab = "", sub="" , cex=.9)
plot(hc_s, main = "Single Linkage" , xlab = "" , sub="" , cex=.9)

cutree(hc_c, 3)
cutree(hc_a, 3)
cutree(hc_s, 3)


x <- matrix(rnorm(30 * 3), ncol = 3)
dd <- as.dist(1 - cor(t(x)))
plot(hclust(dd, method = "complete"), main = "Complete Linkage with Correlation - Based Distance" , xlab = " " ,sub=" " )