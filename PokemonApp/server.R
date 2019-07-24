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

#read data/clean it
pokemonData <- read_csv("C:\\Users\\dbhat\\Desktop\\ST558\\FinalProject-ST558\\Pokemon.csv")

pokemonData$Legendary <- as.factor(pokemonData$Legendary)
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
       #dt<- mtcars
    })

    #######################################################################
    #Data exploration
    #######################################################################
    
    #Printing basic statistic
    output$basicStat <- renderPrint({
        #newData <- pokemon()
        summary(getData())
    })
    
    #Printing basic statistic
    output$genSummary <- renderPrint({
        df <- getData()
        df2 <- df %>% group_by(df$Generation) %>% 
            summary(avg_speed = mean(Speed), avg_hp = mean(HitPoints), 
                    avg_attack = mean(Attack), 
                    avg_defense = mean(Defense), 
                    avg_sp_attack = mean(SpecialAttack), 
                    avg_sp_defense = mean(SpecialDefense))
        df2
    })
    
    #Plotting variables
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
        knn.pred <- knn(data.frame(pokemonDataTrain[,input$checkGroup]),
                        data.frame(pokemonDataTrain[,input$checkGroup]),
                        Legendary, k = input$k)
        
        
        output$value <- renderText({ paste("Classification Error = ",ce(test.Y,knn.pred)) })
        output$confusionMatrix <- renderDataTable({
            # modify this to show title - confusion matrix
            # /false positive/positive false negative/negative
            true.positive    <- sum(knn.pred == "positive" & test.Y == "positive")
            false.positive   <- sum(knn.pred == "negative" & test.Y == "positive")
            true.negative    <- sum(knn.pred == "negative" & test.Y == "negative")
            false.negative   <- sum(knn.pred == "positive" & test.Y == "negative")
            row.names <- c("Prediction - FALSE", "Prediction - TRUE" )
            col.names <- c("Reference - FALSE", "Reference - TRUE")
            cbind(Outcome = row.names, as.data.frame(matrix( 
                c(true.negative, false.negative, false.positive, true.positive) ,
                nrow = 2, ncol = 2, dimnames = list(row.names, col.names))))
        }, options = table.settings
        )
        
    })
})


