# ------------------------------------------------------------------------------
# Chapter 8
library(ISLR2)
library(gam)

df <- Wage
attach(df)
agelims <- range(age)

plot(age, wage, xlim = agelims , cex = .5, col = "darkgrey")
title("Smoothing Spline")
fit <- smooth.spline(age, wage, df = 16)
fit2 <- smooth.spline(age, wage, cv = TRUE)
fit2$df
str(fit2)

lines(fit, col = " red" ,lwd=2)
lines(fit2, col = " blue" ,lwd=2)
legend("topright",
    legend=c("16DF", "6.8DF"),
    col=c("red","blue"), 
    lty=1,
    lwd=2,
    cex=.8)

# GAM
gam1 <- lm(wage ~ ns(year,df=4) + ns(age,df=5) + education)
summary(gam1)

gam2 <- gam(wage ~ gam::s(year,df=4) + gam::s(age,df=5) + education) |>
    suppressWarnings()
summary(gam2)
par(mfrow=c(1,3))
plot(gam2, se=TRUE, col=2)

preds <- predict(gam2, newdata = Wage)
str(preds)

gam.lo <- gam(wage ~ s(year,df=4) + lo(age, span=0.7) + education)
par(mfrow = c(1,3))
plot.Gam(gam.lo, se = TRUE, col = "green")

lo.i <- lo(year, age, span = 0.5)
loess.i <- loess(year~age, span = 0.5, degree = 1)
str(lo.i)
str(loess.i)
fitted(loess.i)
summary(lo.i)
summary(loess.i)

gam.lo.i <- gam(wage~ lo(year, age, span = 0.5) + education)
summary(gam.lo.i)

gam.lr.s <- gam(I(wage > 250) ~ year + s(age, df = 5) + education,
    family=binomial("probit"), data = Wage, subset = (education != "1. < HS Grad" ))
summary(gam.lr.s)

par(mfrow = c(1,3))
plot(gam.lr.s, se = TRUE, col = "green")