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
library(sp)

# L'interface de l'application 
ui <- dashboardPage(
    
    dashboardHeader(title = "Insertion Professionnelle", titleWidth = 250),
    
    # Contenu du Sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Distribution des échantillons", tabName = "diplome", icon = icon("certificate")),
            menuItem("Statistiques par an", tabName = "ans", icon = icon("chart-line")),
            menuItem("Distribution des disciplines", tabName = "domaine", icon = icon("book")),
            menuItem("Statistiques par département", tabName = "academie", icon = icon("university"))
        ),
        width = 250
    ),
    
    # Le corps de l'application 
    dashboardBody(
        tabItems(
            # Premier tabItems "Distribution des échantillons"
            # Dans un premier temps nous vous montrons la distribution de l'ensemble de notre jeu de données en l'illustrant 
            # un histogramme des nombres d'échantillons de chaque diplôme, un bar graph des pourcentages d'échantillons des disciplines dans chaque diplôme 
            # et une cartographie des pourcentages d'échantillons de la discipline et du diplôme choisi dans chaque département
            tabItem(tabName = "diplome",
                    box(width = NULL, 
                        # Le sliderInput filtre les données alimentant les trois graphes au-dessous en fonction de l'année
                        fluidRow(
                            column(2),
                            column(8,
                                   sliderInput(inputId = "annees_par_diplome",
                                               label = "Année",
                                               min = 2013,
                                               max = 2016,
                                               step = 1,
                                               value = 2013,
                                               animate = TRUE))),
                        
                        fluidRow(
                            column(6,
                                   # Le graphe des nombres d'échantillons de chaque diplôme(DUT, Licence professionnel et Master)
                                   plotOutput(outputId = "histo_diplome", height = "450px", brush = "plot_brush")),
                            column(6, 
                                   # Le graphe des pourcentages d'échantillons de chaque discipline dans chaque diplôme(DUT, Licence professionnel et Master)
                                   plotOutput(outputId = "diplome", height="450px", brush = "plot_brush"))),
                        br(),
                        fluidRow(
                            column(2),
                            column(4,
                                   # A cause du manque de données géographiques dans le jeu de données de DUT, 
                                   # nous présentons ici uniquement la cartographie des données de licence professionnelle et de master
                                   radioButtons(inputId = "diplome_par_diplome",
                                                label = "Choisissez un diplôme :",
                                                width = "80%",
                                                list("Licence professionnelle",
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
                                 column(8,
                                        # La cartographie représente des pourcentages d'échantillons de la discipline et du diplôme choisi dans chaque département
                                        leafletOutput("carte_diplome"),
                                        h5("Pourcentages d'échantillons de la discipline et du diplôme choisis dans chaque département", align = "center"))),
                        title = "Distribution des échantillons", solidHeader = TRUE, status = "primary")),
            
            
            # Deuxième tabItems "Distribution des échantillons"
            # Dans cette partie, nous présentons les évolutions des statistiques critiques de chaque diplôme au cours des années (2010 à 2016) 
            # en prenant en compte les médianes, ainsi que les distributions de ces dernières
            tabItem(tabName = "ans", 
                    box(width = NULL,
                        fluidRow(
                            column(4),
                            column(6,
                                   # Le radioButtons filtre les données alimentant les graphes au-dessous en fonction des disciplines
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
                               # Le taux d'insertion (en %) de chaque diplôme
                               tabPanel("Taux d'insertion (en %)", 
                                        plotOutput(outputId = "Taux_insertion_par_an", height="450px")),
                               # Les statistiques des emplois de chaque dipôme : 
                               # le taux d'emplois cadres, le taux d'emplois stables et le taux d'emplois à temps plein (en %)
                               tabPanel("Statistiques des emplois (en %)", 
                                        plotOutput(outputId = "Taux_emploi_cadre_par_an", height="450px"), 
                                        plotOutput(outputId = "Taux_emploi_stable_par_an", height="450px"), 
                                        plotOutput(outputId = "Taux_emploi_temps_plein_par_an", height="450px")),
                               # Les parts des femmes de chaque diplôme :
                               tabPanel("Part des femmes (en %)", 
                                        plotOutput(outputId = "Part_femmes_par_an", height="450px")),
                               # Les salaires nets mensuels médians des emplois à temps plein (en euros) de chaque diplôme 
                               tabPanel("Salaires nets mensuels (en euros)", 
                                        plotOutput(outputId = "Salaire_par_an", height="450px"))
                        ))),
            
            # Troisième tabItem "Distribution des disciplines"
            # Dans cette partie, on vous montre des distributions des statistiques critiques dans chaque discipline et chaque année, ainsi  
            # qu'une comparaison entre les différents diplômes. Un histogramme et un violinplot par statistique illustrent ces distributions
            tabItem(tabName = "domaine", 
                    # Les paramètres
                    box(width = NULL,
                        fluidRow(
                          column(6, 
                                 # Le sliderInput filtre les données alimentant les trois graphes se situant en dessous en fonction de l'année
                                 sliderInput(inputId = "annees_par_domaine",
                                                            label = "Année",
                                                            min = 2013,
                                                            max = 2016,
                                                            step = 1,
                                                            value = 2013,
                                                            width = "80%",
                                                            animate = TRUE)),
                          column(6,
                                 # Le radioButtons filtre les données alimentant les graphes qui se trouvent en dessous en fonction des disciplines
                                 radioButtons(inputId = "discipline_par_domaine", 
                                                      label = "Choisissez une discipline :", 
                                                      width = "80%",
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
                    tabBox(width = 12, id = "tabset_domaines", 
                           tabPanel("Taux d'insertion (en %)", 
                                    fluidRow(
                                        column(6,
                                               # L'histogramme des médianes du taux d'insertion (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_dinsertion_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6, 
                                               # La distribution du taux d'insertion (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_dinsertion_par_domaine", height="450px", brush = "plot_brush")))), 
                           tabPanel("Statistiques des emplois (en %)", 
                                    fluidRow(
                                        column(6,
                                               # L'histogramme des médianes du taux d'emplois cadres (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_demplois_cadres_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6,
                                               # La distribution des taux d'emplois cadres (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_demplois_cadres_par_domaine", height="450px", brush = "plot_brush"))
                                        ), 
                                    fluidRow(
                                        column(6,
                                               # L'histogramme des médianes du taux d'emplois stables (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_demplois_stables_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6,
                                               # La distribution du taux d'emplois cadres (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_demplois_stables_par_domaine", height="450px", brush = "plot_brush"))
                                    ),
                                    fluidRow(
                                        column(6,
                                               # L'histogramme des médianes du taux d'emplois à temps plein (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_demplois_temps_plein_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6,
                                               # La distribution du taux d'emplois à temps plein (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "taux_demplois_temps_plein_par_domaine", height="450px", brush = "plot_brush"))
                                    )), 
                           tabPanel("Part des femmes (en %)", 
                                    fluidRow(
                                        column(6,
                                               # L'histogramme des médianes des parts des femmes de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "part_femmes_par_domaine_histo", height="450px", brush = "plot_brush")),
                                        column(6, 
                                               # La distribution des parts des femmes de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "part_femmes_par_domaine", height="450px", brush = "plot_brush")))), 
                           
                           tabPanel("Salaires nets mensuels (en euros)", 
                                    fluidRow(
                                        column(6, 
                                               # L'histogramme des médianes des salaires net mensuels (en euros) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "salaire_diplomes_par_domaine_histo", height="450px", brush = "plot_brush")), 
                                        column(6, 
                                               # La distribution des salaires nets mensuels (en euros) de chaque diplôme en fonction de l'année et de la discipline choisies
                                               plotOutput(outputId = "salaire_diplomes_par_domaine", height="450px", brush = "plot_brush"))
                                    )
                                    
                                    )
                    ))),
            
            # Quatrième tabItem "Statistiques par ville"
            # Dans cette partie, nous illustrons la distribution des statistiques critiques de chaque département sous forme d'une cartographie 
            # en fonction de l'année, du diplôme, de la discipline et de la statistique choisis
            tabItem(tabName = "academie", 
                    fluidRow(
                        column(5,
                               box(
                                    title = "Paramètres",
                                    width = NULL,
                                    # Le sliderInput filtre les données alimentant les trois graphes se situant en dessous en fonction de l'année
                                    sliderInput(inputId = "annees_carto",
                                                label = "Année",
                                                min = 2013,
                                                max = 2016,
                                                step = 1,
                                                value = 2013,
                                                width = "100%",
                                                animate = TRUE),
                                    # A cause du manque de données géographiques dans le jeu de données de DUT, 
                                    # nous présentons ici uniquement la cartographie des données de licence professionnelle et de master
                                    radioButtons(inputId = "diplome_par_ville",
                                                 label = "Choisissez un diplôme :",
                                                 width = "80%",
                                                 list("Licence professionnelle",
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
                                                 list("Taux d'insertion (en %)",
                                                      "Part des femmes (en %)",
                                                      "Taux d'emplois cadres (en %)",
                                                      "Taux d'emplois stables (en %)",
                                                      "Taux d'emplois à temps plein (en %)",
                                                      "Salaires nets mensuels médians des emplois à temps plein (en euros)"))
                                    )
                               ),
                        column(7,
                               box(
                                 # La cartographie représente la distribution de la statistique critique dans chaque département choisie 
                                 # en fonction de l'année, du diplôme, de la discipline et de la statistique choisis, ici on prend en compte 
                                 #les médianes de cette dernière
                                 leafletOutput("carte_academie"),
                                 width = NULL, title = "Statistiques par département",solidHeader = TRUE, status = "primary"))
                                )
                    )
            
        )))

        

# Serveur de l'application 
server <- function(input, output) {
    
    # Lecture du fichier contenant le jeu de données de licence professionnelle 
    diplome.lp <- reactive({
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', 
                               header = T, 
                               sep = ';', 
                               fill=TRUE, 
                               encoding = "UTF-8")
    })
    
    # Lecture du fichier contenant le jeu de données de DUT
    diplome.DUT <- reactive({
        diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', 
                                header = T, 
                                sep = ';', 
                                fill=TRUE, 
                                encoding = "UTF-8")
    })
    
    # Lecture du fichier contenant le jeu de données de master
    diplome.master <- reactive({
        diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', 
                                   header = T, 
                                   sep = ';', 
                                   fill=TRUE, 
                                   encoding = "UTF-8")
    })
    
    #############################################################################################################################################
    # Premier tabItem "Distribution des échantillons"
    # L'histogramme du nombre d'échantillons de chaque diplôme en fonction de l'année choisie 
    output$histo_diplome <- renderPlot({
      diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_diplome)
      diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_diplome)
      diplome.master <- diplome.master()%>%filter(annee == input$annees_par_diplome)
      
      nbr.echanti.dut <- sum(diplome.DUT$Nombre.de.réponses)
      nbr.echanti.lp <- sum(diplome.lp$Nombre.de.réponses)
      nbr.echanti.master <- sum(diplome.master$nombre_de_reponses)   
      
      type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                     Nombre = c(nbr.echanti.dut, nbr.echanti.lp, nbr.echanti.master))
      
      ggplot(type.de.diplomes, aes(y=Nombre,x =Diplome)) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(title= "Nombre d'échantillons de chaque diplôme en fonction de l'année choisie", x= "Diplômes", y = "Nombre d'échantillons de chaque diplôme")
    })
    
    # Le bar graph représente les pourcentages de chaque discipline dans chaque diplôme 
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
                   x =Diplome )) +geom_bar(position="fill", stat="identity") + labs(title = "Pourcentages de chaque discipline dans chaque diplôme", x= "Diplômes", y = "Pourcentage de chaque discipline")
        
    })
    
    # La cartographie représente des pourcentages d'échantillons de la discipline et du diplôme chosisis dans chaque département
    output$carte_diplome <- renderLeaflet({
        
        nbr.lp <- diplome.lp()%>%filter(Académie != ""&Annee == input$annees_par_diplome)%>%subset(select = c("Académie", "Domaine", "Nombre.de.réponses"))
        nbr.regroupe.lp <- nbr.lp%>%group_by(Académie, Domaine)%>%summarise(Pourcentage = sum(Nombre.de.réponses, na.rm = TRUE))%>%rename(academie = Académie)%>%mutate(Pourcentage = Pourcentage*100/sum(Pourcentage)) 
        
        nbr.master <- diplome.master()%>%filter(academie != ""&annee == input$annees_par_diplome)%>%subset(select = c("academie", "domaine", "nombre_de_reponses"))
        nbr.regroupe.master <- nbr.master%>%group_by(academie, domaine)%>%summarise(Pourcentage = sum(nombre_de_reponses, na.rm = TRUE))%>%rename(Domaine = domaine)%>%mutate(Pourcentage = Pourcentage*100/sum(Pourcentage)) 
        
        
        if(input$diplome_par_diplome == "Licence professionnel"){
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
    
    #############################################################################################################################################
    # Deuxième tabItem "Statistiques par an"
    # La tendance et la distribution du taux d'insertion (en %) de chaque diplôme au cours des années en fonction de la discipline choisie 
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
            labs(x = "Années", y = "Taux d'insertion (en %)")
        
    })
    
    # La tendance et la distribution des taux d'emplois cadres de chaque diplôme au cours des années en fonction de la discipline choisie 
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
            labs(x = "Années", y = "Taux d'emplois cadres (en %)")
    })
    
    # La tendance et la distribution du taux d'emplois stables (en %) de chaque diplôme au cours des années en fonction de la discipline choisie 
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
            labs(x = "Années", y = "Taux d'emplois stables (en %)")
    })
    
    # La tendance et la distribution du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années en fonction de la discipline choisie 
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
            labs(x = "Années", y = "Taux d'emplois à temps plein (en %)")
    })
    
    # La tendance et la distribution des parts de femmes (en %) de chaque diplôme au cours des années en fonction de la discipline choisie 
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
        labs(x = "Années", y = "Part des femmes (en %)")
    })
    
    # La tendance et la distribution des salaires nets mensuels (en euros) de chaque diplôme au cours des années en fonction de la discipline choisie 
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
            labs(x = "Années", y = "Salaires (en euros) de chaque diplôme")
    })
    
    #############################################################################################################################################
    # Troisième tabItem "Distribution des disciplines"
    # L'histogramme des médianes du taux d'insertion (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_dinsertion_par_domaine_histo <- renderPlot({
      
      diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
      
      taux.insert.median.dut <- median(as.numeric(diplome.DUT$Taux.d.insertion), na.rm = TRUE)
      taux.insert.median.lp <- median(as.numeric(diplome.lp$Taux.d.insertion), na.rm = TRUE)
      taux.insert.median.master <- median(as.numeric(diplome.DUT$Taux.d.insertion), na.rm = TRUE)  
      
      type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                     Taux.insert = c(taux.insert.median.dut, taux.insert.median.lp, taux.insert.median.master))
      
      ggplot(type.de.diplomes, aes(y=Taux.insert,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplôme", y ="Médianes du taux d'insertion (en %) de chaque domaine")
      
    })
    
    # Le violinPlot du taux d'insertion (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_dinsertion_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Taux.d.insertion"))%>%rename(Diplome = Diplôme, Taux_Insertion = Taux.d.insertion)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Taux.d.insertion"))%>%rename(Diplome = Diplôme, Taux_Insertion = Taux.d.insertion)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "taux_dinsertion"))%>%rename(Diplome = diplome, Taux_Insertion = taux_dinsertion)
        
        mode(diplome.lp$Taux_Insertion) <- "numeric"
        mode(diplome.DUT$Taux_Insertion) <- "numeric"
        mode(diplome.master$Taux_Insertion) <- "numeric"
        
        taux.insert.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.insert.df, aes(x = Diplome, y = Taux_Insertion, fill = Diplome)) + geom_violin() + labs(x = "Types de diplôme", y = "Taux d'insertion (en %)")
        
    })
    
    # L'histogramme du taux d'emplois cadres (en %) de chaque diplôme en fonction de l'année et de la discipline choisies 
    output$taux_demplois_cadres_par_domaine_histo <- renderPlot({
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        taux.emploi.cadre.median.dut <- median(as.numeric(diplome.DUT$Part.des.emplois.de.niveau.cadre), na.rm = TRUE)
        taux.emploi.cadre.median.lp <- median(as.numeric(diplome.lp$X..emplois.cadre), na.rm = TRUE)
        taux.emploi.cadre.median.master <- median(as.numeric(diplome.master$emplois_cadre), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Taux_emplois_cadre = c(taux.emploi.cadre.median.dut, taux.emploi.cadre.median.lp, taux.emploi.cadre.median.master))
        
        ggplot(type.de.diplomes, aes(y=Taux_emplois_cadre,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplôme", y ="Médianes du taux d'emplois cadre (en %) de chaque domaine")
        
    })
    
    # Le violinPlot du taux d'emplois cadres (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_demplois_cadres_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..emplois.cadre"))%>%rename(Diplome = Diplôme, Taux_emplois_cadre = X..emplois.cadre)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.emplois.de.niveau.cadre"))%>%rename(Diplome = Diplôme, Taux_emplois_cadre = Part.des.emplois.de.niveau.cadre)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "emplois_cadre"))%>%rename(Diplome = diplome, Taux_emplois_cadre = emplois_cadre)
        
        mode(diplome.lp$Taux_emplois_cadre) <- "numeric"
        mode(diplome.DUT$Taux_emplois_cadre) <- "numeric"
        mode(diplome.master$Taux_emplois_cadre) <- "numeric"
        
       
        taux.emploi.cadre.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.emploi.cadre.df, aes(x = Diplome, y = Taux_emplois_cadre, fill = Diplome)) + geom_violin() + labs(x = "Types de diplôme", y = "Taux d'emplois cadres (en %)")
    })
    
    # L'histogramme du taux d'emplois stables (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_demplois_stables_par_domaine_histo <- renderPlot({
      diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
      
      taux.emploi.stables.median.dut <- median(as.numeric(diplome.DUT$Part.des.emplois.stables), na.rm = TRUE)
      taux.emploi.stables.median.lp <- median(as.numeric(diplome.lp$X..emplois.stables), na.rm = TRUE)
      taux.emploi.stables.median.master <- median(as.numeric(diplome.master$emplois_stables), na.rm = TRUE)  
      
      type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                     Emplois_stables = c(taux.emploi.stables.median.dut, taux.emploi.stables.median.lp, taux.emploi.stables.median.master))
      
      ggplot(type.de.diplomes, aes(y=Emplois_stables,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplôme", y ="Médianes du taux d'emplois stables (en %) de chaque domaine")
      
    })
    
    # Le violinPlot du taux d'emplois stables (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_demplois_stables_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..emplois.stables"))%>%rename(Diplome = Diplôme, Taux_emploi_stables = X..emplois.stables)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.emplois.stables"))%>%rename(Diplome = Diplôme, Taux_emploi_stables = Part.des.emplois.stables)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "emplois_stables"))%>%rename(Diplome = diplome, Taux_emploi_stables = emplois_stables)
        
        mode(diplome.lp$Taux_emploi_stables) <- "numeric"
        mode(diplome.DUT$Taux_emploi_stables) <- "numeric"
        mode(diplome.master$Taux_emploi_stables) <- "numeric"
        
        taux.emploi.stables.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.emploi.stables.df, aes(x = Diplome, y = Taux_emploi_stables, fill = Diplome)) + geom_violin() + labs(x = "Types de diplôme", y = "Taux d'emplois stables (en %)")
    })
    
    # L'histogramme du taux d'emplois à temps plein (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_demplois_temps_plein_par_domaine_histo <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
        
        taux.emploi.temps.plein.median.dut <- median(as.numeric(diplome.DUT$Part.des.emplois.à.temps.plein), na.rm = TRUE)
        taux.emploi.temps.plein.median.lp <- median(as.numeric(diplome.lp$X..emplois.à.temps.plein), na.rm = TRUE)
        taux.emploi.temps.plein.median.master <- median(as.numeric(diplome.master$emplois_a_temps_plein), na.rm = TRUE)  
        
        type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                       Emplois_temps_plein = c(taux.emploi.temps.plein.median.dut, taux.emploi.temps.plein.median.lp, taux.emploi.temps.plein.median.master))
        
        ggplot(type.de.diplomes, aes(y=Emplois_temps_plein,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplôme", y ="Médianes du taux d'emplois à temps plein (en %) de chaque domaine")
        
    })
    
    # Le violinPlot du taux d'emplois à temps plein (en %) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$taux_demplois_temps_plein_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, Taux_emploi_temps_plein = X..emplois.à.temps.plein)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, Taux_emploi_temps_plein = Part.des.emplois.à.temps.plein)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "emplois_a_temps_plein"))%>%rename(Diplome = diplome, Taux_emploi_temps_plein = emplois_a_temps_plein)
        
        mode(diplome.lp$Taux_emploi_temps_plein) <- "numeric"
        mode(diplome.DUT$Taux_emploi_temps_plein) <- "numeric"
        mode(diplome.master$Taux_emploi_temps_plein) <- "numeric"
        
        taux.emploi.temps.plein.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = taux.emploi.temps.plein.df, aes(x = Diplome, y = Taux_emploi_temps_plein, fill = Diplome)) + geom_violin() + labs(x = "Types de diplôme", y = "Taux d'emplois à temps plein (en %)")
    
    })
    
    # L'histogramme des parts de femmes de chaque diplôme en fonction de l'année et de la discipline choisies
    output$part_femmes_par_domaine_histo <- renderPlot({
      diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
      
      part.femmes.median.dut <- median(as.numeric(diplome.DUT$Part.des.femmes), na.rm = TRUE)
      part.femmes.median.lp <- median(as.numeric(diplome.lp$X..femmes), na.rm = TRUE)
      part.femmes.median.master <- median(as.numeric(diplome.master$femmes), na.rm = TRUE)  
      
      type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                     Part_femmes = c(part.femmes.median.dut, part.femmes.median.lp, part.femmes.median.master))
      
      ggplot(type.de.diplomes, aes(y=Part_femmes,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplôme", y ="Médianes de la part des femmes (en %) de chaque domaine")
      
    })
    
    # Le violinPlot des parts des femmes de chaque diplôme en fonction de l'année et de la discipline choisies
    output$part_femmes_par_domaine <- renderPlot({
      
      diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "X..femmes"))%>%rename(Diplome = Diplôme, Part_femmes = X..femmes)
      diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Part.des.femmes"))%>%rename(Diplome = Diplôme, Part_femmes = Part.des.femmes)
      diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "femmes"))%>%rename(Diplome = diplome, Part_femmes = femmes)
      
      mode(diplome.lp$Part_femmes) <- "numeric"
      mode(diplome.DUT$Part_femmes) <- "numeric"
      mode(diplome.master$Part_femmes) <- "numeric"
      
      part.femme.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
      
      part.femme.graphe <- ggplot(data = part.femme.df, aes(x = Diplome, y = Part_femmes, fill = Diplome)) + geom_violin() + labs(x = "Types de diplôme", y = "Part des femmes (en %)")
    })
    
    # L'histogramme des salaires nets mensuels (en euros) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$salaire_diplomes_par_domaine_histo <- renderPlot({
      diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)
      diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)
      
      salaire.median.dut <- median(as.numeric(diplome.DUT$Salaire.net.mensuel.médian.des.emplois.à.temps.plein), na.rm = TRUE)
      salaire.median.lp <- median(as.numeric(diplome.lp$Salaire.net.médian.des.emplois.à.temps.plein), na.rm = TRUE)
      salaire.median.master <- median(as.numeric(diplome.master$salaire_net_median_des_emplois_a_temps_plein), na.rm = TRUE)  
      
      type.de.diplomes <- data.frame(Diplome = c("DUT", "LP", "Master"),
                                     Salaire = c(salaire.median.dut, salaire.median.lp, salaire.median.master))
      
      ggplot(type.de.diplomes, aes(y=Salaire,x =Diplome )) +geom_bar(stat="identity", fill="lightblue", colour="black")  + labs(x = "Types de diplôme", y ="Médianes des salaires des emplois à temps plein (en euros) de chaque domaine")
    })
    
    # Le violinPlot des salaires nets mensuels (en euros) de chaque diplôme en fonction de l'année et de la discipline choisies
    output$salaire_diplomes_par_domaine <- renderPlot({
        
        diplome.lp <- diplome.lp()%>%filter(Annee == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Salaire.net.médian.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, salaire_diplomes = Salaire.net.médian.des.emplois.à.temps.plein)
        diplome.DUT <- diplome.DUT()%>%filter(Année == input$annees_par_domaine&Domaine == input$discipline_par_domaine)%>%subset(select = c("Diplôme", "Salaire.net.mensuel.médian.des.emplois.à.temps.plein"))%>%rename(Diplome = Diplôme, salaire_diplomes = Salaire.net.mensuel.médian.des.emplois.à.temps.plein)
        diplome.master <- diplome.master()%>%filter(annee == input$annees_par_domaine&domaine == input$discipline_par_domaine)%>%subset(select = c("diplome", "salaire_net_median_des_emplois_a_temps_plein"))%>%rename(Diplome = diplome, salaire_diplomes = salaire_net_median_des_emplois_a_temps_plein)
        
        mode(diplome.lp$salaire_diplomes) <- "numeric"
        mode(diplome.DUT$salaire_diplomes) <- "numeric"
        mode(diplome.master$salaire_diplomes) <- "numeric"
        
        salaire.diplomes.df <- bind_rows(diplome.DUT, diplome.lp, diplome.master)
        
        ggplot(data = salaire.diplomes.df, aes(x = Diplome, y = salaire_diplomes, fill = Diplome)) + geom_violin() + labs(x = "Types de diplôme", y = "Salaire net mensuel médian des emplois à temps plein (en euros)")
    })
    
    # La cartographie représente les statistiques par département en fonction de l'année, du diplôme, de la discipline et de la statistique choisis
    # ici on prend en compte des médianes des statistiques de chaque département 
    output$carte_academie <- renderLeaflet({
        
        if(input$diplome_par_ville == "Licence professionnelle"){
            academie.statistiques <- diplome.lp()%>%filter(Académie != ""&Annee == input$annees_carto&Domaine == input$discipline_par_ville)%>%group_by(Académie)%>%summarise(Taux_dinsertion = median(as.numeric(Taux.d.insertion), na.rm = TRUE), 
                                     Part_femmes = median(as.numeric(X..femmes), na.rm = TRUE), 
                                     Taux_demplois_cadre = median(as.numeric(X..emplois.cadre), na.rm = TRUE), 
                                     Taux_demplois_stables = median(as.numeric(X..emplois.stables), na.rm = TRUE), 
                                     Taux_emploi_temps_plein = median(as.numeric(X..emplois.à.temps.plein), na.rm = TRUE),
                                     Salaire_mensuel_median = median(as.numeric(Salaire.net.médian.des.emplois.à.temps.plein), na.rm = TRUE))%>%rename(academie = Académie)
        }else{
            academie.statistiques <- diplome.master()%>%filter(academie != ""&annee == input$annees_carto&domaine == input$discipline_par_ville)%>%group_by(academie)%>%summarise(Taux_dinsertion = median(as.numeric(taux_dinsertion), na.rm = TRUE), 
                                     Part_femmes = median(as.numeric(femmes), na.rm = TRUE), 
                                     Taux_demplois_cadre = median(as.numeric(emplois_cadre), na.rm = TRUE), 
                                     Taux_demplois_stables = median(as.numeric(emplois_stables), na.rm = TRUE), 
                                     Taux_emploi_temps_plein = median(as.numeric(emplois_a_temps_plein), na.rm = TRUE),
                                     Salaire_mensuel_median = median(as.numeric(salaire_net_median_des_emplois_a_temps_plein), na.rm = TRUE))
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
        
        if(input$statistiques_par_ville == "Taux d'insertion (en %)"){
            donnees_carte <- academie.dept$Taux_dinsertion
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Part de femmes (en %)"){
            donnees_carte <- academie.dept$Part_femmes
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Taux d'emplois cadres (en %)"){
            donnees_carte <- academie.dept$Taux_demplois_cadre
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Taux d'emplois stables (en %)"){
            donnees_carte <- academie.dept$Taux_demplois_stables
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Taux d'emplois à temps plein (en %)"){
            donnees_carte <- academie.dept$Taux_emploi_temps_plein
            string_print <- "<strong>%s</strong><br/>%g%%"
        }else if(input$statistiques_par_ville == "Salaires nets mensuels médians des emplois à temps plein (en euros)"){
            donnees_carte <- academie.dept$Salaire_mensuel_median
            bins <- c(1200, 1400, 1600, 1800, 2000, 2200, 2400)
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



