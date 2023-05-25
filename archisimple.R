# cd C:\Nico\Github\Memoire\ArchiSimple\src\archisimple93

rm(list = ls())
library(tidyverse)
library(data.table)
setwd("C:/Nico/Github/Memoire")
source("ArchiSimple/src/io_archisimple.R")


# Les six variétés de Sorgho ---------------------------------------------------



# Lecture du fichier de paramètre...............................................

params <- read_archisimple_xml("base_parameter.xml")

# Insérer les différents paramètres à modifier dans le batch....................

par <- data.frame(
  dmin=c(      0.1567  ,0.1567  ,0.1567   ,0.1567  ,0.1567  ,0.1297),
  RDM = c(     0.1874  ,0.2022  ,0.228    ,0.17545 ,0.1745  ,0.1611)
  )

# for loop pour faire le tour de tous les paramètres............................

sims <- NULL
setwd("ArchiSimple/src/archisimple93/")
inc <-0
for (variety in c('Amiggo','Biggben','Hyperion','Juno','Swingg','Vegga')) {
  # Print l'avancé de la boucle
  inc <- inc+1
  print(paste("Simulation pour :", variety, "i=", inc, '========================'))
  
  
  #Update les paramètres
    ## Regarde chaque colone de params, si la même est dans par, il remplace la colonne de params par celle de par
  params <- params %>%
    mutate(across(everything(), ~ ifelse(cur_column() %in% names(par), par[inc,][[cur_column()]],.)))
  print(params)
  # Créaction du fichier paramètre lu par ArchiSimple
  write_archisimple_XML(params, path = "parameter.xml")
  
  # Run ArchiSimple
  system("./archisimple")
  
  # Récupère l'output du modèle qui est écrit en txt
  rs <- fread("myroot.txt", header = T) %>% 
    mutate(sim_length = params$sim_length) %>%
    mutate(sim = as.factor(variety))
  
  # Stock la simulation dans sims
  sims <- rbind(sims, rs)
}
setwd("../../../") 


# Plot..........................................................................

## From the side
for (variety in c('Amiggo','Biggben','Hyperion','Juno','Swingg','Vegga')) {
  print(
    subset(sims,sim==variety) %>%
      ggplot() +
      theme_classic() +
      geom_segment(aes(x = X1, y = -Z1, xend = X2, yend = -Z2), alpha=0.9) +
      coord_fixed()+
      labs(title=variety)
    )
}


# Le maïs ----------------------------------------------------------------------

params_maize <- data.frame(
  ageAdv = 7,
  CVDD = 0.3,
  dAdv = 1,
  distAdv = 20,
  dmax = ,
  dmin = 0.14,
  dSem = 1,
  EL =  51,
  erAdv = 0.8,
  erSem =  0.5,
  exportName = 'myroot' ,
  exportType = 1,
  GDs = 50,
  IPD =  2,
  LDC =  3000,
  maxAdv = 40,
  maxSem =  5,
  pdmax =  0.8,
  pdmin =  0,
  PDT = 4.5,
  RDM =  0.12,
  SGC =  0,
  sim_length = 20,
  simtime =  140,
  TMD =  0.08,
  TrInt = 0.01,
  TrT = 1 
)


