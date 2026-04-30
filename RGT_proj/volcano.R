library(tidyverse)
library(ggplot2)
library(ggrepel)

# data importing
exp <- read.csv("../differential_statistics.txt",sep = '\t') %>% 
  as.data.frame()
row.names(exp) <- exp[,"Motif"]

# data processing
exp[,"Exp"] <- ifelse(exp$P_values<0.05 & exp$TF_Activity>0,"SigExp in Parental",
                         ifelse(exp$P_values<0.05 & exp$TF_Activity<0,"SigExp in Resistant","NoSig"))

# drawing
p <- ggplot(data = exp,
            aes(x = TF_Activity, 
                y = -log10(P_values))) + 
  geom_point(alpha = 0.4, size = 3.5, 
             aes(color = Exp)) + 
  ylab("-log10(Pvalue)") + xlab("TF Activity Score \n Resistant ←→ Parental") +
  scale_color_manual(values = c("grey","blue4", "red3"))+
  theme_bw()

# drawing with top 10 marker
up_data <- filter(exp, Exp == 'SigExp in Resistant') %>%  
  distinct(Motif, .keep_all = TRUE) %>% 
  top_n(10, -log10(P_values))

down_data <- filter(exp, Exp == 'SigExp in Parental') %>% 
  distinct(Motif, .keep_all = TRUE) %>%
  top_n(10, -log10(P_values))

p1 <- p +
  geom_text_repel(data = up_data, aes(x = TF_Activity, y = -log10(P_values), label = Motif)) +  
  geom_text_repel(data = down_data, aes(x = TF_Activity, y = -log10(P_values), label = Motif)) 

# saving
ggsave("volcano_basic.pdf",          
       plot = p,             
       width = 8,            
       height = 6.5,           
       dpi = 300, 
       bg = "white") 

ggsave("volcano_Top10.pdf",          
       plot = p1,             
       width = 8,            
       height = 6.5,           
       dpi = 300, 
       bg = "white") 

