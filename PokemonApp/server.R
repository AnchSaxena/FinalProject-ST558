#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$the_pcs_to_plot_x <- renderUI({
        pca_output <- pca_objects()$pca_output$x
        
        # drop down selection
        selectInput(inputId = "the_pcs_to_plot_x", 
                    label = "X axis:",
                    choices= colnames(pca_output), 
                    selected = 'PC1')
    })
    
    output$the_pcs_to_plot_y <- renderUI({
        pca_output <- pca_objects()$pca_output$x
        
        # drop down selection
        selectInput(inputId = "the_pcs_to_plot_y", 
                    label = "Y axis:",
                    choices= colnames(pca_output), 
                    selected = 'PC2')
    })

})
