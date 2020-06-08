# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

# Author: Julien Bryois
# Date: 17.1.2020

library(shiny)
library(shinythemes)

# Define UI for application
ui <- fluidPage(
    
    # App title
    titlePanel("GeneSetPlot"),
    
    # Theme 
    theme = shinytheme("flatly"),                   
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            h4(strong("Gene Set Plots")),
            h5("This Shiny app plots the expression of each gene in a gene set in the top N cell types."),
            br(),
            h5(strong("Please input a file with your gene list (first column).")),
            h5("The app works with ensembl, symbol or entrez gene ids."),
            br(),
            h5("Once the file is loaded, select the number of cell types to display, the width and height, and click save!"),
            h5("The figure will then be downloaded on your computer."),
            
            # Input: Select type of delimiter for file to be uploaded
            radioButtons('sep', 'Separator',
                         c(Tab='\t',
                           Space=' ',
                           Comma=',',
                           xls='xls',
                           xlsx='xlsx'),
                         '\t'),
            
            # Input: Check whether the file has a header or not
            checkboxInput('header', 'Header', TRUE),
            
            # Input: Load input file
            fileInput('file1', 'Input File'),
            
            # Input: Select Dataset to use
            selectInput("select", label = h3("Select Dataset"), 
                        choices = list("Zeisel et al. (2018) lvl2" = "Data/Zeisel.lvl2.1to1.norm.txt.gz",
                                       "Zeisel et al. (2018) lvl3" = "Data/Zeisel.lvl3.1to1.norm.txt.gz",
                                       "Zeisel et al. (2018) lvl4" = "Data/Zeisel.lvl4.1to1.norm.txt.gz",
                                       "Zeisel et al. (2018) lvl5" = "Data/Zeisel.1to1.norm.txt.gz",
                                       "Skene et al. (2018) lvl1" = "Data/Skene_lvl1.1to1.norm.txt.gz",
                                       "Skene et al. (2018) lvl2" = "Data/Skene_lvl2.1to1.norm.txt.gz",
                                       "Saunders et al. (2018) lvl1" = "Data/Saunders.lvl1.1to1.norm.txt.gz",
                                       "Saunders et al. (2018) lvl2" = "Data/Saunders.lvl2.1to1.norm.txt.gz",
                                       "Saunders et al. (2018) lvl3" = "Data/Saunders.lvl3.1to1.norm.txt.gz",
                                       "Habib et al. (2017)" = "Data/Habib.norm.txt.gz",
                                       "GTex v7" = "Data/GTEx.v7.all.norm.txt.gz", 
                                       "GTex v8" = "Data/GTEx.v8.all.norm.txt.gz"),
                        selected = "Data/Zeisel.lvl4.1to1.norm.txt.gz"),
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Tabset w/ plot ----
            tabsetPanel(type = "tabs",
                        tabPanel("Heatmap", fluid = TRUE,
                                 mainPanel(
                                     h5("Heatmap of the expression of each gene in the gene set in all cell types (z-scaling per gene)"),
                                     column(4,
                                            numericInput("width_hm", label = h3("Plot Width"), value = 16),
                                     ),
                                     column(4,
                                            numericInput("height_hm", label = h3("Plot Height"), value = 10),
                                     ),
                                     downloadButton('save_heatmap',label = "Save Plot"),
                                     plotOutput("heatmap")
                                 ), 
                        ),
                        tabPanel("Gene Set Plot", fluid = TRUE,
                                mainPanel(
                                    h5("Plots expression of each gene in the gene set in the top N cell types/tissues"),
                                    column(4,
                                           numericInput("num", label = h3("Number of cell types"), value = 15),
                                    ),
                                    column(4,
                                           numericInput("width", label = h3("Plot Width"), value = 30),
                                    ),
                                    column(4,
                                           numericInput("height", label = h3("Plot Height"), value = 40),
                                    ),
                                    downloadButton('save_plot',label = "Save Plot")
                                ), 
                        ),
                        tabPanel("References", fluid = TRUE,
                                 mainPanel(
                                     h3("Datasets:"),
                                     h5(a("Zeisel et al. 2018",href="https://www.cell.com/cell/fulltext/S0092-8674(18)30789-X")),
                                     h5(a("Skene et al. 2018",href="https://www.nature.com/articles/s41588-018-0129-5")),
                                     h5(a("Habib et al. 2017",href="https://www.nature.com/articles/nmeth.4407")),
                                     h5(a("Saunders et al. 2018",href="https://www.sciencedirect.com/science/article/pii/S0092867418309553")),
                                     h5(a("GTEx v7",href="https://www.nature.com/articles/nature24277")),
                                     h5(a("GTEx v8",href="https://www.biorxiv.org/content/10.1101/787903v1")),
                                     h3("Code:"),
                                     h5(a("Github",href="https://github.com/jbryois/GeneSetPloter"))
                                 )
                        )
            ),
        )
    )
)