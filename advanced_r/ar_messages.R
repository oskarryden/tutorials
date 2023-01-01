# Chapter 8

# The condition system provides a paired set of tools
# that allow the author of a function to indicate that
# something unusual is happening, and the user of that
# function to deal with it.
#
# The function author signals conditions with functions
# like stop() (for errors), warning() (for warnings),
# and message() (for messages), then the function user
# can handle them with functions like tryCatch() and
# withCallingHandlers(). 

# R inherrits this from Commons Lisp. Good resources
# for understanding this: 
# http://homepage.stat.uiowa.edu/~luke/R/exceptions/simpcond.html
# https://gigamonkeys.com/book/beyond-exception-handling-conditions-and-restarts.html
# http://adv-r.had.co.nz/beyond-exception-handling.html

# ---

library(rlang)

# Signalling conditions
# Errors > Warnings > Messages
# break CTRL+C style is also a condition

# error
stop("This is what an error looks like")
f <- function() g()
g <- function() h()
h <- function() stop("This is an error!")
f() # h will call stop
# Setting call. = FALSE will just print the error txt
h <- function() stop("This is an error!", call. = FALSE)
f()

# The rlang equivalent is abort()

# Warning
warning("This is what a warning looks like")
# it is possible to have multiple warnings
fw <- function() {
  cat("1\n")
  warning("Warning 1")
  cat("2\n")
  warning("W2")
  cat("3\n")
  warning("W3")
}

# they are cached and printed at the end 
# under options(warn = 0)
options(warn = 0)
fw()

# options(warn = 1) prints warnings as they happen
options(warn = 1)
fw()

# options(warn = 3) turns warnings into proper errors
# option(warn=3) is good for debugging, as traceback()
# then signals its place.
options(warn = 3)
fw()
#traceback()

# warning has a call. argument.

options(warn = 0)
fw()

# messages are always printed when they appear
# the function does not have a call. argument
message("This is what a message looks like")

fm <- function() {
  cat("1\n")
  message("M1")
  cat("2\n")
  message("M2")
  cat("3\n")
  message("M3")
}

fm()

# When writing a package, you sometimes want to display
# a message when your package is loaded (i.e. in .onAttach());
# here you must use packageStartupMessage().

# In other words, cat() is for when the user asks for something
# to be printed and message() is for when the developer elects
# to print something.

# Ignoring conditions
# We can often ignore conditions
# ignore errors with try()
# ignore messages with suppressMessages()
# ... suppressWarnings()

# try() will try to continue the function
f1 <- function(x) {
  log(x)
  
  message("if you see me, try() worked")
}
f1("x")
# Error in log(x): non-numeric argument to mathematical function
f2 <- function(x) {
  try(log(x))
  
  message("if you see me, try() worked")
}
f2("x")

suppressWarnings({
  warning("Uhoh!")
  warning("Another warning")
  1000
})

suppressMessages({
  message("Hello there")
  21
})

suppressWarnings({
  message("You can still see me")
  3
})

# Handling conditions
# conditions have default behaviors
# errors stop execution and return to the top level
# warnings are captured and displayed in aggregate
# messages are immediately displayed.

# Condition handlers allow us to temporarily override or supplement the default behaviour

# tryCatch() defines exiting handlers
# after the condition is handled, control returns to the context where tryCatch() was called.
# This makes tryCatch() most suitable for working with errors and interrupts,
# as these have to exit anyway.

tryCatch(
  error = function(cnd) {
    # code to run when error is thrown
  },
  1+1
)


# withCallingHandlers() defines calling handlers
# after the condition is captured control returns to the context where the condition was signalled.
# This makes it most suitable for working with non-error conditions
withCallingHandlers(
  warning = function(cnd) {
    # code to run when warning is signalled
  },
  message = function(cnd) {
    # code to run when message is signalled
  },
  median(rnorm(10))
)

# Condition objects

cnd <- catch_cnd(stop("An error"))
str(cnd)
conditionMessage(cnd)
conditionCall(cnd)
rm(cnd)

# Exiting handlers
f3 <- function(x) {
  
  first_class <- class(x)[1]
  #
  # Try catch will produce a cnd, that can be printed like below!
  tryCatch(
    error = function(cnd) message(sprintf("Cannot find log of %s due to %s", first_class, cnd)),
    log(x)
  )
}
f3("x")

# If no conditions are signalled, or the class of the signalled condition
# does not match the handler name, the code executes normally

# The handlers set up by tryCatch() are called exiting handlers because after
# the condition is signalled, control passes to the handler and never returns
# to the original code, effectively meaning that the code exits
tryCatch(
  message = function(cnd) "return(NULL)",
  {
    message("Here")
    stop("This code is never run!")
  }
)

# The handler functions are called with a single argument, the condition object.
# I call this argument cnd, by convention. This value is only moderately useful
# for the base conditions because they contain relatively little data.
# It’s more useful when you make your own custom conditions, as you’ll see shortly.
tryCatch(
  error = function(cnd) {
    paste0("--", conditionMessage(cnd), "--")
  },
  stop("This is an error")
)

# tryCatch() has one other argument: finally
# It specifies a block of code (not a function) to run regardless of whether the
# initial expression succeeds or fails. This can be useful for clean up,
# like deleting files, or closing connections. This is functionally equivalent
# to using on.exit() (and indeed that’s how it’s implemented) but it can wrap
# smaller chunks of code than an entire function.
path <- tempfile()
tryCatch(
  {
    writeLines("Hi!", path)
    readLines(path)
  },
  finally = {
    # always run
    unlink(path) # delete the file
  }
)

# Calling Handlers

# The handlers set up by tryCatch() are called exiting handlers, because they cause code
# to exit once the condition has been caught. By contrast, withCallingHandlers() sets up
# calling handlers: code execution continues normally once the handler returns.
# This tends to make withCallingHandlers() a more natural pairing with the non-error conditions.
# Exiting and calling handlers use “handler” in slighty different senses:
  
# tryCatch: An exiting handler handles a signal like you handle a problem; it makes the problem go away.
# withCallingHandlers: A calling handler handles a signal like you handle a car; the car still exists.
tryCatch(
  message = function(cnd) cat("Caught a message!\n"), 
  {
    message("Someone there?")
    message("Why, yes!")
  }
)

withCallingHandlers(
  message = function(cnd) message("Caught a message!\n"), 
  {
    message("Someone there?")
    message("Why, yes!")
  }
)

withCallingHandlers(
  # message = can be used to indicate what went wrong?
  message = function(cnd) message("Second message"),
  #{
    #message("First message")
    message("third one")
  #}
)

# Call Stacks
##### NOT DONE YET




