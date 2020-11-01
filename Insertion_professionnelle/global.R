# Chargement et traitement des données

# Lecture du fichier contenant le jeu de données sur les diplômes universitaires de technologie
diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', 
                        header = T, 
                        sep = ';', 
                        fill=TRUE, 
                        encoding = "UTF-8")

# Lecture du fichier contenant le jeu de données sur les licences professionnelles 
diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', 
                       header = T, 
                       sep = ';', 
                       fill=TRUE, 
                       encoding = "UTF-8")

# Lecture du fichier contenant le jeu de données sur les masters 
diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', 
                           header = T, 
                           sep = ';', 
                           fill=TRUE, 
                           encoding = "UTF-8")