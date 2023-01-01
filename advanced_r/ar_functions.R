# Chapater 6 Functions
# 
# All functions can be broken down to:
# arguments, body, and environment
# For some functions, this does not apply
# as they are implemented in C as "primitive".
#
# All functions are objects, just like a vector.
#
# We can understand a function by using functions 
# like formals(), body(), environment().

f <- function(x,y) {
  # A
  x + y
}

formals(f)
body(f)
environment(f)

# Functions also have attributes, which can be
# exposed by attributes() or attr()

attributes(f)
attr(f, which  = "srcref") # srcref is the source reference, that points to the creating code.

## Primitive functions
sum
`[`
`(`

typeof(`[`)
typeof(sum)

# these do not exist in R, so there are no formals
formals(sum)
body(sum)
environment(sum)

## First class functions
# The property that a function is an object is called 
# first class function
#
# When we do not name a function, we call it anonymous
Filter(function(x) Negate(is.numeric)(x), mtcars)

## Closurs
# In R, functions are often called closures, this refers to the
# fact that they enclose an environment (See environments).

## Invoking
mean(1:5)
args <- list(quote(x), na.rm = TRUE)
x <- 1:5
do.call(mean, args) # substitues with the global environment
do.call(mean, args, envir = list2env(list(x = 1:10))) # substitues with the assigned environment
rm(x)
rm(args)

match.fun("mean")

objs <- mget(ls("package:base", all = TRUE), inherits = TRUE)
funs <- Filter(is.function, objs)
args_n <- lapply(funs, \(x) length(formals(x))) |>
  unlist()
args_n[which.max(args_n)]
args_n[args_n == 0]
rm(args_n)
rm(funs)
rm(objs)

## Composing functions
# there are three ways of composing: nesting, intermediate, piping

## Lexical Scoping
# scoping is defined as "the act of finding a value associated with a name".
# the rules for this are not intuituve!

x <- 10
g01 <- function() {
  x <- 20; x
}
g01() # will print 20
rm(g01, x)

# lexical scoping means that R looks up values based on HOW THEY WHERE CREATED,
# not how it is called. Lexical means that the scoping is based on parse-time, 
# rather than run-time.
# R has four rules for lexical scoping:
# 1. Name Masking
# 2. Function versus variables
# 3. A fresh start
# 4. Dynamic lookup

## Name Masking
# R always looks inside the function definition for a name 
# as a first try. If it cannot find the name inside, it moves
# one step up in the call stack. This applies to both values
# and functions.

## Functions versus variables
# As R sees variables and functions as objects, there can be 
# conflicts that should be avoided.

## A Fresh start
# Every time a function is called, it created a new "hosting environment".
# This means that a function has no memory whether it has been called once
# or twice. This means that each execution is independent, if the function
# is "pure". 

g11 <- function() {
  if (!exists("a")) {
    a <- 1
  } else {
    a <- a + 1
  }
  # a <<- a # Activate this, and runs are no longer independent
  a
}

g11(); g11(); g11()

## Dynamic lookup
# scoping only tells HOW to look up things, but not WHEN to find them.
# R looks for names/values when a function is called, not when it is 
# created.
g12 <- function() x + 1
x <- 15; g12()
x <- 20; g12()
# these produce different outputs... dangerous!

# findGlobals can show which symbols that are "unbound" inside the function.
codetools::findGlobals(g12)

environment(g12) <- emptyenv()
g12()
environment(g12) <- .GlobalEnv
g12()

# R relies on lexical scoping to find everything. Even things like "+",
# because it is a function.
lobstr::ast(`+`(5, `*`(5, `/`(10,5))))

## Lazy evaluation
# Function arguments are only evaluated if once they are accessed.
h01 <- function(x) 10 
h01(stop("This is an error!"))
# x is never used, so it will not do anything.
#
# In R, the lazy evaluation is powered by something called a "promise", which
# sometimes is called a "thunk". 
# 
# A promise is built up with three components:
# an expression -- delayed execution
# an environment -- where to evaluate
# a value -- computed and cached

double <- function(x) { 
  message("Calculating...")
  x * 2
}
h03 <- function(x) {
  c(x, x)
}
h03(double(20))

# caching here makes h03 only print calculating... once.
# You cannot mainpulate promises, as touching them will
# result in also invoking them.

## Defaults
# due to laziness, defaults can be specified in terms of other arguments.
# This is not recommended, as it obscures.

## Missing arguments
# you can use missing() to understand whether the argument comes
# from the user or from a default
h06 <- function(x = 10) {
  list(missing(x), x)
}
str(h06()) # will say missing = TRUE
str(h06(10)) # .. will say FALSE

# missingness is not always so clear-cut...
`%||%` <- function(lhs, rhs) {
  if (!is.null(lhs)) {
    lhs
  } else {
    rhs
  }
}
sample <- function(x, size = NULL, replace = FALSE, prob = NULL) {
  size <- size %||% length(x)
  x[sample.int(length(x), size, replace = replace, prob = prob)]
}

## dot-dot-dot
# can also be called varargs (variable arguments). It can hold
# any number of additional arguments.

i01 <- function(y, z) {
  list(y = y, z = z)
}

i02 <- function(x, ...) {
  i01(...)
}

i02(x = 1, y = 2, z = 3) |> str()

i03 <- function(...) {
  list(first = ..1, third = ..3)
}

i03(1, 2, 3) |> str()

i04 <- function(...) {
  list(...)
}
i04(a = 1, b = 2) |> str()

# ... comes with at least two downsides:
# 1: not easy to always explain how args will be used
# 2: misspelled arguments will produce unknown errors
sum(1, 2, NA, na_rm = TRUE)

sum(1, 2, 3)
mean(c(1, 2, 3))
sum(1, 2, 3, na.omit = TRUE)
mean(c(1, 2, 3), na.omit = TRUE)

## Exiting a functions
# Most functions exit by returning a value, showing success, throw an error, show failure.

# implicit return is simply without return()
# expliciti return is with return()

# invisible return
j04 <- function() invisible(1)
j04()
(j04())
withVisible(j04()) |> str()

# the most common invisible return is <-
# all functions that are called for their side effects
# should return invisibly.

## Errors
# if the functions does not work, it should stop
# on.exit() can be used to setup an exit handler.
# always have add = TRUE in on.exit.
# the argument AFTER controls when it is called, so it overrides the ordering
j06 <- function(x) {
  cat("Hello\n")
  on.exit(cat("Goodbye!\n"), add = TRUE)
  
  if (x) {
    return(10)
  } else {
    stop("Error")
  }
  
}

j06(x=TRUE)
j06(x=FALSE)

# after
j09 <- function() {
  invisible(rnorm(10))
  on.exit(message("a"), add = TRUE, after = TRUE)
  on.exit(message("b"), add = TRUE, after = FALSE)
}
j09()

## Functioing forms
# prefix, infix, replacement, special

options(warnPartialMatchArgs = TRUE)

# Replacement functions must have the name xxx<- 
`second<-` <- function(x, value) {
  x[2] <- value
  x
}
a <- 1:5
second(a) <- 3L

x <- runif(5)
`modify<-` <- function(x, position, value) {
  x[position] <- value
  x
}
modify(x, 2) <- 10
x

# what actually happens
x <- `modify<-`(x, 1, 10)


















