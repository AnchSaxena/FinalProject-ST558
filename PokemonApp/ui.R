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
                    ),
                    box(
                        title = "Summary by Generation",
                        solidHeader = TRUE,  width = 12,
                        collapsible = TRUE, status = "primary",
                        verbatimTextOutput("genSummary")
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
                ))
))))
