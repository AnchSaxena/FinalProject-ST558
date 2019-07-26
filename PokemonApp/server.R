library(shiny)
library(shinyAce)
library(psych)
library(rpart)
library(partykit)
library(randomForest)
library(dplyr)
library(corrplot)
library(readr)
library(ggplot2)
library(stringr)
library(tidyverse)
library(knitr)
library(kableExtra)
library(readr)
library(DT)
library(caret)
library(RCurl)
library(excelR)

#read data/clean it
pokemonData <- read.csv("C:\\Users\\dbhat\\Desktop\\ST558\\FinalProject-ST558\\Pokemon.csv")

features <- colnames(pokemonData)

pokemonData$Legendary <- as.numeric(pokemonData$Legendary)
anyNA(pokemonData)
set.seed(1)
train <- sample(1:nrow(pokemonData), size = nrow(pokemonData)*0.8)
test <- dplyr::setdiff(1:nrow(pokemonData), train)
pokemonDataTrain <- pokemonData[train, ]
pokemonDataTest <- pokemonData[test, ]


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    #Reading in file
    getData <- reactive({
        read.csv("C:\\Users\\dbhat\\Desktop\\ST558\\FinalProject-ST558\\Pokemon.csv")
    })

    #######################################################################
    #Data exploration
    #######################################################################
    
    #Printing basic statistic
    output$basicStat <- renderPrint({
        #newData <- pokemon()
        summary(getData())
    })

    #Plotting Attack v/s Defense
    output$pairs <- renderPlot({
        df <- getData()
        ggplot(df, aes(df$Attack, df$Defense)) + 
            geom_point(aes(color = df$Generation)) +
            theme_bw() + labs(title="Scatterplot") + 
            facet_wrap( ~ df$Generation)
    })
    
    
    #Corr plot1
    output$corPlot1 <- renderPlot({
        df <- getData()
        Correlation <- cor(df[,5:12], method = "spearman")
        #plotting correlation
        corrplot(Correlation,type="lower")
    })
    
    #Corr plot2
    output$corPlot2 <- renderPlot({
        df <- getData()
        g <- ggplot(df, aes(df$Attack, df$Defense)) 
        g + geom_point(aes(df$Attack, df$Defense, color = df$Legendary)) +
            theme_bw() + labs(title="Scatterplot")
    })
        

    #######################################################################
    #Data Tab
    #######################################################################
    output$table1 <- renderDataTable({
        datatable(getData()[,2:13])
    })
    #######################################################################
    #kNN Model
    #######################################################################
    observe({
        set.seed(1)
        ctrl <- trainControl(method = "repeatedcv", number = 10, 
                             repeats = 3)
        knnFit <- train(as.formula(paste("Total ~ ",paste(input$checkGroup,collapse="+"))), data = pokemonDataTrain,
                        method = "knn", trControl = ctrl,
                        preProcess = c("center","scale"),
                        tuneGrid = expand.grid(k = input$k))
        #Predict
        knnPredict <- predict(knnFit,newdata = pokemonDataTest)
        
        #Print RMSE of predicted Model
        output$value <- renderPrint({ 
            r <- RMSE(knnPredict, pokemonDataTest$Total)
            paste("RMSE of predicted model is", r)
            })
        # Print training model Summary
        output$knnSumm <- renderPrint({
            knnFit
            })

    })
    #######################################################################
    # Random Forest
    #######################################################################
    observe({
        set.seed(1)
        ctrl <- trainControl(method = "repeatedcv", number = 10, 
                             repeats = 3)
        rfFit <- train(as.formula(paste("Total ~ ",paste(input$rfcheckGroup,collapse="+"))), data = pokemonDataTrain,
                        method = "rf", trControl = ctrl,
                        preProcess = c("center","scale")
                        )
        #Predict
        rfPredict <- predict(rfFit,newdata = pokemonDataTest)
        
        #Print RMSE of predicted Model
        output$rfvalue <- renderPrint({ 
            r2 <- summary(rfPredict)
            rfR <- RMSE(rfPredict, pokemonDataTest$Total)
            paste("RMSE of predicted model is", rfR)
        })
        # Print training model Summary
        output$rfSumm <- renderPrint({
            rfFit
        })
        
    })
    
    #######################################################################
    # PCA
    #######################################################################
    
    
    
})


