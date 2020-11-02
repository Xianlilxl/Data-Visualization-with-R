# Introduction
  
Dans le cadre du module "*R et Data Visualization*" (**DSIA-4101C**), nous avons eu l'opportunité de réutiliser les notions de R vues dans le cours pour produire un rapport d'étude sur un sujet de notre choix, en répondant à une problématique. Le travail est réalisé en binôme et l'objectif est de produire un dashboard R Shiny d'un jeu de données accessibles publiquement et non modifiées.  

Notre responsable est Monsieur **COURIVAUD Daniel**, et notre binôme est composé de Mademoiselle **Andrianihary RAZAFINDRAMISA** et de Mademoiselle **Xianli LI**.
  
Nous avons choisi de travailler sur les jeux de données :
- *[Insertion professionnelle des diplômé.e.s de Diplôme universitaire de technologie (DUT) en universités et établissements assimilés - données nationales par disciplines détaillées](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-diplome-universitaire-de-technologie-dut-en-universites-et-etablissements-assimiles-donnees-nationales-par-disciplines-detaillees/#_)*
  > *source: data.gouv.fr*
- *[Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-licence-professionnelle-en-universites-et-etablissements-assimiles/#_)*
  > *source: data.gouv.fr*
- *[Insertion professionnelle des diplômés de Master en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimil-0/#_)*
  > *source: data.gouv.fr*

#### Problématique
Nous avons choisi de répondre à la problématique : <ins>*Le choix des diplômes et le nombre d'années d'étude sont-ils primordiaux pour l'insertion professionnelle ?*</ins>

<br>

___

# Table des matières

[[_TOC_]]
___


# I. Guide de l'utilisateur

## 1. Installation et Téléchargement

### A. Environnement de travail
Dans un premier temps, afin d'exploiter notre projet, il faudra télécharger et installer le langage de base ***R version 3.5.X*** sur votre appareil. Pour cela, que votre appareil soit sous Linux, macOS, Windows ou autre, vous pouvez accéder à la page de téléchargement de R en cliquant [ici](https://cran.r-project.org/bin/). Nous recommandons fortement ***R Studio Desktop***, un puissant IDE open source pour R, comme environnement de développement. Choisissez la licence Open Source gratuite qui se trouve [ici](https://rstudio.com/products/rstudio/download/). 

Après l'installation, vérifiez le fonctionnement sur votre appareil en créant un répertoire de travail et en installant des packages à partir des lignes de commande R suivantes :

```bash
> install.packages("tidyverse")
```

```bash
> install.packages("devtools")
```

Des warnings peuvent apparaître dans les messages du log, mais ils ne vont pas bloquer l'exécution généralement. Si la dernière version de R est installée, l'installation du package donnera un message de réussite :

```bash
package ‘tidyverse’ successfully unpacked and MD5 sums checked
```

et l'importation des packages est possible :

```bash
> library(ggplot2)
```

Sinon, vérifiez la version de R avec la commande suivante :

```bash
> version
```

et, s'il le faut, mettez R à jour avec les commandes suivantes :

```bash
> install.packages("installr")
> library(installr)
> updateR()
```

### B. Le dashboard

#### Télécharger le projet

Le projet se trouve sur un dépôt Git se situant sur [cette page](https://git.esiee.fr/lix/projet-r). Ce dépôt pourra être "*cloné*" dans un répertoire de travail que vous avez créé sur votre ordinateur.

#### Packages nécessaires

Des packages supplémentaires sont nécessaires au bon fonctionnement de notre projet.

```bash
library(shiny)
```

Shiny permet de créer facilement des applications Web interactives avec R. 

```bash
library(dplyr)
```

Dplyr est conçu pour importer et manipuler des données dans R.

```bash
library(ggplot2)
```

Ggplot2 est un système de création graphique déclarative.

```bash
library(shinydashboard)
```

Shinydashboard permet de créer des tableaux de bord avec "Shiny".

```bash
library(leaflet)
```

Leaflet permet de créer, de personnaliser et d'utiliser des cartes interactives à l'aide de la bibliothèque interactive JavaScript 'Leaflet' et du package 'htmlwidgets'.

```bash
library(sp)
```

Sp fournit des fonctions pour le traçage des données sous forme de cartes, et pour la récupération des coordonnées.

On peut utiliser la commande vue précedemment pour les télécharger et les installer :

```bash
> install.packages("package")
```

où "package" est le nom du package à installer.

## 2. Exécution

Commencez par ouvrir le projet se trouvant dans le répertoire de travail en suivant File > Open Project..., quel que soit le système d'exploitation, puis utilisez la commande suivante afin de lancer l'application :

```bash
> runApp('Dashboard')
```

Vous pouvez également exécuter l'application en cliquant sur le bouton 'Run App'.

## 3. Utilisation

Une fois éxécuté, le "*dashboard*" est accessible à une adresse donnée comme suit :

```bash
Listening on http://127.0.0.1:7216
```

Ou à cette adresse : https://xianli.shinyapps.io/Insertion_professionnelle/.

### A. Menu

Un menu permet d'accéder aux différentes pages de notre application :

![menu.PNG](images/menu.PNG)

Il y a quatre pages :
- *Distribution des échantillons*,
- *Statistiques par an*,
- *Distribution des disciplines*,
- et *Statistiques par département*.
Ces pages sont accessibles en cliquant sur leur label, dans le menu à gauche.

### B. *Distribution des échantillons*

Une fois l'installation et l'exécution réussies, l'application s'ouvre sur la page suivante:  

![dde.PNG](images/dde.PNG)

- #### Première partie

![dde_1.PNG](images/dde_1.PNG)

La partie supérieure de la page affiche un histogramme du nombre d'échantillons de chaque diplôme, et un diagramme à bandes du pourcentage de chaque discipline, dans chaque diplôme, en fonction de l'année que l'on choisit avec le "*slider*" situé au-dessus des graphes. En plus de définir une année, le slider permet également de les faire défiler. Cela permet de voir la progression et la distribution du nombre d'échantillons et du pourcentage de chaque discipline au cours des années. 

- #### Seconde partie

![dde_2.PNG](images/dde_2.PNG)

La partie inférieure de la page affiche une carte des départements de la France métropolitaine. On peut intéragir avec cette dernière grâce à des "*radio buttons*", situés au-dessus de la carte. Ils permettent de choisir une discipline et un diplôme afin d'afficher sur la carte les pourcentages d'échantillons de la discipline et du diplôme choisis avec le nom de chaque département. Cela permet d'avoir plus d'informations sur un département spécifique grâce à une représentation géolocalisée des échantillons. De plus, cela permet de comparer un département, une région ou une académie par rapport à d'autres.

### C. *Statistiques par an*

![spa.PNG](images/spa.PNG)

- #### Paramètres

![spa_param.PNG](images/spa_param.PNG)

Ce bloc permet de contrôler les différents graphes présents dans le bloc inférieur, en modifiant la *discipline*.

- #### Evolution du taux d'insertion au cours du temps

![spa_ti.PNG](images/spa_ti.PNG)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'insertion (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'insertion (en %).

- #### Evolution des statistiques des emplois au cours du temps 

![spa_se_1.PNG](images/spa_se_1.PNG)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'emplois cadres (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'emplois cadres (en %).

![spa_se_2.PNG](images/spa_se_2.PNG)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'emplois stables (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'emplois stables (en %).

![spa_se_3.PNG](images/spa_se_3.PNG)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'emplois à temps plein (en %).

- #### Evolution de la part des femmes au cours du temps

![spa_pf.PNG](images/spa_pf.PNG)

Ce graphe montre l'évolution de la tendance et de la distribution de la part des femmes (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée la part des femmes (en %).

- #### Evolution des salaires nets mensuels au cours du temps

![spa_snm.PNG](images/spa_snm.PNG)

Ce graphe montre l'évolution de la tendance et de la distribution des salaires nets mensuels (en euros) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée les salaires nets mensuels (en euros).

### D. *Distribution des disciplines*

![ddd.PNG](images/ddd.PNG)

- #### Paramètres

![ddd_param.PNG](images/ddd_param.PNG)

Ce bloc permet de contrôler les différents graphes présents dans le bloc inférieur, en modifiant l'*année* avec un slider et en modifiant la *discipline* avec des radio buttons.

- #### Evolution du taux d'insertion au cours du temps

![ddd_ti.PNG](images/ddd_ti.PNG)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'insertion (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'insertion (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'insertion (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'insertion (en %) de chaque diplôme. 

- #### Evolution des statistiques des emplois au cours du temps 

![ddd_se_1.PNG](images/ddd_se_1.PNG)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'emplois cadres (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'emplois cadres (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'emplois cadres (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'emplois cadres (en %) de chaque diplôme.

![ddd_se_2.PNG](images/ddd_se_2.PNG)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'emplois stables (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'emplois stables (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'emplois stables (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'emplois stables (en %) de chaque diplôme.

![ddd_se_3.PNG](images/ddd_se_3.PNG)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'emplois à temps plein (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'emplois à temps plein (en %) de chaque diplôme.

- #### Evolution de la part des femmes au cours du temps

![ddd_pf.PNG](images/ddd_pf.PNG)

L'histogramme permet de voir la progression et la distribution des médianes de la part des femmes (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes de la part des femmes (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique de la part des femmes (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée la part des femmes (en %) de chaque diplôme.

- #### Evolution des salaires nets mensuels au cours du temps

![ddd_snm.PNG](images/ddd_snm.PNG)

L'histogramme permet de voir la progression et la distribution des médianes des salaires nets mensuels (en euros) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes des salaires nets mensuels (en euros) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique des salaires nets mensuels (en euros) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée les salaires nets mensuels (en euros) de chaque diplôme.

### E. *Statistiques par département*

![spd.PNG](images/spd.PNG)

Seuls les jeux de données *[Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-licence-professionnelle-en-universites-et-etablissements-assimiles/#_)* et *[Insertion professionnelle des diplômés de Master en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimil-0/#_)* sont utilisés sur cette page.

- #### Paramètres

![spd_param.PNG](images/spd_param.PNG)

La partie gauche de la page présente les paramètres permettant d'intéragir avec la carte. Le "*slider*" permet de choisir une année ou de faire défiler les années, et les "*radio buttons*" permettent de choisir un diplôme, une discipline et une statistique. 

- #### Partie principale

![spd_1.PNG](images/spd_1.PNG)

La partie droite de la page affiche une carte des départements de la France métropolitaine. On peut intéragir avec cette dernière grâce aux paramètres, situé à gauche de la carte. Ils permettent de choisir une discipline, un diplôme et une statistique afin d'afficher sur la carte le nom de chaque département avec les valeurs de la statistique choisie en fonction de la discipline et du diplôme choisis. Cela permet d'avoir plus d'informations sur un département spécifique grâce à une représentation géolocalisée des statistiques. De plus, cela permet de comparer un département, une région ou une académie par rapport à d'autres.
Pour pouvoir représenter les statistiques de chaque département sur la carte, nous avons décidé de prendre la médiane des données de chaque département étant donné que la taille des données est conséquente. Nous avons choisi la médiane, plutôt que la moyenne, car celle-ci est plus représentative.

# II. Guide développeur

Dans ce Developper Guide, la structure, le code et le rôle des fichiers dans le projet seront expliqués.

## 1. Les répertoires & fichiers

Dans cette partie, on explique le rôle du répertoire et des fichiers.

### A. *images*

Ce répertoire contient les images servant principalement à la rédaction de ce guide.

### B. *Jeux de données*

Voici l'ensemble des jeux de données utilisés pour le projet :

- ***fr-esr-insertion_professionnelle-dut_donnees_nationales.csv*** : le jeu de données sur les diplômes universitaires de technologie, *[Insertion professionnelle des diplômé.e.s de Diplôme universitaire de technologie (DUT) en universités et établissements assimilés - données nationales par disciplines détaillées](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-diplome-universitaire-de-technologie-dut-en-universites-et-etablissements-assimiles-donnees-nationales-par-disciplines-detaillees/#_)*.

- ***fr-esr-insertion_professionnelle-lp.csv*** : le jeu de données sur les licences professionnelles, *[Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-licence-professionnelle-en-universites-et-etablissements-assimiles/#_)*.

- ***fr-esr-insertion_professionnelle-master.csv*** : le jeu de données sur les masters, *[Insertion professionnelle des diplômés de Master en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimil-0/#_)*.

- ***departements.geojson***: Le jeu de données contenant les délimitations des départements de la France métropolitaine ([source](https://france-geojson.gregoiredavid.fr/)). 

### C. *global.R*

Ce fichier contient le code permettant le traitement des données afin que l'on puisse les utiliser et les lire clairement.

### D. *ui.R*

Ce fichier permet de créer l'interface graphique. 

### E. *server.R*

Ce fichier implimente le traitement dynamique des données en créant une interactivité entre les différents composants de l'application et les jeux de données.

### F. *README.md*

Le présent fichier *Markdown* qui contient:
- la présentation du projet avec la problématique,
- le guide de l'utilisateur avec les instructions d'exécution,
- le guide du développeur,
- et le rapport d'analyse.

## 2. Le code

### A. global.R

#### - Le chargement des données

Dans cette section, on récupère les jeux de données nécessaires au fonctionnement de l'application. Par exemple:

```bash
# Lecture du fichier contenant le jeu de données de licence professionnelle 
    diplome.lp <- reactive({
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', 
                               header = T, 
                               sep = ';', 
                               fill=TRUE, 
                               encoding = "UTF-8")
    })
...
```

Ici on charge le jeux de données *Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés*.

### B. ui.R
Le fichier est structuré de la manière suivante:



#### - Les *packages*

Dans cette section, on charge les packages nécessaires pour le bon fonctionnement de l'application. 

```bash
library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(leaflet)
library(sp)
```

#### - La création de l'interface de l'application

Dans cette section, on crée l'interface de l'application en définissant le contenu du menu et du corps de l'application. 

##### a. Menu

```bash
...
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
...
```

Ici on crée le menu en créant un label et en donnant une icône.

##### b. Corps de l'application

On crée le corps de l'application en définissant les différents éléments de chaque onglet. Par exemple :

```bash
...
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
...
```

Ici, on crée les éléments de l'onglet "Statistiques par an" tels que les "radio buttons" dans le bloc paramètres et les différents onglets pour afficher les graphes.

### C. server.R

Le fichier est structuré de la manière suivante:



#### - Les *packages*

Dans cette section, on charge les packages nécessaires pour le bon fonctionnement de l'application. 

```bash
library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(leaflet)
library(sp)
```

#### - Le serveur de l'application

Dans cette section, on implimente le traitement dynamique des données en créant une interactivité entre les différents composants de l'application et les jeux de données. Par exemple :

```bash
        ...
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
```

Ici, on implimente la carte qui va représenter les statistiques par département en fonction de l'année, du diplôme et de la discipline.

# III. Rapport d'analyse

## 1. Les données

On suppose que les données sont traitées.

### A. Insertion professionnelle des diplômé.e.s de Diplôme universitaire de technologie (DUT) en universités et établissements assimilés - données nationales par disciplines détaillées

Ce jeu de données provient de *[data.gouv.fr](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-diplome-universitaire-de-technologie-dut-en-universites-et-etablissements-assimiles-donnees-nationales-par-disciplines-detaillees/#_)*, plus précisément du ministère de l'enseignement supérieur, de la recherche et de l'innovation.
  
On y retrouve le pourcentage de diplômés occupant un emploi, quel qu'il soit, sur l’ensemble des diplômés présents sur le marché du travail. Il est calculé sur le nombre des diplômés de nationalité française, issus de la formation initiale, entrés immédiatement et durablement sur le marché du travail après l’obtention de leur diplôme en 2013. 
Celui-ci est composé de **732 observations** et de **68 variables**.

<br>

### B. Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés

Ce jeu de données provient de *[data.gouv.fr](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-licence-professionnelle-en-universites-et-etablissements-assimiles/#_)*, plus précisément du ministère de l'enseignement supérieur, de la recherche et de l'innovation.
  
Cette enquête a été menée en décembre 2015, 18 et 30 mois après l’obtention de diplôme, auprès des diplômés de Licence professionnelle de la session 2013. On y retrouve le pourcentage de diplômés occupant un emploi, quel qu'il soit, sur l’ensemble des diplômés présents sur le marché du travail. Il est calculé sur le nombre des diplômés de nationalité française, issus de la formation initiale, entrés immédiatement et durablement sur le marché du travail après l’obtention de leur diplôme en 2013. 
Celui-ci est composé de **6038 observations** et de **32 variables**.

<br>

### C. Insertion professionnelle des diplômés de Master en universités et établissements assimilés

Ce jeu de données provient de *[data.gouv.fr](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimil-0/#_)*, plus précisément du ministère de l'enseignement supérieur, de la recherche et de l'innovation.
  
Cette enquête a été menée en décembre 2013, 30 mois après l’obtention de diplôme, auprès de 59 600 diplômés de Master de la session 2011, et en décembre 2012, 30 mois après l’obtention de diplôme, auprès de 47 500 diplômés de Master de la session 2010. 
On y retrouve le pourcentage de diplômés occupant un emploi, quel qu'il soit, sur l’ensemble des diplômés présents sur le marché du travail. Il est calculé sur le nombre des diplômés de nationalité française, issus de la formation initiale, entrés immédiatement et durablement sur le marché du travail après l’obtention de leur diplôme en 2011. 
Celui-ci est composé de **11873 observations** et de **32 variables**.

<br>


## 2. Analyse  
### A. Distribution des échantillons 

![diplome_histo.PNG](images/diplome_histo.PNG)

- #### Histogramme

Dans un premier temps, pour représenter la structure de nos jeux de données, nous avons affiché sur la partie supérieure de la page un histogramme du nombre d'échantillons de chaque diplôme. Au cours des années, la proportion de ces jeux de données ne varient pas énormément, le jeu de données sur les masters est le plus conséquent par rapport à ceux sur les licences professionnelles et les diplômes universitaires de technologie (DUT).

![diplome.PNG](images/diplome.PNG)

- #### Diagramme à bandes

Le diagramme à bandes montre les pourcentages de chaque discipline, dans chaque diplôme, en fonction de l'année que l'on choisit. La proportion de ces derniers reste également stable au cours du temps. La discipline « Science, technologie et santé » représente toujours la majorité des échantillons dans les trois jeux de données. Les disciplines « Droit économie et gestion » et « Sciences humaines et sociales » sont en deuxième et troisième position. La discipline « Lettres, langues, arts » est la plus minoritaire pour tout type de diplôme.

- #### Cartographie

![dde_lp_sts.PNG](images/dde_lp_sts.PNG)

La carte des départements de la France métropolitaine dans la partie inférieure de la page montre les pourcentages d'échantillons de l’année, de la discipline et du diplôme choisis avec le nom de chaque département. Le jeu de données sur les DUT n’ayant pas de données géographiques, nous présentons uniquement la cartographie des données de licences professionnelles et de masters. Comme vu avec le diagramme à bandes, la proportion des différentes disciplines ne se varient pas au cours des années. Pourtant, dans beaucoup de départements, les diplômés de licence professionnelle en « Science, technologie et santé » prennent plus de 50% des échantillons, tout comme ceux de master qui sont légèrement plus nombreux en « Droit économie et gestion ». Au contraire, les diplômés en « Lettres, langues, arts » reste minoritaires pour tout type de diplôme et ne prennent pas plus que 10% dans tous les départements.

### B. Statistiques par an

Dans cette partie, nous présentons les évolutions des statistiques critiques de chaque diplôme au cours des années (2010 à 2016) en prenant en compte les médianes, ainsi que les distributions de ces dernières. 

- #### Analyse temporelle

![spa_sts_ti.PNG](images/spa_sts_ti.PNG)

Les taux d’insertion de toutes les disciplines et de tous les diplômes varient légèrement au cours des années, généralement le taux d’insertion des licences professionnelles est légèrement supérieur à celui des masters et des DUT, qui se trouve en dernière position.

![cadreparan.PNG](images/cadreparan.PNG)

L'évolution de la tendance et de la distribution du taux d'emplois cadres de chaque diplôme reste stable au cours des années. En général, les diplômés en master ont plus de chance d’être recruté en tant que cadre que ceux de DUT et de licence professionnelle.

![stablesparan.PNG](images/stablesparan.PNG)

Ici, un emploi stable signifie à durée indéterminée. La variation des tendances des diplômes master et licence professionnelle d'environs 15 % se retrouve dans tout type de diplôme au cours du temps, surtout en « Sciences humains et sociales ». 

![femmesparan.PNG](images/femmesparan.PNG)

En général, la part des femmes dans les établissements d’IUT varie énormément et diminue au cours du temps contrairement à celle dans les autres établissements, qui est plus stable malgré la tendance légèrement décroissante.

![salairesparan.PNG](images/salairesparan.PNG)

 La tendance et de la distribution des salaires nets mensuels (en euros) de chaque diplôme au cours des années en fonction de la discipline choisie ne varient pas énormément.

- #### Bilan

A partir de toutes ces observations, on constate une décroissance évidente en « Science, technologie et santé » et « Sciences humains et sociales » dans la part des femmes au cours des années qui apparaît dans tout type de diplôme. A part cela, on peut conclure que les statistiques critiques ne varient pas énormément, la différence se situe principalement entre les différents types de diplôme et les disciplines. 

### C. Distributions des disciplines

- #### Analyse temporelle

tauxdinsertdomaine
![tauxdinsertdomaine.PNG](images/tauxdinsertdomaine.PNG)

Lorsque l’on observe les histogrammes, on a l’impression que les médianes du taux d’insertion de chaque diplôme se rapprochent pour toutes les disciplines. Cependant, on constate avec les « violin Plots » que la distribution de diplômés DUT est plus centrée, contrairement à celle des diplômés en licence professionnelle et en master qui a un grand écart entre les valeurs extrêmes dans toutes les disciplines.

![salairesparan.PNG](images/salairesparan.PNG)
|Science, technologie et santé|Droit économie et gestion|Sciences humains et sociales|
| ---------- | :-----------:  | :-----------: |
|![salairesparan.PNG](images/salairesparan.PNG)|![salairesparan.PNG](images/salairesparan.PNG)|![salairesparan.PNG](images/salairesparan.PNG)|

La différence entre les diplômes réside principalement sur le taux d’emplois cadres. Lorsque l’on observe les histogrammes, on remarque que les diplômés en master ont plus de chance d’être recrutés en tant que cadre dans une entreprise, devant les diplômés de licence professionnelle et de DUT. Au niveau des disciplines, chaque année, plus de 50% des diplômés en master « Science, technologie et santé », « Droit économie et gestion » et « Sciences humains et sociales » sont recrutés en tant que cadre, contre moins de 20% des diplômés de licence professionnelle et de DUT. Les diplômés en « Lettres, langues, arts » ont moins de chances de devenir cadre dans une entreprise, contre environ 40% des diplômés de master. Cependant, malgré une médiane élevée pour les diplômés de master, la distribution du taux d'emplois cadres au cours des années reste très dispersée. 

![salairesparan.PNG](images/salairesparan.PNG)

Globalement, les diplômés en licence professionnelle ont plus de chance d’avoir un emploi CDI que ceux diplômés de master et de DUT. Plus de 65% des diplômés en « Science, technologie et santé » ont un emploi stable, 60% des diplômés en « Droit, économie et gestion » et 50% des diplômés en « Science humains et sociales ». 

![salairesparan.PNG](images/salairesparan.PNG)

D’après l’histogramme, le taux d’emplois à temps plein est élevé pour tout type de diplôme et pour toute discipline, mais les diplômés en « Science, technologie et santé », en « Droit, économie et gestion » et en « Science, humaines et sociales » ont plus de chance d’avoir un emploi à temps plein. 

![salairesparan.PNG](images/salairesparan.PNG)

Au niveau des diplômes, la part des femmes en master est la plus élevée sauf en « Droit, économie et gestion », dans laquelle  la part des femmes en licence professionnelle est légèrement plus élevée. La différence évidente entre les différents diplômes se situe dans la discipline « Science, technologie et santé ». De plus, la médiane de la part des femmes dans la discipline « Science, technologie et santé » est la plus basse parmi toutes les disciplines de nos jeux de données : 40%, contre plus de 50% dans les autres disciplines.Cependant, malgré cette différence entre disciplines et types de diplôme, les distributions de ces derniers restent dispersées.

![salairesparan.PNG](images/salairesparan.PNG)

D’après l’histogramme, les diplômés en master gagnent le plus dans toutes les disciplines, devant ceux de licence professionnelle et de DUT. Cependant, on constate une grande disparité des salaires entre diplômés pour les masters, contrairement à ceux de DUT et de licence professionnelle. Au niveau des disciplines, ceux qui choisissent « Science, technologie et santé » gagnent le plus, suivis de « Droit, économie et gestion » et de « Sciences humaines et sociales ».
<br>

- #### Bilan

En combinant nos jeux de données, on a découvert que les diplômés en master toutes disciplines confondues ont plus de chance d’avoir un emploi CDI à temps plein et d’être cadre avec un meilleur salaire. Cependant, il grande disparité entre ces valeurs. 
Si on se concentre sur les disciplines, on peut conclure que les diplômés en « Science, technologie et santé », ont le plus de chance de trouver un emploi CDI à temps plein et d’être cadre avec un meilleur salaire, suivis par les diplômés en « Droit économie et gestion », en « Sciences humains et sociales » et en « Lettres, langues, arts ». Cependant la part des femmes en “Sciences, technologie et santé” est très basse comparée aux autres disciplines avec une croissance en master au cours des années qui reste insuffisante.

### D. Statistiques par département 

- #### Analyse temporelle

Les taux d’insertion, d’emplois stables et d’emplois à temps plein de tout type de diplôme présentent une homogénéité dans tous les départements, et cela ne  varient pas en fonction des disciplines. 
<br>

La différence des distributions de la part des femmes réside principalement dans les disciplines plutôt que les départements, sauf en « Science humaines et sociales ».
<br>

La part des femmes parmi les diplômés de licence professionnelle du sud et de l’est de la France s’élève à 90%. 
<br>

![ddd_2013_sts_ti.PNG](images/ddd_2013_sts_ti.PNG)

Lorsque l’on observe les histogrammes, on a l’impression que les médianes du taux d’insertion de chaque diplôme se rapprochent pour toutes les disciplines. Cependant, on constate avec les « violin Plots » que la distribution de diplômés DUT est plus centrée, contrairement à celle des diplômés en licence professionnelle et en master qui a un grand écart entre les valeurs extrêmes dans toutes les disciplines.

![ddd_2014_deg_se_2.PNG](images/ddd_2014_deg_se_2.PNG)

La différence entre les diplômes réside principalement sur le taux d’emplois cadres.Lorsque l’on observe les histogrammes, on remarque que les diplômés en master ont plus de chance d’être recrutés en tant que cadre dans une entreprise, devant les diplômés de licence professionnelle et de DUT. Au niveau des disciplines, chaque année, plus de 50% des diplômés en master « Science, technologie et santé », « Droit économie et gestion » et « Sciences humains et sociales » sont recrutés en tant que cadre, contre moins de 20% des diplômés de licence professionnelle et de DUT. Les diplômés en « Lettres, langues, arts » ont moins de chances de devenir cadre dans une entreprise, contre environ 40% des diplômés de master. Cependant, malgré une médiane élevée pour les diplômés de master, la distribution du taux d'emplois cadres au cours des années reste très dispersée. 

Globalement, les diplômés en licence professionnelle ont plus de chance d’avoir un emploi CDI que ceux diplômés de master et de DUT. Plus de 65% des diplômés en « Science, technologie et santé » ont un emploi stable, 60% des diplômés en « Droit, économie et gestion » et 50% des diplômés en « Science humains et sociales ». 

D’après l’histogramme, le taux d’emplois à temps plein est élevé pour tout type de diplôme et pour toute discipline, mais les diplômés en « Science, technologie et santé », en « Droit, économie et gestion » et en « Science, humaines et sociales » ont plus de chance d’avoir un emploi à temps plein. 

![ddd_2015_shs_pf.PNG](images/ddd_2015_shs_pf.PNG)

Au niveau des diplômes, la part des femmes en master est la plus élevée sauf en « Droit, économie et gestion », dans laquelle  la part des femmes en licence professionnelle est légèrement plus élevée. La différence évidente entre les différents diplômes se situe dans la discipline « Science, technologie et santé ». De plus, la médiane de la part des femmes dans la discipline « Science, technologie et santé » est la plus basse parmi toutes les disciplines de nos jeux de données : 40%, contre plus de 50% dans les autres disciplines.Cependant, malgré cette différence entre disciplines et types de diplôme, les distributions de ces derniers restent dispersées.

![ddd_2016_lla_snm.PNG](images/ddd_2016_lla_snm.PNG)

D’après l’histogramme, les diplômés en master gagnent le plus dans toutes les disciplines, devant ceux de licence professionnelle et de DUT. Cependant, on constate une grande disparité des salaires entre diplômés pour les masters, contrairement à ceux de DUT et de licence professionnelle. Au niveau des disciplines, ceux qui choisissent « Science, technologie et santé » gagnent le plus, suivis de « Droit, économie et gestion » et de « Sciences humaines et sociales ».

- #### Bilan

En combinant nos jeux de données, on a découvert que les diplômés en master toutes disciplines confondues ont plus de chance d’avoir un emploi CDI à temps plein et d’être cadre avec un meilleur salaire. Cependant, il grande disparité entre ces valeurs. 
Si on se concentre sur les disciplines, on peut conclure que les diplômés en « Science, technologie et santé », ont le plus de chance de trouver un emploi CDI à temps plein et d’être cadre avec un meilleur salaire, suivis par les diplômés en « Droit économie et gestion », en « Sciences humains et sociales » et en « Lettres, langues, arts ». Cependant la part des femmes en “Sciences, technologie et santé” est très basse comparée aux autres disciplines avec une croissance en master au cours des années qui reste insuffisante.

### D. Statistiques par département


| 2014 | 2015 | 2016 |
|:-----------:|:-----------:|:-----------:|
|![spd_2014_lp_sts_ti](images/spd_2014_lp_sts_ti.PNG)|![spd_2015_deg_tec](images/spd_2014_lp_sts_ti.PNG)|![spd_2016_lp_shs_snm](images/spd_2014_lp_sts_ti.PNG)


Les taux d’insertion, d’emplois stables et d’emplois à temps plein de tout type de diplôme présentent une homogénéité dans tous les départements, et cela ne  varient pas en fonction des disciplines. 
La différence des distributions de la part des femmes réside principalement dans les disciplines plutôt que les départements, sauf en « Science humaines et sociales ».
La part des femmes parmi les diplômés de licence professionnelle du sud et de l’est de la France s’élève à 90%. 
Concernant les taux d’emplois cadres des diplômés de licence professionnelle, ils présentent également une homogénéité dans tous les départements, et ne varient pas en fonction des disciplines. Contrairement aux diplômés de master dont les taux d’emplois cadres sont élevés surtout autour de l’Île-de-France et au sud de la France toutes disciplines confondues. 
En analysant les salaires nets mensuels des diplômés de licence professionnelle, on constate une croissance dans les départements autour de l’Île-de-France dans toutes les disciplines. Quant aux diplômés de master, les salaires nets mensuels sont en général plus élevés comparés aux licences professionnelles. 

- #### Bilan
A partir de toutes ces observations, on conclut que les diplômés en master toutes disciplines confondues ont plus de chance d’avoir un emploi CDI à temps plein et d’être cadre avec un meilleur salaire, de plus on constate une croissance évidente de ces statistiques critiques dans les départements autour de  l’Île-de-France, au sud et à l’est de la France.

## 3. Conclusion

Pour conclure, on peut dire qu’il est plus intéressant d’avoir un master en « Science, technologie et santé » et en « Droit économie et gestion » autour de l’Ile-de-France, au sud et à l’est de la France pour avoir plus facilement un emploi stable à temps plein. 
Les autres diplômes permettent plus facilement d’avoir un emploi à temps plein, mais il est plus difficile d’avoir un emploi en tant que cadre ou bien rémunéré. 
Il ne faut non plus négliger le choix de la discipline. En effet, les disciplines « Science humaines et sociales » et « Lettres, langues, arts » ne permettent pas, par exemple, d’être bien rémunéré ou d’être cadre. 
Ainsi, le choix des diplômes et du nombre d’années d’études sont primordiaux pour l’insertion professionnelle.
