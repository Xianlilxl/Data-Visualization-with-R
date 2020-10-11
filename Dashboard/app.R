#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
    
    dashboardHeader(title = "Insertion Professionnelle", titleWidth = 250),
    
    # Sidebar content
    dashboardSidebar(
        sidebarSearchForm(textId = "searchText", buttonId = "searchButton", label = ""),
        sidebarMenu(
            menuItem("Distribution des diplomes", tabName = "diplome", icon = icon("certificate")),
            menuItem("Statistiques par an", tabName = "an", icon = icon("chart-line")),
            menuItem("Distribution des domaines", tabName = "domaine", icon = icon("book")),
            menuItem("Statistiques par ville", tabName = "academie", icon = icon("university"))
        ),
        width = 250
    ),
    
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "diplome", 
                    #h2("Distribution des diplomes"),
                    box(width = NULL, 
                        fluidRow(
                        column(2),
                        column(8,
                               sliderInput(inputId = "annees",
                                           label = "Année",
                                           min = 2013,
                                           max = 2016,
                                           step = 1,
                                           value = 2013,
                                           animate = TRUE),
                        )
                        ),
                        fluidRow(
                            column(2),
                            column(8, 
                                   plotOutput(outputId = "diplome", height="450px", brush = "plot_brush")),
                            column(2)
                        )
                    ,title = "Distribution des diplomes", solidHeader = TRUE, status = "primary")
            ),
            
            # Second
            tabItem(tabName = "an", 
                    fluidRow(
                        tabBox(title = "Statistiques par an", id = "tabset_par_an", width = 12,
                               #background = "blue",
                               #red, yellow, aqua, blue, light-blue, green, navy, 
                               #teal, olive, lime, orange, fuchsia, purple, maroon, black
                               #solidHeader = TRUE,
                               tabPanel("Parametres", selectizeInput(inputId = "discipline", 
                                                                     label = "Choisissez une discipline.", 
                                                                     choices = list('Droit, economie et gestion', 
                                                                                    "Ensemble des departements d'IUT",
                                                                                    'Lettres, langues et arts',
                                                                                    'Masters enseignement',
                                                                                    'Sciences humaines et sociales',
                                                                                    'Sciences, technologie et sante'),
                                                                     width = "100%",
                                                                     options = list(placeholder = "Disciplines",
                                                                                    onInitialize = I('function() { this.setValue(""); }'))),
                                        
                                        checkboxGroupInput(inputId = "stats", 
                                                           label = "Choisissez un ou des statistiques.", 
                                                           list("Part des femmes",
                                                                "Taux d'insertion",
                                                                "Taux d'emploi cadre",
                                                                "Taux d'emploi stable",
                                                                "Taux d'emploi temps plein",
                                                                "Salaire net mensuel median des emplois temps plein national",
                                                                "Salaire net mensuel median des emplois temps plein regional")),
                                        actionButton(inputId = "valid", label = "Valider")),
                               tabPanel("Tendance", #background = "aqua", solidHeader = TRUE, 
                                        plotOutput(outputId = "plot"))
                        ))),
            
            # Third tab content
            tabItem(tabName = "domaine", 
                    #h2("Distribution des domaines")
                        tabBox(width = 12, title = "Distribution des domaines", id = "tabset_domaines", 
                                    tabPanel("Paramètres", fluidRow(
                                        column(2),
                                        column(8,
                                               sliderInput(inputId = "annees",
                                                           label = "Année",
                                                           min = 2013,
                                                           max = 2016,
                                                           step = 1,
                                                           value = 2013,
                                                           animate = TRUE),
                                        )
                                    ),
                                    ), 
                                    tabPanel("Tendance", 
                                             fluidRow(
                                                 column(2),
                                                 column(8, 
                                                        plotOutput(outputId = "domaines", height="450px", brush = "plot_brush")),
                                                 column(2)
                                             )
                                             )
                                    )
                    ),
            
            # Third tab content
            tabItem(tabName = "academie", h2("Statistiques par ville"))
            
        )))



# Define server logic required to draw a histogram
server <- function(input, output) {

    output$diplome <- renderPlot({
        
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an)
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")%>%filter(Année == an)
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an)
    
        nbr.echanti.domaine.dut <- diplome.DUT%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("DUT", 4))            
        nbr.echanti.domaine.lp <- diplome.lp%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("LP", 4))
        nbr.echanti.domaine.master <- diplome.master%>%group_by(domaine)%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%bind_cols(Diplome = rep("Master", 5))

        type.de.diplomes <- bind_rows(nbr.echanti.domaine.master, nbr.echanti.domaine.lp, nbr.echanti.domaine.dut)
        
        ggplot(type.de.diplomes, aes(fill =Domaine,  y=Nombre, x =Diplome )) +geom_bar(position="fill", stat="identity") + ylab("Pourcentage de chaque domaine")
        
    })
    
    output$domaines <- renderPlot({
        
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        taux.insert.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_Insertion = as.numeric(diplome.DUT$Taux.d.insertion))
        taux.insert.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_Insertion = as.numeric(diplome.lp$Taux.d.insertion))
        taux.insert.master <- data.frame(Diplome = diplome.master$diplome, Taux_Insertion = as.numeric(diplome.master$taux_dinsertion))
        
        distribution.boxplot <- bind_rows(taux.insert.DUT, taux.insert.lp, taux.insert.master)
        
        ggplot(data = distribution.boxplot, aes(x = Diplome, y = Taux_Insertion)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Taux d'insertion")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
