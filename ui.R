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
                            box(
                                title = "Data Subsetting",
                                solidHeader = TRUE, width = 3,
                                collapsible = TRUE, status = "warning",
                                radioButtons("button","Choose data set",
                                             choices = c("Complete",
                                                         "Subset")),
                            conditionalPanel(condition = "input.button == 'Subset'",
                                        selectizeInput('gen', 
                                                'Select Generation',
                                                choices = c(1,2,3,4,5,6),
                                                            selected = 1)),
                            downloadButton("downloadData","Download Data")
                            ),
                            box(
                                title = "Data",
                                solidHeader = TRUE, width = 9,
                                collapsible = TRUE, status = "success",
                            div(style = 'overflow-x: scroll',
                                dataTableOutput("table1"))
                            ),
                            box(
                                title = "Description of DataSet",
                                solidHeader = TRUE, width = 12,
                                collapsible = TRUE, status = "danger",
                                a(h4("Link to Data Source") ,href="https://www.kaggle.com/alopez247/pokemon", target="_blank"),
                                br(),
                                p(h4(strong("Name:")," Name of each pokemon")),
                                p(h4(strong("Type1:")," Each pokemon has a type, this determines weakness/resistance to attacks")),
                                p(h4(strong("Type2:")," Some pokemon are dual type and have 2")),
                                p(h4(strong("Total:")," Sum of all stats that come after this, a general guide to how strong a pokemon is")),
                                p(h4(strong("HitPoints:")," This defines how much damage a pokemon can withstand before fainting")),
                                p(h4(strong("Attack:")," The base modifier for normal attacks (eg. Scratch, Punch)")),
                                p(h4(strong("Defense:")," The base damage resistance against normal attacks")),
                                p(h4(strong("SpecialAttack:")," The base modifier for special attacks (e.g. fire blast, bubble beam)")),
                                p(h4(strong("SpecialDefense:")," The base damage resistance against special attacks")),
                                p(h4(strong("Speed:")," Determines which pokemon attacks first each round")),
                                p(h4(strong("Generation:")," Number of the generation when the Pokémon was introduced")),
                                p(h4(strong("Legendary:")," Indicates whether the Pokémon is Legendary or not"))
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
                                title = "RMSE for Model",
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
                                collapsible = TRUE, status = "warning",
                                selectizeInput('var1', 'Select PC on x-axis',
                                               choices = c(1,2,3,4,5,6,7),
                                               selected = 1),
                                selectizeInput('var2', 'Select PC on y-axis',
                                               choices = c(1,2,3,4,5,6,7),
                                               selected = 2),
                                conditionalPanel(
                                    condition = "input.var1==input.var2",
                                    h4("Error : X and Y PCs should be different!", style = "color:red;")
                                )
                            ),
                            box(
                                title = "Bi Plot", width = 8,
                                solidHeader = TRUE,
                                collapsible = TRUE, status = "success",
                                plotOutput("biPlot", height = 500, width = 500)
                            ),
                            box(
                                title = "Scree Plot", width = 6,
                                solidHeader = TRUE,
                                collapsible = TRUE, status = "info",
                                plotOutput("screePlot")
                            ),
                            box(
                                title = "Cummulative Variance Plot", width = 6,
                                solidHeader = TRUE,
                                collapsible = TRUE, status = "danger",
                                plotOutput("cummVarPlot")
                            )
                        )
                ),
                tabItem(tabName = "numSummary",
                        fluidRow(
                            box(
                                title = "Basic Summary of Data Set",
                                solidHeader = TRUE,  width = 12,
                                collapsible = TRUE, status = "info",
                                verbatimTextOutput("basicStat")
                                
                            )
                        )
                ),
                tabItem(tabName = "graphSummary",
                        fluidRow(
                            box(
                                title = "Correlation Plot",
                                solidHeader = TRUE, width = 6,
                                collapsible = TRUE, status = "info",
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
                                collapsible = TRUE, status = "success",
                                plotlyOutput("boxPlot")
                            ),
                            box(
                                title = "Save Plot & Data",
                                solidHeader = TRUE, width = 3,
                                collapsible = TRUE, status = "warning",
                                selectizeInput( "savePlot", 
                                                "Choose Plot to Save",
                                                choices = c("Correlation Plot",
                                                            "Histogram",
                                                            "Box Plot"),
                                                selected = "Correlation Plot"),
                                downloadButton("downloadPlot", "Save Plot"),
                                br(),
                                downloadButton("downloadPlotData", "Save Plot Data")
                            )
                        )
                ),
                tabItem(tabName = "intro",
                        h1(strong("Learning Data Science with Pokemon")),
                        br(),
                        h3(strong("Goal")),
                        h4("The goal of this App is to walkthrough data science with R."),
                        h3(strong("How the App works?")),
                        h4("The app has different tabs which walks through different techniques used in Data Science"),
                        h4(strong("Data Exploration :")),
                        h4("In this tab you will see basic summary of how the dataset looks like. You can do a statistical summary, get 5 point summary plot graphs, check for correlation, if any, etc."),
                        br(),
                        h4(strong("Unsupervised Learning:")),
                        h4("In this we'll try to find any relationship in the data. Here the goal is not make predictions but finding trends/correlation. We'll examine PCA technique for unsupervised learning."),
                        br(),
                        h4(strong("Supervised Learning:")),
                        h4(" We'll build models and make predictions here! Our goal is to predict total strength of a pokemon based on different predictors. We'll be comparing RMSE and R-Squared to choose model."),
                        withMathJax(
                            helpText(h4('RMSE is calculated as $$\\left(\\sqrt{\\frac{1}{n}\\sum_1^n x^2}\\right)$$'))),
                        #br(),
                        h4(strong("Data Tab: ")),
                        h4("Displays pokemon dataset"),
                        br(),
                        h3(strong("References: ")),
                        a("PCA for Pokemon",href='https://rstudio-pubs-static.s3.amazonaws.com/356603_d15935202c01480d8530f9149144a6a4.html', 
                          target="_blank"),
                        br(),
                        a("Machine Learning With Pokemon",href='http://www.rpubs.com/dannyhuang/pokemon_go_ML', 
                          target="_blank"),
                        br(),
                        a("Visualizations",href='https://www.kaggle.com/shwetp/pokemon-visualizations-unsupervised-learning', 
                          target="_blank"),
                        br(),
                        a("Pokemon Analysis",href='https://www.kaggle.com/devisangeetha/analysis-on-pokemon-data', 
                          target="_blank"),
                        br(),
                        a("Random Forest",href='https://amysfernweh.wordpress.com/2017/08/13/random-forest-with-pokemon-dataset-with-correlation-plot-with-r/', 
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
