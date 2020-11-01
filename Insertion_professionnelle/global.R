diplome.DUT <- read.csv('fr-esr-insertion_professionnelle-dut_donnees_nationales.csv', 
                        header = T, 
                        sep = ';', 
                        fill=TRUE, 
                        encoding = "UTF-8")

diplome.lp <- read.csv('fr-esr-insertion_professionnelle-lp.csv', 
                       header = T, 
                       sep = ';', 
                       fill=TRUE, 
                       encoding = "UTF-8")


diplome.master <- read.csv('fr-esr-insertion_professionnelle-master.csv', 
                           header = T, 
                           sep = ';', 
                           fill=TRUE, 
                           encoding = "UTF-8")