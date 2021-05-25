library(tracerer)
library(data.table)
library(ggplot2)
library(pammtools)

ma_skl <- fread("./BEAST/modern_ancient_skyline.txt",skip = 1, header = T)
ma_skl$model <- "modern & ancient"
m_skl  <- fread("./BEAST/modern_skyline.txt",skip = 1, header = T)
m_skl$model <- "modern"

skl    <- bind_rows(ma_skl,m_skl)

ggplot()+
    geom_stepribbon(data = skl,aes(x=Time,ymin=Lower,ymax=Upper, fill =model),alpha = 0.5)+
  geom_step(data = skl,aes(x=Time,y=Mean, color = model),size = 2, alpha = 0.7)+
  #coord_cartesian(xlim = c(0,50000))+
  scale_x_log10(breaks = scales::trans_breaks("log10", function(x) 10^x),
  labels = scales::trans_format("log10", scales::math_format(10^.x)))+
    scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x),
   labels = scales::trans_format("log10", scales::math_format(10^.x)))+
   annotation_logticks(sides = "lb")+
  xlab("Years Before Present")+
  ylab("Effective Female Population Size (Nef)")+
  theme_bw()
ggsave("BEAST_skl.png",dpi = 300, width = 10, height = 5, units = "in")