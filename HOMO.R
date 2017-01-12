## HOMOGENEOUS MODEL


#********************** HOMOGENEOUS Network construction function *********************#

##Arguments
# train_dataset: the 60 % of the data to train the network
# test_dataset: the 40 % of the data to test the network
# predictor_order: the no. of supplied past historical data (sample input range: 3 <-> 10)
# learning_rate : the learning rate to train the network (sample input range : 1 <-> 0.05)

# Return Values 
# 


HOMO <- function(train_dataset,test_dataset,usd_non_normalize,predictor_order,learning_rate){
        source("MLP.R")
        require(RSNNS)
        ## FIRST MLP
        set.seed(1)
        weight_size =length(train_dataset[,1])
        weight1 <- sample(1:1000,size = weight_size,replace = F)
        weight1 = normalizeData(weight1, type = "0_1")
        
        ## Train the network using neuralnet (First MLP)
        first <- MLP( train_dataset,test_dataset,usd_non_normalize,predictor_order,learning_rate,weight1)
        
        ## First performance ERROR
        mae(first[[2]])
        rmse(first[[2]])
        
        ## SECOND MLP
        set.seed(2)
        weight_size =length(train_dataset[,1])
        weight2 <- sample(1:1000,size = weight_size,replace = F)
        weight2 = normalizeData(weight2, type = "0_1")
        ## Train the network using neuralnet (First MLP)
        second <- MLP( train_dataset,test_dataset,usd_non_normalize,predictor_order,learning_rate,weight2)
        
        ## Second Performance ERROR
        mae(second[[2]])
        rmse(second[[2]])
        
        ## THIRD MLP
        set.seed(3)
        weight_size =length(train_dataset[,1])
        weight3 <- sample(1:1000,size = weight_size,replace = F)
        weight3 = normalizeData(weight3, type = "0_1")
        ## Train the network using neuralnet (First MLP)
        third <-  first <- MLP( train_dataset,test_dataset,usd_non_normalize,predictor_order,learning_rate,weight3)
        
        ## Third Performance ERROR
        mae(third[[2]])
        rmse(third[[2]])
        
        ## Predicted Value from all Three Network
        all_predicted <- cbind(first[[1]],second[[1]],third[[1]])
        all_predicted <-as.data.frame(all_predicted)
        names(all_predicted)<- c("First MLP", "Second MLP", "Third MLP")
        
        actual <- denormalized(test_dataset[,predictor_order+1],usd_non_normalize)
        
        min_value <-apply(all_predicted,1, min)
        max_value <- apply(all_predicted,1,max)
        mean_value <- apply(all_predicted,1,mean)
        
        error_min <- actual - min_value
        error_max <- actual - max_value
        error_mean <- actual - mean_value
        
        error_all_after_fusion <- as.data.frame(cbind(error_min,error_max,error_mean))
        names(error_all_after_fusion) <- c("MIN","MAX","MEAN")
        
        
    
        rmse_min <- rmse(error_all_after_fusion$MIN)
        mae_min <- mae(error_all_after_fusion$MIN)
        rmse_max <- rmse(error_all_after_fusion$MAX)
        mae_max <- mae(error_all_after_fusion$MAX)
        rmse_mean <- rmse(error_all_after_fusion$MEAN)
        mae_mean<- mae(error_all_after_fusion$MEAN)
        
       rmse_rate <- min(rmse_min,rmse_max,rmse_mean)
       mae_rate <- min(mae_max,mae_mean,mae_min)
       
       if(rmse_rate == rmse_max && mae_rate == mae_max){
               final_result = list(max_value,error_max,"MAX",rmse_rate,mae_rate)
       }
       
       if(rmse_rate == rmse_min && mae_rate == mae_min){
               final_result = list(min_value,error_min,"MIN",rmse_rate,mae_rate)
       }
       
       if(rmse_rate == rmse_mean && mae_rate == mae_mean){
                final_result = list(mean_value,error_mean,"MEAN",rmse_rate,mae_rate)       
       }
        
       return(final_result)
        
}