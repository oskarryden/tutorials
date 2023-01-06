# Probability

samples <- c("W", "L", "W", "W", "W", "L", "W", "L" , "W")
W <- sum(samples=="W")
L <- sum(samples=="L")
p <- seq(0, 1, by = 0.25)
ways <- vapply(p, function(q) { (q*4)^W * ((1-q)*4)^L }, FUN.VALUE = numeric(1))
prob <- ways / sum(ways)
cbind(p, ways, prob)

barplot(prob)

# Generative
sim_toss <- function(p=0.7, N=10) {
    sample(c("W", "L"), size=N, prob = c(p, (1-p)), replace=TRUE)
}

# Test alltid extrema situationer!
sim_toss(p=1)

# Testa förväntning
mean(sim_toss(p = 0.5, N = 1e4) == "W")
mean(sim_toss(p = 0.5, N = 1e4) == "L")

# Beräkna en posterior
# hur kan en parameter P generera W och L?
compute_posterior <- function(samples, poss=3) {

    poss <- seq(from=0,to=1,length.out=poss)
    W <- sum(samples=="W")
    L <- sum(samples=="L")
    ways <- vapply(poss, function(q) (q*4)^W  * ((1-q)*4)^L, FUN.VALUE = numeric(1))
    post <- ways / sum(ways)
    data.frame(poss, ways, post=round(post,3))
}

compute_posterior(sim_toss(), poss = 21)

# More possibilities
# Vi kan få från fyra sidor, till 10 sidor, till 20 sidor
# Generellt har polyhedron en posterior prob. p^W * (1-p)^L
# Vi måste normalisera så att sannolikheten summerar till 1:
# p = [(W+L+1)! / (W!L!)] * [p^W * (1-p)^L]
# Den första delen är en normaliserande konstant medan den andra delen
# är det relativa antalet kombinationer för att observera vårt urval.
# Detta är den så kallade betafördelningen.
# För 10 dragningar...

get_p <- function(samples, res=100, richards = TRUE) {

    p <- seq(0, 1, length.out = res)
    W <- sum(samples=="W")
    L <- sum(samples=="L")

    if (richards) {
        # formula from slides
        const <- gamma(W+L+1) / ( gamma(W)*gamma(L) )
        rest <- p^W * ((1-p)^L)
        stop("Does not work...", .call=FALSE)
    } else {
        # formula for what is in dbeta
        const <- gamma(W+L) / ( gamma(W)*gamma(L) )
        rest <- p^(W-1) * (1-p)^(L-1)
    }

    post <- const * rest
    db <- dbeta(p, W, L)
    out <- data.frame(p, post, db)
    out[] <- lapply(out, round, digits=3)
    return(out)
}

draw_p <- function(obj) {


    lines(x = obj[["p"]], y = obj[["post"]], type = "l")

}

plot(NULL, xlim = c(0,1), ylim = c(0, 5))
get_p(
    samples = c("L", "W", "L", "L", "W", "W", "W", "L", "W", "W"),
    richards = FALSE) |>
draw_p(obj = _)  


# sampling
post_samples <- rbeta(1e3, 6+1, 3+1)
rethinking::dens(post_samples, lwd =3, col = 2, adj=0.1)
curve( dbeta(x, 6+1, 3+1), add = TRUE, lty = 2, lwd = 3)

# posterior predictive distibution
# posteriod distribution för p -->
# predictive distribution för p -->
# posterior predictive distribution för 
