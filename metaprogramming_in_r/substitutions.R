# Substitutions

quote(x+y)
bquote(x+y)
bquote(x+.(4-1))

call("+", 2+2, quote(y))

bquote((.(2+2) + x) * y)

## Parse and deparse
deparse(quote(x+y))
parse(text= "x+y")

(expr <- parse(text = "x+y; z*y"))
expr[[1]]
expr[[2]]

f <- function(x) deparse(x)
f(1)
f(quote(a))
f(x + y)

g <- function(x) deparse(substitute(x))
g(1)
g(quote(a))
g(x + y)

# substitute in global environment
substitute(1)
substitute(a)
substitute(x + y)
x <- 4
y <- 5
substitute(x + y)
eval(x + y)

f <- function(x,y) substitute(x + y)
f(1,2)

# substitutes can use environment
e <- new.env()
e$x = 55
e$y = 66
substitute(x + y, e)
substitute(x + y, list(x = 5, y = 6))

# substitute do not follow parent pointers

# substitute and expressions
expr <- quote(x + y)
substitute(expr)
substitute(expr, list(x = 5, y = 6))
substitute(expr, list(expr = expr)) 
substitute(expr, list(expr = quote(x + y)))

# substitute and functions
f <- function() {
    expr <- quote(x + y)
    substitute(expr)
}

f()

f <- function() {
    expr <- quote(x + y); print(expr)
    eval(substitute(substitute(expr, list(y = 2)), list(expr = expr)))

}

f()


f <- function(x) function(y=x) substitute(y)
g <- f(2)
g()
x <- 5
g()
g(5)

f <- function(expr) substitute(expr)
f(x + y)
x = 2; y = 2
eval(f(x + y))

g <- function(expr) f(expr)
g(y+t)
eval(g(y+t))

# Non-standard evaluation
eval(quote(x / y), list(x = 4, y = 2.4))

d <- data.frame(x = 10:1, y = 1:10)
eval(quote(x / y), d)

# my_with
x <- 2; y <- 3
eval(bquote(x + y))
eval(quote(x + y))

my_with <- function(data, expr) {
    eval(expr = substitute(expr), envir = data)
}

my_with(d, x / y)
my_with(d, x + y)

q <- 10
my_with(d, x + y + q)

## Add the enclosing environment
my_with_enc <- function(data, expr) {
    eval(expr = substitute(expr), envir = data, enclos = parent.frame())
}

my_with(d, x + y + q)
my_with_enc(d, x + y + q)

f <- function(z) {
    with(d, x + y + z)
}

f(1)

g <- function(z) {
    my_with(d, x + y + z)
}

g(1)

h <- function(z) {
    my_with_enc(d, x + y + z)
}

h(1)

my_with_quoted <- function(df, expr) {
    eval(expr, df, parent.frame())
}

my_with <- function(df, expr) {
    substitute(expr) |> print()
    my_with_quoted(df, substitute(expr))
}

a = 10
my_with(d, x + y * a)

e <- list2env(list(x = 2, y = 5))
eval(quote(z <- x + y), e)
as.list(e)

l <- list(x = 2, y = 5)
eval(quote(z <- x + y), l)
l