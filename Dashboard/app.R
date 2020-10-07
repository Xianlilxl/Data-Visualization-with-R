#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(gapminder)
library(dplyr)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Distribution de types de diplomes"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "annees",
                        label = "Annee",
                        min = 2013,
                        max = 2016,
                        step = 1,
                        value = 2013,
                        animate = TRUE)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput(outputId = "plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # output$distPlot <- renderPlot({
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # })
    output$plot <- renderPlot({
        
        annee <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")
    
        nbr.echanti.domaine.dut <- diplome.DUT%>%filter(Année == annee)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("DUT", 4))            
        nbr.echanti.domaine.lp <- diplome.lp%>%filter(Annee == annee)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("LP", 4))
        nbr.echanti.domaine.master <- diplome.master%>%filter(annee == annee)%>%group_by(domaine)%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%bind_cols(Diplome = rep("Master", 5))

        type.de.diplomes <- rbind(nbr.echanti.domaine.master, nbr.echanti.domaine.lp, nbr.echanti.domaine.dut)
        
        ggplot(type.de.diplomes, aes(fill =Domaine,  y=Nombre, x =Diplome )) +geom_bar(position="fill", stat="identity") + ylab("Pourcentage de chaque domaine")
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
