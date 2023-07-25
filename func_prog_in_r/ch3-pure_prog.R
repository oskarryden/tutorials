# Recursion
# For recursion, identify the base case and the recursive case
# Base case: the case where the function returns a value without calling itself
# Recursive case: the case where the function calls itself
linear_search <- function(element, sequence) {
    if (is_empty(sequence)) {
        return(FALSE)
    } else if (first(sequence) == element) {
        return(TRUE)
    } else {
        return(linear_search(element, rest(sequence)))
    }
}

is_empty <- function(sequence) {
    length(sequence) == 0
}

first <- function(sequence) {
    sequence[1]
}

# Bad code because it will be quadratic time, not linear
rest <- function(sequence) {
    sequence[-1]
}

x <- 1:5
linear_search("x", x)
linear_search(3, x)

next_list <- function(element, rest = NULL) {
    list(element = element, rest = rest)
}

x <- next_list(1, next_list(2))

nl_is_empty <- function(nl) is.null(nl)
nl_first <- function(nl) nl$element
nl_rest <- function(nl) nl$rest

nl_linear_search <- function(element, nl) {
    if (nl_is_empty(nl)) {
        return(FALSE)
    } else if (nl_first(nl) == element) {
        return(TRUE)
    } else {
        return(nl_linear_search(element, nl_rest(nl)))
    }
}

nl_linear_search(1, x)
nl_linear_search(2, x)
nl_linear_search(3, x)


# Using an index approach
i_is_empty <- function(i, x) {
    i > length(x)
}

i_first <- function(i, x) {
    x[i]
}

i_vector_to_next_list <- function(x, i = 1) {
    if (i_is_empty(i, x)) {
        return(NULL)
    } else {
        return(next_list(i_first(i, x), i_vector_to_next_list(x, i + 1)))
    }
}

i_lin_search <- function(element, sequence, i = 1) {
    if (i_is_empty(i, sequence)) {
        return(FALSE)
    } else if (i_first(i, sequence) == element) {
        return(TRUE)
    } else {
        return(i_lin_search(element, sequence, i + 1))
    }
}

i_lin_search(1, 1:5)
i_lin_search("w", 1:5)

lin_search <- function(x, sequence, i = 1) {
    if (i > length(sequence)) {
        return(FALSE)
    } else if (sequence[i] == x) {
        return(TRUE)
    } else {
        lin_search(x, sequence, i + 1)
    }
}

lin_search(6, 1:5)

recursive_factorial <- function(n) {
    if (n < 1) stop("n must be a positive integer", call. = FALSE)
    if (n == 1) 1 
    else n * recursive_factorial(n - 1)
}

recursive_factorial(2)

# vector remove duplicates
vector_rm_duplicates <- function(x) {
    dup <- find_duplicates(x)
    x[-dup]
}

find_duplicates <- function(x, i = 1) {
    if (i >= length(x)) return(c())

    if (x[i] == x[i+1]) c(i, find_duplicates(x, i + 1))
    else find_duplicates(x, i + 1)
}

x <- c(1,2,2,3,4,5,6,7,7,8,9,10,1)

find_duplicates(x)
vector_rm_duplicates(x)

# tail recursion
# tail recursion is when the recursive call is the last thing the function does
# tail recursion can be optimized by the compiler to be iterative
# tail recursion is not possible in R


acc_factorial <- function(n, acc = 1) {
    if (n == 1) acc
    else acc_factorial(n-1, acc * n)
}

acc_factorial(1)
acc_factorial(2)
acc_factorial(3)