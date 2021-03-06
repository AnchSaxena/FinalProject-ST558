library(shiny)
library(shinyAce)
library(psych)
library(rpart)
#library(partykit)
library(randomForest)
library(dplyr)
library(corrplot)
library(readr)
library(ggplot2)
library(stringr)
library(tidyverse)
library(knitr)
library(readr)
library(DT)
library(caret)
library(plotly)

#read data/clean it
pokemonData <- read.csv("../Pokemon.csv")

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
        read.csv("../Pokemon.csv")
    })
    
    #######################################################################
    # #Data Tab
    #######################################################################
    output$table1 <- renderDataTable({
         datatable(getData()[,2:13])
    })
    #Download data to csv
    output$downloadData <- downloadHandler(
        filename = function(){paste("pokemonData", "csv", sep = ".")}, 
        content = function(file){
            write.csv(pokemonData, file)}
    )
    
    #######################################################################
    # #kNN Model
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
    # # Random Forest
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
    #PCA
    #######################################################################
    observe({
        dataPCA <- pokemonData %>% select(5:11)
        pca<-prcomp(dataPCA, center=TRUE, scale=TRUE)

        #Store PCs into dataframe
        PC <- as.data.frame(pca$rotation)
        output$PCTable <- renderDataTable({
            datatable(round(PC,3))
        })

        # Variability of each principal component: pr.var
        pr.var <- pca$sdev^2
        # Variance explained by each principal component: pve
        pve <- pr.var / sum(pr.var)

        #ScreePlot
        output$screePlot <- renderPlot({
            # Plot variance explained for each principal component
            screeplot(pca, type = "lines")
        })

        output$cummVarPlot <- renderPlot({
            #Plot cumulative proportion of variance explained
            plot(cumsum(pve), xlab = "Principal Component",
                 ylab = "Cumulative Proportion of Variance Explained",
                 ylim = c(0, 1), type = "b")
        })

        #BiPlot
        output$biPlot <- renderPlot({
            if(input$var1 == input$var2){
                print("X & Y variables should be different")
            }
            biplot(pca, choices = c(as.numeric(input$var1),
                                    as.numeric(input$var2)), cex = 0.8,
                   xlim = c(-0.08, 0.1), ylim = c(-0.07, 0.1))
        })

        #Print PCA Summary
        output$pcSumm <- renderPrint({
            summary(pca)
        })

    })
    #######################################################################
    #Data exploration
    #######################################################################
    
    #Printing basic statistic
    output$basicStat <- renderPrint({
        #newData <- pokemon()
        summary(getData())
    })
    
    #Corr plot1
    output$corPlot1 <- renderPlot({
        df <- getData()
        Correlation <- cor(df[,5:12], method = "spearman")
        #plotting correlation
        corrplot(Correlation,type="lower")
    })
    
    #Histogram
    output$hist <- renderPlotly({
        qplot(pokemonData$Total,geom="histogram", 
          binwidth = 2, xlab = "Total", fill=I("blue"), 
          col=I("red"))
    })
    
    #Box Plot
    output$boxPlot <- renderPlotly({
        pokemonData %>%
            gather(key, value, HitPoints:Speed) %>%
            ggplot(aes(x=key, y=value, fill = key)) +
            geom_boxplot() +
            theme(legend.position = 'none') +
            labs(y='Stats', x='Category', title = 'Boxplot Distribution of Overall Pokemon Stats') +
            theme(plot.title = element_text(hjust = 0.5))
    })
    
    #Download data to csv
    output$downloadPlot <- downloadHandler(
        filename = function(){paste(input$savePlot, "png", sep = ".")}, 
        content = function(file){
            png(file)
            if(input$savePlot == "Histogram"){
                print(qplot(pokemonData$Total,geom="histogram", 
                      binwidth = 2, xlab = "Total", ylab = "Frequency",
                      fill=I("blue"), 
                      col=I("red")))
            }
            else if(input$savePlot == "Correlation Plot"){
                df <- getData()
                Correlation <- cor(df[,5:12], method = "spearman")
                #plotting correlation
                corrplot(Correlation,type="lower")
            }
            else{
                print(ggplot(data = pokemon, aes(x = Generation, y = Total, fill = as.factor(Generation))) +
                          geom_boxplot() +
                          xlab(label = "Pokemon Generation") +
                          ylab(label = "Total Score of Pokemon") +
                          ggtitle(label = "Pokemon Score by Generation facet by Lengendry flag") +
                          theme(plot.title = element_text(hjust = 0.5)) +
                          theme(legend.position="none"))
            }
            dev.off()}
    )

})
