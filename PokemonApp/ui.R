## ui.R ##
library(shiny)
library(shinyAce)
library(shinydashboard)


shinyUI(
    dashboardPage(
        dashboardHeader(title = "Data Science with Pokemon Stats", 
                        titleWidth = 300),
        dashboardSidebar(
            width = 300,
    sidebarMenu(
        menuItem("Introduction", tabName = "Introduction", icon = icon("info")),
        menuItem("Data Exploration", icon = icon("chart-bar"), 
                 tabName = "explore",
            menuSubItem("Numerical Summary", icon = icon("calculator"), 
                    tabName = "numSummary"),
            menuSubItem("Graphical Summary", icon = icon("chart-line"), 
                    tabName = "graphSummary")
        ),
        menuItem("Unsupervised Learning", tabName = "unsuper", 
                 icon = icon("buromobelexperte")),
        menuItem("Supervised Learning", tabName = "super", 
                 icon = icon("buromobelexperte"),
            menuSubItem("kNN Model", icon = icon("chart-line"), 
                             tabName = "kNN"),
            menuSubItem("Random Forest", icon = icon("chart-line"), 
                        tabName = "rfModel")),
        menuItem("Data", tabName = "dataSet", 
                 icon = icon("table"))
    )
),
        dashboardBody(
    tabItems(
        tabItem(tabName = "dataSet",
                fluidRow(
                div(style = 'overflow-x: scroll', dataTableOutput("table1"))
                
                )
        ),
        tabItem(tabName = "numSummary",
                fluidRow(
                    box(
                    title = "Basic statistics",
                    solidHeader = TRUE,  width = 12,
                    collapsible = TRUE, status = "primary",
                    verbatimTextOutput("basicStat")
                    )
                )
        ),
        tabItem(tabName = "graphSummary",
                fluidRow(
                    box(
                        title = "Scatter Plot", width = 6, 
                        solidHeader = TRUE,
                        collapsible = TRUE, status = "primary",
                        plotOutput("corPlot1", height = 250)
                    ),
                    box(
                        title = "Scatter Plot", width = 6, 
                        solidHeader = TRUE,
                        collapsible = TRUE, status = "primary",
                        plotOutput("corPlot2", height = 250)
                    ),
                    box(
                        title = "Attack v/s Defense", width = 8, 
                        solidHeader = TRUE,
                        collapsible = TRUE, status = "primary",
                        plotOutput("pairs", height = 250)
                    )
                )),
        tabItem(tabName = "kNN",
                fluidRow(
                    box(
                        title = "Model Inputs",
                        solidHeader = TRUE,  width = 4,
                        collapsible = TRUE, status = "primary",
                        sliderInput("k", "number of neighbors",
                                    min = 1, max = 20, value = 5),
                        checkboxGroupInput("checkGroup", 
                                           label = h3("Dataset Features"), 
                                           choices = c("HitPoints",
                                                       "Attack","Defense",
                                                       "SpecialAttack",
                                                       "SpecialDefense",
                                                       "Speed","Type1",
                                                       "Type2","Legendary",
                                                       "Generation"), 
                                           inline = F,
                                           selected = "Attack")
                    ),
                    box(
                        title = "Model Summary",
                        solidHeader = TRUE,  width = 8,
                        collapsible = TRUE, status = "primary",
                        div(style = 'overflow-y: scroll',verbatimTextOutput("knnSumm"))
                    ),
                    box(
                        title = "RMSE",
                        solidHeader = TRUE,  width = 8,
                        collapsible = TRUE, status = "primary",
                        verbatimTextOutput("value")
                    )
                )
        ),
        tabItem(tabName = "rfModel",
                fluidRow(
                    box(
                        title = "Model Inputs",
                        solidHeader = TRUE,  width = 4,
                        collapsible = TRUE, status = "primary",
                        checkboxGroupInput("rfcheckGroup", 
                                           label = h3("Dataset Features"), 
                                           choices = c("HitPoints",
                                                       "Attack","Defense",
                                                       "SpecialAttack",
                                                       "SpecialDefense",
                                                       "Speed","Type1",
                                                       "Type2","Legendary",
                                                       "Generation"), 
                                           inline = F,
                                           selected = "Attack")
                    ),
                    box(
                        title = "Training Model Summary",
                        solidHeader = TRUE,  width = 8,
                        collapsible = TRUE, status = "primary",
                        div(style = 'overflow-y: scroll',
                            verbatimTextOutput("rfSumm"))
                    ),
                    box(
                        title = "RMSE for Predicted Model",
                        solidHeader = TRUE,  width = 8,
                        collapsible = TRUE, status = "primary",
                        verbatimTextOutput("rfvalue")
                    )
                )
        )
))))
