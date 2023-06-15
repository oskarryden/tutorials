
f <- function(x=5) {
    y = x + 2
    sys.function()
}

f(4)

f <- function(x=5) {
    y = x + 2
    formals()
}

f(2)

f <- function(x=5) {
    y = x + 2
    body()
}

f(2)

f <- function(x=5) {
    y = x + 2
    environment()
}

fenv <- f(2)
fenv
as.list(fenv)
parent.env(fenv)

f <- function(x=5) {
    y = x + 2
    parent.env(environment())
}

f(2)

f <- function(x=1:3) {
    print(formals()$x)
    x
}

f(x = 33)

f <- function(x=1:3){
    substitute(x)
}

f()

eval(f())

f(2 * 10)
f(oskar * ryden)

f <- function(x=1:3, y = x){
    substitute(x + y)
}

f()
f(x = 1)
f(y = 9)
f(x = 1, y = 0.5)
f(x = 2, y = 3 * x)

x <- 10
eval(f(y = 2))
eval(f(x = 2*x))

f <- function(x){
    cat(deparse(substitute(x)), "=" , x, "\n")
}

f(10+10)

f <- function(x) substitute(x)
f(10) |> class()
f(10) |> typeof()
f(10) |> mode()
f(10) |> is.call()
f(10+1) |> is.call()

f <- function(x) {
    y = 2*x; substitute(y)
}

f(10)
f(10) |> class()


x <- 11
substitute(x)
class(substitute(x))

f <- function(x,y,z) {
    substitute(y + x + z)
}

f(1,2,3)
f(1,2,3) |> class()
mc <- f(1,2,3) 
str(mc)
as.list(mc)
eval(mc)

mc <- f(x, y, z)
as.list(mc)
eval(mc)
eval(mc, list(x = 1, y = 2, z = 3))
mc[[2]] <- 5 + 2
mc[[3]] <- 5
eval(mc)

f <- function(x, y) {
    match.call()
}

mc <- f(2, exp(2))
mc
mc[[1]]
as.list(mc)

g <- function(x, y) {
    h <- f
    h(x, y)
}

g(2, exp(2))
f(2, exp(2))

bind <- function(...){
    bindings <- eval(substitute(alist(...)))
    scope <- parent.frame()
    structure(list(bindings = bindings, scope = scope, class = "bindings"))
    }

bind(x, y, z)
bind(x = 1, y = 2, z = 3)

.unpack <- function(x) unname(unlist(x, use.names = FALSE))[1]

`%<-%` <- function(bindings, values){

    var_names <- names(bindings$bindings)
    val_names <- names(values)
    has_names <- which(nchar(val_names) > 0)
    value_env <- list2env(as.list(values[has_names]), parent = bindings$scope)

    for(i in seq_along(bindings$bindings)){
        name <- var_names[i]
        if (length(var_names) == 0 || nchar(name) == 0) {
            variable <- bindings$bindings[[i]]

        if (!is.name(variable)) {
            stop(paste0("Positional variables cannot be expressions " , deparse(variable), "\n"))
        }

        val <- .unpack(values[i])
        assign(as.character(variable), val, envir = bindings$scope)
    } else {
        assignment <- substitute(delayedAssign(
            name,
            expr,
            eval.env = value_env,
            assign.env = bindings$scope),
            
            list(expr = bindings$bindings[[i]]))
        eval(assignment)
        }
    }
    for (name in var_names) {
        if (nchar(name) > 0) {
            force(bindings$scope[[name]])
        }
    }
}

bind(x, y, z) %<-% c(1, 2, 3)
x;y;z

bind(x, y, z) %<-% c(55, 22, 77)
x;y;z

bind(x, y, z) %<-% c(z = 55)
x;y;z




nested <- function(x) {
    function(local) {
        if (local) x else get("x", envir = parent.frame())
    }
}

f <- nested(10) # x = 10 exists in closure now
f(TRUE) # as given in nested enclosure
f(FALSE) # as given in parent frame

listsub <- function(...) {
    eval(substitute(alist(...)))
}
