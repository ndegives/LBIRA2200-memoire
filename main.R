library(dplyr)
library(readxl)

# Aerial part CIPF --------------------------------------------------------

aerial <- read_excel("Aerials data/Sorgho20_21_22_CIPF.xlsx")

# Early stage -------------------------------------------------------------

early.global <- read.csv("C:/Nico/Github/Memoire/Early_growth_root_data/early global.csv")
early.growth <- read.csv("C:/Nico/Github/Memoire/Early_growth_root_data/early growth.csv")

# End stage --------------------------------------------------------------
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# end.data est le dataframe avec les données 'Global root data' de toutes les variétés + une colonne renseignant la variété 
end.data <- data.frame()
for (variety in c("Amiggo","Biggben","Hyperion","Juno","Swingg","Vegga")) {
  paste0("C:/Nico/Github/Memoire/End_growth_root_data/root_data/0.global_root_data/",variety,".csv") %>%
    read.csv() %>% 
    mutate(variety = factor(variety)) %>%
    rbind(end.data,.) -> end.data
}
colnames(end.data)
end.data <- select(end.data,c('root_name','diameter','root_ontology','root','parent_name','variety'))
head(end.data,2)
summary(end.data)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Fonction qui donne moyenne et écart-type des diamètres filles pour chaque racine nodale
mean_dataset <- function(variete) {
  end.data %>%
    filter(variety==variete, root_ontology==" Root") %>%
    select('root_name','diameter') %>%
    left_join(., aggregate(end.data$diameter,by=list(end.data$parent_name),FUN=mean), by = c("root_name" = "Group.1")) %>%
    left_join(., aggregate(end.data$diameter,by=list(end.data$parent_name),FUN=sd), by = c("root_name" = "Group.1")) %>%
    rename(child_mean_diameter = x.x , child_sd_diameter = x.y)-> data
  return(data)
}
#Amiggo <- mean_dataset("Amiggo") ; Biggben <- mean_dataset("Biggben") ; Hyperion <- mean_dataset("Hyperion") ; Juno <- mean_dataset("Juno") ; Swingg <- mean_dataset("Swingg") ; Vegga <- mean_dataset("Vegga")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Moyenne et 

# More section -----------------------------------------------------------

