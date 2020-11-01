# Introduction
  
Dans le cadre du module "*R et Data Visualization*" (**DSIA-4101C**), nous avons eu l'opportunité de réutiliser les notions de R vues dans le cours pour produire un rapport d'étude sur un sujet que l'on choisit, en répondant à une problématique. Le travail fut réaliser en binôme et l'objectif fut de produire un dashboard R Shiny d'un jeu de données accessibles publiquement et non modifiées.  

Notre responsable fut **COURIVAUD Daniel**, et notre binôme fut composé de **Andrianihary RAZAFINDRAMISA** et de **Xianli LI**.
  
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


# I. Guide utilisateur

## 1. Installation & Téléchargement

### A. Environnement de travail
Dans un premier temps, afin d'exploiter notre projet, il faudra télécharger et installer le langage de base ***R version 3.5.X*** sur votre appareil. Pour cela, que votre appareil soit sous Linux, macOS, Windows ou autre, vous pouvez trouver la page de téléchargement de R en cliquant [ici](https://cran.r-project.org/bin/). Nous recommandons fortement ***R Studio Desktop***, un puissant IDE open source pour R, comme environnement de développement. Choisissez la licence Open Source gratuite qui se trouve [ici](https://rstudio.com/products/rstudio/download/). 

Après l'installation, vérifiez le fonctionnement sur votre appareil en créant un répertoire de travail et en installant des packages à partir des lignes de commande R suivantes :

```bash
> install.packages("tidyverse")
```

```bash
> install.packages("devtools")
```

Des warnings peuvent apparaître dans les messages du log, mais ils ne sont pas bloquants généralement. Si la dernière version de R est installée, l'installation du package donnera un message de réussite :

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

Le projet se trouve sur un dépôt Git se trouvant sur [cette page](https://git.esiee.fr/lix/projet-r). Ce dépôt pourra être "*cloné*" dans un répertoire de travail que vous avez créé sur votre ordinateur.

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

Sp fournit des fonctions pour le traçage des données sous forme de cartes et pour la récupération des coordonnées.

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

### A. Menu

Un menu permet d'accéder aux différentes pages de notre application :

![menu.png](images/menu.png)

Il y a quatre pages :
- *Distribution des échantillons*,
- *Statistiques par an*,
- *Distribution des disciplines*,
- et *Statistiques par département*.
Ces pages sont accessibles en cliquant sur leur label, dans le menu à gauche.

### B. *Distribution des échantillons*

Une fois l'installation et l'éxecution réussies, l'application s'ouvre sur la page suivante:  

![dde.png](images/dde.png)

- #### Première partie

![dde_1.png](images/dde_1.png)

La partie supérieure de la page affiche un histogramme du nombre d'échantillons de chaque diplôme, et un diagramme à bandes du pourcentage de chaque discipline, dans chaque diplôme, en fonction de l'année que l'on choisit avec le "*slider*" situé en au dessus des graphes. En plus de définir une année, le slider permet également de les faire défiler. Cela permet de voir la progression et la distribution du nombre d'échantillons et du pourcentage de chaque discipline au cours des années. 

- #### Seconde partie

![dde_2.png](images/dde_2.png)

La partie inférieure de la page affiche une carte des départements de la France métropolitaine. On peut intéragir avec cette dernière grâce à des "*radio buttons*", situé au-dessus de la carte. Ils permettent de choisir une discipline et un diplôme afin d'afficher sur la carte les pourcentages d'échantillons de la discipline et du diplôme choisis avec le nom de chaque département. Cela permet d'avoir plus d'informations sur un département spécifique grâce à une représentation géolocalisée des échantillons. De plus, cela permet de comparer un département, une région ou une académie par rapport à d'autres.

### C. *Statistiques par an*

![spa.png](images/spa.png)

- #### Paramètres

![spa_param.png](images/spa_param.png)

Ce bloc permet de contrôler les différents graphes présents dans le bloc inférieur, en modifiant la *discipline*.

- #### Evolution du taux d'insertion au cours du temps

![spa_ti.png](images/spa_ti.png)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'insertion (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'insertion (en %).

- #### Evolution des statistiques des emplois au cours du temps 

![spa_se_1.png](images/spa_se_1.png)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'emplois cadres (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'emplois cadres (en %).

![spa_se_2.png](images/spa_se_2.png)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'emplois stables (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'emplois stables (en %).

![spa_se_3.png](images/spa_se_3.png)

Ce graphe montre l'évolution de la tendance et de la distribution du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée le taux d'emplois à temps plein (en %).

- #### Evolution de la part des femmes au cours du temps

![spa_pf.png](images/spa_pf.png)

Ce graphe montre l'évolution de la tendance et de la distribution de la part des femmes (en %) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée la part des femmes (en %).

- #### Evolution des salaires nets mensuels au cours du temps

![spa_snm.png](images/spa_snm.png)

Ce graphe montre l'évolution de la tendance et de la distribution des salaires nets mensuels (en euros) de chaque diplôme au cours des années en fonction de la discipline choisie. L'abscisse représente les années et l'ordonnée les salaires nets mensuels (en euros).

### D. *Distribution des disciplines*

![ddd.png](images/ddd.png)

- #### Paramètres

![ddd_param.png](images/ddd_param.png)

Ce bloc permet de contrôler les différents graphes présents dans le bloc inférieur, en modifiant l'*année* avec un slider et en modifiant la *discipline* avec des radio buttons.

- #### Evolution du taux d'insertion au cours du temps

![ddd_ti.png](images/ddd_ti.png)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'insertion (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'insertion (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'insertion (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'insertion (en %) de chaque diplôme. 

- #### Evolution des statistiques des emplois au cours du temps 

![ddd_se_1.png](images/ddd_se_1.png)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'emplois cadres (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'emplois cadres (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'emplois cadres (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'emplois cadres (en %) de chaque diplôme.

![ddd_se_2.png](images/ddd_se_2.png)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'emplois stables (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'emplois stables (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'emplois stables (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'emplois stables (en %) de chaque diplôme.

![ddd_se_3.png](images/ddd_se_3.png)

L'histogramme permet de voir la progression et la distribution des médianes du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes du taux d'emplois à temps plein (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique du taux d'emplois à temps plein (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée le taux d'emplois à temps plein (en %) de chaque diplôme.

- #### Evolution de la part des femmes au cours du temps

![ddd_pf.png](images/ddd_pf.png)

L'histogramme permet de voir la progression et la distribution des médianes de la part des femmes (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes de la part des femmes (en %) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique de la part des femmes (en %) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée la part des femmes (en %) de chaque diplôme.

- #### Evolution des salaires nets mensuels au cours du temps

![ddd_snm.png](images/ddd_snm.png)

L'histogramme permet de voir la progression et la distribution des médianes des salaires nets mensuels (en euros) de chaque diplôme au cours des années et en fonction de la discipline choisie. 
L'abscisse représente les types de diplôme et l'ordonnée les médianes des salaires nets mensuels (en euros) de chaque diplôme.

Similairement à l'histogramme, le violin plot montre une représentation abstraite de la distribution empirique des salaires nets mensuels (en euros) de chaque diplôme au cours des années et en fonction de la discipline choisie.
L'abscisse représente les types de diplôme et l'ordonnée les salaires nets mensuels (en euros) de chaque diplôme.

### E. *Statistiques par département*

![spd.png](images/spd.png)

Seuls les jeux de données *[Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-licence-professionnelle-en-universites-et-etablissements-assimiles/#_)* et *[Insertion professionnelle des diplômés de Master en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimil-0/#_)* sont utilisés sur cette page.

- #### Paramètres

![spd_param.png](images/spd_param.png)

La partie gauche de la page présente les paramètres permettant d'intéragir avec la carte. Le "*slider*" permet de choisir une année ou de faire défiler les années, et les "*radio buttons*" permettent de choisir un diplôme, une discipline et une statistique. 

- #### Partie principale

![spd_1.png](images/spd_1.png)

La partie droite de la page affiche une carte des départements de la France métropolitaine. On peut intéragir avec cette dernière grâce aux paramètres, situé à gauche de la carte. Ils permettent de choisir une discipline, un diplôme et une statistique afin d'afficher sur la carte le nom de chaque département avec les valeurs de la statistique choisie en fonction de la discipline et du diplôme choisis. Cela permet d'avoir plus d'informations sur un département spécifique grâce à une représentation géolocalisée des statistiques. De plus, cela permet de comparer un département, une région ou une académie par rapport à d'autres.
Pour pouvoir représenter les statistiques de chaque département sur la carte, nous avons décidé de prendre la médiane des données de chaque département comme la taille est conséquente. Nous avons choisi la médiane, plutôt que la moyenne, car elle est plus représentative.

# II. Guide développeur

Dans ce Developper Guide, la structure, le code et le rôle des fichiers dans le projet seront expliqués.

## 1. Les répertoires & fichiers

Dans cette partie, on explique le rôle de chaque répertoire et fichiers.

### A. *images*

Ce répertoire contient les images servant principalement à la rédaction de ce guide.

### B. *Jeux de données*

Voici l'ensemble des jeux de données utilisés pour le projet :

- ***fr-esr-insertion_professionnelle-dut_donnees_nationales.csv*** : le jeu de données sur les diplômes universitaires de technologie, *[Insertion professionnelle des diplômé.e.s de Diplôme universitaire de technologie (DUT) en universités et établissements assimilés - données nationales par disciplines détaillées](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-diplome-universitaire-de-technologie-dut-en-universites-et-etablissements-assimiles-donnees-nationales-par-disciplines-detaillees/#_)*.

- ***fr-esr-insertion_professionnelle-lp.csv*** : le jeu de données sur les licences professionnelles, *[Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplome-e-s-de-licence-professionnelle-en-universites-et-etablissements-assimiles/#_)*.

- ***fr-esr-insertion_professionnelle-master.csv*** : le jeu de données sur les masters, *[Insertion professionnelle des diplômés de Master en universités et établissements assimilés](https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimil-0/#_)*.

- ***departements.geojson***: Le jeu de données contenant les délimitations des départements de la France métropolitaine ([source](https://france-geojson.gregoiredavid.fr/)). 

### C. *global.R*

Ce fichier continent le code permettant le traitement des données afin que l'on puisse les utiliser et les lire proprement.

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

Ces scripts sont structurés de la manière suivante:

```bash
...
```

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

#### - Le chargement des données

Dans cette section, on récupère les jeux de données nécessaires au fonctionnement de l'application. Par exemple:

```bash
...
# Lecture du fichier contenant le jeu de données de licence professionnelle 
    diplome.lp <- reactive({
        diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', 
                               header = T, 
                               sep = ';', 
                               fill=TRUE, 
                               encoding = "UTF-8")
    })
...
departements <- geojsonio::geojson_read("departements.geojson", what = "sp")
...
```

Ici on charge le jeux de données *Insertion professionnelle des diplômé.e.s de Licence professionnelle en universités et établissements assimilés* et celui contenant les délimitations des départements de la France métropolitaine.

#### - Le traitement des données

Dans cette section, on traite les jeux de données nécessaires au fonctionnement de l'application. Par exemple:

```bash
...
# Chargement des donnees
departements <- geojsonio::geojson_read("departements.geojson", what = "sp")
...
# Traitement des donnees
academie <- c("Amiens","Reims","Normandie","Clermont-Ferrand","Orléans-Tours","Rennes","Besançon","Bordeaux","Lyon","Orléans-Tours","Bordeaux","Nancy-Metz","Normandie","Lille","Clermont-Ferrand","Strasbourg","Strasbourg","Normandie","Dijon","Créteil","Aix-Marseille","Aix-Marseille","Grenoble","Reims","Toulouse","Poitiers","Limoges","Bordeaux","Normandie","Orléans-Tours","Montpellier","Dijon","Amiens","Bordeaux","Lyon","Dijon","Paris","Versailles","Toulouse","Toulouse","Nice","Nantes","Limoges","Nancy-Metz","Versailles","Clermont-Ferrand","Nice","Montpellier","Corse","Rennes","Limoges","Besançon","Rennes","Montpellier","Bordeaux","Orléans-Tours","Grenoble","Reims","Reims","Nancy-Metz","Toulouse","Montpellier","Grenoble","Grenoble","Créteil","Aix-Marseille","Poitiers","Créteil","Lyon","Toulouse","Aix-Marseille","Poitiers","Orléans-Tours","Corse","Dijon","Grenoble","Toulouse","Toulouse","Montpellier","Clermont-Ferrand","Nantes","Toulouse","Nantes","Normandie","Rennes","Lille","Besançon","Nantes","Amiens","Versailles","Versailles","Orléans-Tours","Nantes","Nancy-Metz","Poitiers","Besançon")
        
departements$academie <- academie
academie.dept <- departements%>%merge(academie.statistiques, by = "academie", duplicateGeoms = TRUE)
...
```

Ici après avoir chargé le jeu de données, on ajoute une colonne afin de pouvoir grouper les données geojson et csv.

#### - Les variables

Dans cette section, on définit toutes les variables. Par exemple:

```python
...
# Variables pour les elements de la page
minYear = obesity.year.min()
maxYear = obesity.year.max()
dropdown_continents = generate_dropdown(obesity, 'continent')
dropdown_countries = generate_dropdown(obesity, 'country')

# Selection du type de groupe
radioitems = dbc.FormGroup(...)

# Page pour obesite
pageObesity = html.Div([...])
...
```
> exemple: *obesity_page.py*

Ici par exemple la variable *pageObesity* continent l'ensemble de la page *Obesity* c'est-à-dire (les éléments pour l'interaction et les graphiques), et les variables *minYear*, *maxYear*, *dropdown_continents*, *dropdown_countries* et *radioitems* sont utilisés dans *pageObesity*.
Pour avoir plus d'explication sur la structure de *pageObesity*, c'est [ici](https://dash.plotly.com/layout).

### B. ui.R

Ce script s'occupe de définir des variables pour le chemin des jeux de données. Celui-ci utilise le package *os*.

### C. server.R

Ce script s'occupe du traitement des données, voici sa structure:

```python
...
# Imports
...

# Fonctions complementaires
...

# Fonctions principales
def process_obesity(obesity):
  ...
def process_employment(employment):
  ...
```

- #### Traitement de *obesity* : *process_obesity*

##### - Renommage de certaines variables:

| Anciens noms | Nouveaux noms 
| --- | --- |
| Country | country |
| Year | year |
| Obesity (%) | obesity |
| Sex | sex |

##### - Extraction de réels à partir d'une chaine de caractères

La fonction *extract_float(str, index)* permet d'extraire un réel dans une chaîne de caractère à un indice donné. On extrait les réels dans la variable *obesity* anciennement *Obesity (%)* en sachant que les valeurs de cette variable sont des chaînes de caractères dans le format suivant:

```math
S_i = "X_{i,0}[X_{i,1}-X_{i,2}]", S_i \in \text{obesity}, X_{i,j} \in \R
```

Donc:
```math
\text{ extract\_float}(S_i, 0)  = X_{i,0} \\
\text{ extract\_float}(S_i, 1)  = X_{i,1} \\
\text{ extract\_float}(S_i, 2)  = X_{i,2}
```

##### - Changement des valeurs pour la variable *sex*

| Anciennes valeurs | Nouvelles valeurs 
| --- | --- |
| Male | M |
| Female | F |
| Both sexes | B |

Pour faire ceci il faut juste extraire la première lettre de la valeur et prendre sa majuscule.

##### - Création de la variable *country_code*

Cette variable sert seulement pour la représentation géolocalisée de l'obésité. Afin de la créer, un package externe est nécessaire. On utilise le package *pycountry_convert*, précisément la fonction *country_name_to_country_alpha2* qui va convertir un pays en son code alpha2 (*ex: France=FR*).

Afin de gérer quelques exceptions, la fonction ***convert_country_to_country_code*** a été créée.

##### - Création de la variable *continent*

On utilise alors les fonctions ***country_name_to_country_alpha2***  et ***country_alpha2_to_continent_code*** du package *pycountry_convert* pour créer la variable *continent* voici les étapes suivies:
1. Convertir le pays en code alpha2 avec ***country_name_to_country_alpha2*** (*ex: France=FR*) 
2. Convertir le code alpha2 en continent avec ***country_alpha2_to_continent_code*** (*ex: FR=Europe*)
3. Affecter cette valeur à la variable *continent*
  
Afin de gérer quelques exceptions, la fonction ***convert_country_to_continent*** a été créée.

- #### Traitement de *employment* : *process_employment*

##### - Renommage de certaines variables:

| Anciens noms | Nouveaux noms 
| --- | --- |
| LOCATION | country_code |
| Country | country |
| Subject | subject |
| Time | year |
| Value | value |

##### - Changement des valeurs pour la variable *sex*

| Anciennes valeurs | Nouvelles valeurs 
| --- | --- |
| Males | M |
| Females | F |
| All persons | B |





##### - Changement des valeurs pour la variable *value*

Étant donnée que les valeurs de la variable *value* sont des nombres qui représentent des milliers, on multiple les valeurs de cette colonne par 1 000.

##### - Création de la variable *continent*

Comme pour *obesity*, on va créer la variable continent à partir de *country_code* et la fonction ***convert_country_to_continent*** qui a été créée à l'occasion.

# III. Rapport d'analyse

## 1. Les données

A partir d'ici on suppose que les données on déjà été traitées, pour plus de détails [ici](#c-script-process_datapy).

### A. Obesity among adults by country, 1975-2016

Ce jeu de données provient de *[Kaggle](https://www.kaggle.com/amanarora/obesity-among-adults-by-country-19752016)*, une communauté regroupant des outils et des ressources pour la data science, précisément celui-ci a été modifié par l'utilisateur *[Aman Arora](https://www.kaggle.com/amanarora)* à partir des données originales se trouvant [ici](https://apps.who.int/gho/data/node.main.A900A?lang=en) sur le site l'*Organisation Mondiale de la Santé (OMS)*.
  
Dans ce jeu de données on retrouve le pourcentage de personnes obèses, pour les hommes/femmes/les deux, au sein d'un pays pour une année spécifique. Celui-ci est composé de **24 570 enregistrements/lignes** et de **8 variables**.

  
Voici la structure du jeu de données post-traitement:

<br>

| Variables | Type | Description |
|:-----------:|:-----------:|:-----------|
| **country** | Categoriel (nominal) | *Le pays* |
| **country_code** | Categoriel (nominal) | *Le code du pays en format ISO3* |
| **continent** | Categoriel (nominal) | *Le continent, associé au **country*** |
| **year** | Numérique (ratio) | *L'année* |
| **sex** | Categoriel binaire (nominal) | *Le sexe, on ne prend en compte que l'homme ou la femme* |
| **obesity** | Numérique (ratio) | *L'obesité moyenne en pourcentage pour un pays et un sexe donné* |
| **max_obesity** | Numérique (ratio) | *La valeure minimale en pourcentage de l'obesité* |
| **min_obesity** | Numérique (ratio) | *La valeure maximale en pourcentage de l'obesité* |

<ins>Remarques :</ins>
- On ne travaille pas avec les variables **max_obesity** et  **min_obesity**, ceux-ci ont été gardées au cas où elles deviendraient utiles à autrui ultérieurement.
- La variable **country_code** sert pour le graphique géolocalisé, on utilise un jeu de données complémentaire afin d'obtenir les coordonnées géographiques de chaque pays.

<br>

### B. Employment by activities (ISIC Rev.4)

Ce jeu de données provient de *[OECD (Organisation for Economic Co-operation and Development)](https://stats.oecd.org/Index.aspx?QueryId=3491)*, une organisation économique intergouvernementale composée de 37 pays fondée en 1961 (*Wikipedia*) dans le but de stimuler la progression économique et les échanges.
  
Dans ce jeu de données on retrouve le nombre d'employés selon des activités économiques. Ces activités économiques sont définies par l'*International Standard Industrial Classification (ISIC) Revision 4*, on y retrouve les activités suivantes:

1. Agriculture, forestry and fishing
1. Mining and quarrying
2. Manufacturing
3. Electricity, gas, steam and air conditioning supply
4. Water supply; sewerage, waste management and remediation activities
5. Construction
6. Wholesale and retail trade; repair of motor vehicles and motorcycles
7. Transportation and storage
8. Accommodation and food service activities
9. Information and communication
10. Financial and insurance activities
11. Real estate activities
12. Professional, scientific and technical activities
13. Administrative and support service activities
14. Public administration and defence; compulsory social security
15. Education
16. Human health and social work activities
17. Arts, entertainment and recreation
18. Other service activities
19. Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
20. Activities of extraterritorial organizations and bodies

Voici la structure du jeu de données post-traitement:

<br>

| Variables | Type | Description |
|:-----------:|:-----------:|:-----------|
| **country** | Categoriel (nominal) | *Le pays* |
| **country_code** | Categoriel (nominal) | *Le code du pays en format ISO3* |
| **continent** | Categoriel (nominal) | *Le continent, associé au pays* |
| **sex** | Categoriel binaire (nominal) | *Le sexe, on ne prend en compte que l'homme ou la femme* |
| **year** | Numérique (ratio) | *L'année* |
| **subject** | Categoriel (nominal) | *L'activité économique (listées au-dessus)* |
| **activity** | Categoriel binaire (nominal) | *Le type d'emploi, soit bureautique, soit manuel* |
| **value** | Numérique (ratio) | *Le nombre d'employés dans le secteur, associé à un secteur/année/pays* |

<ins>Remarques :</ins>
- La création de la variable **activity** a été faite manuellement à partir de la variable **subject** donc celle-ci reste subjective à notre binôme.

<br>



## 2. Observations

Maintenant analysons les jeux de données sur l'obésité et l'emploi afin de répondre à notre problématique.

### A. Obesity among adults by country, 1975-2016 

- #### Cartographie & Distribution

| 1975 | 1996 | 2016 |
|:-----------:|:-----------:|:-----------:|
|![map_obesity_1975](images/obesity/map_obesity_1975.png)|![map_obesity_1996](images/obesity/map_obesity_1996.png)|![map_obesity_2016](images/obesity/map_obesity_2016.png)
|![distribution_obesity_1975](images/obesity/distribution_obesity_1975.png)|![distribution_obesity_1996](images/obesity/distribution_obesity_1996.png)|![distribution_obesity_2016](images/obesity/distribution_obesity_2016.png) 

- On observe plusieurs choses avec ces cartes et histogrammes:
  - Les **pays les moins développés** sont ceux qui possèdent une **croissance faible même quasi nulle du pourcentage d'obesité**.  
  - Les **pays les plus développées/riches** et les **pays en voie de développement** possèdent une croissance un peu plus élevée du pourcentage d'obésité.
  - Un pays a réussi à avoir une majorité de sa population en obésité (*Nauru*).

- #### Analyse spacio-temporelle

<ins>Selon les continents:</ins>
  
![evolution_obesity_continent](images/obesity/evolution_obesity_continent.png)

- On observe plusieurs choses avec ce graphique:
  - **Dans chaque continent** le pourcentage d'obesité au sein de la population ne fait **que augmenter**.
  - Le continent avec me pourcentage d'obésité le plus élevé est l'**Océanie**.
  - Le continent avec le pourcentage d'obésité le plus faible est l'**Afrique**.

- <ins>Critiques:</ins>
  - Le calcul du pourcentage d'obésité par continent s'est fait par le calcul des moyennes d'obésité de chaque pays du continent sans prendre en compte le coefficient de population par pays, donc les résultats ne sont pas à 100% représentatifs de la réalité. 

<ins>Selon les continents et le sexe:</ins>

| Continent | Graphique |
|:---:|:---:|
| Asie | ![evolution_obesity_asia](images/obesity/evolution_obesity_asia.png) |
| Europe | ![evolution_obesity_europe](images/obesity/evolution_obesity_europe.png) |
| Amerique du nord | ![evolution_obesity_north_america](images/obesity/evolution_obesity_north_america.png) |
| Amerique du sud | ![evolution_obesity_south_america](images/obesity/evolution_obesity_south_america.png) |
| Océanie | ![evolution_obesity_oceania](images/obesity/evolution_obesity_oceania.png) |

- On observe plusieurs choses avec ce graphique:
  - Dans tout les continents, peut importe le sexe, **la tendance pour le pourcentage de l'obésité est d'augmenter**.
  - Dans la majorité des continents **le pourcentage de femmes obèses est toujours plus élevé que les hommes**.
  - **L'Europe est le seul continent qui a inversé la position des courbes des hommes et des femmes**. Donc à partir d'une certaine année le pourcentage d'hommes obèses est devenu plus élevé que celui des femmes obèses.

- <ins>Critiques:</ins>
  - On retouve ici le même problème que le graphique précédent puisqu'on n'utilise pas le coefficient de la population pour le calcul de la moyenne d'obésité.

- #### Bilan

A partir de toutes ces observations on peut conclure que l'obésité est une maladie qui touche le monde entier cependant certains sont plus touchés que d'autres, notamment les pays riches et  les plus développés à quelques exceptions près. En plus de cela, les femmes sont plus touchées que les hommes par cette maladie en général cependant on observe une transition de cette tendance en Europe. Malheureusement **l'obésité peut être décrite comme une fonction croissante par rapport au temps**, c'est-à-dire que le pourcentage de personnes obèses ne fait qu'augmenter.

### B. Employment by activities (ISIC Rev.4)

- #### Analyse spacio-temporelle

<ins>Selon le type d'activité:</ins>

![evolution_activity_type_employment.png](images/employment/evolution_activity_type_employment.png)

- On observe plusieurs choses avec ce graphique:
  - Le nombre d'employés dans **les deux types d'activité augmente jusque 2018** puis **en 2019 on a une petite chute** (peut-être dû à la crise de la *COVID-19*).
  - Il y a **plus d'employés dans les activités manuelles que dans les activités bureautiques**.

<br>

<ins>Selon le type d'activité pour un échantillon de pays:</ins>

![evolution_activity_type_sample_employmen.png](images/employment/evolution_activity_type_sample_employment.png)

- On observe plusieurs choses avec ce graphique:
  - La majorité des pays possède **plus d'employés dans le manuel que dans le bureautique**.
  - Certains pays ont subi une **transition où le nombre d'employés en bureautique est plus élévé que dans le manuel**. On remarque aussi le fait que **le bureautique augmente** et le **manuel diminue ou se stabilise** après cette transition.

<ins>Répartion des activités manuelles:</ins>
![manual_activities_employment.png](images/employment/manual_activities_employment.png)

- On observe plusieurs choses avec ce graphique:
  - ***Le commerce de gros et de détail, la réparation de véhicules automobiles et de motos*** représente environ un quart (*25%*) des activités manuelles.
  - ***La production*** représente aussi environ un quart (*25%*) des activités manuelles.

<ins>Répartion des activités bureautiques:</ins>
 ![desktop_activities_employment.png](images/employment/desktop_activities_employment.png)

- On observe plusieurs choses avec ce graphique:
  - ***Les activités sociales et médicales*** représente environ un quart (*25%*) des activités bureautiques. 
  - ***L'éducation*** représente environ un cinquième (*20%*) des activités bureautiques. 
  - ***L'administration et la défense publique*** représente environ *16%* des activités bureautiques. 

- #### Bilan

A partir de toutes ces observations on peut conclure qu'entre 2008 et 2018, l'emploi possédait une bonne dynamique car le nombre d'employés ne faisait qu'augmenter dans cet interval. Cependant à partir de 2019 il y a un arrêt de cette dynamique que l'on suppose être la crise sanitaire de la *COVID-19*. Puis les métiers bureautiques commencent peu à peu à devancer les métiers manuels dans certains pays européens.

### C. Comparaison des jeux de données

Nos deux jeux de données nous ont appris beaucoup de choses, cependant il serait intéressant de conclure sur notre problématique en faisant des opérations entre  elles.

- #### Contraintes

Malgré le fait que nos jeux de données soient chacunes assez complètes, elles ne proviennent pas de la même sources. Donc la fusion des jeux de données limites les comparaisons sur **15 164 enregistrement/lignes** dont **32 pays** répartis sur **les années [2008;2016]**.

- #### Correlation

![heatmap_correlation_analytics](images/analytics/heatmap_correlation_analytics.png)
- <ins>Explication du graphique:</ins>
  - En abscisse, les pays
  - En ordonnée, le type d'activité (*Desk: Bureautique, Manual: Manuel*)
  - Les carrés représentent la correlation entre l'obésité et le nombre d'employés dans le type d'activité. La couleur des carrés est interprété de la manière suivante:
    - Plus la couleur du carré se rapproche du **<span style="color:blue">bleu</span>** 🔵, donc de la valeur **<span style="color:blue">1</span>**, alors correlation est positive. Cela signifie que **<span style="color:blue">l'obésité et le type d'activité peuvent être représentés par une fonction croissante</span>**.
    - Plus la couleur du carré se rapproche du **<span style="color:red">rouge</span>** 🔴, donc de la valeur **<span style="color:red">-1</span>**, alors correlation est positive. Cela signifie que **<span style="color:red">l'obésité et le type d'activités peuvent être représenté par une fonction décroissante</span>**.
  - Par exemple pour la France:
    - 🔵 **Desk/Obesity** en bleu implique que **<span style="color:blue">le pourcentage d'obesité augmente lorsque le nombre d'employés dans les bureaux augmente</span>**.
    - 🔴 **Manual/Obesity** en rouge implique que **<span style="color:red">le pourcentage d'obesité baisse lorsque le nombre d'employés travaillant manuellement augmente</span>**.

<br>

- <ins>Observations:</ins>
  - **<span style="color:blue">Desk</span>🔵 <span style="color:red">Manual</span>** 🔴: <b>14 pays</b> (*Denmark, Finland, France, Hungary, Ireland, Italy, Japan, Latvia, Lithuania, Netherlands, Poland, Portugal, Slovenia, Sweden*)
  - **<span style="color:blue">Desk</span>🔵 <span style="color:blue">Manual</span>** 🔵: <b>16 pays</b> (*Australia, Austria, Belgium, Chile, Colombia, Costa Rica, Estonia, Germany, Iceland, Israel, Luxembourg, Mexico, New Zealand, Norway, Switzerland, Turkey*)
  - **<span style="color:red">Desk</span>🔴 <span style="color:red">Manual</span>** 🔴: <b>2 pays</b> (*Greece, Spain*)
- <ins>Hypothèses:</ins>
  - Pour les pays en **<span style="color:blue">Desk</span>🔵 <span style="color:red">Manual</span>** 🔴 sont les pays qui ont tendance à moins recruter dans les métiers manuels mais plus dans les métiers bureautiques.
  -  Pour les pays en **<span style="color:blue">Desk</span>🔵 <span style="color:blue">Manual</span>** 🔵 sont les pays qui recrutent dans les métiers manuels et bureautiques.
  - Pour les pays en **<span style="color:red">Desk</span>🔴 <span style="color:red">Manual</span>** 🔴 sont les pays qui sont possiblement en crise.

<br>

- **Bilan**
  
En combinant nos jeux de données, on a découvert **3 groupes de pays qui présentent des comportements similaires** grâce à la correlation entre l'obésité et l'emploi dans les activités manuelles/bureautiques.

## 3. Conclusion

En conclusion on peut dire qu'il existe un lien entre l'obésité et la croissance des emplois en bureaux. Cependant ce lien n'est pas présent pour tous les pays car cela dépendant aussi de leur situation économique, politique <sup>et</sup>/<sub>ou </sub>démographique.
