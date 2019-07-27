## ui.R ##
library(shiny)
library(shinyAce)
library(shinydashboard)
library(plotly)


shinyUI(
    dashboardPage(
        dashboardHeader(title = "Data Science with Pokemon Stats", 
                        titleWidth = 300),
        dashboardSidebar(
            width = 300,
            sidebarMenu(
                menuItem("Introduction", tabName = "intro", icon = icon("info")),
                menuItem("Data Exploration", icon = icon("chart-bar"), 
                         tabName = "explore",
                         menuSubItem("Numerical Summary", icon = icon("calculator"), 
                                     tabName = "numSummary"),
                         menuSubItem("Graphical Summary", icon = icon("chart-line"), 
                                     tabName = "graphSummary")
                ),
                menuItem("Unsupervised Learning", tabName = "unsuper", 
                         icon = icon("buromobelexperte"),
                         menuSubItem("PCA Analysis", icon = icon("calculator"), 
                                     tabName = "PCASumm"),
                         menuSubItem("PCA Plots", icon = icon("chart-line"), 
                                     tabName = "PCAPlots")),
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
                            downloadButton("downloadData","Download Data"),
                            br(),
                            br(),
                            div(style = 'overflow-x: scroll', 
                                dataTableOutput("table1")),
                            a(href="www.kaggle.com", target="_blank")
                        )
                ),
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
                                    verbatimTextOutput("knnSumm")
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
                ),
                tabItem(tabName = "PCASumm",
                        fluidRow(
                                box(
                                    title = "PCA Table",
                                    solidHeader = TRUE,  width = 12,
                                    collapsible = TRUE, status = "primary",
                                    div(style = 'overflow-y: scroll',
                                    dataTableOutput("PCTable"))
                                ),
                                box(
                                    title = "PCA Summary",
                                    solidHeader = TRUE,  width = 12,
                                    collapsible = TRUE, status = "primary",
                                    verbatimTextOutput("pcSumm")
                                )
                        )
                ),
                tabItem(tabName = "PCAPlots",
                    fluidRow(
                        box(
                            title = "Select PCs to be plotted",
                            solidHeader = TRUE,  width = 4,
                            collapsible = TRUE, status = "primary",
                            selectizeInput('var1', 'Select PC on x-axis',
                                           choices = c(1,2,3,4,5,6,7),
                                           selected = 1),
                            selectizeInput('var2', 'Select PC on y-axis',
                                          choices = c(1,2,3,4,5,6,7),
                                          selected = 2)
                        ),
                        box(
                            title = "Bi Plot", width = 8,
                            solidHeader = TRUE,
                            collapsible = TRUE, status = "primary",
                            plotOutput("biPlot", height = 500, width = 500)
                        ),
                        box(
                            title = "Scree Plot", width = 6,
                            solidHeader = TRUE,
                            collapsible = TRUE, status = "primary",
                            plotOutput("screePlot")
                        ),
                        box(
                            title = "Cummulative Variance Plot", width = 6,
                            solidHeader = TRUE,
                            collapsible = TRUE, status = "primary",
                            plotOutput("cummVarPlot")
                        )
                    )
                ),
                tabItem(tabName = "numSummary",
                    fluidRow(
                        box(
                            title = "Basic Summary of Data Set",
                            solidHeader = TRUE,  width = 12,
                            collapsible = TRUE, status = "primary",
                            verbatimTextOutput("basicStat")
                            
                        )
                    )
                ),
                tabItem(tabName = "graphSummary",
                    fluidRow(
                        box(
                            title = "Correlation Plot",
                            solidHeader = TRUE, width = 6,
                            collapsible = TRUE, status = "primary",
                            plotOutput("corPlot1")
                        ),
                        box(
                            title = "Histogram of Total",
                            solidHeader = TRUE, width = 6,
                            collapsible = TRUE, status = "primary",
                            plotlyOutput("hist")
                        ),
                        box(
                            title = "Box Plot",
                            solidHeader = TRUE, width = 6,
                            collapsible = TRUE, status = "info",
                            plotlyOutput("boxPlot")
                        ),
                        box(
                            title = "Save Plot",
                            solidHeader = TRUE, width = 6,
                            collapsible = TRUE, status = "warning",
                            selectizeInput( "savePlot", 
                                            "Choose Plot to Save",
                                            choices = c("Correlation Plot",
                                                        "Histogram",
                                                        "Box Plot"),
                                            selected = "Histogram"),
                            downloadButton("downloadPlot", "Save Plot")
                        )
                    )
                ),
                tabItem(tabName = "intro",
                    h1("Learning Datascience with Pokemon"),
                    br(),
                    h2("Goal"),
                    h3("The goal of this App is to walkthrough data science with R."),
                    h2("How the App works?"),
                    h3("The app has different tabs which walks through different methods used."),
                    h4("Tab Data Exploration : In this tab you'll see basic summary of how the dataset looks like. You can do a statistical summary, get 5 point summary plot graphs, check for correlation if any etc."),
                    br(),
                    h4("Tab Unsupervised Learning: In this we try to find any relationship in the data. Here the goal is not make predictions but finding trends/correlation. In this we'll examine PCA technique."),
                    br(),
                    h4("Tab Supervised Learning:"),
                    h4(" We'll build models and make predictions here! We'll be comparing RMSE and R-Squared to choose model."),
                    br(),
                    withMathJax(
                    helpText('RMSE is calculated as $$\\left(\\sqrt{\\frac{1}{n}\\sum_1^n x^2}\\right)$$')),
                    h3("References: "),
                    a(href='https://rstudio-pubs-static.s3.amazonaws.com/356603_d15935202c01480d8530f9149144a6a4.html', 
                      target="_blank")
                )
            )
            
            )
        )
)
