# Chapter 4

# quote
quote(1 + 2)

f <- quote(if (TRUE) 1 )
length(f)
class(f)
str(f)
typeof(f)
for (i in 1:length(f)) cat(print(f[[i]]), sep = "\n")

f <- quote(if (x) print(1:4) else print(y))
is.call(f)
length(f)
class(f)
str(f)
typeof(f)
for (i in 1:length(f)) print(f[[i]])
f[[2]]

# expression
x <- quote(f(x,y,z))
class(x)
length(x)
is.call(x) # true
is.call(quote(y)) # false: numbers are expressions already

# recursion
is.atomic(4)
x <- 4
is.atomic(x)

is.name(5)
f <- function(x) is.name(x)
f(quote(x))

is.call(x)
is.call(5)
is.call(quote(x))
y <- 1
is.call(x+y)
is.call(quote(x+y))

z <- pairlist(a = 1, b = 2, c = 3)
is.pairlist(z)
class(z)
is.list(z)
is.pairlist(as.list(z))



