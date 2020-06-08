# You can run the application by clicking 'Run App' above (RStudio)
# Author: Julien Bryois
# Date: 17.1.2020

library(shiny)
library(dplyr)
library(readxl)
library(tidyr)
library(ggplot2)
library(tibble)
library(R.utils)
library(tidytext)

# Theme for plots
theme_set(theme_light())

# Load file with helper functions
source(file = "functions.R")

# Option to increase max size of the file to be loaded
options(shiny.maxRequestSize=90*1024^2) 

# Define server logic
shinyServer(function(input, output) {

    # Load list of genes of interest (user input)
    gene_list <- reactive({
        inFile <- input$file1
        req(inFile)
        if(!input$sep%in%c('xlsx','xls')){
            tbl <- read.csv(inFile$datapath, header=input$header, sep=input$sep,comment = "#",stringsAsFactors = FALSE)
        } 
        if(input$sep=='xlsx'){
            tbl <- as.data.frame(read_xlsx(inFile$datapath,col_names=input$header))
        }
        if(input$sep=='xls'){
            tbl <- as.data.frame(read_xls(inFile$datapath,col_names=input$header))
        }
        return(tbl)
    }) 
    
    # Load selected dataset (e.g. GTEx v8)
    dataset <- reactive({
        inFile <- input$select
        req(inFile)
        d <- data.table::fread(inFile,data.table=FALSE)
    }) 
    
    # Plot Heatmap
    output$heatmap <- renderPlot({
        plot_heatmap(dataset(),gene_list())
    }, height = 600)
    
    #Download plot
    output$save_plot <- downloadHandler(
        filename = function() {
            datasetname <- parse_dataset_name(input$select)
            paste(input$file1,datasetname,".pdf",sep = ".")
        },
        content = function(file) {
            p <- plot_gene_set(dataset(),gene_list(),input$num)
            ggsave(file, plot = p, device = "pdf", width=input$width,height=input$height,limitsize = FALSE)
        }
    )
    #Download heatmap
    output$save_heatmap <- downloadHandler(
        filename = function() {
            datasetname <- parse_dataset_name(input$select)
            paste(input$file1,datasetname,"heatmap.pdf",sep = ".")
        },
        content = function(file) {
            pdf(file,height=12,width=16)
            grid::grid.draw(plot_heatmap(dataset(),gene_list())$gtable)
            dev.off()
        }
    )
})
