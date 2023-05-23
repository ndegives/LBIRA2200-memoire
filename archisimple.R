library(tidyverse)
library(data.table)
setwd("C:/Nico/Github/Memoire")
source("ArchiSimple/src/io_archisimple.R")


# Lecture du fichier de paramètre ----------------------------------------------

params <- read_archisimple_xml("base_parameter.xml")


# Insérer les différents paramètres à modifier dans le batch -------------------

P_sim_length <- c(10,20)
P_dmax <- seq(1.2, 2, 0.1)


# for loop pour faire le tour de tous les paramètres ---------------------------


all_sims <- NULL # Table to containn all the simulation data
inc <- 0 # increment for the simulations
setwd("ArchiSimple/src/archisimple93/")
for(dmax in P_dmax){
  for(sim_length in P_sim_length){
    
    ## increment 
    inc <- inc+1
    print(paste0("simulation ",inc))
    
    ### 4. Update the parameter in the loop
    params$sim_length <- sim_length ## put a minimal value of 10 here
    params$dmax <- dmax ## put a minimal value of 10 here
    
    ### 3 . Save the parameters back to a text file to be read by ArchiSimple
    write_archisimple_XML(params, path = "parameter.xml")
    
    ### 4. run archisimple
    system("./archisimple")
    
    ### 5. Get the output from the simulation
    rs <- fread("myroot.txt", header = T) %>% 
      mutate(sim_length = sim_length) %>%
      mutate(dmax = dmax) %>%
      mutate(sim = inc) # add a column with the simulation id
    
    ### 6. Store all the input in one big table
    all_sims <- rbind(all_sims, rs)
  }
}
setwd("../../../")  



### 6. Plot the output of all the simulations (/!\ takes time for large simulations)

## From the side
all_sims %>%
  ggplot() +
  theme_classic() +
  geom_segment(aes(x = X1, y = -Z1, xend = X2, yend = -Z2), alpha=0.9) +
  coord_fixed() + 
  facet_grid(dmax~sim_length)

# From the top
rs %>%
  ggplot() +
  theme_classic() +
  geom_segment(aes(x = X1, y = -Z1, xend = X2, yend = -Z2), alpha=0.9) +
  coord_fixed()


