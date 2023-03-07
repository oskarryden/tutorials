
library(ISLR2)
Gitters <- na.omit(Hitters)
n <- nrow(Gitters)
set.seed(13)
ntest <- trunc(n/3)
testid <- sample(n, ntest)

library(keras)
library(tensorflow)
library(reticulate)
path_to_python <- install_python()
virtualenv_create("r-reticulate", python = path_to_python)
install_tensorflow(envname = "r-reticulate")
install_keras(envname = "r-reticulate")

modnn <-
    keras_model_sequential() |> 
    layer_dense(
        units = 50,
        activation = "relu",
        input_shape = ncol(x)) |> 
    layer_dropout(rate = 0.4) |> 
    layer_dense(units = 1)




install.packages("keras")
library(keras)

library(tensorflow)
tf$constant("Hello Tensorflow!")