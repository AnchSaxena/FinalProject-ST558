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
                                     tabName = "rfModel"),
                         menuSubItem("Custom Prediction",icon = icon("chart-line"),
                                     tabName = "predict")),
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
                            br(),
                            box(
                                title = "Description of DataSet",
                                solidHeader = TRUE, width = 12,
                                collapsible = TRUE, status = "danger",
                                a("Data Source" ,href="https://www.kaggle.com/alopez247/pokemon", target="_blank"),
                                br(),
                                h4("Name: Name of each pokemon"),
                                h4("Type1: Each pokemon has a type, this determines weakness/resistance to attacks"),
                                h4("Type2: Some pokemon are dual type and have 2"),
                                h4("Total: Sum of all stats that come after this, a general guide to how strong a pokemon is"),
                                h4("HitPoints: This defines how much damage a pokemon can withstand before fainting"),
                                h4("Attack: The base modifier for normal attacks (eg. Scratch, Punch)"),
                                h4("Defense: The base damage resistance against normal attacks"),
                                h4("SpecialAttack: The base modifier for special attacks (e.g. fire blast, bubble beam)"),
                                h4("SpecialDefense: The base damage resistance against special attacks"),
                                h4("Speed: Determines which pokemon attacks first each round"),
                                h4("Generation: Number of the generation when the Pokémon was introduced"),
                                h4("Legendary: Boolean that indicates whether the Pokémon is Legendary or not")
                            )
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
                                                   selected = "Attack"),
                                uiOutput("kNNModel")
                                
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
                                                   selected = "Attack"),
                                uiOutput("modelSelected")
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
                                               selected = 2),
                                conditionalPanel(
                                    condition = "input.var1==input.var2",
                                    h4("X and Y PCs should be different!")
                                )
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
                                solidHeader = TRUE, width = 9,
                                collapsible = TRUE, status = "info",
                                plotlyOutput("boxPlot")
                            ),
                            box(
                                title = "Save Plot",
                                solidHeader = TRUE, width = 3,
                                collapsible = TRUE, status = "warning",
                                selectizeInput( "savePlot", 
                                                "Choose Plot to Save",
                                                choices = c("Correlation Plot",
                                                            "Histogram",
                                                            "Box Plot"),
                                                selected = "Correlation Plot"),
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
                        tags$b(h4("Data Exploration :")),
                        h4("In this tab you will see basic summary of how the dataset looks like. You can do a statistical summary, get 5 point summary plot graphs, check for correlation, if any, etc."),
                        br(),
                        h4("Unsupervised Learning:"),
                        h4("In this we'll try to find any relationship in the data. Here the goal is not make predictions but finding trends/correlation. We'll examine PCA technique for unsupervised learning."),
                        br(),
                        h4("Supervised Learning:"),
                        h4(" We'll build models and make predictions here! Our goal is to predict total strength of a pokemon based on different predictors. We'll be comparing RMSE and R-Squared to choose model."),
                        withMathJax(
                            helpText('RMSE is calculated as $$\\left(\\sqrt{\\frac{1}{n}\\sum_1^n x^2}\\right)$$')),
                        br(),
                        h4("Data"),
                        h4("Displays pokemon dataset"),
                        br(),
                        h3("References: "),
                        a("Ref1",href='https://rstudio-pubs-static.s3.amazonaws.com/356603_d15935202c01480d8530f9149144a6a4.html', 
                          target="_blank"),
                        br(),
                        a("Ref2",href='http://www.rpubs.com/dannyhuang/pokemon_go_ML', 
                          target="_blank"),
                        br(),
                        a("Ref3",href='https://www.kaggle.com/shwetp/pokemon-visualizations-unsupervised-learning', 
                          target="_blank"),
                        br(),
                        a("Ref4",href='https://www.kaggle.com/devisangeetha/analysis-on-pokemon-data', 
                          target="_blank"),
                        br(),
                        a("Ref5",href='https://amysfernweh.wordpress.com/2017/08/13/random-forest-with-pokemon-dataset-with-correlation-plot-with-r/', 
                          target="_blank"),
                        br(),
                        h3("Author : Anchal Saxena")
                ),
                tabItem(tabName = "predict",
                    fluidRow(
                        box(
                            title = "Select values for predictors",
                            solidHeader = TRUE, width = 4,
                            collapsible = TRUE, status = "warning",
                            numericInput("hp", "HitPoints", value = 5),
                            numericInput("at","Attack", value = 5),
                            numericInput("de","Defense", value = 5),
                            numericInput("speed","Speed",value = 10)
                        ),
                        box(
                            title = "Prediction Results",
                            solidHeader = TRUE, width = 8,
                            collapsible = TRUE, status = "danger",
                            verbatimTextOutput("pred")
                        )
                    )
                )
            )
            
        )
    )
)
