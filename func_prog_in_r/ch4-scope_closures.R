# Scope and closures in R

## implicit environment
x <- 1
y <- 6
x + y

## explicit environment
genv <- globalenv()
eval(x+y, genv)
eval(quote(x+y), genv)
eval(expression(x+y), genv)
a_call <- call("+", x, y)
eval(a_call, genv)
do.call("+", list(genv$x, genv$y))

e <- new.env()
e$x <- 10
e$y <- 20
ls.str(e)
eval(quote(x+y), e)
eval(quote(x+y), envir = e)

efx <- expression(x+y)
eval(efx, e)
eval(efx, genv)

eval(efx, list2env(list(x = 100, y = 200)))

## environments and functions
f <- function(px) {
    lx <- px**2
    as.list(environment())
    }
x <- 1:4
f(x)


as.list(globalenv())
as.list(environment())
as.list(baseenv())

parent.env(globalenv())
parent.env(parent.env(globalenv()))