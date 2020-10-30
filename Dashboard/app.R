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
            menuItem("Distribution des échantillons", tabName = "diplome", icon = icon("certificate")),
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
                                   sliderInput(inputId = "annees_par_diplome",
                                               label = "Année",
                                               min = 2013,
                                               max = 2016,
                                               step = 1,
                                               value = 2013,
                                               animate = TRUE),)),
                        fluidRow(
                            column(6,
                                   plotOutput(outputId = "histo_diplome", height = "450px", brush = "plot_brush")),
                            column(6, 
                                   plotOutput(outputId = "diplome", height="450px", brush = "plot_brush"))),
                        br(),
                        fluidRow(
                            column(2),
                            column(4,
                                   radioButtons(inputId = "diplome_par_diplome",
                                                label = "Choisissez une diplôme :",
                                                width = "80%",
                                                list("LP",
                                                     "Master"))),
                            column(2),
                            column(6,
                                   radioButtons(inputId = "discipline_par_diplome", 
                                                label = "Choisissez une discipline :", 
                                                list("Sciences, technologies et santé",
                                                     "Droit, économie et gestion",
                                                     "Sciences humaines et sociales",
                                                     "Lettres, langues, arts",
                                                     "Masters enseignement")))),
                        fluidRow(column(2),
                                 column(8,leafletOutput("carte_diplome"),
                                        h5("Pourcentage de la discipline et du diplôme donnés dans chaque département", align = "center"))),
                        title = "Distribution des échantillons", solidHeader = TRUE, status = "primary")),
            
            # Second
            tabItem(tabName = "ans", 
                    box(width = NULL,
                        fluidRow(
                            column(4),
                            column(6,
                                     radioButtons(inputId = "discipline_par_an", 
                                                     label = "Choisissez une discipline :", 
                                                     list("Sciences, technologies et santé",
                                                          "Droit, économie et gestion",
                                                          "Sciences humaines et sociales",
                                                          "Lettres, langues, arts",
                                                          "Masters enseignement",
                                                          "Ensemble des départements d'IUT")))),
                        title = "Paramètres",
                        solidHeader = TRUE,
                        status = "primary"),
                    fluidRow(
                        tabBox(id = "tabset_an", width = 12, 
                               tabPanel("Taux d'insertion", 
                                        plotOutput(outputId = "Taux_insertion_par_an", height="450px")
                               ),
                               tabPanel("Statistiques des emplois", 
                                        plotOutput(outputId = "Taux_emploi_cadre_par_an", height="450px"), 
                                                        plotOutput(outputId = "Taux_emploi_stable_par_an", height="450px"), 
                                                        plotOutput(outputId = "Taux_emploi_temps_plein_par_an", height="450px")
                               ),
                               tabPanel("Part des femmes", 
                                        plotOutput(outputId = "Part_femmes_par_an", height="450px")
                               ),
                               tabPanel("Salaire net mensuel", 
                                        plotOutput(outputId = "Salaire_par_an", height="450px")
                               )
                        ))),
            
            # Third tab content
            tabItem(tabName = "domaine", 
                    box(width = NULL,
                        fluidRow(
                          column(6, 
                                 sliderInput(inputId = "annees_par_domaine",
                                                            label = "Année",
                                                            min = 2013,
                                                            max = 2016,
                                                            step = 1,
                                                            value = 2013,
                                                            width = "80%",
                                                            animate = TRUE)),
                          column(6,
                                 radioButtons(inputId = "discipline_par_domaine", 
                                                      label = "Choisissez une discipline :", 
                                                      width = "80%",
                                                      list("Sciences, technologies et santé",
                                                           "Droit, économie et gestion",
                                                           "Sciences humaines et sociales",
                                                           "Lettres, langues, arts",
                                                           "Masters enseignement",
                                                           "Ensemble des départements d'IUT")))
                        ),
                        title = "Paramètres",
                        solidHeader = TRUE,
                        status = "primary"),
                    fluidRow(
                    tabBox(width = 12, id = "tabset_domaines", 
                           tabPanel("Taux d'insertion", 
                                    fluidRow(
                                        column(6,
                                               plotOutput(outputId = "taux_dinsertion_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6, 
                                               plotOutput(outputId = "taux_dinsertion_par_domaine", height="450px", brush = "plot_brush")))), 
                           tabPanel("Statistiques des emplois", 
                                    fluidRow(
                                        column(6,
                                               plotOutput(outputId = "taux_demplois_cadres_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6,
                                               plotOutput(outputId = "taux_demplois_cadres_par_domaine", height="450px", brush = "plot_brush"))
                                        ), 
                                    fluidRow(
                                        column(6,
                                               plotOutput(outputId = "taux_demplois_stables_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6,
                                               plotOutput(outputId = "taux_demplois_stables_par_domaine", height="450px", brush = "plot_brush"))
                                    ),
                                    fluidRow(
                                        column(6,
                                               plotOutput(outputId = "taux_demplois_temps_plein_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6,
                                               plotOutput(outputId = "taux_demplois_temps_plein_par_domaine", height="450px", brush = "plot_brush"))
                                    )
                                    # fluidRow(
                                    #     splitLayout(cellWidths = c("33%", "33%", "33%"), 
                                    #                 ))
                                    ), 
                           tabPanel("Part des femmes", 
                                    fluidRow(
                                        column(6,
                                               plotOutput(outputId = "part_femmes_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6, 
                                               plotOutput(outputId = "part_femmes_par_domaine", height="450px", brush = "plot_brush")))), 
                           
                           tabPanel("Salaire net mensuel", 
                                    fluidRow(
                                        column(6, 
                                               plotOutput(outputId = "salaire_diplomes_par_domaine_histo", height="450px", brush = "plot_brush")), 
                                        column(6, 
                                               plotOutput(outputId = "salaire_diplomes_par_domaine", height="450px", brush = "plot_brush"))
                                    )
                                    
                                    )
                    ))),
            
            # Third tab content
            tabItem(tabName = "academie", 
                    # h2(""),
                    fluidRow(
                        column(5,
                               box(
                                    title = "Paramètres",
                                    width = NULL,
                                    sliderInput(inputId = "annees_carto",
                                                label = "Année",
                                                min = 2013,
                                                max = 2016,
                                                step = 1,
                                                value = 2013,
                                                width = "100%",
                                                animate = TRUE),
                                    radioButtons(inputId = "diplome_par_ville",
                                                 label = "Choisissez un diplôme :",
                                                 width = "80%",
                                                 list("LP",
                                                      "Master")),
                                    radioButtons(inputId = "discipline_par_ville",
                                                 label = "Choisissez une discipline :",
                                                 width = "80%",
                                                 list("Sciences, technologies et santé",
                                                      "Droit, économie et gestion",
                                                      "Sciences humaines et sociales",
                                                      "Lettres, langues, arts",
                                                      "Masters enseignement")),
                                    radioButtons(inputId = "statistiques_par_ville",
                                                 label = "Choisissez une statistique (médiane) :",
                                                 width = "80%",
                                                 list("Taux d'insertion",
                                                      "Part des femmes",
                                                      "Taux d'emplois cadre",
                                                      "Taux d'emplois stables",
                                                      "Taux d'emplois à temps plein",
                                                      "Salaires net mensuel médian des emplois à temps plein"))
                                    )
                               ),
                        column(7,
                               box(leafletOutput("carte_academie"),
                                    width = NULL, title = "Statistiques par ville",solidHeader = TRUE, status = "primary"))
                                
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
        
        nbr.echanti.domaine.dut <- diplome.DUT()%>%filter(Année == input$annees_par_diplome)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("DUT", 4))            
        nbr.echanti.domaine.lp <- diplome.lp()%>%filter(Annee == input$annees_par_diplome)%>%group_by(Domaine)%>%summarise(Nombre = sum(Nombre.de.réponses, na.rm = TRUE))%>%bind_cols(Diplome = rep("LP", 4))
        nbr.echanti.domaine.master <- diplome.master()%>%filter(annee == input$annees_par_diplome)%>%group_by(domaine)%>%summarise(Nombre = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%bind_cols(Diplome = rep("Master", 5))
        
        type.de.diplomes <- bind_rows(nbr.echanti.domaine.master, 
                                      nbr.echanti.domaine.lp, 
                                      nbr.echanti.domaine.dut)
        
        ggplot(type.de.diplomes, 
               aes(fill =Domaine,  
                   y=Nombre, 
                   x =Diplome )) +geom_bar(position="fill", stat="identity") + labs(x= "diplômes", y = "Pourcentage de chaque domaine")
        
    })
    
    output$histo_diplome <- renderPlot({
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_diplome)
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_diplome)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_diplome)
        
        nbr.echanti.dut <- sum(diplome.DUT$Nombre.de.réponses)
        nbr.echanti.lp <- sum(diplome.lp$Nombre.de.réponses)
        nbr.echanti.master <- sum(diplome.master$nombre_de_reponses)   
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Nombre = c(nbr.echanti.dut, nbr.echanti.lp, nbr.echanti.master))
        
        ggplot(type.de.diplomes, aes(y=Nombre,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x= "diplômes", y = "Nombre d'échantillons de chaque domaine")
    })
    
    
    output$carte_diplome <- renderLeaflet({
        
        nbr.lp <- diplome.lp()%>%filter(Académie != ""&Annee == input$annees_par_diplome)%>%subset(select = c("Académie", "Domaine", "Nombre.de.réponses"))
        nbr.regroupe.lp <- nbr.lp%>%group_by(Académie, Domaine)%>%summarise(Pourcentage = sum(Nombre.de.réponses, na.rm = TRUE))%>%rename(academie = Académie)%>%mutate(Pourcentage = Pourcentage*100/sum(Pourcentage)) 
        
        nbr.master <- diplome.master()%>%filter(academie != ""&annee == input$annees_par_diplome)%>%subset(select = c("academie", "domaine", "nombre_de_reponses"))
        nbr.regroupe.master <- nbr.master%>%group_by(academie, domaine)%>%summarise(Pourcentage = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%mutate(Pourcentage = Pourcentage*100/sum(Pourcentage)) 
        
        
        if(input$diplome_par_diplome == "LP"){
            academie.statistiques <- nbr.regroupe.lp%>%filter(Domaine == input$discipline_par_diplome)
        }else{
            academie.statistiques <- nbr.regroupe.master%>%filter(Domaine == input$discipline_par_diplome)
        }
        
        departements <- geojsonio::geojson_read("departements.geojson", what = "sp")
        academie <- c("Amiens","Reims","Normandie","Clermont-Ferrand","Orléans-Tours","Rennes","Besançon","Bordeaux","Lyon","Orléans-Tours","Bordeaux","Nancy-Metz","Normandie","Lille","Clermont-Ferrand","Strasbourg","Strasbourg","Normandie","Dijon","Créteil","Aix-Marseille","Aix-Marseille","Grenoble","Reims","Toulouse","Poitiers","Limoges","Bordeaux","Normandie","Orléans-Tours","Montpellier","Dijon","Amiens","Bordeaux","Lyon","Dijon","Paris","Versailles","Toulouse","Toulouse","Nice","Nantes","Limoges","Nancy-Metz","Versailles","Clermont-Ferrand","Nice","Montpellier","Corse","Rennes","Limoges","Besançon","Rennes","Montpellier","Bordeaux","Orléans-Tours","Grenoble","Reims","Reims","Nancy-Metz","Toulouse","Montpellier","Grenoble","Grenoble","Créteil","Aix-Marseille","Poitiers","Créteil","Lyon","Toulouse","Aix-Marseille","Poitiers","Orléans-Tours","Corse","Dijon","Grenoble","Toulouse","Toulouse","Montpellier","Clermont-Ferrand","Nantes","Toulouse","Nantes","Normandie","Rennes","Lille","Besançon","Nantes","Amiens","Versailles","Versailles","Orléans-Tours","Nantes","Nancy-Metz","Poitiers","Besançon")
        
        departements$academie <- academie
        require(sp)
        ?sp::merge
        academie.dept <- departements%>%merge(academie.statistiques, by = "academie", duplicateGeoms = TRUE)
        
        m <- leaflet(academie.dept)%>%addTiles("MapBox",
                                               options = providerTileOptions(id = "mapbox.light",
                                                                             accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
        
        bins <- c(0, 5, 10, 20, 30, 40, 50, 60,70, 80, 90, 100)
        
        
        pal <- colorBin("YlOrRd", domain = academie.dept$Pourcentage, bins = bins)
        
        labels <- sprintf(
            "<strong>%s</strong><br/>%g%%",
            academie.dept$nom,  academie.dept$Pourcentage
        ) %>% lapply(htmltools::HTML)
        
        m %>% addPolygons(fillColor = ~pal(Pourcentage),
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
                              direction = "auto"))%>% addLegend(pal = pal, values = ~Pourcentage, opacity = 0.7, title = NULL,position = "bottomright")
    })
    

#####################################################################################################################################################################################    
    output$Part_femmes_par_an <- renderPlot({
        diplome.DUT <- diplome.DUT()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Année", "Diplôme", "Part.des.femmes"))%>%rename(Annee = Année, Diplome = Diplôme, Part_femmes = Part.des.femmes)
        diplome.lp <- diplome.lp()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Annee", "Diplôme", "X..femmes"))%>%rename(Annee = Annee, Diplome = Diplôme, Part_femmes = X..femmes)
        diplome.master <- diplome.master()%>%filter(domaine == input$discipline_par_an)%>%subset(select = c("annee", "diplome", "femmes"))%>%rename(Annee = annee, Diplome = diplome, Part_femmes = femmes)

        mode(diplome.lp$Part_femmes) <- "numeric"
        mode(diplome.DUT$Part_femmes) <- "numeric"
        mode(diplome.master$Part_femmes) <- "numeric"
    
        part.femme.df <- bind_rows(diplome.DUT, 
                                   diplome.lp, 
                                   diplome.master)
        
        part.femme.DUT.regroupe <- diplome.DUT%>%group_by(Annee, Diplome)%>%summarise(Part_femmes = median(Part_femmes, na.rm = TRUE))
        part.femme.lp.regroupe <- diplome.lp%>%group_by(Annee, Diplome)%>%summarise(Part_femmes = median(Part_femmes, na.rm = TRUE))
        part.femme.master.regroupe <- diplome.master%>%group_by(Annee, Diplome)%>%summarise(Part_femmes = median(Part_femmes, na.rm = TRUE))
        
        part.femme.regroupe.df <- bind_rows(part.femme.DUT.regroupe, 
                                            part.femme.lp.regroupe, 
                                            part.femme.master.regroupe)
        
        
        ggplot()+geom_point(data = part.femme.df, mapping = aes(x = Annee,y = Part_femmes, group = Diplome, color = Diplome))+ 
            geom_line(data = part.femme.regroupe.df, mapping = aes(x = Annee,y = Part_femmes,group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Part des femmes")
        

    })
    
    output$Taux_insertion_par_an <- renderPlot({
      
      diplome.DUT <- diplome.DUT()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Année", "Diplôme", "Taux.d.insertion"))%>%rename(Annee = Année, Diplome = Diplôme, Taux_Insertion = Taux.d.insertion)
      diplome.lp <- diplome.lp()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Annee", "Diplôme", "Taux.d.insertion"))%>%rename(Diplome = Diplôme, Taux_Insertion = Taux.d.insertion)
      diplome.master <- diplome.master()%>%filter(domaine == input$discipline_par_an)%>%subset(select = c("annee", "diplome", "taux_dinsertion"))%>%rename(Annee = annee, Diplome = diplome, Taux_Insertion = taux_dinsertion)
      
      mode(diplome.lp$Taux_Insertion) <- "numeric"
      mode(diplome.DUT$Taux_Insertion) <- "numeric"
      mode(diplome.master$Taux_Insertion) <- "numeric"
      
        
        taux.insert.df <- bind_rows(diplome.DUT, 
                                    diplome.lp, 
                                    diplome.master)
        
        taux.insert.DUT.regroupe <- diplome.DUT%>%group_by(Annee, Diplome)%>%summarise(TauxInsertion = median(Taux_Insertion, na.rm = TRUE))
        taux.insert.lp.regroupe <- diplome.lp%>%group_by(Annee, Diplome)%>%summarise(TauxInsertion = median(Taux_Insertion, na.rm = TRUE))
        taux.insert.master.regroupe <- diplome.master%>%group_by(Annee, Diplome)%>%summarise(TauxInsertion = median(Taux_Insertion, na.rm = TRUE))
        
        taux.insert.regroupe.df <- bind_rows(taux.insert.DUT.regroupe, 
                                             taux.insert.lp.regroupe, 
                                             taux.insert.master.regroupe)
        
        ggplot()+geom_point(data = taux.insert.df, mapping = aes(x = Annee,y = Taux_Insertion, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.insert.regroupe.df, mapping = aes(x = Annee,y = TauxInsertion, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'insertion")
        
    })
    
    output$Taux_emploi_cadre_par_an <- renderPlot({
      
      diplome.DUT <- diplome.DUT()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Année", "Diplôme", "Part.des.emplois.de.niveau.cadre"))%>%rename(Annee = Année, Diplome = Diplôme, Taux_emploi_cadre = Part.des.emplois.de.niveau.cadre)
      diplome.lp <- diplome.lp()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Annee", "Diplôme", "X..emplois.cadre"))%>%rename(Diplome = Diplôme, Taux_emploi_cadre = X..emplois.cadre)
      diplome.master <- diplome.master()%>%filter(domaine == input$discipline_par_an)%>%subset(select = c("annee", "diplome", "emplois_cadre"))%>%rename(Annee = annee, Diplome = diplome, Taux_emploi_cadre = emplois_cadre)
      
      mode(diplome.lp$Taux_emploi_cadre) <- "numeric"
      mode(diplome.DUT$Taux_emploi_cadre) <- "numeric"
      mode(diplome.master$Taux_emploi_cadre) <- "numeric"
      
        taux.emploi.cadre.df <- bind_rows(diplome.DUT, 
                                          diplome.lp, 
                                          diplome.master)
        
        taux.emploi.cadre.DUT.regroupe <- diplome.DUT%>%group_by(Annee, Diplome)%>%summarise(Tauxemploicadre = median(Taux_emploi_cadre, na.rm = TRUE))
        taux.emploi.cadre.lp.regroupe <- diplome.lp%>%group_by(Annee, Diplome)%>%summarise(Tauxemploicadre = median(Taux_emploi_cadre, na.rm = TRUE))
        taux.emploi.cadre.master.regroupe <- diplome.master%>%group_by(Annee, Diplome)%>%summarise(Tauxemploicadre = median(Taux_emploi_cadre, na.rm = TRUE))
        
        taux.emploi.cadre.regroupe.df <- bind_rows(taux.emploi.cadre.DUT.regroupe, 
                                          taux.emploi.cadre.lp.regroupe, 
                                          taux.emploi.cadre.master.regroupe)
        
        ggplot()+geom_point(data = taux.emploi.cadre.df, mapping = aes(x = Annee,y = Taux_emploi_cadre, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.emploi.cadre.regroupe.df, mapping = aes(x = Annee,y = Tauxemploicadre, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'emplois cadre")
    })
    
    output$Taux_emploi_stable_par_an <- renderPlot({
      
      diplome.DUT <- diplome.DUT()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Année", "Diplôme", "Part.des.emplois.stables"))%>%rename(Annee = Année, Diplome = Diplôme, Taux_emploi_stables = Part.des.emplois.stables)
      diplome.lp <- diplome.lp()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Annee", "Diplôme", "X..emplois.stables"))%>%rename(Diplome = Diplôme, Taux_emploi_stables = X..emplois.stables)
      diplome.master <- diplome.master()%>%filter(domaine == input$discipline_par_an)%>%subset(select = c("annee", "diplome", "emplois_stables"))%>%rename(Annee = annee, Diplome = diplome, Taux_emploi_stables = emplois_stables)
      
      mode(diplome.lp$Taux_emploi_stables) <- "numeric"
      mode(diplome.DUT$Taux_emploi_stables) <- "numeric"
      mode(diplome.master$Taux_emploi_stables) <- "numeric"
        
        taux.emploi.stables.df <- bind_rows(diplome.DUT, 
                                            diplome.lp, 
                                            diplome.master)
        
        taux.emploi.stables.DUT.regroupe <- diplome.DUT%>%group_by(Annee, Diplome)%>%summarise(Tauxemploistables = median(Taux_emploi_stables, na.rm = TRUE))
        taux.emploi.stables.lp.regroupe <- diplome.lp%>%group_by(Annee, Diplome)%>%summarise(Tauxemploistables = median(Taux_emploi_stables, na.rm = TRUE))
        taux.emploi.stables.master.regroupe <- diplome.master%>%group_by(Annee, Diplome)%>%summarise(Tauxemploistables = median(Taux_emploi_stables, na.rm = TRUE))
        
        taux.emploi.stables.regroupe.df <- bind_rows(taux.emploi.stables.DUT.regroupe, 
                                            taux.emploi.stables.lp.regroupe, 
                                            taux.emploi.stables.master.regroupe)
        
        ggplot()+geom_point(data = taux.emploi.stables.df, mapping = aes(x = Annee,y = Taux_emploi_stables, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.emploi.stables.regroupe.df, mapping = aes(x = Annee,y = Tauxemploistables, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'emplois stables")
    })
    
    output$Taux_emploi_temps_plein_par_an <- renderPlot({
        
      diplome.DUT <- diplome.DUT()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Année", "Diplôme", "Part.des.emplois.à.temps.plein"))%>%rename(Annee = Année, Diplome = Diplôme, Taux_emploi_temps_plein = Part.des.emplois.à.temps.plein)
      diplome.lp <- diplome.lp()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Annee", "Diplôme", "X..emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, Taux_emploi_temps_plein = X..emplois.à.temps.plein)
      diplome.master <- diplome.master()%>%filter(domaine == input$discipline_par_an)%>%subset(select = c("annee", "diplome", "emplois_a_temps_plein"))%>%rename(Annee = annee, Diplome = diplome, Taux_emploi_temps_plein = emplois_a_temps_plein)
      
      mode(diplome.lp$Taux_emploi_temps_plein) <- "numeric"
      mode(diplome.DUT$Taux_emploi_temps_plein) <- "numeric"
      mode(diplome.master$Taux_emploi_temps_plein) <- "numeric"
      
        taux.emploi.temps.plein.df <- bind_rows(diplome.DUT, 
                                                diplome.lp, 
                                                diplome.master)
        
        taux.emploi.temps.plein.DUT.regroupe <- diplome.DUT%>%group_by(Annee, Diplome)%>%summarise(Tauxemploitempsplein = median(Taux_emploi_temps_plein,na.rm = TRUE))
        taux.emploi.temps.plein.lp.regroupe <- diplome.lp%>%group_by(Annee, Diplome)%>%summarise(Tauxemploitempsplein = median(Taux_emploi_temps_plein, na.rm = TRUE))
        taux.emploi.temps.plein.master.regroupe <- diplome.master%>%group_by(Annee, Diplome)%>%summarise(Tauxemploitempsplein = median(Taux_emploi_temps_plein, na.rm = TRUE))
        
        taux.emploi.temps.plein.regroupe.df <- bind_rows(taux.emploi.temps.plein.DUT.regroupe, 
                                                taux.emploi.temps.plein.lp.regroupe, 
                                                taux.emploi.temps.plein.master.regroupe)
        
        ggplot()+geom_point(data = taux.emploi.temps.plein.df, mapping = aes(x = Annee,y = Taux_emploi_temps_plein, group = Diplome, color = Diplome))+ 
            geom_line(data = taux.emploi.temps.plein.regroupe.df, mapping = aes(x = Annee,y = Tauxemploitempsplein, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Taux d'emplois à temps plein")
    })
    
    output$Salaire_par_an <- renderPlot({
        
      diplome.DUT <- diplome.DUT()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Année", "Diplôme", "Salaire.net.mensuel.médian.des.emplois.à.temps.plein"))%>%rename(Annee = Année, Diplome = Diplôme, salaire_diplomes = Salaire.net.mensuel.médian.des.emplois.à.temps.plein)
      diplome.lp <- diplome.lp()%>%filter(Domaine == input$discipline_par_an)%>%subset(select = c("Annee", "Diplôme", "Salaire.net.médian.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, salaire_diplomes = Salaire.net.médian.des.emplois.à.temps.plein)
      diplome.master <- diplome.master()%>%filter(domaine == input$discipline_par_an)%>%subset(select = c("annee", "diplome", "salaire_net_median_des_emplois_a_temps_plein"))%>%rename(Annee = annee, Diplome = diplome, salaire_diplomes = salaire_net_median_des_emplois_a_temps_plein)
      
      mode(diplome.lp$salaire_diplomes) <- "numeric"
      mode(diplome.DUT$salaire_diplomes) <- "numeric"
      mode(diplome.master$salaire_diplomes) <- "numeric"
      
        salaire.diplomes.df <- bind_rows(diplome.DUT, 
                                         diplome.lp, 
                                         diplome.master)
        
        salaire.diplomes.DUT.regroupe <- diplome.DUT%>%group_by(Annee, Diplome)%>%summarise(salairediplomes = median(salaire_diplomes, na.rm = TRUE))
        salaire.diplomes.lp.regroupe <- diplome.lp%>%group_by(Annee, Diplome)%>%summarise(salairediplomes = median(salaire_diplomes, na.rm = TRUE))
        salaire.diplomes.master.regroupe <- diplome.master%>%group_by(Annee, Diplome)%>%summarise(salairediplomes = median(salaire_diplomes, na.rm = TRUE))
        
        salaire.diplomes.regroupe.df <- bind_rows(salaire.diplomes.DUT.regroupe, 
                                         salaire.diplomes.lp.regroupe, 
                                         salaire.diplomes.master.regroupe)
        
        ggplot()+geom_point(data = salaire.diplomes.df, mapping = aes(x = Annee,y = salaire_diplomes, group = Diplome, color = Diplome))+ 
            geom_line(data = salaire.diplomes.regroupe.df, mapping = aes(x = Annee,y = salairediplomes, group = Diplome, color = Diplome)) + 
            labs(x = "Années", y = "Salaires de chaque diplômes")
    })
    
    ###############################################################################################################################################
    
    output$taux_dinsertion_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Taux.d.insertion"))%>%rename(Diplome = Diplôme, Taux_Insertion = Taux.d.insertion)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Taux.d.insertion"))%>%rename(Diplome = Diplôme, Taux_Insertion = Taux.d.insertion)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "taux_dinsertion"))%>%rename(Diplome = diplome, Taux_Insertion = taux_dinsertion)
        
        mode(diplome.lp$Taux_Insertion) <- "numeric"
        mode(diplome.DUT$Taux_Insertion) <- "numeric"
        mode(diplome.master$Taux_Insertion) <- "numeric"
        
        taux.insert.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.insert.df, aes(x = Diplome, y = Taux_Insertion, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'insertion")
        
    })
    
    output$taux_dinsertion_par_domaine_histo <- renderPlot({
        
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        taux.insert.median.dut <- median(as.numeric(diplome.DUT$Taux.d.insertion), na.rm = TRUE)
        taux.insert.median.lp <- median(as.numeric(diplome.lp$Taux.d.insertion), na.rm = TRUE)
        taux.insert.median.master <- median(as.numeric(diplome.DUT$Taux.d.insertion), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Taux.insert = c(taux.insert.median.dut, taux.insert.median.lp, taux.insert.median.master))
        
        ggplot(type.de.diplomes, aes(y=Taux.insert,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplômes", y ="Médianes de taux d'insertion de chaque domaine")
        
    })
    
    
    output$part_femmes_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..femmes"))%>%rename(Diplome = Diplôme, Part_femmes = X..femmes)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.femmes"))%>%rename(Diplome = Diplôme, Part_femmes = Part.des.femmes)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "femmes"))%>%rename(Diplome = diplome, Part_femmes = femmes)
        
        mode(diplome.lp$Part_femmes) <- "numeric"
        mode(diplome.DUT$Part_femmes) <- "numeric"
        mode(diplome.master$Part_femmes) <- "numeric"
  
        part.femme.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        part.femme.graphe <- ggplot(data = part.femme.df, aes(x = Diplome, y = Part_femmes, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Part des femmes")
        print(part.femme.graphe)
        })
    
    output$part_femmes_par_domaine_histo <- renderPlot({
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        part.femmes.median.dut <- median(as.numeric(diplome.DUT$Part.des.femmes), na.rm = TRUE)
        part.femmes.median.lp <- median(as.numeric(diplome.lp$X..femmes), na.rm = TRUE)
        part.femmes.median.master <- median(as.numeric(diplome.master$femmes), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Part_femmes = c(part.femmes.median.dut, part.femmes.median.lp, part.femmes.median.master))
        
        ggplot(type.de.diplomes, aes(y=Part_femmes,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplômes", y ="Médianes de part des femmes de chaque domaine")
        
    })
    
    output$taux_demplois_cadres_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..emplois.cadre"))%>%rename(Diplome = Diplôme, Taux_emplois_cadre = X..emplois.cadre)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.emplois.de.niveau.cadre"))%>%rename(Diplome = Diplôme, Taux_emplois_cadre = Part.des.emplois.de.niveau.cadre)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "emplois_cadre"))%>%rename(Diplome = diplome, Taux_emplois_cadre = emplois_cadre)
        
        mode(diplome.lp$Taux_emplois_cadre) <- "numeric"
        mode(diplome.DUT$Taux_emplois_cadre) <- "numeric"
        mode(diplome.master$Taux_emplois_cadre) <- "numeric"
        
       
        taux.emploi.cadre.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.emploi.cadre.df, aes(x = Diplome, y = Taux_emplois_cadre, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'emplois cadre")
    })
    
    output$taux_demplois_cadres_par_domaine_histo <- renderPlot({
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        taux.emploi.cadre.median.dut <- median(as.numeric(diplome.DUT$Part.des.emplois.de.niveau.cadre), na.rm = TRUE)
        taux.emploi.cadre.median.lp <- median(as.numeric(diplome.lp$X..emplois.cadre), na.rm = TRUE)
        taux.emploi.cadre.median.master <- median(as.numeric(diplome.master$emplois_cadre), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Taux_emplois_cadre = c(taux.emploi.cadre.median.dut, taux.emploi.cadre.median.lp, taux.emploi.cadre.median.master))
        
        ggplot(type.de.diplomes, aes(y=Taux_emplois_cadre,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplômes", y ="Médianes de taux d'insertion de chaque domaine")
        
    })
    
    output$taux_demplois_stables_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..emplois.stables"))%>%rename(Diplome = Diplôme, Taux_emploi_stables = X..emplois.stables)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.emplois.stables"))%>%rename(Diplome = Diplôme, Taux_emploi_stables = Part.des.emplois.stables)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "emplois_stables"))%>%rename(Diplome = diplome, Taux_emploi_stables = emplois_stables)
        
        mode(diplome.lp$Taux_emploi_stables) <- "numeric"
        mode(diplome.DUT$Taux_emploi_stables) <- "numeric"
        mode(diplome.master$Taux_emploi_stables) <- "numeric"
        
        taux.emploi.stables.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.emploi.stables.df, aes(x = Diplome, y = Taux_emploi_stables, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'emplois stables")
    })
    
    output$taux_demplois_stables_par_domaine_histo <- renderPlot({
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        taux.emploi.stables.median.dut <- median(as.numeric(diplome.DUT$Part.des.emplois.stables), na.rm = TRUE)
        taux.emploi.stables.median.lp <- median(as.numeric(diplome.lp$X..emplois.stables), na.rm = TRUE)
        taux.emploi.stables.median.master <- median(as.numeric(diplome.master$emplois_stables), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Emplois_stables = c(taux.emploi.stables.median.dut, taux.emploi.stables.median.lp, taux.emploi.stables.median.master))
        
        ggplot(type.de.diplomes, aes(y=Emplois_stables,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplômes", y ="Médianes de taux d'emplois stables de chaque domaine")
        
    })
    
    output$taux_demplois_temps_plein_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, Taux_emploi_temps_plein = X..emplois.à.temps.plein)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, Taux_emploi_temps_plein = Part.des.emplois.à.temps.plein)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "emplois_a_temps_plein"))%>%rename(Diplome = diplome, Taux_emploi_temps_plein = emplois_a_temps_plein)
        
        mode(diplome.lp$Taux_emploi_temps_plein) <- "numeric"
        mode(diplome.DUT$Taux_emploi_temps_plein) <- "numeric"
        mode(diplome.master$Taux_emploi_temps_plein) <- "numeric"
        
        taux.emploi.temps.plein.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.emploi.temps.plein.df, aes(x = Diplome, y = Taux_emploi_temps_plein, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Taux d'emplois à temps plein")
    
    })
    
    output$taux_demplois_temps_plein_par_domaine_histo <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        taux.emploi.temps.plein.median.dut <- median(as.numeric(diplome.DUT$Part.des.emplois.à.temps.plein), na.rm = TRUE)
        taux.emploi.temps.plein.median.lp <- median(as.numeric(diplome.lp$X..emplois.à.temps.plein), na.rm = TRUE)
        taux.emploi.temps.plein.median.master <- median(as.numeric(diplome.master$emplois_a_temps_plein), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Emplois_temps_plein = c(taux.emploi.temps.plein.median.dut, taux.emploi.temps.plein.median.lp, taux.emploi.temps.plein.median.master))
        
        ggplot(type.de.diplomes, aes(y=Emplois_temps_plein,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplômes", y ="Médianes de taux d'emplois à temps plein de chaque domaine")
        
    })
    
    output$salaire_diplomes_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Salaire.net.médian.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, salaire_diplomes = Salaire.net.médian.des.emplois.à.temps.plein)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Salaire.net.mensuel.médian.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, salaire_diplomes = Salaire.net.mensuel.médian.des.emplois.à.temps.plein)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "salaire_net_median_des_emplois_a_temps_plein"))%>%rename(Diplome = diplome, salaire_diplomes = salaire_net_median_des_emplois_a_temps_plein)
        
        mode(diplome.lp$salaire_diplomes) <- "numeric"
        mode(diplome.DUT$salaire_diplomes) <- "numeric"
        mode(diplome.master$salaire_diplomes) <- "numeric"
        
        print(diplome.lp$salaire_diplomes)
        salaire.diplomes.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = salaire.diplomes.df, aes(x = Diplome, y = salaire_diplomes, fill = Diplome)) + geom_violin() + labs(x = "Types de diplômes", y = "Salaire net mensuel médian des emplois à temps plein")
    })
    
    output$salaire_diplomes_par_domaine_histo <- renderPlot({
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        salaire.median.dut <- median(as.numeric(diplome.DUT$Salaire.net.mensuel.médian.des.emplois.à.temps.plein), na.rm = TRUE)
        salaire.median.lp <- median(as.numeric(diplome.lp$Salaire.net.médian.des.emplois.à.temps.plein), na.rm = TRUE)
        salaire.median.master <- median(as.numeric(diplome.master$salaire_net_median_des_emplois_a_temps_plein), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Salaire = c(salaire.median.dut, salaire.median.lp, salaire.median.master))
        
        ggplot(type.de.diplomes, aes(y=Salaire,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplômes", y ="Médianes de salaires des emplois à temps plein de chaque domaine")
        
    })
    

    output$carte_academie <- renderLeaflet({
        
        academie.lp <- diplome.lp()%>%filter(Académie != ""&Annee == input$annees_carto&Domaine == input$discipline_par_ville)%>%group_by(Académie)%>%summarise(Taux_dinsertion = median(as.numeric(Taux.d.insertion), na.rm = TRUE), 
                         Part_femmes = median(as.numeric(X..femmes), na.rm = TRUE), 
                         Taux_demplois_cadre = median(as.numeric(X..emplois.cadre), na.rm = TRUE), 
                         Taux_demplois_stables = median(as.numeric(X..emplois.stables), na.rm = TRUE), 
                         Taux_emploi_temps_plein = median(as.numeric(X..emplois.à.temps.plein), na.rm = TRUE),
                         Salaire_mensuel_median = median(as.numeric(Salaire.net.médian.des.emplois.à.temps.plein), na.rm = TRUE))%>%rename(academie = Académie)
        
        academie.master <- diplome.master()%>%filter(academie != ""&annee == input$annees_carto&domaine == input$discipline_par_ville)%>%group_by(academie)%>%summarise(Taux_dinsertion = median(as.numeric(taux_dinsertion), na.rm = TRUE), 
                         Part_femmes = median(as.numeric(femmes), na.rm = TRUE), 
                         Taux_demplois_cadre = median(as.numeric(emplois_cadre), na.rm = TRUE), 
                         Taux_demplois_stables = median(as.numeric(emplois_stables), na.rm = TRUE), 
                         Taux_emploi_temps_plein = median(as.numeric(emplois_a_temps_plein), na.rm = TRUE),
                         Salaire_mensuel_median = median(as.numeric(salaire_net_median_des_emplois_a_temps_plein), na.rm = TRUE))
        
        if(input$diplome_par_ville == "LP"){
            academie.statistiques <- academie.lp
        }else{
            academie.statistiques <- academie.master
        }
        
        departements <- geojsonio::geojson_read("departements.geojson", what = "sp")
        academie <- c("Amiens","Reims","Normandie","Clermont-Ferrand","Orléans-Tours","Rennes","Besançon","Bordeaux","Lyon","Orléans-Tours","Bordeaux","Nancy-Metz","Normandie","Lille","Clermont-Ferrand","Strasbourg","Strasbourg","Normandie","Dijon","Créteil","Aix-Marseille","Aix-Marseille","Grenoble","Reims","Toulouse","Poitiers","Limoges","Bordeaux","Normandie","Orléans-Tours","Montpellier","Dijon","Amiens","Bordeaux","Lyon","Dijon","Paris","Versailles","Toulouse","Toulouse","Nice","Nantes","Limoges","Nancy-Metz","Versailles","Clermont-Ferrand","Nice","Montpellier","Corse","Rennes","Limoges","Besançon","Rennes","Montpellier","Bordeaux","Orléans-Tours","Grenoble","Reims","Reims","Nancy-Metz","Toulouse","Montpellier","Grenoble","Grenoble","Créteil","Aix-Marseille","Poitiers","Créteil","Lyon","Toulouse","Aix-Marseille","Poitiers","Orléans-Tours","Corse","Dijon","Grenoble","Toulouse","Toulouse","Montpellier","Clermont-Ferrand","Nantes","Toulouse","Nantes","Normandie","Rennes","Lille","Besançon","Nantes","Amiens","Versailles","Versailles","Orléans-Tours","Nantes","Nancy-Metz","Poitiers","Besançon")
        
        departements$academie <- academie
        require(sp)
        ?sp::merge
        academie.dept <- departements%>%merge(academie.statistiques, by = "academie", duplicateGeoms = TRUE)
        
        m <- leaflet(academie.dept)%>%addTiles("MapBox",
                                               options = providerTileOptions(id = "mapbox.light",
                                                                             accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
        
        bins <- c(0, 10, 20, 30, 40, 50, 60,70, 80, 90, 100)
        
        if(input$statistiques_par_ville == "Taux d'insertion"){
            donnees_carte <- academie.dept$Taux_dinsertion
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Part des femmes"){
            donnees_carte <- academie.dept$Part_femmes
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Taux d'emplois cadre"){
            donnees_carte <- academie.dept$Taux_demplois_cadre
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Taux d'emplois stables"){
            donnees_carte <- academie.dept$Taux_demplois_stables
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Taux d'emplois à temps plein"){
            donnees_carte <- academie.dept$Taux_emploi_temps_plein
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Salaires net mensuel médian des emplois à temps plein"){
            donnees_carte <- academie.dept$Salaire_mensuel_median
            bins <- c(1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600)
            string_print <- "<strong>%s</strong><br/>%g euros"
        }
            
        pal <- colorBin("YlOrRd", domain = donnees_carte, bins = bins)
        
        labels <- sprintf(
            string_print,
            academie.dept$nom, donnees_carte
        ) %>% lapply(htmltools::HTML)
        
        m %>% addPolygons(fillColor = ~pal(donnees_carte),
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
                              direction = "auto"))%>% addLegend(pal = pal, values = ~donnees_carte, opacity = 0.7, title = NULL,position = "bottomright")
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)



