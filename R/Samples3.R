```{r violin, fig.dim=c(10,20), dpi=600, fig.cap="Tomb construction through time at both cemeteries. On the left, counts are based on the ceramic phase considered most likely to correspond to the tomb's first use (including simply 'PG', 'G' and 'O' where no greater specificity was possible). On the right, aoristic sums are presented, spreading the uncertainty associated with those general assignations. In both cases, tombs lacking any securely dateable pottery are excluded."}


names(df_prep)
aorist_tomb_dates<-subset(df_prep,total_pottery>10)
aorist_tomb_dates<-aorist_tomb_dates[-c(2,4:15,17,19:111,113:157,208:258)]
aorist_tomb_dates<-subset(aorist_tomb_dates,start_period!="")

aorist_tomb_dates_melt<-melt(as.data.table(aorist_tomb_dates), id.vars = c("tomb","cem_condensed","start_period","start_date","total_pottery","cluster"), measure.vars = c("X1100","X1090","X1080","X1070","X1060","X1050","X1040","X1030","X1020","X1010","X1000","X990","X980","X970","X960","X950","X940","X930","X920","X910","X900","X890","X880","X870","X860","X850","X840","X830","X820","X810","X800","X790","X780","X770","X760","X750","X740","X730","X720","X710","X700","X690","X680","X670","X660","X650","X640","X630","X620","X610"))

aorist_tomb_dates_melt$variable<-gsub("X","",aorist_tomb_dates_melt$variable)
aorist_tomb_dates_melt$variable<-as.numeric(aorist_tomb_dates_melt$variable)

aorist_tomb_dates_melt$value_100<-aorist_tomb_dates_melt$value*100
aorist_tomb_dates_melt<-data.frame(aorist_tomb_dates_melt)
df.expanded <- aorist_tomb_dates_melt[rep(row.names(aorist_tomb_dates_melt), aorist_tomb_dates_melt$value_100), 1:9]
names(aorist_tomb_dates_melt)

pic<-ggplot()+geom_violin(data=df.expanded,aes(x=variable,y=fct_reorder(tomb,total_pottery),fill=as.factor(cluster)),
                          scale="width",trim=FALSE,width=0.8)+scale_x_reverse(expand=c(0,0))+
  theme_bw()+theme(legend.title=element_blank(),
                   text=element_text(family="serif", size=12),
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x="Date (Years BC)", y="Tomb")

ggsave("C:/Users/dcpol/knossoscemeteries/analysis/figures/pic.png",width = 20, height = 40, units = "cm")


```

library(stats)
library(cluster)
library(tidyverse)
install.packages("purrr")
library(purrr)
library(dplyr)
df_prep<-subset(tombs,total_pottery>0)
df<-df_prep[-c(2:157,206:258)]
row.names(df)<-df[,1]
df[,1]<-NULL
df<-scale(df)

head(df)

d <- dist(df, method = "euclidean")
hc1 <- hclust(d, method = "complete" )

plot(hc, cex = 0.6, hang = -1)

hc3 <- agnes(df, method = "ward")


m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

ac <- function(x) {
  agnes(df, method = x)$ac
}

hc <- hclust(d, method = "ward.D2")

hc3
hcd <- as.dendrogram(hc3)

plot(hcd, type="rectangle",ylab="Height", horiz=TRUE)
rect.dendrogram(k = 4, horiz = TRUE, border = 8, lty = 5, lwd = 2)

install.packages("ggdendro")
install.packages("factoextra")
library(ggdendro)
library(factoextra)
dendr <- dendro_data(hc, type="rectangle",4)

cbPalette <- c("#56B4E9", "#F0E442", "#009E73","#E69F00")

fviz_cluster(list(data = df, cluster = sub_grp),ellipse.alpha=0.1,show.clust.cent=FALSE,main=NULL,xlab="Dimension 1",ylab="Dimension 2",
             ggtheme=theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
                                      text=element_text(family="serif", size=12),legend.position = "bottom"),
             geom="point")+ geom_text_repel(label=df_prep$tomb,color="Black",family="serif")+
                scale_fill_manual('Cluster',values = cbPalette)+scale_color_manual('Cluster',values = cbPalette)+
  scale_shape_manual('Cluster', values=c(15,16,17,18))

df_prep <- within(df_prep, tomb[cluster<2] <- NA)

df_prep$tomb


fviz_nbclust(df, FUN = hcut, method = "wss")
fviz_nbclust(df, FUN = hcut, method = "silhouette")
gap_stat <- clusGap(df, FUN = hcut, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

ggplot() +
  geom_segment(data=segment(dendr), aes(x=x, y=y, xend=xend, yend=yend)) +
  geom_text(data=label(dendr), aes(x=x, y=y, label=label, hjust=0), size=3) +
  coord_flip() + scale_y_reverse(expand=c(0.2, 0)) +
  theme(axis.line.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.y=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_rect(fill="white"),
        panel.grid=element_blank())

ggdendrogram(hc,rotate=TRUE)
rect.hclust(hc, k = 6)
sub_grp <- cutree(hc3, k = 4)

names(pots)

str(sub_grp)

df_prep$cluster<-sub_grp

GroupA<-subset(df_prep,cluster==3)

aorist_GroupA <- colSums(GroupA[158:207])
aorist_GroupA<-data.frame(aorist_GroupA)

colnames(aorist_GroupA)<-c("aoristic_sum")
row.names(aorist_GroupA)<-dates
aorist_GroupA<-data.frame(aorist_GroupA)
setDT(aorist_GroupA, keep.rownames = "decade")
aorist_GroupA$decade<-as.numeric(aorist_GroupA$decade)

aorist_GroupA$group<-"A"

GroupB<-subset(tombs,cluster==4)

aorist_GroupB <-colSums(GroupB[158:207])
aorist_GroupB<-data.frame(aorist_GroupB)

colnames(aorist_GroupB)<-c("aoristic_sum")
row.names(aorist_GroupB)<-dates
aorist_GroupB<-data.frame(aorist_GroupB)
setDT(aorist_GroupB, keep.rownames = "decade")
aorist_GroupB$decade<-as.numeric(aorist_GroupB$decade)

aorist_GroupB$group<-"B"

GroupC<-subset(tombs,cluster==1|cluster==2)

aorist_GroupC <-colSums(GroupC[158:207])
aorist_GroupC<-data.frame(aorist_GroupC)

colnames(aorist_GroupC)<-c("aoristic_sum")
row.names(aorist_GroupC)<-dates
aorist_GroupC<-data.frame(aorist_GroupC)
setDT(aorist_GroupC, keep.rownames = "decade")
aorist_GroupC$decade<-as.numeric(aorist_GroupC$decade)

aorist_GroupC$group<-"C"

aorist_groups<-rbind(aorist_GroupA,aorist_GroupB,aorist_GroupC)

ggplot()+ geom_line(data=aorist_groups,aes(decade,aoristic_sum,linetype=group,group=group))+
  theme_bw()+theme_bw()+theme(text=element_text(family="serif", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_manual(values=c("gray50","gray80"),name="Group")+
  scale_y_continuous(expand=c(0,0))+
  scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

ggplot()+geom_line(data=subset(aorist_groups,group=="A"),aes(decade,aoristic_sum/sum(tombs$cluster==3),group=1))+
  geom_line(data=subset(aorist_groups,group=="B"),aes(decade,aoristic_sum/sum(tombs$cluster==4),group=1))+
  geom_line(data=subset(aorist_groups,group=="C"),aes(decade,aoristic_sum/sum(tombs$cluster==1|tombs$cluster==2),group=1))+
  theme_bw()+theme_bw()+theme(text=element_text(family="serif", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_manual(values=c("gray50","gray80"),name="Group")+
  scale_y_continuous(expand=c(0,0))+
  scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

sum(tombs$cluster==1|tombs$cluster==2)
sum(tombs$cluster==3)
sum(tombs$cluster==4)

names(tombs)
tombs$century_built<-factor(tombs$century_built,levels=c("11th","10th","9th","8th","7th"))

names(tombs)
mytable <- xtabs(~cluster+total_burials, data=tombs)
ftable(mytable)
mydf<-data.frame(mytable)

mydf
ggplot(subset(mydf,cluster!=2),aes(start_period,Freq,linetype=cluster,group=cluster))+geom_line()

assemblages<-read.csv("../data/raw_data/KnossosAssemblages.csv",header=TRUE)

assemblages$cluster <- df_prep$cluster[match(assemblages$tomb,df_prep$tomb)]
assemblages$cluster[is.na(assemblages$cluster)]<- "Other"
assemblages$cluster[assemblages$cluster<3]<- "Other"
assemblages$cluster[assemblages$cluster==3]<- "Group A"
assemblages$cluster[assemblages$cluster==4]<- "Group B"

length(objects$tomb)

assem2<-unique(assemblages$assemblage)

assem2<-data.frame(assem2)
colnames(assem2)<-"assemblage"
assem2$cluster <- assemblages$cluster[match(assem2$assemblage,assemblages$assemblage)]
counts<-count(assemblages,"assemblage")
assem_counts<-merge(assem2,counts)
ggplot(assem_counts,aes(freq))+geom_histogram(bins=24)+facet_wrap(~cluster)


ggplot(subset(objects,material!="Clay"),aes(category))+geom_bar()+facet_col(~cluster)
names(assemblages)

ggplot(assemblages,aes(cluster,fill=cluster))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5), axis.title.x = element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.title.align=0.5)+
  labs(y="Proportion of Total Assemblage")+
  scale_y_continuous(expand=c(0,0.0))+guides(fill=guide_legend(title="Century BC",title.position = "top"))


shapes<-ddply(assemblages,~assemblage,summarise,types=length(unique(category)))
shapes$cluster <- assemblages$cluster[match(shapes$assemblage,assemblages$assemblage)]
ggplot(shapes,aes(types))+geom_histogram(bins=6)+facet_wrap(~cluster)


range(shapes$types)
colnames(counts)<-c("assemblage","count")

ggplot(assem3,aes(freq,fill=shape))+geom_histogram(bins=7)+facet_wrap(~cluster)

ggplot(subset(assemblages,category=="Vessel"),aes(tomb,fill=shape))+geom_bar(position="fill")+facet_wrap(~cluster,scales="free_x")

ggplot(pots_ranked,aes(tomb,fill=cluster))+geom_bar()+
  theme_bw()+theme(legend.position="bottom",text=element_text(family="serif", size=10),
                   panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                   axis.text.x = element_text(angle = 90,hjust=1,vjust=0.4), legend.margin=margin(0,0,0,0),legend.box.margin=margin(-10,-10,10,-10))+
  guides(fill=guide_legend(title="Group"))+labs(x="Tomb", y="Vessel Count")+
  scale_fill_brewer(palette = "Set2")+
  scale_y_continuous(expand=c(0,0))+facet_grid(~century,scales="free_x",space="free")


aorist_tomb_values<-subset(tombs,cluster=="Group A")[c(1,160:209)]
aorist_tomb_values[aorist_tomb_values == 0] <- NA

aorist_tomb_values<-data.frame(aorist_tomb_values)
colnames(aorist_tomb_values)[2:51]<-dates

tombs_giniA<-matrix(0, ncol = 0, nrow = 1)
tombs_giniA<-data.frame(tombs_giniA)
for(i in colnames(aorist_tomb_values[2:51])) {
  tombs_giniA[[paste0(i)]] <- ineq(aorist_tomb_values[[i]],type="Gini")
}


tombs_giniA<-t(tombs_giniA)
tombs_giniA<-data.frame(tombs_giniA)

colnames(tombs_giniA)<-c("gini_coefficient")
row.names(tombs_giniA)<-dates
tombs_giniA<-data.frame(tombs_giniA)
setDT(tombs_giniA, keep.rownames = "decade")
tombs_giniA$decade<-as.numeric(tombs_giniA$decade)



aorist_tomb_values<-subset(tombs,cluster=="Group B")[c(1,160:209)]
aorist_tomb_values[aorist_tomb_values == 0] <- NA

aorist_tomb_values<-data.frame(aorist_tomb_values)
colnames(aorist_tomb_values)[2:51]<-dates

tombs_giniB<-matrix(0, ncol = 0, nrow = 1)
tombs_giniB<-data.frame(tombs_giniB)
for(i in colnames(aorist_tomb_values[2:51])) {
  tombs_giniB[[paste0(i)]] <- ineq(aorist_tomb_values[[i]],type="Gini")
}


tombs_giniB<-t(tombs_giniB)
tombs_giniB<-data.frame(tombs_giniB)

colnames(tombs_giniB)<-c("gini_coefficient")
row.names(tombs_giniB)<-dates
tombs_giniB<-data.frame(tombs_giniB)
setDT(tombs_giniB, keep.rownames = "decade")
tombs_giniB$decade<-as.numeric(tombs_giniB$decade)


aorist_tomb_values<-subset(tombs,cluster=="Other")[c(1,160:209)]
aorist_tomb_values[aorist_tomb_values == 0] <- NA

aorist_tomb_values<-data.frame(aorist_tomb_values)
colnames(aorist_tomb_values)[2:51]<-dates

tombs_giniO<-matrix(0, ncol = 0, nrow = 1)
tombs_giniO<-data.frame(tombs_giniO)
for(i in colnames(aorist_tomb_values[2:51])) {
  tombs_giniO[[paste0(i)]] <- ineq(aorist_tomb_values[[i]],type="Gini")
}


tombs_giniO<-t(tombs_giniO)
tombs_giniO<-data.frame(tombs_giniO)

colnames(tombs_giniO)<-c("gini_coefficient")
row.names(tombs_giniO)<-dates
tombs_gini<-data.frame(tombs_giniO)
setDT(tombs_giniO, keep.rownames = "decade")
tombs_giniO$decade<-as.numeric(tombs_giniO$decade)

tombs_giniA$group<-"Group A"
tombs_giniB$group<-"Group B"
tombs_giniO$group<-"Other"

tombs_gini<-rbind(tombs_giniA,tombs_giniB,tombs_giniO)

names(tombs_giniA)
ggplot() +
  geom_line(data = tombs_gini, aes(decade,gini_coefficient,linetype=group),size=0.5)+
  theme_bw()+theme(text=element_text(family="serif", size=12))+
  labs(x="Date (Years BC)", y="Gini Coefficient")+
  scale_fill_brewer(name="Period",palette = "Set3")+
  coord_cartesian(xlim = c(1100, 600),ylim=c(0.1,0.75))+ scale_x_reverse(expand = c(0, 0),limits=c(1100,600))

assem_prep<-subset(assemblages, century!="" & century=="10th"|century=="9th"|century=="8th"|century=="7th")
assem_prep$century<-factor(assem_prep$century,levels=c("10th","9th","8th","7th"))
ggplot(assem_prep,aes(century,fill=category)
)+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title=element_blank(),
                   text=element_text(family="serif", size=11))+
  labs(title="Group A",x="", y="")+
  scale_y_continuous(expand=c(0,0.0))+facet_wrap(~cluster)



assemblages<-read.csv("../data/raw_data/KnossosAssemblages.csv",header=TRUE)

assemblages$cluster <- df_prep$cluster[match(assemblages$tomb,df_prep$tomb)]
assemblages$cluster[is.na(assemblages$cluster)]<- "Other"
assemblages$cluster[assemblages$cluster<3]<- "Other"
assemblages$cluster[assemblages$cluster==3]<- "Group A"
assemblages$cluster[assemblages$cluster==4]<- "Group B"

assemblages_no_pith<-subset(assemblages,material=="Clay" & shape!="Pithos"& shape!="Lid" & century!="13th" & century!="14th")
assemblages_no_pith$century<-factor(assemblages_no_pith$century,levels=c("11th","10th","9th","8th","7th"))

cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

potcompKNC<-ggplot(subset(assemblages_no_pith,century!="" & cemetery=="NC"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.position = "none")+
  labs(y="Proportion of Total Assemblage",x="Century BC")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))

potcompFOR<-ggplot(subset(assemblages_no_pith,century!="" & cemetery=="FOR"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title=element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.position="none")+
  labs(y="",x="Century BC")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))

potcompA<-ggplot(subset(assemblages_no_pith,century!="" & cluster=="Group A"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title=element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.position="none")+
  labs(y="",x="Century BC")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))

potcompB<-ggplot(subset(assemblages_no_pith,century!="" & cluster=="Group B"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title=element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.position="none")+
  labs(y="",x="Century BC")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))

ggarrange(potcompKNC,potcompFOR,potcompA,potcompB,ncol=4, common.legend = TRUE,legend="bottom")

###

counts <- ddply(assemblages_no_pith, .(assemblages_no_pith$cemetery, assemblages_no_pith$assemblage), nrow)
names(counts) <- c("cem", "assemblage", "Freq")
View(counts)

counts <- ddply(assemblages_no_pith, .(assemblages_no_pith$cemetery, assemblages_no_pith$century), nrow)
names(counts) <- c("group", "century", "Freq")
counts<-counts[complete.cases(counts), ]


counts2 <- ddply(assemblages_no_pith, .(assemblages_no_pith$cluster, assemblages_no_pith$century), nrow)
names(counts2) <- c("group", "century", "Freq")
counts2<-counts2[complete.cases(counts2), ]
counts2<-subset(counts2,group=="Group A" |group=="Group B")

pot_counts<-rbind(counts,counts2)
pot_counts$level<-10

potcompKNC_total<-ggplot(subset(pot_counts,group=="NC"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5), text=element_text(family="serif", size=11),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(pot_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="KNC")

potcompFOR_total<-ggplot(subset(pot_counts,group=="FOR"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5),text=element_text(family="serif", size=11),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(pot_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="FOR")

potcompA_total<-ggplot(subset(pot_counts,group=="Group A"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5),text=element_text(family="serif", size=11),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(pot_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="Group A")

potcompB_total<-ggplot(subset(pot_counts,group=="Group B"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5),text=element_text(family="serif", size=11),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(pot_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="Group B")

ggarrange(ggarrange(potcompKNC_total,potcompFOR_total,potcompA_total,potcompB_total, ncol=4),
          ggarrange(potcompKNC,potcompFOR,potcompA,potcompB, ncol=4,common.legend =TRUE,legend="bottom"),nrow=2,heights=c(1,9),align="hv")


ggplot(objects,aes(x=category,y=..prop..,group=cluster), stat="count")+
  geom_bar()+facet_col(~cluster)+scale_fill_brewer(palette="Blues")
  scale_y_continuous(expand=expansion(mult = c(0, 0.05)),labels=scales::percent)+scale_fill_manual(values=c("gray80","gray40"))+
  scale_color_manual(values="black")+theme_bw()+labs(x="Object Category",y="Proportion of Total Assemblage")+
  theme(panel.grid=element_blank())

ggplot(objects,aes(x=category,fill=cemetery,color="black"))+
  geom_bar()+facet_col(~cluster)+
  scale_y_continuous(expand=expansion(mult = c(0, 0.05)))+scale_fill_manual(values=c("gray80","gray40"))+
  scale_color_manual(values="black")+theme_bw()+labs(x="Object Category",y="Proportion of Total Assemblage")+
  theme(panel.grid=element_blank())

(sum(tombs$tomb_type_condensed=="CT")/sum(tombs$tomb_type_condensed!="U"))*100
sum(tombs$tomb_type=="Unknown")

82*0.75
ggplot(subset(tombs,est_burials>1))+geom_col(aes(tomb,pithoi,fill="red"))+geom_col(aes(tomb,polychrome_pithoi))

greys<-rep("gray80",20)
greys
names(tombs)

aorist_pithoi_values<-KNC[c(1,160:209)]
aorist_pithoi_values[aorist_pithoi_values == 0] <- NA

aorist_pithoi_values<-data.frame(aorist_pithoi_values)
colnames(aorist_pithoi_values)[2:51]<-dates

pithoi_gini<-matrix(0, ncol = 0, nrow = 1)
pithoi_gini<-data.frame(pithoi_gini)
for(i in colnames(aorist_pithoi_values[2:51])) {
  pithoi_gini[[paste0(i)]] <- ineq(aorist_pithoi_values[[i]],type="Gini")
}


looting<-read.csv("../data/derived_data/looting.csv",header=TRUE)
looting$cluster <- df_prep$cluster[match(looting$tomb,df_prep$tomb)]
looting$cluster[is.na(looting$cluster)]<- "Other"
looting$cluster[looting$cluster<3]<- "Other"
looting$cluster[looting$cluster==3]<- "Group A"
looting$cluster[looting$cluster==4]<- "Group B"

((sum(looting$looted=="Unlooted"))/length(looting$looted))*100


Group_A_loot<-subset(looting,cluster=="Group A")

objects<-read.csv("../data/raw_data/KnossosObjects.csv",header=T)

objects$cluster <- df_prep$cluster[match(objects$tomb,df_prep$tomb)]
objects$cluster[is.na(objects$cluster)]<- "Other"
objects$cluster[objects$cluster<3]<- "Other"
objects$cluster[objects$cluster==3]<- "Group A"
objects$cluster[objects$cluster==4]<- "Group B"

objects$cemetery <- tombs$cem_condensed[match(objects$tomb,tombs$tomb)]
objects<-subset(objects,!is.na(objects$cemetery))

pithoi_gini<-t(pithoi_gini)
pithoi_gini<-data.frame(pithoi_gini)

colnames(pithoi_gini)<-c("gini_coefficient")
row.names(pithoi_gini)<-dates
pithoi_gini<-data.frame(pithoi_gini)
setDT(pithoi_gini, keep.rownames = "decade")
pithoi_gini$decade<-as.numeric(pithoi_gini$decade)

pithoi_gini$type<-"Pithoi"

names(tombs_gini)
rects <- data.frame(xstart = c(1100,970,920,875,840,810,790,745,710,670,630),
                    xend =    c(970,920,875,840,810,790,745,710,670,630,600),
                    xmid =   c(1035,945,897.5,857.5,825,800,767.5,727.5,690,650,615),
                    col = c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))
rects$col<-factor(rects$col,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))


ggplot() +
  geom_line(data = pithoi_gini, aes(decade,gini_coefficient),size=0.5)+
  theme_bw()+theme(text=element_text(family="serif", size=12),
                   panel.grid = element_blank())+
  labs(x="Date (Years BC)", y="Gini Coefficient")+
  scale_fill_brewer(name="Period",palette = "Set3")+ coord_cartesian(
    xlim = c(1100, 600))+ scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  scale_y_continuous(expand=c(0,0.1))



objects$cluster <- df_prep$cluster[match(objects$tomb,df_prep$tomb)]
objects$cluster[is.na(objects$cluster)]<- "Other"
objects$cluster[objects$cluster<3]<- "Other"
objects$cluster[objects$cluster==3]<- "Group A"
objects$cluster[objects$cluster==4]<- "Group B"


ggplot(pots,aes(cluster,import,fill=import_region))+geom_col()
names(pots)
ggplot()+ geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf), fill=NA, colour="grey90",alpha = 0.4) +
  geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = 10, ymax = 11), fill=NA, colour="black",alpha = 0.4) +
  geom_text(data=rects,aes(xmid, 10.5,label=col),family="serif",size=2.5)+
  geom_line(data=KNC_all_import_imitation,aes(decade,aoristic_sum, linetype=origin))+
  theme_bw()+theme(text=element_text(family="serif", size=10), legend.position="bottom",panel.grid = element_blank(),
                   legend.title = element_blank(),plot.margin=unit(c(0.1,1,0.5,1),"cm"))+facet_wrap(~cluster)
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_brewer(name="Origin",palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,11))+
  scale_x_reverse(expand = c(0, 0),limits=c(1000,630))

FOR_imports<-ggplot()+ geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf), fill=NA, colour="grey90",alpha = 0.4) +
  geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = 10, ymax = 11), fill=NA, colour="black",alpha = 0.4) +
  geom_text(data=rects,aes(xmid, 10.5,label=col),family="serif",size=2.5)+
  geom_line(data=FOR_all_import_imitation,aes(decade,aoristic_sum, linetype=origin))+
  theme_bw()+theme(text=element_text(family="serif", size=10), legend.position="bottom", panel.grid = element_blank(),
                   legend.title = element_blank(),plot.margin=unit(c(0.1,1,0.5,1),"cm"))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_brewer(name="Origin",palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,11))+
  scale_x_reverse(expand = c(0, 0),limits=c(1000,630))

ggarrange(KNC_imports,FOR_imports,nrow=2,labels=c("A","B"),common.legend = TRUE,legend="bottom")


```{r imports, fig.dim=c(7,7),dpi=600, fig.align='center',fig.cap="Aoristic sums of imported and 'oriental' imitation vessels through time across both cemeteries, colour-coded by regional origin in the case of imports."}

imports<-subset(pots,pots$import!="")
KNC_greekimports<-subset(imports,imports$import_region=="Greece" & imports$cem_condensed =="KNC")
KNC_NEimports<-subset(imports,imports$import_region=="Near East" & imports$cem_condensed=="KNC")
KNC_imitations<-subset(pots,pots$imitation!=""& pots$cem_condensed=="KNC")

KNC_greekimport_aorist<-colSums(KNC_greekimports[27:76])
KNC_greekimport_aorist<-data.frame(KNC_greekimport_aorist)
colnames(KNC_greekimport_aorist)<-c("aoristic_sum")
row.names(KNC_greekimport_aorist)<-dates
setDT(KNC_greekimport_aorist, keep.rownames = "decade")
KNC_greekimport_aorist$decade<-as.numeric(KNC_greekimport_aorist$decade)

KNC_NEimport_aorist<-colSums(KNC_NEimports[27:76])
KNC_NEimport_aorist<-data.frame(KNC_NEimport_aorist)
colnames(KNC_NEimport_aorist)<-c("aoristic_sum")
row.names(KNC_NEimport_aorist)<-dates
setDT(KNC_NEimport_aorist, keep.rownames = "decade")
KNC_NEimport_aorist$decade<-as.numeric(KNC_NEimport_aorist$decade)

KNC_imitation_aorist<-colSums(KNC_imitations[27:76])
KNC_imitation_aorist<-data.frame(KNC_imitation_aorist)
colnames(KNC_imitation_aorist)<-c("aoristic_sum")
row.names(KNC_imitation_aorist)<-dates
setDT(KNC_imitation_aorist, keep.rownames = "decade")
KNC_imitation_aorist$decade<-as.numeric(KNC_imitation_aorist$decade)

KNC_greekimport_aorist$cem<-"KNC"
KNC_NEimport_aorist$cem<-"KNC"
KNC_imitation_aorist$cem<-"KNC"


#####
FOR_greekimports<-subset(imports,imports$import_region=="Greece" & imports$cem_condensed=="FOR")
FOR_NEimports<-subset(imports,imports$import_region=="Near East" & imports$cem_condensed=="FOR")
FOR_imitations<-subset(pots,pots$imitation!="" & pots$cem_condensed=="FOR")

FOR_greekimport_aorist<-colSums(FOR_greekimports[27:76])
FOR_greekimport_aorist<-data.frame(FOR_greekimport_aorist)
colnames(FOR_greekimport_aorist)<-c("aoristic_sum")
row.names(FOR_greekimport_aorist)<-dates
setDT(FOR_greekimport_aorist, keep.rownames = "decade")
FOR_greekimport_aorist$decade<-as.numeric(FOR_greekimport_aorist$decade)

FOR_NEimport_aorist<-colSums(FOR_NEimports[27:76])
FOR_NEimport_aorist<-data.frame(FOR_NEimport_aorist)
colnames(FOR_NEimport_aorist)<-c("aoristic_sum")
row.names(FOR_NEimport_aorist)<-dates
setDT(FOR_NEimport_aorist, keep.rownames = "decade")
FOR_NEimport_aorist$decade<-as.numeric(FOR_NEimport_aorist$decade)

FOR_imitation_aorist<-colSums(FOR_imitations[27:76])
FOR_imitation_aorist<-data.frame(FOR_imitation_aorist)
colnames(FOR_imitation_aorist)<-c("aoristic_sum")
row.names(FOR_imitation_aorist)<-dates
setDT(FOR_imitation_aorist, keep.rownames = "decade")
FOR_imitation_aorist$decade<-as.numeric(FOR_imitation_aorist$decade)


FOR_greekimport_aorist$cem<-"FOR"
FOR_NEimport_aorist$cem<-"FOR"
FOR_imitation_aorist$cem<-"FOR"

###

KNC_greekimport_aorist$origin<-"Greek Imports"
KNC_NEimport_aorist$origin<-"Near Eastern Imports"
KNC_imitation_aorist$origin<-"'Oriental' Imitations"
FOR_greekimport_aorist$origin<-"Greek Imports"
FOR_NEimport_aorist$origin<-"Near Eastern Imports"
FOR_imitation_aorist$origin<-"'Oriental' Imitations"

KNC_all_import_imitation<-rbind(KNC_greekimport_aorist,KNC_NEimport_aorist,KNC_imitation_aorist)
FOR_all_import_imitation<-rbind(FOR_greekimport_aorist,FOR_NEimport_aorist,FOR_imitation_aorist)

KNC_all_import_imitation$origin<-factor(KNC_all_import_imitation$origin,levels=c("Greek Imports","Near Eastern Imports","'Oriental' Imitations"))
FOR_all_import_imitation$origin<-factor(FOR_all_import_imitation$origin,levels=c("Greek Imports","Near Eastern Imports","'Oriental' Imitations"))

rects <- data.frame(xstart = c(1000,970,920,875,840,810,790,745,710,670,630),
                    xend =    c(970,920,875,840,810,790,745,710,670,630,600),
                    xmid =   c(985,945,897.5,857.5,825,800,767.5,727.5,690,650,615),
                    col = c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))
rects$col<-factor(rects$col,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))

KNC_imports<-ggplot()+ geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf), fill=NA, colour="grey90",alpha = 0.4) +
  geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = 10, ymax = 11), fill=NA, colour="black",alpha = 0.4) +
  geom_text(data=rects,aes(xmid, 10.5,label=col),family="serif",size=2.5)+
  geom_line(data=KNC_all_import_imitation,aes(decade,aoristic_sum, linetype=origin))+
  theme_bw()+theme(text=element_text(family="serif", size=10), legend.position="bottom",panel.grid = element_blank(),
                   legend.title = element_blank(),plot.margin=unit(c(0.1,1,0.5,1),"cm"))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_brewer(name="Origin",palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,11))+
  scale_x_reverse(expand = c(0, 0),limits=c(1000,630))

FOR_imports<-ggplot()+ geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf), fill=NA, colour="grey90",alpha = 0.4) +
  geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = 10, ymax = 11), fill=NA, colour="black",alpha = 0.4) +
  geom_text(data=rects,aes(xmid, 10.5,label=col),family="serif",size=2.5)+
  geom_line(data=FOR_all_import_imitation,aes(decade,aoristic_sum, linetype=origin))+
  theme_bw()+theme(text=element_text(family="serif", size=10), legend.position="bottom", panel.grid = element_blank(),
                   legend.title = element_blank(),plot.margin=unit(c(0.1,1,0.5,1),"cm"))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_brewer(name="Origin",palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,11))+
  scale_x_reverse(expand = c(0, 0),limits=c(1000,630))

ggarrange(KNC_imports,FOR_imports,nrow=2,labels=c("A","B"),common.legend = TRUE,legend="bottom")

imports1<-nrow(subset(pots,pots$group=="B" & pots$import =="Y"))/nrow(subset(pots,pots$group=="B"))*100
imports2<-nrow(subset(pots,pots$group=="C" & pots$import =="Y"))/nrow(subset(pots,pots$group=="C"))*100
imports3<-nrow(subset(pots,pots$group=="A" & pots$import =="Y"))/nrow(subset(pots,pots$group=="A"))*100
groupA7th<-subset(pots,cluster=="Group A" & century=="7th")
groupA7thimports<-(sum(groupA7th$import=="Y")/nrow(groupA7th))*100



```

```{r assem_comps, fig.dim=c(7,4),dpi=600, fig.align='center',fig.cap="The composition of the total pottery assemblage for each century across both cemeteries, and among the 7 notable tombs (Group A) drawn out earlier in the analysis."}

assemblages$cluster <- df_prep$cluster[match(assemblages$tomb,df_prep$tomb)]
assemblages$cluster[is.na(assemblages$cluster)]<- "Other"
assemblages$cluster[assemblages$cluster<3]<- "Other"
assemblages$cluster[assemblages$cluster==3]<- "Group A"
assemblages$cluster[assemblages$cluster==4]<- "Group B"

assemblages_no_pith<-subset(assemblages,material=="Clay" & shape!="Pithos"& shape!="Lid" & century!="13th" & century!="14th")
assemblages_no_pith$century<-factor(assemblages_no_pith$century,levels=c("11th","10th","9th","8th","7th"))


assemcompKNC<-ggplot(subset(assemblages_no_pith,century!="" & cemetery=="NC"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5), axis.title.x = element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.title.align=0.5)+
  labs(y="Proportion of Total Assemblage")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))+guides(fill=guide_legend(title="Century BC",title.position = "top"))

assemcompFOR<-ggplot(subset(assemblages_no_pith,century!="" & cemetery=="FOR"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),axis.title.x = element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.title.align=0.5)+
  labs(y="")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))+guides(fill=guide_legend(title="Century BC",title.position = "top"))

assemcompA<-ggplot(subset(assemblages_no_pith,century!="" & cluster=="Group A" & century!="10th"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),axis.title.x = element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.title.align=0.5)+
  labs(y="")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))+guides(fill=guide_legend(title="Century BC",title.position = "top"))

assemcompB<-ggplot(subset(assemblages_no_pith,century!="" & cluster=="Group B"),aes(century,fill=category))+geom_bar(position="fill")+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),axis.title.x = element_blank(),
                   text=element_text(family="serif", size=11),
                   plot.margin=margin(0.1,0.1,0.1,0.1),legend.title.align=0.5)+
  labs(y="")+
  scale_fill_manual(values=cbPalette)+
  scale_y_continuous(expand=c(0,0.0))+guides(fill=guide_legend(title="Century BC"),title.position = "top")

###

counts <- ddply(assemblages_no_pith, .(assemblages_no_pith$cemetery, assemblages_no_pith$century), nrow)
names(counts) <- c("group", "century", "Freq")
counts<-counts[complete.cases(counts), ]


counts2 <- ddply(assemblages_no_pith, .(assemblages_no_pith$cluster, assemblages_no_pith$century), nrow)
names(counts2) <- c("group", "century", "Freq")
counts2<-counts2[complete.cases(counts2), ]
counts2<-subset(counts2,group=="Group A" |group=="Group B")

assem_counts<-rbind(counts,counts2)
assem_counts$level<-10

assemcompKNC_total<-ggplot(subset(assem_counts,group=="NC"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5), text=element_text(family="serif", size=9),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(assem_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="KNC")

assemcompFOR_total<-ggplot(subset(assem_counts,group=="FOR"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5),text=element_text(family="serif", size=9),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(assem_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="FOR")

assemcompA_total<-ggplot(subset(assem_counts,group=="Group A"&century!="10th"),
                         aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5),text=element_text(family="serif", size=9),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(assem_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="Group A")

assemcompB_total<-ggplot(subset(assem_counts,group=="Group B"),aes(century,level,label=Freq))+geom_text(family="serif",size=3)+
  theme_bw()+theme(plot.title = element_text(hjust=0.5),legend.title = element_blank(),
                   plot.margin=margin(0.1,0.1,0.1,30.5),text=element_text(family="serif", size=9),
                   axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),
                   axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),
                   panel.grid = element_blank())+geom_vline(xintercept = seq(0.5, length(assem_counts$century),
                                                                             by = 1), color="black", size=.5)+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+scale_x_discrete(expand=c(0,0.5))+labs(title="Group B")

ggarrange(ggarrange(assemcompKNC_total,assemcompFOR_total,assemcompA_total,assemcompB_total, ncol=4),ggarrange(assemcompKNC,assemcompFOR,assemcompA,assemcompB, ncol=4,common.legend =TRUE,legend="bottom"),nrow=2,heights=c(1,9),align="hv")



```
