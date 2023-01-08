

# Family-wise error rate
fwer <- function(alpha, m) {
    1 - (1-alpha)^m
}

fwer(alpha = 0.05, m = 1)
fwer(alpha = 0.05, m = 10)
fwer(alpha = 0.05, m = 100)

fwer(alpha = 0.001, m = 1)
fwer(alpha = 0.001, m = 10)
fwer(alpha = 0.001, m = 100)

curve(
    expr = fwer(alpha=0.05, m=x),
    from=1, to=500, n=500,
    xlim=c(1, 500), ylim=c(0,1),
    xlab = "m test", ylab = "FWER(alpha)",
    col = "black")
curve(
    expr = fwer(alpha=0.01, m=x),
    from=1, to=500, n=500,
    xlim=c(1, 500), ylim=c(0,1),
    col = "yellow", add=TRUE)
curve(
    expr = fwer(alpha=0.001, m=x),
    from=1, to=500, n=500,
    xlim=c(1, 500), ylim=c(0,1),
    col = "red", add=TRUE)
abline(h=0.05, lty = "dashed", lwd = 0.25)

# Bonferroni
bonferroni <- function(alpha, m) {
    alpha/m
}

bonferroni(alpha = 0.05, m = 5)

curve(
    expr = bonferroni(alpha = 0.05, m = x),
    from = 1, to = 100, n = 100,
    xlim = c(1,100),
    ylim = c(0,0.1),
    col = "black")
curve(
    expr = bonferroni(alpha = 0.01, m = x),
    from = 1, to = 100, n = 100,
    xlim = c(1,100),
    ylim = c(0,0.1),
    col = "red", add = TRUE)
abline(h=0.05, lty = "dashed", lwd = 0.25)

# Holm
holm <- function(alpha, p_values) {
    p <- sort(p_values)
    j <- rank(p)
    m <- length(p_values)

    holm.correction <- alpha / (m + 1 - j)
    holm.bool <- p > holm.correction
    holm.p <- min(p[holm.bool])

    p.corr <- p < holm.p

    data.frame(
        p = p,
        p.corr = p.corr,
        holm.p = holm.correction
    )
}

pvs <- c(0.012, 0.601, 0.756, 0.918, 0.006)

holm(alpha=0.05, pvs)

# ========================================================================== #
# Lab
set.seed(6)
x <- matrix(rnorm(10*100), 10, 100)
x[, 1:50] <- x[, 1:50] + .5

t.test(x[,1], mu=0) # typ-2-fel: vi vet att mu_1 = 0.5

# för alla kolumner
p.values <- rep(0, 100)
for (i in 1:100) p.values[i] <- t.test(x[, i], mu = 0)$p.value
decision <- rep("Do not reject H0", 100)
decision[p.values <= .05] <- "Reject H0"

tab_d <- table(decision, c(rep("H0 is FALSE", 50), rep("H0 is TRUE", 50)))
print(tab_d)
tab_d
sprintf("W=%d, U=%d, S=%d, V=%d",
    tab_d[1,1], tab_d[1,2], tab_d[2,1], tab_d[2,2]) |>
    message()

tab_d[2,2] / sum(tab_d[,2]) # förkastade nollor över samtliga sanna nollor
# --> rätt nära 0.05.


