library(tidyverse)

mito_info <- xlsx::read.xlsx("./summary_file_mitochondrial_genomes.xlsx", sheetName = "mito_seq_info", as.data.frame = T, header = T)
modern_clade  <- mito_info %>% filter(type == "modern") 
ancient_clade <- mito_info %>% filter(type == "ancient") 
n_ancient <- nrow(ancient_clade)

##major_clade
p_vals_maj <- c()
for(i in 1:1000){
modern_clade_sub <- sample_n(modern_clade, n_ancient)
M <- modern_clade_sub %>% group_by(clade_major) %>% summarise(modern = n()) 
A <- ancient_clade %>% group_by(clade_major) %>% summarise(ancient = n())
J <- left_join(M,A)
mat_maj <- J[,2:3]
val <- fisher.test(mat_maj)
val$p.value
p_vals_maj <- c(p_vals_maj,val$p.value)
}
mean_maj <- mean(p_vals_maj)
sd_maj   <- sd(p_vals_maj)

boxplot(p_vals_maj)

##major_clade
p_vals_min <- c()
for(i in 1:1000){
modern_clade_sub <- sample_n(modern_clade, n_ancient)
M <- modern_clade_sub %>% group_by(clade_minor) %>% summarise(modern = n()) 
A <- ancient_clade %>% group_by(clade_minor) %>% summarise(ancient = n())
J <- left_join(M,A)
mat_min <- J[,2:3]
val <- fisher.test(mat_min)
val$p.value
p_vals_min <- c(p_vals_min,val$p.value)
}
mean_min <- mean(p_vals_min)
sd_min   <- sd(p_vals_min)


