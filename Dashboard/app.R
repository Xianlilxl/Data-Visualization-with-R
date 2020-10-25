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
library(leaflet)
library(maptools)
library(rgdal)

# Define UI for application that draws a histogram
ui <- dashboardPage(
    
    dashboardHeader(title = "Insertion Professionnelle", titleWidth = 250),
    
    # Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Distribution des diplomes", tabName = "diplome", icon = icon("certificate")),
            menuItem("Statistiques par an", tabName = "ans", icon = icon("chart-line")),
            menuItem("Distribution des disciplines", tabName = "domaine", icon = icon("book")),
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
            tabItem(tabName = "ans",
                    box(width = NULL,
                        fluidRow(
                            column(4),
                            column(6,
                                     radioButtons(inputId = "discipline_par_an", 
                                                     label = "Choisissez une discipline :", 
                                                     list("Droit, économie et gestion",
                                                          "Ensemble des départements d'IUT",
                                                          "Lettres, langues, arts",
                                                          "Masters enseignement",
                                                          "Sciences humaines et sociales",
                                                          "Sciences, technologies et santé")))),
                        title = "Paramètres",
                        solidHeader = TRUE,
                        status = "primary"),
                    fluidRow(
                        tabBox(title = "Statistiques par an", id = "tabset_an", width = 12,
                               tabPanel("Part des femmes", 
                                        plotOutput(outputId = "Part_femmes_par_an", height="450px"),
                                        #plotOutput(outputId = "Part_femmes_par_an_tendance", height="450px")
                               ),
                               tabPanel("Taux d'insertion", 
                                        plotOutput(outputId = "Taux_insertion_par_an", height="450px")
                               ),
                               tabPanel("Statistiques des emplois", 
                                        plotOutput(outputId = "Taux_emploi_cadre_par_an", height="450px"), 
                                                        plotOutput(outputId = "Taux_emploi_stable_par_an", height="450px"), 
                                                        plotOutput(outputId = "Taux_emploi_temps_plein_par_an", height="450px")
                                        # fluidRow(
                                        #     splitLayout(cellWidths = c("33%", "33%", "33%"), 
                                        #                 
                                        #     )
                                        # )
                               ),
                               tabPanel("Statistiques des salaires", 
                                        plotOutput(outputId = "Salaire_par_an", height="450px")
                               )
                        ))),
            
            # Third tab content
            tabItem(tabName = "domaine", 
                    box(width = 14,
                        #fluidRow(
                            splitLayout(cellWidths = c("50%", "50%"),
                                        
                                        sliderInput(inputId = "annees",
                                                            label = "Année",
                                                            min = 2013,
                                                            max = 2016,
                                                            step = 1,
                                                            value = 2013,
                                                            width = "80%",
                                                            animate = TRUE),
                                         radioButtons(inputId = "discipline_par_domaine", 
                                                                 label = "Choisissez une discipline :", 
                                                                    width = "80%",
                                                                 list("Droit, économie et gestion",
                                                                      "Ensemble des départements d'IUT",
                                                                      "Lettres, langues, arts",
                                                                      "Masters enseignement",
                                                                      "Sciences humaines et sociales",
                                                                      "Sciences, technologies et santé"))
                                  
                                   
                        ),
                        title = "Paramètres",
                        solidHeader = TRUE,
                        status = "primary"),
                    fluidRow(
                    tabBox(width = 12, title = "Distribution des domaines", id = "tabset_domaines", 
                           tabPanel("Taux d'insertion", 
                                    fluidRow(
                                        column(2),
                                        column(8, 
                                               plotOutput(outputId = "taux_dinsertion_par_domaine", height="450px", brush = "plot_brush")),
                                        column(2))), 
                           tabPanel("Taux d'emplois", 
                                    plotOutput(outputId = "taux_demplois_cadres_par_domaine", height="450px", brush = "plot_brush"), 
                                                    plotOutput(outputId = "taux_demplois_stables_par_domaine", height="450px", brush = "plot_brush"), 
                                                    plotOutput(outputId = "taux_demplois_temps_plein_par_domaine", height="450px", brush = "plot_brush")
                                    # fluidRow(
                                    #     splitLayout(cellWidths = c("33%", "33%", "33%"), 
                                    #                 ))
                                    ), 
                           tabPanel("Part des femmes", 
                                    fluidRow(
                                        column(2),
                                        column(8, 
                                               plotOutput(outputId = "part_femmes_par_domaine", height="450px", brush = "plot_brush")),
                                        column(2))), 
                           
                           tabPanel("Salaires", 
                                    plotOutput(outputId = "salaire_diplomes_par_domaine", height="450px", brush = "plot_brush")
                                    )
                    ))),
            
            # Third tab content
            tabItem(tabName = "academie", 
                    box(
                        plotOutput(outputId = "carte_academie", height="450px", brush = "plot_brush"),
                        width = NULL, title = "Statistiques par ville",solidHeader = TRUE, status = "primary"
                        
                        
                        
                    )
                    )
            
        )))

        

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    diplome.lp <- reactive({
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', 
                               header = T, 
                               sep = ';', 
                               fill=TRUE, 
                               encoding = "UTF-8")
    })
    
    diplome.DUT <- reactive({
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', 
                                header = T, 
                                sep = ';', 
                                fill=TRUE, 
                                encoding = "UTF-8")
    })
    
    diplome.master <- reactive({
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', 
                                   header = T, 
                                   sep = ';', 
                                   fill=TRUE, 
                                   encoding = "UTF-8")
    })
    
    output$diplome <- renderPlot({
        an <- input$annees
        
        nbr.echanti.domaine.dut <- diplome.DUT()%>%filter(Année == an)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("DUT", 4))            
        nbr.echanti.domaine.lp <- diplome.lp()%>%filter(Annee == input$annees)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("LP", 4))
        nbr.echanti.domaine.master <- diplome.master()%>%filter(annee == an)%>%group_by(domaine)%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%bind_cols(Diplome = rep("Master", 5))
        
        type.de.diplomes <- bind_rows(nbr.echanti.domaine.master, 
                                      nbr.echanti.domaine.lp, 
                                      nbr.echanti.domaine.dut)
        
        ggplot(type.de.diplomes, 
               aes(fill =Domaine,  
                   y=Nombre, 
                   x =Diplome )) +geom_bar(position="fill", stat="identity") + ylab("Pourcentage de chaque domaine")
        
    })
    

#####################################################################################################################################################################################    
    output$Part_femmes_par_an <- renderPlot({
        
        discipline <- input$discipline_par_an
        diplome.lp <- diplome.lp()%>%filter(Domaine == discipline)
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == discipline)
        diplome.master <- diplome.master()%>%filter(domaine == discipline)
        
        part.femme.DUT <- data.frame(Annee = diplome.DUT$Année, 
                                     Diplome = diplome.DUT$Diplôme, 
                                     Part_femmes = as.numeric(diplome.DUT$Part.des.femmes))
        
        part.femme.lp <- data.frame(Annee = diplome.lp$Annee, 
                                    Diplome = diplome.lp$Diplôme, 
                                    Part_femmes = as.numeric(diplome.lp$X..femmes))
        
        part.femme.master <- data.frame(Annee = diplome.master$annee, 
                                        Diplome = diplome.master$diplome, 
                                        Part_femmes = as.numeric(diplome.master$femmes))
        
        part.femme.df <- bind_rows(part.femme.DUT, 
                                   part.femme.lp, 
                                   part.femme.master)
        
        part.femme.DUT.regroupe <- part.femme.DUT%>%group_by(Annee, Diplome)%>%summarise(Part_femmes = median(Part_femmes, na.rm = TRUE))
        part.femme.lp.regroupe <- part.femme.lp%>%group_by(Annee, Diplome)%>%summarise(Part_femmes = median(Part_femmes, na.rm = TRUE))
        part.femme.master.regroupe <- part.femme.master%>%group_by(Annee, Diplome)%>%summarise(Part_femmes = median(Part_femmes, na.rm = TRUE))
        
        part.femme.regroupe.df <- bind_rows(part.femme.DUT.regroupe, 
                                            part.femme.lp.regroupe, 
                                            part.femme.master.regroupe)
        
        
        ggplot()+geom_point(data = part.femme.df, mapping = aes(x = Annee,y = Part_femmes, group = Diplome, color = Diplome))+ 
            geom_line(data = part.femme.regroupe.df, mapping = aes(x = Annee,y = Part_femmes,group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Part des femmes")
        

    })
    
    output$Taux_insertion_par_an <- renderPlot({
        
        discipline <- input$discipline_par_an
        
        diplome.lp <- diplome.lp()%>%filter(Domaine == discipline)
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == discipline)
        diplome.master <- diplome.master()%>%filter(domaine == discipline)
        
        taux.insert.DUT <- data.frame(Annee = diplome.DUT$Année, 
                                      Diplome = diplome.DUT$Diplôme, 
                                      Taux_Insertion = as.numeric(diplome.DUT$Taux.d.insertion))
        
        
        taux.insert.lp <- data.frame(Annee = diplome.lp$Annee, 
                                     Diplome = diplome.lp$Diplôme, 
                                     Taux_Insertion = as.numeric(diplome.lp$Taux.d.insertion))
        
        taux.insert.master <- data.frame(Annee = diplome.master$annee, 
                                         Diplome = diplome.master$diplome, 
                                         Taux_Insertion = as.numeric(diplome.master$taux_dinsertion))
        
        
        taux.insert.df <- bind_rows(taux.insert.DUT, 
                                    taux.insert.lp, 
                                    taux.insert.master)
        
        taux.insert.DUT.regroupe <- taux.insert.DUT%>%group_by(Annee, Diplome)%>%summarise(TauxInsertion = median(Taux_Insertion, na.rm = TRUE))
        taux.insert.lp.regroupe <- taux.insert.lp%>%group_by(Annee, Diplome)%>%summarise(TauxInsertion = median(Taux_Insertion, na.rm = TRUE))
        taux.insert.master.regroupe <- taux.insert.master%>%group_by(Annee, Diplome)%>%summarise(TauxInsertion = median(Taux_Insertion, na.rm = TRUE))
        taux.insert.regroupe.df <- bind_rows(taux.insert.DUT.regroupe, 
                                             taux.insert.lp.regroupe, 
                                             taux.insert.master.regroupe)
        
        ggplot()+geom_point(data = taux.insert.df, mapping = aes(x = Annee,y = Taux_Insertion, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.insert.regroupe.df, mapping = aes(x = Annee,y = TauxInsertion, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'insertion")
        
    })
    
    output$Taux_emploi_cadre_par_an <- renderPlot({
        
        discipline <- input$discipline_par_an
        
        diplome.lp <- diplome.lp()%>%filter(Domaine == discipline)
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == discipline)
        diplome.master <- diplome.master()%>%filter(domaine == discipline)
        
        taux.emploi.cadre.DUT <- data.frame(Annee = diplome.DUT$Année, 
                                            Diplome = diplome.DUT$Diplôme, 
                                            Taux_emploi_cadre = as.numeric(diplome.DUT$Part.des.emplois.de.niveau.cadre))
        
        
        taux.emploi.cadre.lp <- data.frame(Annee = diplome.lp$Annee, 
                                           Diplome = diplome.lp$Diplôme, 
                                           Taux_emploi_cadre = as.numeric(diplome.lp$X..emplois.cadre))
        
        
        taux.emploi.cadre.master <- data.frame(Annee = diplome.master$annee, 
                                               Diplome = diplome.master$diplome, 
                                               Taux_emploi_cadre = as.numeric(diplome.master$emplois_cadre))
        
        taux.emploi.cadre.df <- bind_rows(taux.emploi.cadre.DUT, 
                                          taux.emploi.cadre.lp, 
                                          taux.emploi.cadre.master)
        
        taux.emploi.cadre.DUT.regroupe <- taux.emploi.cadre.DUT%>%group_by(Annee, Diplome)%>%summarise(Tauxemploicadre = median(Taux_emploi_cadre, na.rm = TRUE))
        taux.emploi.cadre.lp.regroupe <- taux.emploi.cadre.lp%>%group_by(Annee, Diplome)%>%summarise(Tauxemploicadre = median(Taux_emploi_cadre, na.rm = TRUE))
        taux.emploi.cadre.master.regroupe <- taux.emploi.cadre.master%>%group_by(Annee, Diplome)%>%summarise(Tauxemploicadre = median(Taux_emploi_cadre, na.rm = TRUE))
        
        taux.emploi.cadre.regroupe.df <- bind_rows(taux.emploi.cadre.DUT.regroupe, 
                                          taux.emploi.cadre.lp.regroupe, 
                                          taux.emploi.cadre.master.regroupe)
        
        ggplot()+geom_point(data = taux.emploi.cadre.df, mapping = aes(x = Annee,y = Taux_emploi_cadre, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.emploi.cadre.regroupe.df, mapping = aes(x = Annee,y = Tauxemploicadre, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'emplois cadré")
    })
    
    output$Taux_emploi_stable_par_an <- renderPlot({
        
        discipline <- input$discipline_par_an
        
        diplome.lp <- diplome.lp()%>%filter(Domaine == discipline)
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == discipline)
        diplome.master <- diplome.master()%>%filter(domaine == discipline)
        
        taux.emploi.stables.DUT <- data.frame(Annee = diplome.DUT$Année, 
                                              Diplome = diplome.DUT$Diplôme, 
                                              Taux_emploi_stables = as.numeric(diplome.DUT$Part.des.emplois.stables))
        
        taux.emploi.stables.lp <- data.frame(Annee = diplome.lp$Annee, 
                                             Diplome = diplome.lp$Diplôme, 
                                             Taux_emploi_stables = as.numeric(diplome.lp$X..emplois.stables))
        
        taux.emploi.stables.master <- data.frame(Annee = diplome.master$annee, 
                                                 Diplome = diplome.master$diplome, 
                                                 Taux_emploi_stables = as.numeric(diplome.master$emplois_stables))
        
        taux.emploi.stables.df <- bind_rows(taux.emploi.stables.DUT, 
                                            taux.emploi.stables.lp, 
                                            taux.emploi.stables.master)
        
        taux.emploi.stables.DUT.regroupe <- taux.emploi.stables.DUT%>%group_by(Annee, Diplome)%>%summarise(Tauxemploistables = median(Taux_emploi_stables, na.rm = TRUE))
        taux.emploi.stables.lp.regroupe <- taux.emploi.stables.lp%>%group_by(Annee, Diplome)%>%summarise(Tauxemploistables = median(Taux_emploi_stables, na.rm = TRUE))
        taux.emploi.stables.master.regroupe <- taux.emploi.stables.master%>%group_by(Annee, Diplome)%>%summarise(Tauxemploistables = median(Taux_emploi_stables, na.rm = TRUE))
        
        taux.emploi.stables.regroupe.df <- bind_rows(taux.emploi.stables.DUT.regroupe, 
                                            taux.emploi.stables.lp.regroupe, 
                                            taux.emploi.stables.master.regroupe)
        
        ggplot()+geom_point(data = taux.emploi.stables.df, mapping = aes(x = Annee,y = Taux_emploi_stables, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.emploi.stables.regroupe.df, mapping = aes(x = Annee,y = Tauxemploistables, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'emplois stables")
    })
    
    output$Taux_emploi_temps_plein_par_an <- renderPlot({
        
        discipline <- input$discipline_par_an
        
        diplome.lp <- diplome.lp()%>%filter(Domaine == discipline)
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == discipline)
        diplome.master <- diplome.master()%>%filter(domaine == discipline)
        
        taux.emploi.temps.plein.DUT <- data.frame(Annee = diplome.DUT$Année, 
                                                  Diplome = diplome.DUT$Diplôme, 
                                                  Taux_emploi_temps_plein = as.numeric(diplome.DUT$Part.des.emplois.à.temps.plein))
        
        taux.emploi.temps.plein.lp <- data.frame(Annee = diplome.lp$Annee, 
                                                 Diplome = diplome.lp$Diplôme, 
                                                 Taux_emploi_temps_plein = as.numeric(diplome.lp$X..emplois.à.temps.plein))
        
        taux.emploi.temps.plein.master <- data.frame(Annee = diplome.master$annee, 
                                                     Diplome = diplome.master$diplome, 
                                                     Taux_emploi_temps_plein = as.numeric(diplome.master$emplois_a_temps_plein))
        
        taux.emploi.temps.plein.df <- bind_rows(taux.emploi.temps.plein.DUT, 
                                                taux.emploi.temps.plein.lp, 
                                                taux.emploi.temps.plein.master)
        
        taux.emploi.temps.plein.DUT.regroupe <- taux.emploi.temps.plein.DUT%>%group_by(Annee, Diplome)%>%summarise(Tauxemploitempsplein = median(Taux_emploi_temps_plein,na.rm = TRUE))
        taux.emploi.temps.plein.lp.regroupe <- taux.emploi.temps.plein.lp%>%group_by(Annee, Diplome)%>%summarise(Tauxemploitempsplein = median(Taux_emploi_temps_plein, na.rm = TRUE))
        taux.emploi.temps.plein.master.regroupe <- taux.emploi.temps.plein.master%>%group_by(Annee, Diplome)%>%summarise(Tauxemploitempsplein = median(Taux_emploi_temps_plein, na.rm = TRUE))
        
        taux.emploi.temps.plein.regroupe.df <- bind_rows(taux.emploi.temps.plein.DUT.regroupe, 
                                                taux.emploi.temps.plein.lp.regroupe, 
                                                taux.emploi.temps.plein.master.regroupe)
        
        ggplot()+geom_point(data = taux.emploi.temps.plein.df, mapping = aes(x = Annee,y = Taux_emploi_temps_plein, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.emploi.temps.plein.regroupe.df, mapping = aes(x = Annee,y = Tauxemploitempsplein, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'emplois stables")
    })
    
    output$Salaire_par_an <- renderPlot({
        
        discipline <- input$discipline_par_an
        
        diplome.lp <- diplome.lp()%>%filter(Domaine == discipline)
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == discipline)
        diplome.master <- diplome.master()%>%filter(domaine == discipline)
        
        salaire.diplomes.DUT <- data.frame(Annee = diplome.DUT$Année, 
                                           Diplome = diplome.DUT$Diplôme, 
                                           salaire_diplomes = as.numeric(diplome.DUT$Salaire.net.mensuel.médian.des.emplois.à.temps.plein))
        
        salaire.diplomes.lp <- data.frame(Annee = diplome.lp$Annee, 
                                          Diplome = diplome.lp$Diplôme, 
                                          salaire_diplomes = as.numeric(diplome.lp$Salaire.net.médian.des.emplois.à.temps.plein))
        
        salaire.diplomes.master <- data.frame(Annee = diplome.master$annee, 
                                              Diplome = diplome.master$diplome, 
                                              salaire_diplomes = as.numeric(diplome.master$salaire_net_median_des_emplois_a_temps_plein))
        
        salaire.diplomes.df <- bind_rows(salaire.diplomes.DUT, 
                                         salaire.diplomes.lp, 
                                         salaire.diplomes.master)
        
        salaire.diplomes.DUT.regroupe <- salaire.diplomes.DUT%>%group_by(Annee, Diplome)%>%summarise(salairediplomes = median(salaire_diplomes, na.rm = TRUE))
        salaire.diplomes.lp.regroupe <- salaire.diplomes.lp%>%group_by(Annee, Diplome)%>%summarise(salairediplomes = median(salaire_diplomes, na.rm = TRUE))
        salaire.diplomes.master.regroupe <- salaire.diplomes.master%>%group_by(Annee, Diplome)%>%summarise(salairediplomes = median(salaire_diplomes, na.rm = TRUE))
        
        salaire.diplomes.regroupe.df <- bind_rows(salaire.diplomes.DUT.regroupe, 
                                         salaire.diplomes.lp.regroupe, 
                                         salaire.diplomes.master.regroupe)
        
        ggplot()+geom_point(data = salaire.diplomes.df, mapping = aes(x = Annee,y = salaire_diplomes, group = Diplome, color = Diplome))+ 
            geom_line(data = salaire.diplomes.regroupe.df, mapping = aes(x = Annee,y = salairediplomes, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Salaires de chaque diplômes")
    })
    
    ###############################################################################################################################################
    
    output$taux_dinsertion_par_domaine <- renderPlot({
        an <- input$annees
        domaine <- input$discipline_par_domaine
        
        diplome.lp <- diplome.lp()%>%filter(Annee == an&Domaine == domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == an&Domaine == domaine)
        diplome.master <- diplome.master()%>%filter(annee == an&domaine == domaine)
        
        taux.insert.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_Insertion = as.numeric(diplome.lp$Taux.d.insertion))
        taux.insert.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_Insertion = as.numeric(diplome.DUT$Taux.d.insertion))
        taux.insert.master <- data.frame(Diplome = diplome.master$diplome, Taux_Insertion = as.numeric(diplome.master$taux_dinsertion))
        
        taux.insert.df <- bind_rows(taux.insert.DUT, taux.insert.lp, taux.insert.master)
        
        ggplot(data = taux.insert.df, aes(x = Diplome, y = Taux_Insertion, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'insertion")
        
    })
    
    
    output$part_femmes_par_domaine <- renderPlot({
        an <- input$annees
        domaine <- input$discipline_par_domaine
        
        diplome.lp <- diplome.lp()%>%filter(Annee == an&Domaine == domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == an&Domaine == domaine)
        diplome.master <- diplome.master()%>%filter(annee == an&domaine == domaine)
        
        part.femme.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Part_femme = as.numeric(diplome.DUT$Part.des.femmes))
        part.femme.lp <- data.frame(Diplome = diplome.lp$Diplôme, Part_femme = as.numeric(diplome.lp$X..femmes))
        part.femme.master <- data.frame(Diplome = diplome.master$diplome, Part_femme = as.numeric(diplome.master$femmes))
        
        part.femme.df <- bind_rows(part.femme.DUT, part.femme.lp, part.femme.master)
        
        part.femme.graphe <- ggplot(data = part.femme.df, aes(x = Diplome, y = Part_femme, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Part des femmes")
        print(part.femme.graphe)
        
    })
    
    
    output$taux_demplois_cadres_par_domaine <- renderPlot({
        an <- input$annees
        domaine <- input$discipline_par_domaine
        
        diplome.lp <- diplome.lp()%>%filter(Annee == an&Domaine == domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == an&Domaine == domaine)
        diplome.master <- diplome.master()%>%filter(annee == an&domaine == domaine)
        
        taux.emploi.cadre.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_cadre = as.numeric(diplome.DUT$Part.des.emplois.de.niveau.cadre))
        taux.emploi.cadre.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_cadre = as.numeric(diplome.lp$X..emplois.cadre))
        taux.emploi.cadre.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_cadre = as.numeric(diplome.master$emplois_cadre))
        
        taux.emploi.cadre.df <- bind_rows(taux.emploi.cadre.DUT, taux.emploi.cadre.lp, taux.emploi.cadre.master)
        
        ggplot(data = taux.emploi.cadre.df, aes(x = Diplome, y = Taux_emploi_cadre, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'emplois cadrés")
    })
    
    output$taux_demplois_stables_par_domaine <- renderPlot({
        an <- input$annees
        domaine <- input$discipline_par_domaine
        
        diplome.lp <- diplome.lp()%>%filter(Annee == an&Domaine == domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == an&Domaine == domaine)
        diplome.master <- diplome.master()%>%filter(annee == an&domaine == domaine)
        
        taux.emploi.stables.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_stables = as.numeric(diplome.DUT$Part.des.emplois.stables))
        taux.emploi.stables.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_stables = as.numeric(diplome.lp$X..emplois.stables))
        taux.emploi.stables.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_stables = as.numeric(diplome.master$emplois_stables))
        
        taux.emploi.stables.df <- bind_rows(taux.emploi.stables.DUT, taux.emploi.stables.lp, taux.emploi.stables.master)
        
        ggplot(data = taux.emploi.stables.df, aes(x = Diplome, y = Taux_emploi_stables, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'emplois stables")
    })
    
    output$taux_demplois_temps_plein_par_domaine <- renderPlot({
        an <- input$annees
        domaine <- input$discipline_par_domaine
        
        diplome.lp <- diplome.lp()%>%filter(Annee == an&Domaine == domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == an&Domaine == domaine)
        diplome.master <- diplome.master()%>%filter(annee == an&domaine == domaine)
        
        taux.emploi.temps.plein.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, Taux_emploi_temps_plein = as.numeric(diplome.DUT$Part.des.emplois.à.temps.plein))
        taux.emploi.temps.plein.lp <- data.frame(Diplome = diplome.lp$Diplôme, Taux_emploi_temps_plein = as.numeric(diplome.lp$X..emplois.à.temps.plein))
        taux.emploi.temps.plein.master <- data.frame(Diplome = diplome.master$diplome, Taux_emploi_temps_plein = as.numeric(diplome.master$emplois_a_temps_plein))
        
        taux.emploi.temps.plein.df <- bind_rows(taux.emploi.temps.plein.DUT, taux.emploi.temps.plein.lp, taux.emploi.temps.plein.master)
        
        ggplot(data = taux.emploi.temps.plein.df, aes(x = Diplome, y = Taux_emploi_temps_plein, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'emplois à temps plein")
    })
    
    output$salaire_diplomes_par_domaine <- renderPlot({
        an <- input$annees
        domaine <- input$discipline_par_domaine
        
        diplome.lp <- diplome.lp()%>%filter(Annee == an&Domaine == domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == an&Domaine == domaine)
        diplome.master <- diplome.master()%>%filter(annee == an&domaine == domaine)
        
        salaire.diplomes.DUT <- data.frame(Diplome = diplome.DUT$Diplôme, salaire_diplomes = as.numeric(diplome.DUT$Salaire.net.mensuel.médian.des.emplois.à.temps.plein))
        salaire.diplomes.lp <- data.frame(Diplome = diplome.lp$Diplôme, salaire_diplomes = as.numeric(diplome.lp$Salaire.net.médian.des.emplois.à.temps.plein))
        salaire.diplomes.master <- data.frame(Diplome = diplome.master$diplome, salaire_diplomes = as.numeric(diplome.master$salaire_net_median_des_emplois_a_temps_plein))
        
        salaire.diplomes.df <- bind_rows(salaire.diplomes.DUT, salaire.diplomes.lp, salaire.diplomes.master)
        
        ggplot(data = salaire.diplomes.df, aes(x = Diplome, y = salaire_diplomes, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Salaire net mensuel médian des emplois à temps plein")
    })
    

    output$carte_academie <- renderPlot({
        
        academie.lp <- diplome.lp()%>%filter(Académie != "")%>%group_by(Académie)%>%summarise(Taux_dinsertion = median(as.numeric(Taux.d.insertion), na.rm = TRUE), Part_femmes = median(as.numeric(X..femmes), na.rm = TRUE), Taux_demplois_cadre = median(as.numeric(X..emplois.cadre), na.rm = TRUE), Taux_demplois_stables = median(as.numeric(X..emplois.stables), na.rm = TRUE), Taux_emploi_temps_plein = median(as.numeric(X..emplois.à.temps.plein), na.rm = TRUE))%>%rename(academie = Académie)%>%bind_cols(Diplome = rep("LP", 30))
        
        academie.master <- diplome.master()%>%filter(academie != "")%>%group_by(academie)%>%summarise(Taux_dinsertion = median(as.numeric(taux_dinsertion), na.rm = TRUE), Part_femmes = median(as.numeric(femmes), na.rm = TRUE), Taux_demplois_cadre = median(as.numeric(emplois_cadre), na.rm = TRUE), Taux_demplois_stables = median(as.numeric(emplois_stables), na.rm = TRUE), Taux_emploi_temps_plein = median(as.numeric(emplois_a_temps_plein), na.rm = TRUE))%>%bind_cols(Diplome = rep("Master", 30))
        
        academie.statistiques <- bind_rows(academie.lp, academie.master)
        
        
        departements <- geojsonio::geojson_read("departements.geojson", what = "sp")
        #regions <- geojsonio::geojson_read("regions.geojson", what = "sp")
        #class(departements)
        #names(departements)
        academie <- c("Amiens","Reims","Normandie","Clermont-Ferrand","Orléans-Tours","Rennes","Besançon","Bordeaux","Lyon","Orléans-Tours","Bordeaux","Nancy-Metz","Normandie","Lille","Clermont-Ferrand","Strasbourg","Strasbourg","Normandie","Dijon","Créteil","Aix-Marseille","Aix-Marseille","Grenoble","Reims","Toulouse","Poitiers","Limoges","Bordeaux","Normandie","Orléans-Tours","Montpellier","Dijon","Amiens","Bordeaux","Lyon","Dijon","Paris","Versailles","Toulouse","Toulouse","Nice","Nantes","Limoges","Nancy-Metz","Versailles","Clermont-Ferrand","Nice","Montpellier","Corse","Rennes","Limoges","Besançon","Rennes","Montpellier","Bordeaux","Orléans-Tours","Grenoble","Reims","Reims","Nancy-Metz","Toulouse","Montpellier","Grenoble","Grenoble","Créteil","Aix-Marseille","Poitiers","Créteil","Lyon","Toulouse","Aix-Marseille","Poitiers","Orléans-Tours","Corse","Dijon","Grenoble","Toulouse","Toulouse","Montpellier","Clermont-Ferrand","Nantes","Toulouse","Nantes","Normandie","Rennes","Lille","Besançon","Nantes","Amiens","Versailles","Versailles","Orléans-Tours","Nantes","Nancy-Metz","Poitiers","Besançon")
        
        departements$academie <- academie
        require(sp)
        ?sp::merge
        academie.dept <- departements%>%merge(academie.statistiques, by = "academie", duplicateGeoms = TRUE)
        
        m <- leaflet(academie.dept)%>%addTiles("MapBox",
                                               options = providerTileOptions(id = "mapbox.light",
                                                                             accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
        
        bins <- c(50, 60,70, 80, 90, 100)
        pal <- colorBin("YlOrRd", domain = academie.dept$Part_femmes, bins = bins)
        
        labels <- sprintf(
            "<strong>%s</strong><br/>%g%%",
            academie.dept$nom, academie.dept$Part_femmes
        ) %>% lapply(htmltools::HTML)
        
        m %>% addPolygons(fillColor = ~pal(Part_femmes),
                          weight = 2,
                          opacity = 1,
                          color = "white",
                          dashArray = "3",
                          fillOpacity = 0.7,
                          highlight = highlightOptions(
                              weight = 5,
                              color = "#666",
                              dashArray = "",
                              fillOpacity = 0.7,
                              bringToFront = TRUE),
                          label = labels,
                          labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))%>% addLegend(pal = pal, values = ~Part_femmes, opacity = 0.7, title = NULL,position = "bottomright")
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)



