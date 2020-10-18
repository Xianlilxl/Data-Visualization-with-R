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
                                           animate = TRUE),)),
                        fluidRow(
                            column(2),
                            column(8, 
                                   plotOutput(outputId = "diplome", height="450px", brush = "plot_brush")),
                            column(2)),
                    title = "Distribution des diplomes", solidHeader = TRUE, status = "primary")),
            
            # Second
            tabItem(tabName = "an", 
                    fluidRow(
                        tabBox(title = "Statistiques par an", id = "tabset1", width = 12,
                               tabPanel("Parametres", 
                                        selectizeInput(inputId = "discipline", 
                                                                     label = "Choisissez une discipline.", 
                                                                     choices = list('Droit, economie et gestion', 
                                                                                    "Ensemble des departements d'IUT",
                                                                                    'Lettres, langues et arts',
                                                                                    'Masters enseignement',
                                                                                    'Sciences humaines et sociales',
                                                                                    'Sciences, technologie et sante'),
                                                                     width = "25%",
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
                               tabPanel("Tendance", 
                                        plotOutput(outputId = "plot2"))
                        ))),
            
            # Third tab content
            tabItem(tabName = "domaine", 
                    #h2("Distribution des domaines")
                        tabBox(width = 12, title = "Distribution des domaines", id = "tabset_domaines", 
                                    tabPanel("Paramètres", 
                                             fluidRow(
                                                column(3),
                                                column(8,
                                                       sliderInput(inputId = "annees",
                                                                   label = "Année :",
                                                                   min = 2013,
                                                                   max = 2016,
                                                                   step = 1,
                                                                   value = 2013,
                                                                   animate = TRUE),)),
                                             fluidRow(
                                                 column(3),
                                                 column(8, 
                                                        checkboxGroupInput(inputId = "stats", 
                                                                           label = "Choisissez un ou des disciplines :", 
                                                                           list('Droit, economie et gestion', 
                                                                                "Ensemble des departements d'IUT",
                                                                                'Lettres, langues et arts',
                                                                                'Masters enseignement',
                                                                                'Sciences humaines et sociales',
                                                                                'Sciences, technologie et sante')),)
                                                 ),
                                             fluidRow(
                                                 column(3),
                                                 column(8, actionButton(inputId = "valid", label = "Valider"))
                                                 
                                             )
                                             ), 
                                    tabPanel("Taux d'insertion", 
                                             fluidRow(
                                                 column(2),
                                                 column(8, 
                                                        plotOutput(outputId = "taux_dinsertion", height="450px", brush = "plot_brush")),
                                                 column(2))), 
                                    tabPanel("Taux d'emplois", 
                                             fluidRow(
                                                     splitLayout(cellWidths = c("33%", "33%", "33%"), 
                                                                 plotOutput(outputId = "taux_demplois_cadres", height="450px", brush = "plot_brush"), 
                                                                 plotOutput(outputId = "taux_demplois_stables", height="450px", brush = "plot_brush"), 
                                                                 plotOutput(outputId = "taux_demplois_temps_plein", height="450px", brush = "plot_brush")))), 
                                   tabPanel("Part des femmes", 
                                            fluidRow(
                                                column(2),
                                                column(8, 
                                                       plotOutput(outputId = "part_femmes", height="450px", brush = "plot_brush")),
                                                column(2))), 
                                  
                                   tabPanel("Salaires", 
                                            fluidRow(
                                                splitLayout(cellWidths = c("50%", "50%"), 
                                                            plotOutput(outputId = "salaire_diplomes", height="450px", brush = "plot_brush"), 
                                                            plotOutput(outputId = "salaire_regional", height="450px", brush = "plot_brush"))))
                         )),
            
            # Third tab content
            tabItem(tabName = "academie", h2("Statistiques par ville"))
            
        )))
diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")
diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")
diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$diplome <- renderPlot({
        an <- input$annees
        #print(summary(diplome.DUT()))
        nbr.echanti.domaine.dut <- diplome.DUT%>%filter(Année == an)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("DUT", 4))            
        nbr.echanti.domaine.lp <- diplome.lp%>%filter(Annee == an)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("LP", 4))
        nbr.echanti.domaine.master <- diplome.master%>%filter(annee == an)%>%group_by(domaine)%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%bind_cols(Diplome = rep("Master", 5))

        type.de.diplomes <- bind_rows(nbr.echanti.domaine.master, nbr.echanti.domaine.lp, nbr.echanti.domaine.dut)
        
        ggplot(type.de.diplomes, aes(fill =Domaine,  y=Nombre, x =Diplome)) +geom_bar(position="fill", stat="identity") + ylab("Pourcentage de chaque domaine")
        
    })


    output$plot2 <- renderPlot({
        #data()
        
        discipline <- input$discipline
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Domaine == discipline)
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Domaine == discipline)
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(domaine == discipline)
        
        nbr.echanti.dut <- diplome.DUT%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("DUT", 4))            
        nbr.echanti.lp <- diplome.lp%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("LP", 4))
        nbr.echanti.master <- diplome.master%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%bind_cols(Diplome = rep("Master", 5))
        
        type.de.diplomes <- bind_rows(nbr.echanti.master, nbr.echanti.lp, nbr.echanti.dut)
        
        taux.insert.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_Insertion = as.numeric(diplome.DUT$Taux.d.insertion))
        taux.insert.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_Insertion = as.numeric(diplome.lp$Taux.d.insertion))
        taux.insert.master <- data.frame(Diplome = diplome.master$diplome, Taux_Insertion = as.numeric(diplome.master$taux_dinsertion))
        
        part.femme.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Part_femme = as.numeric(diplome.DUT$Part.des.femmes))
        part.femme.lp <- data.frame(Diplome = diplome.lp$Diplôme, Part_femme = as.numeric(diplome.lp$X..femmes))
        part.femme.master <- data.frame(Diplome = diplome.master$diplome, Part_femme = as.numeric(diplome.master$femmes))
        
        taux.emploi.cadre.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_cadre = as.numeric(diplome.DUT$Part.des.emplois.de.niveau.cadre))
        taux.emploi.cadre.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_cadre = as.numeric(diplome.lp$X..emplois.cadre))
        taux.emploi.cadre.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_cadre = as.numeric(diplome.master$emplois_cadre))
        
        taux.emploi.stable.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_stable = as.numeric(diplome.DUT$Part.des.emplois.stables))
        taux.emploi.stable.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_stable = as.numeric(diplome.lp$X..emplois.stables))
        taux.emploi.stable.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_stable = as.numeric(diplome.master$emplois_stables))
        
        taux.emploi.tp.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_tp = as.numeric(diplome.DUT$Part.des.emplois.a.temps.plein))
        taux.emploi.tp.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_tp = as.numeric(diplome.lp$X..emplois.a.temps.plein))
        taux.emploi.tp.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_tp = as.numeric(diplome.master$emplois_a_temps_plein))
        
        salaire.national.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Salaire_national = as.numeric(diplome.DUT$Salaire.net.mensuel.median.des.emplois.a.temps.plein))
        salaire.national.lp <- data.frame(Diplome = diplome.lp$Diplôme, Salaire_national = as.numeric(diplome.lp$Salaire.net.median.des.emplois.a.temps.plein))
        salaire.national.master <- data.frame(Diplome = diplome.master$diplome, Salaire_national = as.numeric(diplome.master$salaire_net_median_des_emplois_a_temps_plein))
        
        filter(discipline==input$discipline) %>%
            #    filter(stats==input$stats) %>%
            ggplot(type.de.diplomes, aes(x = Annee, y = Taux_Insertion, group = Diplome, color = Diplome)) + 
            geom_line()
    })
    
    
    
    output$taux_dinsertion <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        taux.insert.DUT <- diplome.lp%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')%>%subset(slect = c("Diplôme", ))
        
        taux.insert.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_Insertion = as.numeric(diplome.DUT$Taux.d.insertion))
        taux.insert.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_Insertion = as.numeric(diplome.lp$Taux.d.insertion))
        taux.insert.master <- data.frame(Diplome = diplome.master$diplome, Taux_Insertion = as.numeric(diplome.master$taux_dinsertion))
        
        taux.insert.df <- bind_rows(taux.insert.DUT, taux.insert.lp, taux.insert.master)
        
        ggplot(data = taux.insert.df, aes(x = Diplome, y = Taux_Insertion)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Taux d'insertion")
    })
    
    
    output$part_femmes <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        part.femme.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Part_femme = as.numeric(diplome.DUT$Part.des.femmes))
        part.femme.lp <- data.frame(Diplome = diplome.lp$Diplôme, Part_femme = as.numeric(diplome.lp$X..femmes))
        part.femme.master <- data.frame(Diplome = diplome.master$diplome, Part_femme = as.numeric(diplome.master$femmes))
        
        part.femme.df <- bind_rows(part.femme.DUT, part.femme.lp, part.femme.master)
        
        part.femme.graphe <- ggplot(data = part.femme.df, aes(x = Diplome, y = Part_femme)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Part des femmes")
        print(part.femme.graphe)
        
    })
    
    
    output$taux_demplois_cadres <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        taux.emploi.cadre.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_cadre = as.numeric(diplome.DUT$Part.des.emplois.de.niveau.cadre))
        taux.emploi.cadre.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_cadre = as.numeric(diplome.lp$X..emplois.cadre))
        taux.emploi.cadre.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_cadre = as.numeric(diplome.master$emplois_cadre))
        
        taux.emploi.cadre.df <- bind_rows(taux.emploi.cadre.DUT, taux.emploi.cadre.lp, taux.emploi.cadre.master)
        
        ggplot(data = taux.emploi.cadre.df, aes(x = Diplome, y = Taux_emploi_cadre)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Taux d'emplois cadrés")
    })
    
    output$taux_demplois_stables <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        taux.emploi.stables.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_stables = as.numeric(diplome.DUT$Part.des.emplois.stables))
        taux.emploi.stables.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_stables = as.numeric(diplome.lp$X..emplois.stables))
        taux.emploi.stables.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_stables = as.numeric(diplome.master$emplois_stables))
        
        taux.emploi.stables.df <- bind_rows(taux.emploi.stables.DUT, taux.emploi.stables.lp, taux.emploi.stables.master)
        
        ggplot(data = taux.emploi.stables.df, aes(x = Diplome, y = Taux_emploi_stables)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Taux d'emplois stables")
    })
    
    output$taux_demplois_temps_plein <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        taux.emploi.temps.plein.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_temps_plein = as.numeric(diplome.DUT$Part.des.emplois.à.temps.plein))
        taux.emploi.temps.plein.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_temps_plein = as.numeric(diplome.lp$X..emplois.à.temps.plein))
        taux.emploi.temps.plein.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_temps_plein = as.numeric(diplome.master$emplois_a_temps_plein))
        
        taux.emploi.temps.plein.df <- bind_rows(taux.emploi.temps.plein.DUT, taux.emploi.temps.plein.lp, taux.emploi.temps.plein.master)
        
        ggplot(data = taux.emploi.temps.plein.df, aes(x = Diplome, y = Taux_emploi_temps_plein)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Taux d'emplois à temps plein")
    })
    
    output$salaire_diplomes <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        salaire.diplomes.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, salaire_diplomes = as.numeric(diplome.DUT$Salaire.net.mensuel.médian.des.emplois.à.temps.plein))
        salaire.diplomes.lp <- data.frame(Diplome = diplome.lp$Diplôme, salaire_diplomes = as.numeric(diplome.lp$Salaire.net.médian.des.emplois.à.temps.plein))
        salaire.diplomes.master <- data.frame(Diplome = diplome.master$diplome, salaire_diplomes = as.numeric(diplome.master$salaire_net_median_des_emplois_a_temps_plein))
        
        salaire.diplomes.df <- bind_rows(salaire.diplomes.DUT, salaire.diplomes.lp, salaire.diplomes.master)
        
        ggplot(data = salaire.diplomes.df, aes(x = Diplome, y = salaire_diplomes)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Salaire net mensuel médian des emplois à temps plein")
    })
    
    output$salaire_regional <- renderPlot({
        an <- input$annees
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(Annee == an&Domaine == 'Sciences, technologies et santé')
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', header = T, sep = ';',na.strings = c('ns', 'nd'), fill=TRUE, encoding = "UTF-8")%>%filter(Année == an&Domaine == 'Sciences, technologies et santé')
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', header = T, sep = ';', na.strings = 'ns', fill=TRUE, encoding = "UTF-8")%>%filter(annee == an&domaine == 'Sciences, technologies et santé')
        
        salaire.regional.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, salaire_regional = as.numeric(diplome.DUT$Salaire.net.mensuel.médian.national))
        salaire.regional.lp <- data.frame(Diplome = diplome.lp$Diplôme, salaire_regional = as.numeric(diplome.lp$Salaire.net.mensuel.médian.régional))
        salaire.regional.master <- data.frame(Diplome = diplome.master$diplome, salaire_regional = as.numeric(diplome.master$salaire_net_mensuel_median_regional))
        
        salaire.regional.df <- bind_rows(salaire.regional.DUT, salaire.regional.lp, salaire.regional.master)
        
        ggplot(data = salaire.regional.df, aes(x = Diplome, y = salaire_regional)) + geom_boxplot() + labs(x = "Types de diplômes", y = "Salaire net mensuel médian des emplois à temps plein")
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
