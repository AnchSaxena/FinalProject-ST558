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
library(caret)
library(DT)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    #Reading in file
    getData <- reactive({
        #read.csv("C:\\Users\\dbhat\\Desktop\\ST558\\FinalProject-ST558\\Pokemon.csv")
       dt<- mtcars
    })

    #######################################################################
    #Data exploration
    #######################################################################
    
    #Printing basic statistic
    output$basicStat <- renderPrint({
        #newData <- pokemon()
        summary(getData())
    })
    
    #Corr plot
    output$corPlot <- renderPlot({
        dat <- data.matrix(getData())
        corrplot(dat)
    })
        

    #######################################################################
    #Data Tab
    #######################################################################
    output$table <- renderTable({
        getData()
    })
})

