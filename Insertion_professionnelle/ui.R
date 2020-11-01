#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
    
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
                        collapsible = TRUE,
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
                        collapsible = TRUE,
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
            
        ))))
