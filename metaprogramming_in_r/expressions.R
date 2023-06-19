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


