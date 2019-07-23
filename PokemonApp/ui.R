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
                 icon = icon("buromobelexperte")),
        menuItem("Data", tabName = "dataSet", 
                 icon = icon("table"))
    )
),
        dashboardBody(
    tabItems(
        tabItem(tabName = "Introduction",
                h2("Welcome to Data Science with Pokemon!"),
                img(src="C:\\Users\\dbhat\\Desktop\\ST558\\FinalProject-ST558/image.jpg", width = '100%'),
                br(),
                h3("Introduction"),
                br(),
                h4("We'll be using pokemon dataset to walk through basics of Data Science."),
                br(),
                h3("Data"),
                h4("The dataset contains 13 attributes with 800 samples and my aim will be finding whether a given pokemon is legendary or not."),
                br(),
                h4("The Attributes are:"),
                br(),
                h4("#: ID for each pokemon"),
                h4("Name: Name of each pokemon"),
                h4("Type 1: Each pokemon has a type, this determines weakness/resistance to attacks"),
                h4("Type 2: Some pokemon are dual type and have 2"),
                h4("Total: sum of all stats that come after this, a general guide to how strong a pokemon is"),
                h4("HP: hit points, or health, defines how much damage a pokemon can withstand before fainting"),
                h4("Attack: the base modifier for normal attacks (eg. Scratch, Punch)"),
                h4("Defense: the base damage resistance against normal attacks"),
                h4("SP Atk: special attack, the base modifier for special attacks (e.g. fire blast, bubble beam)"),
                h4("SP Def: the base damage resistance against special attacks"),
                h4("Speed: determines which pokemon attacks first each round")
                
        ),
        tabItem(tabName = "graphSummary",
                fluidRow(
                    box(
                    title = "Histogram", width = 6, solidHeader = TRUE,
                    collapsible = TRUE, status = "primary",
                    plotOutput("distPlot", height = 250)
                    ),
                    box(
                    title = "Scatter Plot", width = 6, solidHeader = TRUE,
                    collapsible = TRUE, status = "primary",
                    plotOutput("distPlot", height = 250)
                    )
                )
        ),
        tabItem(tabName = "numSummary",
                fluidRow(
                    h3("Basic statistics"),
                    verbatimTextOutput("basicStat"),
                    br(),
                    box(
                        title = "Scatter Plot", width = 6, solidHeader = TRUE,
                        collapsible = TRUE, status = "primary",
                        plotOutput("corPlot", height = 250)
                    )
                    
                )
        ),
        tabItem(tabName = "unsuper",
                fluidRow(
                    box(
                        title = "Select the PCs to plot", width = 6,
                        solidHeader = TRUE, collapsible = TRUE, 
                        status = "warning",
                        uiOutput("the_pcs_to_plot_x"),
                        uiOutput("the_pcs_to_plot_y")
                    ),
                    box(
                        title = "BiPlot", width = 6, solidHeader = TRUE,
                        collapsible = TRUE, status = "primary",
                        plotOutput("distPlot", height = 250)
                    )
                )
        ),
        tabItem(tabName = "super",
                fluidRow(
                    box(
                        title = "Select the PCs to plot", width = 6,
                        solidHeader = TRUE, collapsible = TRUE, 
                        status = "warning",
                        uiOutput("varselect2"),
                        uiOutput("the_pcs_to_plot_y")
                    ),
                    box(
                        title = "BiPlot", width = 6, solidHeader = TRUE,
                        collapsible = TRUE, status = "primary",
                        plotOutput("distPlot", height = 250)
                    )
                )
        ),
        tabItem(tabName = "dataSet",
                fluidRow(
                    box(title = "Dataset used", color = "blue", 
                        ribbon = FALSE,
                        title_side = "top left", width = 14,
                        
                            tableOutput("table")
                            
                        )
                    )
                
        )
    )
    )
))
