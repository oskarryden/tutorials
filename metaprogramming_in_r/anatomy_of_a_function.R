# Chapter 1: Anatomy of a Function

## Manipulating functions
f <- function(x) x
formals(f)
body(f)
environment(f)

### Formals
g <- function(x = 1, y = 2, z = 3) x + y + z
parameters <- formals(g)
for (param in names(parameters)) {
    cat(param, "has default value", parameters[[param]], "\n")
}

#NOTE: Parmeters without default value has class "name"
g <- function(x , y , z = 3) x + y + z
parameters <- formals(g)
for (param in names(parameters)) {
    cat(param, "has default value", parameters[[param]], "with class",
        class(parameters[[param]]), "\n", sep = " ")
}

# NOTE: Primives do not have formals
formals(`+`) 

### Body
body(f)
g <- function(x) {
    y = 2*x
    z = x**2
    x + y + z
}
body(g)

eval(body(g))
eval(body(g), list(x = 2))
eval(body(f), list(x = 2))

f <- function(x = 2) {
    x * 2
}

eval(body(f))
eval(body(f), formals(f))
f()

f <- function(x=y, y=2){
    x+y
}

(fenv <- new.env())
params <- formals(f)
for (param in names(params)) {
    delayedAssign(
        x = param,
        value = params[[param]],
        eval.env = fenv,
        assign.env = fenv)
}
eval(body(f))
eval(body(f), fenv)

## Calling a function
environment(f)

enclosing <- function() {
    z = 2
    function(x, y=x) {
        x+y+z
    }
}

f <- enclosing()

calling <- function() {
    w = 5
    f(x = 2*w)
}

calling()

# x * 5 + y * 5 + 2
2 * 5 + 2 * 5 + 2

## Modifying a function
f <- function(x) x
f()

formals(f) <- list(x = 2)
f()
eval(body(f), formals(f))

nested <- function() {
    y = 10
    function(x) {
        x
    }
}

f <- nested()
formals(f) <- list(x = quote(y))
f()

y = 2
f(x=y)

body(f) <- 6

f(x = 1000)

body(f) <- 2*y
f()

body(f) <- quote(2*y)
f()

environment(f) <- globalenv()
f()
y = 100
f()

## Creating a function
f <- as.function(alist(x = 5, y = 2, x**y))
f()

ffail <- as.function(list(x = 5, y = 2, quote(x**y)))
ffail |> body()
ffail |> formals()
ffail |> environment()

nested <- function(z) {
    as.function(alist(x = , y = z, x+y))
}

(g <- nested(2))
g(x = 1)

(h <- nested(20))
h(x = 10)

nested <- function(z) {
    as.function(alist(x = , y = z, x*y))
}

nested2 <- function(z) {
    as.function(alist(y = z, x = , x*y), envir = globalenv())
}

g <- nested(z = 10)
h <- nested2(z = 10)

g(x = 10)
h(x = 10)
z <- 100
h(x = 10)