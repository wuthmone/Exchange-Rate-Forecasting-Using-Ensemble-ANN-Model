## Read  USD dataset and process the dataset

## Function Parameters
## Datasource_url: "/home/wut/Desktop/Link to Data/FYP Program/Raw Data/alldata.csv"
## Predictor order : 1-10
## Currency : "U.S. Dollar" / "Australian Dollar"/ "Canadian Dollar"/"Euro"
##            "Pound Sterling"/"Singapore Dollar"/"Swiss Franc"

## Return Outcomes
## Date for predicted day, Test Dataset, Train Dataset


#Training variables
Data_Processing <- function(datasource_url, predictor_order, ex_currency){ 
                                                                                
        alldata = tbl_df(read.csv(datasource_url))
        usd = filter(alldata, currency ==ex_currency)
        newdata = tbl_df(usd)
        usd_df = select(newdata, Date, Value)
        usd_non_normalize = select(usd_df, Value)
        usd_value = as.tbl(normalized(usd_non_normalize))
        names(usd_value) = "USD"
        result =  createTimeSlices(usd_value$USD, predictor_order, 1, fixedWindow = T)
        train_data = training_data(result, usd_value)
        vector_train = as.vector(train_data$USD,"any")
        matrix_train <- matrix(vector_train, nrow = predictor_order, ncol = length(vector_train)/predictor_order)
      
        #Class Variable
        test_data =  testing_data(result,usd_value)
       
        
        #input_train 60 % && output_train 60 %
        train_until = ceiling(length(matrix_train)*0.6/predictor_order)
        training_input = matrix_train[1:predictor_order, 1:train_until]
        train_end = ceiling(length(test_data$USD)*0.6)
        training_output = test_data[1:train_end,]
        
        new_input = t(training_input)
        train_input = as.data.frame(new_input)
        train_dataset <- cbind(train_input, training_output)
        
        
        #input_test 40% && output_test 40%
        test_until <- train_until+1
        test_end <- train_end+1
        matrix_end <- length(matrix_train)/predictor_order
        testing_input = matrix_train[1:predictor_order, test_until: matrix_end]
        testing_output = test_data[test_end:length(test_data$USD),]
        
        new_input = t(testing_input)
        test_input = as.data.frame(new_input)
        test_dataset = cbind(test_input, testing_output)
        
        #Nameing columns
        if (predictor_order==3){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay", "oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "oneDayAhead")
        }
        
        if(predictor_order==4){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay", "oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","oneDayAhead")
        }
        
        if(predictor_order==5){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay","FifthDay", "oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","Fifthday","oneDayAhead")
        }
        
        if(predictor_order==6){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay","FifthDay","SixthDay", "oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","Fifthday","SixthDay","oneDayAhead")
        }
        
        if(predictor_order==7){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay","FifthDay","SixthDay","SeventhDay","oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","Fifthday","SixthDay","SeventhDay","oneDayAhead")
        }
        
        if(predictor_order==8){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay","FifthDay","SixthDay","SeventhDay","eighthDay","oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","Fifthday","SixthDay","SeventhDay","eighthDay","oneDayAhead")
        }
        if(predictor_order==9){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay","FifthDay","SixthDay","SeventhDay","eighthDay","ninethDay","oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","Fifthday","SixthDay","SeventhDay","eighthDay","ninethDay","oneDayAhead")
        }
        if(predictor_order==10){
                names(train_dataset) <- c("firstDay","secondDay", "thirdDay","fourthDay","FifthDay","SixthDay","SeventhDay","eighthDay","ninethDay","tenthDay","oneDayAhead") 
                names(test_dataset) <- c("firstDay","secondDay", "thirdDay", "fourthDay","Fifthday","SixthDay","SeventhDay","eighthDay","ninethDay","tenthDay","oneDayAhead")
        }
        
        
        
        #Predicted Date
        Date = createTimeSlices(usd$Date, predictor_order, 1, fixedWindow = T)
        date = testing_data(Date,usd)
        test_date = as.data.frame(date[test_end:length(test_data$USD),]$Date)
        names(test_date)= "Date"
        
        output <- list(train_dataset,test_dataset,test_date,usd_non_normalize)
        
        
}