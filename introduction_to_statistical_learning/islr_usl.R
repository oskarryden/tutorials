library(ISLR2)

states <- row.names(USArrests)
X <- USArrests
prout <- prcomp(X, scale. = TRUE)
summary(prout)

# Rotation ger oss komponentladdningar
prout$rotation

# x ger oss komponentpositioner
prout$x

# biplot
biplot(prout, scale = 0)

# Standardavvikelser
prout$sdev

# varians
prout$sdev^2

(pve <- prout$sdev^2 / sum(prout$sdev^2))