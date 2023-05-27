library(ISLR2)
library(e1071)

set.seed(2)
x <- matrix(rnorm(20 * 2), ncol = 2)
y <- c(rep(-1, 10), rep(1, 10))
x[y==1,] <- x[y==1,] + 1
plot(x, pch = 20, col = 5-y)

dat <- data.frame(x = x, y = as.factor(y))
svmf <- svm(y~., data = dat, kernel = "linear", cost = 2, scale = FALSE)
svmf |> summary()
plot(svmf, dat)


svmf <- svm(y~., data = dat, kernel = "polynomial", degree = 2, cost = 1, scale = FALSE)
plot(svmf, dat)

svmf <- svm(y~., data = dat, kernel = "polynomial", degree = 4, cost = 0.5, scale = FALSE)
plot(svmf, dat)

svmf <- svm(y~., data = dat, kernel = "radial", gamma = 0.5, cost = 2, scale = FALSE)
plot(svmf, dat)

set.seed(1)
x <- matrix(rnorm(20*2), ncol = 2)
y <- append(rep(-1, 10), rep(1, 10))
x[ y == 1, ] <- x[ y == 1, ] +1
plot(x, col = 3-y)

dat <- data.frame(x = x, y = as.factor(y))
fit1 <- e1071::svm(y ~ ., data = dat, kernel = "linear", cost = 10, scale = FALSE)
plot(fit1, dat)
fit1$index
summary(fit1)

fit2 <- e1071::svm(y~., data = dat, kernel = "linear", cost = 0.1, scale = FALSE)
summary(fit2)
fit2$index
plot(fit2,dat)

# För att skatta SVM
set.seed(1)
x <- matrix(rnorm(200*2), ncol = 2)
x[1:100, ] <- x[1:100, ] + 2
x[101:150, ] <- x[101:150, ] -2
y <- append(rep(1, 150), rep(2, 50))
dat <- data.frame(y = as.factor(y), x = x)
plot(dat, col =  scales::alpha(y, 1/3), pch = 19)

train <- sample(x = 200, size = 100)
svmfit <- e1071::svm(y ~ ., data=dat[train,], kernel="radial", gamma=1, cost=5)
plot(svmfit, dat[train,])

set.seed(1)
ranges <- list(cost = c(0.1, 1, 10, 100, 1000), gamma = c(0.5, 1, 2, 3, 4))
tune_out <- e1071::tune(
  METHOD = svm,
  y ~ ., data = dat[train,],
  kernel = "radial",
  ranges = ranges
)

summary(tune_out)

table(
  true = dat[-train, "y"],
  pred = predict(
    tune_out$best.model, newdata = dat[-train,]
  )
)


library(ROCR)
rocplot <- function(pred, truth, ...) {
  predob <- prediction(pred, truth)
  perf <- performance(predob, "tpr", "fpr")
  plot(perf, ...)
}

svmfit_opt <-
  svm(y ~ ., data=dat[train, ], kernel="radial",gamma=2, cost=1, decision.values = TRUE)
fitted <- attributes(
  predict(svmfit_opt, dat[train, ], decision.values = TRUE)
)$decision.values

par(mfrow = c(1,2))
rocplot(-fitted, dat[train, "y"], main = "Training")


svmfit_flex <- 
  svm(y ~ ., data = dat[train, ], kernel = "radial" ,gamma=50,cost=1, decision.values = T)
fitted<-attributes( predict(svmfit_flex, dat[train, ], decision.values = T) )$decision.values
rocplot(-fitted, dat[train, "y" ], add = T, col = "red")

fitted<-attributes(predict(svmfit_opt, dat[-train, ], decision.values = T))$decision.values
rocplot(-fitted, dat[-train, "y" ], main = "Test Data")
fitted<-attributes(predict(svmfit_flex, dat[-train, ], decision.values = T))$decision.values
rocplot(-fitted, dat[-train, "y" ], add = T, col = " red")



