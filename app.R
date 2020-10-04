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
  titlePanel("Insertion professionnelle des differents diplomes"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "annees",
                  label = "Annee",
                  min = 2010,
                  max = 2016,
                  step = 1,
                  value = 2016,
                  animate = TRUE),
      
      radioButtons("discipline",
                 label = HTML('<FONT size="5pt">Disciplines :</FONT>'),
                 choices = list("TRUE" = 1, "FALSE" = 2),
                 selected = 1,
                 inline = T,
                 width = "100%")
    #fluidRow(column(3, textOutput("value"))),
    
      
    ),
    
    
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  diplome.doctorat <- read.csv('fr-esr-insertion_professionnelle_des_diplomes_doctorat_par_etablissement.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8") 
  
  diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")
  diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")
  diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")
  nbr.echanti.domaine.dut <- diplome.DUT%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%cbind(Diplome = rep("DUT", 4))
  nbr.echanti.domaine.lp <- diplome.lp%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%transform(Diplome = rep("LP", 4))
  
  nbr.echanti.domaine.master <- diplome.master%>%group_by(domaine)%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%cbind(Diplome = rep("Master", 5))
  
  
  type.de.diplomes <- rbind(nbr.echanti.domaine.master, nbr.echanti.domaine.lp, nbr.echanti.domaine.dut)    
  
  
  output$plot <- renderPlot({
    
    
    gapminder %>%
      filter(year==input$years) %>%
      ggplot(type.de.diplomes, aes(fill =Domaine,  y=Nombre, x =Diplome )) + 
      geom_col()
    
    # gapminder %>%
    #   filter(year==input$years) %>%
    #   ggplot(aes(x=gdpPercap, y=lifeExp, color=continent, size=pop)) +
    #   geom_point()
    
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
