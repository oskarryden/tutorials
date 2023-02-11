# ------------------------------------------------------------------------------
# Chapter 8: Decision Trees

library(tree)
library(ISLR2)

attach(Carseats)

High <- factor(ifelse(Sales <= 8, "No", "Yes"))
Carseats[["High"]] <- High

tree.carseats <- tree(High ~  . -Sales, Carseats)
tree.carseats
summary(tree.carseats)
# Deviance-måttet är 

plot(tree.carseats)
text(tree.carseats, pretty = 0)

set.seed(2)
train <- sample(1:nrow(Carseats), 200)
Carseats.test <- Carseats[-train,]
High.test <- High[-train]
tree.carseats <- tree(High~. -Sales, Carseats, subset = train)
tree.pred <- predict(tree.carseats, Carseats.test, type="class")
table(tree.pred, High.test)
(104 + 50) / 200

set.seed(7)
cv.carseats <- cv.tree(tree.carseats, FUN = prune.misclass)

par(mfrow=c(1, 2))
plot(cv.carseats$size, cv.carseats$dev, type="b")
plot(cv.carseats$k, cv.carseats$dev, type="b")

prune.carseats <- prune.misclass(tree.carseats, best=9)
plot(prune.carseats)
text(prune.carseats, pretty = 0)

tree.pred <- predict(prune.carseats, Carseats.test, type="class")
table(tree.pred, High.test)
(97+58)/200
# ------------------------------------------------------------------------------
library(randomForest)
set.seed(1)
train <- sample(nrow(Boston), nrow(Boston)/2)
boston.test <- Boston[-train, "medv"]
bag.boston <- randomForest(medv ~ ., data = Boston, mtry = 12, subset = train, importance = TRUE) |> suppressWarnings()
bag.boston

yhat.bag <- predict(bag.boston, newdata = Boston[-train, ]) 
plot(yhat.bag, boston.test)
abline(0, 1)
mean((yhat.bag - boston.test)^2)

rf.boston <- randomForest(medv ~ ., data = Boston, mtry = 6, subset = train, importance = TRUE) |> suppressWarnings()
rf.boston
yhat.rf <- predict(rf.boston, newdata = Boston[-train, ]) 
plot(yhat.rf, boston.test)
abline(0, 1)
mean((yhat.rf - boston.test)^2)

importance(rf.boston)
varImpPlot(rf.boston)






