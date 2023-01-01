# Section meta programming
# Chapters 17-20

library(rlang)

# Expressions
a <- expression(mean(rnorm(10)))
eval(a)

# Function that substitutes an sends an expression
substitute_expression <- function(x) {
	substitute(x)
}


a <- substitute_expression(a*10)
print(a); class(a); str(a); dim(a); summary(a)
a[[1]]; a[[2]]; a[[3]] 
eval(a, env = list(a = 1)) # 10
a[[1]] <- `-` # you can change the argument
eval(a, env = list(a = 1)) # -9

# create code for mean(rnorm(10)), unevaluated
to_call <- call("mean",  rnorm(10))
print(to_call)
eval(to_call)
to_call[[1]] <- `sd` # change to sd instead
print(to_call)
eval(to_call)

# Make an expression
z_xy <- expression({z <- x * y})
# Create in the global environmnet
x = 10; y = 10
eval(z_xy) # z will now be assigned to the global env.
get("z", envir = .GlobalEnv)
rm(z)
new_env <- new.env()
new_env$x <- 10
new_env$y <- 5
eval(z_xy, envir = new_env)
get("z", envir = .GlobalEnv) # no z...
ls.str(new_env) # there is z
get("z", envir = new_env)


# Complex expressions
yy <- expression(y * y)
eval(yy, env = list(x = 1, y = 0.25)) # works, bcs it is simple and 1d.
xy <- expression(x * y)
# This will not "carry" the already existing expressions
xy_yy <- expression(xy/yy)
aa <- expression(a*a)
bb <- expression(b*b)
expression(aa ^ bb) # expression is stupid and does not help here
s_xy_yy <- substitute(xy / yy)
substitute(aa + bb) # substitute is not better, and does not help
# both expression and substitute think xy and yy are symbols
# to be substituted and not expressions in themselves
eval(xy_yy, env = list(xy = 10, yy = 10, x = 1, y = 10)) # just 10/10
eval(s_xy_yy, env = list(xy = 10, yy = 10, x = 1, y = 10)) # ... same

# Bquote works here, becuase it can "unpack" expressions
# and quote parts of them but not others.
# Everything that is within .() will be substituted. the rest is quoted.
# If splice=TRUE, the terms that are wrapped inside ..() will evaluated and then spliced.
# Splice means "put together" the pieces.
# splicing and ..
xy_yy <- bquote(expr = ..(xy) / ..(yy), splice = TRUE, where = parent.frame())
print(xy_yy) # ah, that is want we want.
eval(xy_yy, env = list(x = 1, y = 10))
# splice = TRUE is critical, otherwise, it does not build back
xy_yy <- bquote(expr = ..(xy) / ..(yy), splice = FALSE, where = parent.frame())
print(xy_yy)
eval(xy_yy, env = list(x = 1, y = 10))
# ..() is also critical here, otherwise it does not evaluate
xy_yy <- bquote(expr = .(xy) / .(yy), splice = TRUE, where = parent.frame())
print(xy_yy)
eval(xy_yy, env = list(x = 2, y = 4))

# Symbols
?is.symbol # refers to an R object by name rather by value
or <- as.symbol("ro")
is.name(or)
str(or); as.character(or)
or <- substitute(or, list(or = 1))
is.name(or)
str(or)
# symbols are not vectorized; several of them must be in a list.

# Capture the expression with expression
x <- expression(read.table("important.csv", row.names = FALSE))
typeof(x) # expression
is.call(x) # it is not a call..
is.expression(x) # it is an expression
is.call(x[[1]]) # but the first list element contains the call
print(x[[1]][[1]]) # the first element is read.table
is.symbol(x[[1]][[1]]) # the first element of the first list element is a symbol
x[[1]][[3]] <- TRUE # change row.names arg to TRUE
print(x)
x[[1]][["header"]] <- TRUE # add a fourth argument
print(x)

# Operator precedence
lobstr::ast(!x %in% y)
lobstr::ast((1 + 10) * (-2))

# code in strings, parsing
abc <- "a <- b + c"
abc; is.call(abc)
is.expression(parse(text=abc))
is.call(parse(text=abc)[[1]])
abc_expr <- as.list(parse(text=abc)) # shortcut
deparse(abc_expr) # length 2
paste0(deparse(abc_expr), collapse = "") # length 1
rlang::expr_text(abc_expr) # length 1

# Special data structures
f <- expression(function(x, y = 10) x + y)
f[[1]][[2]] # here are the arguments
# pairlists are linked lists

# Quasiquotation
cement_base <- function(...) {
  args <- as.list(substitute(...()))
  print(args)
  paste(lapply(args, as.character), collapse = " ")
}

cement_base(hej, oskar) # still not working if the inputs are variablew
# Capturing expressions
# quote captures what you say
# Quotation: capturing expressions without executing.
rlang::expr(mean(x)) # expr and quote are equivalents
base::quote(mean(x))
# If we want to capture what is supplied to a function: we need to inject the quotation:
f <- function(x) rlang::enexpr(x)
g <- function(x) rlang::expr(x)
f(1+1) # yes
g(1+1) # no

# base R version of enexpr is substitute
h <- function(x) substitute(x)
d <- function(x) quote(x)
h(1*2) # yes
d(1*2) # no

# enexprs can capture dots as list
f <- function(...) rlang::enexprs(...)
f(a = 1, b = 2, c = 3)
# substitute in combination with as.list and ...
g <- function(...) as.list(substitute(...()))
g(a = 1, b=2, c= 3)

# Capturing symbols
# rlang::exprs and base::alist makes arguments into lists
f <- function(...) rlang::exprs(...)
f(a=1, b=2, c=d)
g(a=1, b=2, c=d)
rlang::exprs(a = 1, b = 1)
alist(b = 1, b = a)

# In general, we use quote / expr if we supply arguments,
# and then enexpr/enexprs or substitute for user supplied

# Substitute mainy quotes, but also substitute expressions
f <- function(x) substitute(x / 2)
f(a+b); f(10 + a)
f <- function(x) quote(x / 2)
f(a+b)

# substitute also accept an environment, where we can quote ( no substitute ) and substitute
expr_1 = substitute(expr = x*y / p , env = list(x = cos(1), y = quote(a+b), p = sin(1)))
a=1
b=0.5
eval(expr_1)

# Unquoting: to unquote a quoted object, so that quote(x) actually means x
# About rlang: The big difference is that rlang quoting functions are actually quasiquoting functions because they can also unquote
x <- rlang::expr(-1)
rlang::expr(f(!!x, y)) # f(-1, y)
rlang::expr(f(x, y)) # f(x, y)

a <- rlang::sym("y")
a
b <- 1
rlang::expr(f(!!a, !!b)) # f(y, 1)

a <- as.symbol("y")
bquote(.(a))
b <- 1
bquote(.(a) + .(b))
bquote(.(a) + b)
# a is unquoted to y, which is in the global
y = 22
eval(eval(substitute(bquote(.(a) + .(b)))))

# mean function with rlang
mean_rm_tidy <- function(var) {
  var <- rlang::ensym(var)
  e <- rlang::expr(mean(!!var, na.rm = TRUE))
  return(e)
}
rlang::expr(!!mean_rm_tidy(x) + !!mean_rm_tidy(y)) # mean(x, na.rm = TRUE) + mean(y, na.rm = TRUE)

# mean funtion in base
mean_rm_base <- function(var) {
  var <- as.symbol(substitute(var))
  e <- expression(mean(var, na.rm = TRUE))
  e <- e[[1]]
  e[[2]] <- eval(e[[2]])
  return(e)
}
# Put together
bquote(.(mean_rm_base(x)) + .(mean_rm_base(y)))

# eval it as single
eval(mean_rm_base(x), env = list(x = rnorm(10)))

# also evaluate
env_ <- pairlist(x = rnorm(10), y = runif(10))
expr_ <- bquote(.(mean_rm_base(x)) + .(mean_rm_base(y)))
eval(expr_, env_)

x1 <- rlang::expr(x + 1)
x2 <- rlang::expr(x + 2)

rlang::expr(!!x1 / !!x2)
#> (x + 1)/(x + 2)

xs <- rlang::exprs(1, a, -b)
rlang::expr(f(!!!xs, y))
# f(1, a, -b, y)

f <- rlang::expr(pkg::foo); f
f <- rlang::call2(f, rlang::expr(x), rlang::expr(y)); f # pkg::foo(x, y)
f_ <- expression(pkg::foo)[[1]]; f_
f_ <- as.call(list(f_, expression(x)[[1]], expression(y)[[1]])) # pkg::foo(x, y)
#f_[[2]] <- 10
f_

# Or with names
ys <- setNames(xs, c("a", "b", "c"))
rlang::expr(f(!!!ys, d = 4))
#> f(a = 1, b = a, c = -b, d = 4)


# Base R quasiquotes with bquote
xyz <- bquote(expr = (x + y + z)); xyz
abc <- expression(a * b * c); abc
# and unquotes with .()
bquote(.(xyz))
bquote(-.(xyz) / 2) # -(x + y + z)/2
bquote(2 * .(abc[[1]]) / 20)

ee <- list(a = 10, b = expression(q * q), c = expression(w * w), q = 10, w = 0.5)
aa <- bquote(expr = a + ..(b) + ..(c), where = ee, splice = TRUE)
class(aa); aa
str(aa)
eval(aa, env = ee)

# unquoting in base is not so easy;
# Base has certain non-quoting techniques instead
# Base functions that quote an argument use some other
# technique to allow indirect specification.
# Base R approaches selectively turn quoting off
# rather than using unquoting, so I call them non-quoting techniques
x <- list(var = 1, y = 2); x
var <- "y"
x$var
# [1] 1
x[[var]]
# [1] 2
# the indirect reference only works in the second option

# There are three other quoting functions closely related to $:
# subset(), transform(), and with().
# These are seen as wrappers around $ only suitable for interactive
# use so they all have the same non-quoting alternative

df <- data.frame(x = 1:5)
y <- 100
with(df, x + !!y) # y is turned into TRUE, which is 1
with(df, x + !y) # y is turned into FALSE, which is 0


# dot-dot-dot issues
dfs <- list(
  a = data.frame(x = 1, y = 2),
  b = data.frame(x = 3, y = 4))

# dplyr solution

system.time(dplyr::bind_rows(!!!dfs))
#>   x y
#> 1 1 2
#> 2 3 4

# base r solutions
system.time(do.call(rbind, dfs))
#>   x y
#> a 1 2
#> b 3 4

# tidy
var <- "x"
val <- c(4, 3, 9)
tibble::tibble(!!var := val)

# base
var <- "x"
val <- c(4, 3, 9)
args <- list(val)
names(args) <- var
do.call("data.frame", args)


f <- function(...) {
  #dots <- list(...) # this will evaluate
  dots <- as.list(substitute(...())) # this will quote

  if (length(dots) == 1 && is.list(dots[[1]])) {
    dots <- dots[[1]]
  }
  
  # Everything is stored in dots as a list element
  # Access it by [[]] and eval unless already done.
  
  # Do something
  dots
}

f(.a = data.frame(x = rnorm(5)), .b = 2*2)

expand.grid()
interaction

# alternative form
f <- function(..., .dots) {
  dots <- c(list(...), .dots)
  # Do something
  dots
}

f(.b = 2, .dots = list(.a = exp(10)))

# Map-Reduce
# Generate code
intercept <- (10)
coefs <- c(x1 = 5, x2 = -4)
coef_syms <- sapply(names(coefs), as.symbol)

summands <- Map(function(.x, .y) {
  bquote((.(.x) * .(.y)))
}, .y = coefs, .x = coef_syms)

summands <- c(intercept, summands); summands
# add together expressions

test <- lapply(summands, as.expression)
test <- bquote(.(test[[1]][[1]]) + .(test[[2]][[1]]) + .(test[[3]][[1]]))
str(test)

# Slicing arrays

# Evaluation
# Two important ideas:
# 1) quosures: a data structure that captures an expression along
# with its associated environment, as found in function arguments
# 2) data mask: which makes it easier to evaluate an expression
# in the context of a data frame.
# Together, quasiquotation, quosures, and data masks form what we call tidy evaluation

# eval()
# None of the evaluation functions quote their input
x <- 10
eval(rlang::expr(x))
eval(substitute(x))
eval(expression(x))
eval(quote(x))
eval(bquote(x))

y <- 2
eval(rlang::expr(x + y))
eval(substitute(y+x))

# eval() takes an environmnet (envir) as the second argumnet
eval(rlang::expr(x + y), rlang::env(x = 1000))

eval(quote(x+y), envir = list(x = 1/1000))
eval(substitute(x+y, env = list(x = 10)), envir = list(y = 1))

# The first argument is evaluated, not quoted, which can lead to confusing
# results once if you use a custom environment and forget to manually quote
eval(print(x + 1), list(x = 1000))

eval(rlang::expr(print(x + 1)), list(x = 1000))

# local()
# Clean up variables created earlier
rm(x, y)

foo <- local({
  x <- 10
  y <- 200
  x+y
})
foo # exists
x # dne
y # dne

# Create my own local environment
myLocal <- function(expr) {
  LocalEnv <- new.env()
  eval(substitute(expr), envir = LocalEnv)
}

foo <- myLocal({ 
  z = rnorm(10);
  x = 10;
  x+z
  })

# another version of local
local3 <- function(expr, envir = new.env()) {

  qcall <- quote(expr)
  eqcall <- eval(quote(expr))
  eqenvcall <- eval(quote(expr), envir)
  call <- substitute(eval(quote(expr), envir))
  print(list(qcall, eqcall, eqenvcall, call))
  
  eval(call, envir = parent.frame())
}

foo <- local3({ 
  z = rnorm(10);
  x = 10;
  x+z
})

# Expression vector
# base::eval() has special behaviour for expression vectors,
# evaluating each component in turn.


# Quosures
#Almost every use of eval() involves both an expression and environment.
# This coupling is so important that we need a data structure that can hold
# both pieces. Base R does not have such a structure105 so rlang fills the
# gap with the quosure, an object that contains an expression and an environment
# Quosures work with R promises.

foo <- function(x) rlang::enquo(x)
foo(a + b)

# new_quosure combines two parts: expression + environment
new_quosure(expr(x + y), env(x = 1, y = 10))

# eval_tidy()
# Quosures are paired with a new evaluation function eval_tidy()
# that takes a single quosure instead of an expression-environment pair. 
# An early version of tidy evaluation used formulas instead of quosures,
# as an attractive feature of ~ is that it provides quoting with a single keystroke.
# Unfortunately, however, there is no clean way to make ~ a quasiquoting function.
f <- ~{set.seed(a); rnorm(n)}
fenv <- new.env()
fenv$a <- 10
fenv$n <- 3
n = 2
eval(f[[2]], envir =  fenv)
attr(f, ".Environment")

parent.env(env = .GlobalEnv)
parent.env(env = fenv)

# Data mask
# In this section, you’ll learn about the data mask,
# a data frame where the evaluated code will look first for variable definitions.
# The data mask is the key idea that powers base functions
# like with(), subset() and transform(), and is used throughout
# the tidyverse in packages like dplyr and ggplot2.

q1 <- rlang::new_quosure(rlang::expr(x * y), rlang::env(x = 100))
df <- data.frame(y = 1:10)
rlang::eval_tidy(q1, df)

with2 <- function(data, expr) {
  expr <- rlang::enquo(expr)
  rlang::eval_tidy(expr, data)
}
x <- 100
with2(df, x * y)

# Base with
aenv <- list2env(list(
  x = 10, b = letters[1:5]
))
df <- data.frame(
  y = 40:50,
  yy = 50:40
)

with(data = df,
     expr = {
       if (!"x" %in% names(df)) x <- aenv$x
       yy * x
     },
     env = aenv)

# Subset version
sample_df <- data.frame(a = 1:10, b = 10:1, c = sample(1:10, 10))
# Shorthand for sample_df[sample_df$a >= 4, ]
subset(sample_df, a >= 4)
# Shorthand for sample_df[sample_df$b == sample_df$c, ]
subset(sample_df, b == c)


subset2 <- function(data, rows) {
  rows <- rlang::enquo(rows)
  rows_val <- rlang::eval_tidy(rows, data)
  stopifnot(is.logical(rows_val))
  
  data[rows_val, , drop = FALSE]
}

subset3 <- function(data, rows) {
  rows <- substitute(rows)
  rows_val <- eval(rows, envir = as.list(data))
  stopifnot(is.logical(rows_val))
  
  data[rows_val, , drop = FALSE]
}

ex <- expression(b==c | c >= a)

system.time(subset(sample_df, eval(ex)))
system.time(subset2(sample_df, eval(ex)))
system.time(subset3(sample_df, eval(ex)))

# transform()
df <- data.frame(x = c(2, 3, 1), y = runif(3))
transform(df, x = -x, y2 = 2 * y)

# We use a loop because we want to be able to build sequential things.
transform2 <- function(.data, ...) {
  dots <- rlang::enquos(...)
  
  for (i in seq_along(dots)) {
    name <- names(dots)[[i]]
    dot <- dots[[i]]
    
    .data[[name]] <- rlang::eval_tidy(dot, .data)
  }
  
  .data
}

transform3 <- function(.data, ...) {
  dots <- as.list(substitute(...()))
  
  for (i in seq_along(dots)) {
    name <- names(dots)[[i]]
    dot <- dots[[i]]
    
    # You can build sequential stuff
    .data[[name]] <- eval(dot, envir = as.list(.data))

  }
  
  .data
}

transform3(df, xx = x * 2, n_y = -y, n_y_n_y = n_y * 2)
 
# a variant of select
df <- data.frame(a = 1, b = 2, c = 3, d = 4, e = 5)
subset(df, select = b:d)
vars <- as.list(setNames(seq_along(df), names(df)))
str(vars)

select2 <- function(data, ...) {
  dots <- rlang::enquos(...)
  
  vars <- as.list(rlang::set_names(seq_along(data), names(data)))
  cols <- unlist(purrr::map(dots, rlang::eval_tidy, vars))
  
  data[, cols, drop = FALSE]
}
select2(df, b:d)

# base
select3 <- function(data, ...) {
  dots <- as.list(substitute(...()))
  
  vars <- as.list(setNames(seq_along(data), names(data)))
  cols <- unlist(lapply(dots, function(x) {
    eval(x, envir = vars)
  }))

  data[, cols, drop = FALSE]
}

system.time(subset(df, select = c(a,e)))
system.time(select2(df, list(a, e)))
system.time(select3(df, list(a, e)))
system.time(dplyr::select(df, a, e))

# Base evauluation basics
# substitute() and evaluation in the caller environment, as used by subset().
# This technique is not programming friendly, as warned about in the subset() documentation.

# match.call(), call manipulation, and evaluation in the caller environment,
# as used by write.csv() and lm(). I’ll use this technique to demonstrate how
# quasiquotation and (regular) evaluation can help you write wrappers around such functions.

subset_base <- function(data, rows) {
  rows <- substitute(rows)
  rows_val <- eval(rows, data, rlang::caller_env())
  stopifnot(is.logical(rows_val))
  
  data[rows_val, , drop = FALSE]
}

subset_base_mine <- function(data, rows) {
  rows <- substitute(rows)
  rows_val <- eval(rows, envir = as.list(data))
  stopifnot(is.logical(rows_val))
  
  data[rows_val, , drop = FALSE]
}


subset_tidy <- function(data, rows) {
  rows <- rlang::enquo(rows)
  rows_val <- rlang::eval_tidy(rows, data)
  stopifnot(is.logical(rows_val))
  
  data[rows_val, , drop = FALSE]
}
d <- 5
subset_tidy(sample_df, b > d)
subset_base(sample_df, b > d)
subset_base_mine(sample_df, b > d)
dplyr::filter(sample_df, b > d)

# match.call()
# Another common form of NSE is to capture the complete call with match.call(),
# modify it, and evaluate the result. match.call() is similar to substitute(),
# but instead of capturing a single argument,
# it captures the complete call. It doesn’t have an equivalent in rlang.

g <- function(x, y, z) {
  match.call()
}
g(1, 2, 3)
# g(x = 1, y = 2, z = 3)

# Note that at many times, we do not require NSE tech.

# wrappers
lm2 <- function(formula, data) {
  lm(formula, data)
}
lm2(mpg ~ disp, mtcars)



Reduce(f = quote, x = summands, accumulate = TRUE)
!TRUE
!!TRUE
!!!TRUE




# Environments
env <- new.env() # creates a new environment
is.environment(env)
env$x <- 2
env$y <- 4
ls.str(env)

eval(yy, env)

env_string <- new.env()
env_string$`+` <- function(x,y) paste0(x,y)
env_string$x <- letters[5]
env_string$y <- "oskar"

eval(expression(x + "_hej"), env_string)

# expressions

y <- a * 10
y <- expression(a * 10)
a = 10
y <- eval(y)
y

lobstr::ast(f(1, "y", 2))

y <- x * 10
`<-`(y, `*`(x, 10))
y

lobstr::ast(expression(f(g(h)))

#> y <- x * 10

identical(eval(expression(TRUE)), TRUE)
#> [1] TRUE
identical(expr(1), 1)
#> [1] TRUE
identical(expr(2L), 2L)
#> [1] TRUE
identical(expr("x"), "x")
#> [1] TRUE

aa <- c("10", "20")
lapply(aa, FUN = as.symbol)
rlang::syms(aa)

rr <- expression(readRDS("this.rds", refhook = "aj"))
cc  = call("readRDS", "this.file.rds")
is.call(cc)
as.list(cc)

cc$refhook = FALSE
cc

rlang::call2(bquote(base::mean) , x = expression(x), na.rm = TRUE)
?Syntax

x1 <- "y <- x + 10"
y1 <- as.list(parse(text = x1))
deparse(y1[[1]])





exp1 <- parse(text = c("
x <- 4
x
"))
exp2 <- expression(x <- 4, x)

typeof(exp1)
#> [1] "expression"
typeof(exp2)
#> [1] "expression"

exp1
#> expression(x <- 4, x)
exp2
#> expression(x <- 4, x)
exp1[[1]]
length(exp2)

paste("Good", "morning", "Hadley")






