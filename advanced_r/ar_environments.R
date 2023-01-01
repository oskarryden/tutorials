# Chapter 7 environments
#
# chapter uses rlang::
library(rlang)

# An environment is similar to a named list:
# every name must be unique
# names are not ordered in the environment
# an environment has a parent environment
# environments are not copied when they are modified

## Basics
# we can create a new environment using new.env() or rlang::env()
e1 <- new.env()
e1[["a"]] <- FALSE
e1[["b"]] <- TRUE
e1[["c"]] <- rnorm(10)
e1[["d"]] <- 45

e2 <- env(a = FALSE, b = TRUE, c = rnorm(10), d = 45)

ls.str(e1)
ls.str(e2)

# Every environment does one main thing:
# it binds a name to a value
# the name is the binding, which references a value

env_print(e1)
env_print(e2)

# print all bindings
ls(e1, all.names = TRUE)
names(e1)
env_names(e2)

## important environments
# the global environment and the current environment
# they are not always the same
# if you want to compare environments, you will need to use identical()
identical(global_env(), current_env())
global_env() == current_env()
identical(globalenv(), environment())

# we can access the global environment using globalenv()
globalenv()
# we can access the current environment using environment()
environment()

## parent environments
# every environment has a parent, which is another environment.
# the relation, defines the blueprint for lexical scoping: if the binding is
# not found in the current environment, R looks in the parent, and so on.

e2a <- env(d = 4, e = 5); env_print(e2a)
e2b <- env(e2a, a = 1, b = 2, c = 3); env_print(e2b)

# e2a will have the global environment as its parent
# e2b will have e2b as its
env_parent(e2a); env_parent(e2b)
parent.env(e2a); parent.env(e2b)

# there is only one environment that lacks a parent: the empty environment:
# it is called R_EmptyEnv
emptyenv()

## super assignment
# <- assigns within the current environment
# <<- assings to the parent

## Getting and setting values 
# we can use $ and [[]] as normal
# but we cannot use [[]] with numeric
# indices or just [].

ls.str(e1)
exists("a", envir = e1)
env_has(e1, "a")

## get(), assign(), exists(), and rm().
#These are designed interactively for use with the current environment,
# so working with other environments is a little clunky.
# Also beware the inherits argument: it defaults to TRUE meaning that the
# base equivalents will inspect the supplied environment and all its ancestors.

?delayedAssign
msg = "old"
delayedAssign("x", msg)
substitute(x)
msg = "new"
rm(x)

ne <- new.env()
delayedAssign("x", pi+2, assign.env = ne)
# you can see the promise without evaluating it by substitute:
substitute(x, ne)
# evaluate it!
eval(substitute(x, env = ne))

delayedAssign("oskar",
              value = toupper("oskar"), assign.env = ne)
substitute(oskar, ne)
da <- oskar

## Recursing over environments
where <- function(name, env = caller_env()) {
  if (identical(env, empty_env())) {
    # Base case
    stop("Can't find ", name, call. = FALSE)
  } else if (env_has(env, name)) {
    # Success case
    env
  } else {
    # Recursive case
    where(name, env_parent(env))
  }
}

where("mean")

## Special environments
# Most environment are not created by me.
# Rather, it is R that creates most environments:
# package environments and function environments.

## Package environments and search paths
# whenever you call require or library, those packages
# are turned into a parent to the global environment.
# e.g. package A > global.
# this sequence is known as a search path, which can be exposed using search()
search()
# The sequence always ends with the base environment and then R_EmptyEnv.
# The Autoloads environment is for delayed assignment of big datasets
# the package:base, or base, is for the base package. This can be accessed
# using baseenv() or base_env()
ls.str(baseenv())

# The sequence of the library calls matters: the latest package called,
# becomes the parent environment of the global environment.

library(dplyr)
search()
library(data.table)
search()
detach(name = "package:dplyr")
detach(name = "package:data.table")
search()

## Function environments, aka closures!
# all functions binds its current environment when it is executed.
# this is then used for lexical scoping. This environment is called
# the function environment, but also its closure.

# you can use the fn_env or environment to see the environment of the 
# function
y = 1
f <- function(x) x+y
fn_env(f)
environment(f)

## namespaces
# the namespace makes sure that the order of library/require does not matter.
# nor whether there is a conflict between functions with the same name from
# different packages.
# imports
# :: or :::

## execution environments
# An execution environment is usually ephemeral;
# once the function has completed, the environment will be garbage collected.

## call stacks
# This provides the environment from which the function was called
# and hence varies based on how the function is called, not how the function was created.
# parent.frame() is equivalent to caller_env(); just note that it returns an environment, not a frame.

# a call stack is made up out of frames.
# when you execute a function, the execution environment is created, 
# which is a child of the function environment, which depends on where
# it was created. 

f <- function(x) {
  g(x = 2)
}

g <- function(x) {
  fn <- sys.call(0)
  h(x = fn)
}

h <- function(x) {
  fn <- sys.call(-1)
  print(fn)
  print(x)
  stop()
}

main <- function(x) {
  f(x)
}

do.call(main, list(x = 1))


# traceback will show the call stack
traceback()
sys.status()
sys.calls()
sys.parent()
sys.frames()
sys.frame()
sys.function()

# sys.status
a <- function() {
  x <- rnorm(10)
  sys_stat <- sys.status()
  print(sys_stat)
  
  firstfun <- as.character(sys_stat[[1]][[1]][[1]])
  secondfun <- as.character(sys_stat[[1]][[2]][[1]])
  print(class(firstfun))
  sprintf("mean of %f from calling %s who called %s",
          mean(x),
          firstfun,
          secondfun)
  
}
b <- function() { a() }
b()

# we can also use lobstr::cst() instead of stop() + traceback()
h <- function(x) {
  lobstr::cst()
}
f(1)

# the call stack above is simple. For more complicated onces, we need other tools.

## Lazy evaluation
# this call stack will be much more complicated, because of f()
a <- function(x) b(x)
b <- function(x) c(x)
c <- function(x) x

a(f())
#> █
#> ├─a(f())
#> │ └─b(x)
#> │   └─c(x)
#> └─f()
#>   └─g(x = 2)
#>     └─h(x = 3)
#>       └─lobstr::cst()

## Frames
# each element in a stack is called a frame, aka evaluation context.
# a frame has three elements:
# expression, which defines the call
# environment, typically the execution environment
# parent, which is typically the previous frame

# when a langauge looks up variables in a calling stack rathern
# than in an enclosing environment, it is called dynamic scoping.
# it is not often used, because: not only do you need to know 1) how it was defined,
# you also need to know 2) the context in which it was called.

## As data structures
# Since environments have reference semantics, you’ll never accidentally create a copy.
# But bare environments are painful to work with, so instead I recommend using R6 objects,
# which are built on top of environments.








