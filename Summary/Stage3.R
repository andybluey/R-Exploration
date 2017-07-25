# Testing your model's accuracy
# Predict using trained model against test data

#   Logistic Regression
logRegPrediction <- predict(logisticRegModel, testDataFiltered)

#    Get detailed statistics of prediction versus actual via Confusion Matrix 
logRegConfMat <- confusionMatrix(logRegPrediction, testDataFiltered[,"ARR_DEL15"])
logRegConfMat

# Improving performance

# Use the Random Forest algorithm which creates multiple decision trees and to improve performance

library(randomForest)

# This code will run for a while
rfModel <- randomForest(trainDataFiltered[-1], trainDataFiltered$ARR_DEL15, proximity = TRUE, importance = TRUE)
rfModel

#   Random Forest
rfValidation <- predict(rfModel, testDataFiltered)

#    Get detailed statistics of prediction versus actual via Confusion Matrix 
rfConfMat <- confusionMatrix(rfValidation, testDataFiltered[,"ARR_DEL15"])
rfConfMat

