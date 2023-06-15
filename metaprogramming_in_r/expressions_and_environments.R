# Expressions and environments
emptyenv()
baseenv()
globalenv()

search()
library(MASS)
search()


environmentName(globalenv())
environment(MASS::mvrnorm) |> parent.env()
parent.env(globalenv())
parent.env(baseenv())
parent.env(emptyenv())


.search <- function(env) {
    repeat {
        name <- environmentName(env)
        if (nchar(name) != 0)
            name <- sprintf("%s\n", name)
        else 
            name <- str(env, give.attr = FALSE)
        
        cat(name)
        env <- parent.env(env)
        if (identical(env, emptyenv()))
            break
    }
}

.search(globalenv())

f <- function() {
    g <- function() {
        h <- function() {
            function(x) x
        }
        h()
    }
    g()
}

.search(environment(f()))

# Not the same "base"
environment(ls)
baseenv()

# Look at the chain of environments
.search(environment(sd))

environment(sd)
parent.env(environment(sd))
parent.env(parent.env(environment(sd)))
parent.env(parent.env(parent.env(environment(sd))))
parent.env(parent.env(parent.env(parent.env(environment(sd)))))
parent.env(parent.env(parent.env(parent.env(parent.env(environment(sd))))))

f <- function(x) {
    g <- function(y,z) x+y+z
    g
}

h <- function(a) {
    g <- f(x)
    i <- function(b) g(a+b,5)
}

x <- 2
i <- h(1)
i(3)

.search(environment(i))
ls.str(globalenv())
ls.str(environment(f))
ls.str(environment(i))
ls.str(environment(h))
ls.str(environment(get("g", environment(i))))

env <- new.env()
environment(environment(env))
environmentName(env)
x <- 5
exists("x", envir = env)
ls.str(env)
ls.str(globalenv())
get("x", envir = env)
env$x <- 10
get("x", envir = env)
ls.str(env)
assign("y", "abc", envir = env)

env2 <- new.env(parent = emptyenv())
environment(env2)
.search(env2)
.search(env)

get("x", envir = env2)



