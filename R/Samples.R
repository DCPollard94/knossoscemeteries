```{r aorist_uncertainty, fig.dim = c(7, 4), dpi=300}

aorist_pot_values<-pots[25:74]
aorist_pot_matrix<-data.matrix(aorist_pot_values)
aorist_pot_matrix[aorist_pot_matrix == 0] <- NA
aorist_pot_medians<-apply(aorist_pot_matrix,2,median,na.rm=TRUE)

aorist_pot_medians<-data.frame(aorist_pot_medians)
colnames(aorist_pot_medians)<-c("aoristic_median")
row.names(aorist_pot_medians)<-dates
aorist_pot_medians<-data.frame(aorist_pot_medians)
setDT(aorist_pot_medians, keep.rownames = "decade")
aorist_pot_medians$decade<-as.numeric(aorist_pot_medians$decade)


ggplot(NULL)+geom_col(data=aorist_pot_medians,aes(decade,aoristic_median))+
  xlim(1100,630)+ylim(0,0.3)+theme_minimal()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Median")+
  scale_fill_brewer(palette = "Set2")

```
```{r aoristmedianadjust}

aorist_pot_medians$aoristic_sums<-aorist_all_tombs$aoristic_sum
aorist_pot_medians$aorist_median_adjust<-aorist_pot_medians$aoristic_sums/aorist_pot_medians$aoristic_median


ggplot(NULL)+geom_col(data=aorist_pot_medians,aes(decade,aorist_median_adjust))+
  xlim(1100,630)+theme_minimal()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Median")+
  scale_fill_brewer(palette = "Set2")

```

```{r boxplot,  fig.dim=c(9,5), dpi=300,}

ggplot(tombs,aes(total_finds))+geom_histogram()+xlim(0,200)

aorist_tomb_values<-tombs[c(1,158:207)]
aorist_tomb_values[aorist_tomb_values == 0] <- NA

aorist_tomb_values<-data.frame(aorist_tomb_values)
colnames(aorist_tomb_values)[2:51]<-dates

aorist_melt<-melt(aorist_tomb_values)
aorist_melt$variable<-as.numeric(as.character(aorist_melt$variable))

aorist_melt$period<-ifelse(aorist_melt$variable<=1100 & aorist_melt$variable>=980,"SM",
                           ifelse(aorist_melt$variable<=970 & aorist_melt$variable>=930,"EPG",
                                  ifelse(aorist_melt$variable<=920 & aorist_melt$variable>=880,"MPG",
                                         ifelse(aorist_melt$variable<=870 & aorist_melt$variable>=850,"LPG",
                                                ifelse(aorist_melt$variable<=840 & aorist_melt$variable>=820,"PGB",
                                                       ifelse(aorist_melt$variable<=810 & aorist_melt$variable>=800,"EG",
                                                              ifelse(aorist_melt$variable<=790 & aorist_melt$variable>=750,"MG",
                                                                     ifelse(aorist_melt$variable<=740 & aorist_melt$variable>=720,"LG",
                                                                            ifelse(aorist_melt$variable<=710 & aorist_melt$variable>=680,"EO",
                                                                                   ifelse(aorist_melt$variable<=670 & aorist_melt$variable>=640,"LO",
                                                                                          ifelse(aorist_melt$variable<=630 & aorist_melt$variable>=600,"A",""
                                                                                          )))))))))))

decade_ranges<-seq(from = 600, to = 1100, by = 10)
decade_ranges<-rev(decade_ranges)
decade_ranges<-as.factor(decade_ranges)
aorist_melt$variable<-as.factor(aorist_melt$variable)
aorist_melt$variable<-factor(aorist_melt$variable, levels=(decade_ranges))
aorist_melt$period<-factor(aorist_melt$period,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))
aorist_melt$variable<-as.numeric(as.character(aorist_melt$variable))


ggplot(aorist_melt,aes(variable,value,fill=period,outlier.size=0.1))+geom_boxplot(aes(group = cut_width(variable, 10)),outlier.size=0.8)+theme_bw()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12),
        axis.text.x = element_text(angle = 70, hjust = 1),
        panel.grid.major.x = element_blank())+
  labs(x="Date (Years BC)", y="Aoristic Sums per Tomb")+
  scale_fill_brewer(palette = "Set3")+
  scale_x_reverse()+
  scale_y_continuous()+
  facet_zoom(x=variable<900& variable>640,y=value<20)



ggplot(aorist_melt,aes(variable,value,fill=period,outlier.size=0.3))+geom_boxplot(aes(group = cut_width(variable, 10),outlier.size=0.1))+theme_bw()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12),
        axis.text.x = element_text(angle = 70, hjust = 1),
        panel.grid.major.x = element_blank())+
  labs(x="Date (Years BC)", y="Aoristic Sums per Tomb")+
  scale_fill_brewer(palette = "Set3")+
  scale_x_reverse()+
  scale_y_continuous(limits=c(0,20))+geom_label(data=subset(aorist_melt,value>19),aes(label=tomb))

```
```{r aorist_tomb_adjust}

no_tombs<-colSums(tombs[158:207]!=0)
no_tombs<-data.frame(no_tombs)
colnames(no_tombs)<-c("no_tombs")
row.names(no_tombs)<-dates
no_tombs<-data.frame(no_tombs)
setDT(no_tombs, keep.rownames = "decade")
no_tombs$decade<-as.numeric(no_tombs$decade)

aorist_all_tombs1<-aorist_all_tombs
aorist_by_tomb<-merge(aorist_all_tombs1,no_tombs)

aorist_by_tomb$aorist_by_tomb<-aorist_by_tomb$aoristic_sum/aorist_by_tomb$no_tombs

ggplot(aorist_by_tomb,aes(decade,aorist_by_tomb))+geom_col()+xlim(1100,600)

#Now for the 9th century tombs

tombs_9th<-subset(tombs,tombs$century_built=="9th")
no_tombs_9th<-colSums(tombs_9th[158:207]!=0)

View(tombs_9th)
no_tombs_9th<-data.frame(no_tombs_9th)
colnames(no_tombs_9th)<-c("no_tombs")
row.names(no_tombs_9th)<-dates
no_tombs_9th<-data.frame(no_tombs_9th)
setDT(no_tombs_9th, keep.rownames = "decade")
no_tombs_9th$decade<-as.numeric(no_tombs_9th$decade)

aorist_tombs_9th<-colSums(tombs_9th[158:207])
aorist_tombs_9th<-data.frame(aorist_tombs_9th)
colnames(aorist_tombs_9th)<-c("aoristic_sum")
row.names(aorist_tombs_9th)<-dates
aorist_tombs_9th<-data.frame(aorist_tombs_9th)
setDT(aorist_tombs_9th, keep.rownames = "decade")
aorist_tombs_9th$decade<-as.numeric(aorist_tombs_9th$decade)

aorist_by_tomb_9th<-merge(aorist_tombs_9th,no_tombs_9th)
aorist_by_tomb_9th$aorist_by_tomb<-aorist_by_tomb_9th$aoristic_sum/aorist_by_tomb_9th$no_tombs

ggplot()+geom_col(data=aorist_by_tomb_9th,aes(decade,aorist_by_tomb,fill="9th Century Tombs"))+
  geom_col(data=aorist_by_tomb,aes(decade,aorist_by_tomb, fill="All Tombs"),alpha=0.7)+
  xlim(1100,600)+theme_minimal()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Density/Number of Tombs Represented")+
  scale_fill_brewer(palette = "Set2")

names(tombs)
tombs_in_use<-colSums(tombs[6:15]!="")
tombs_in_use<-data.frame(tombs_in_use)
colnames(tombs_in_use)<-c("no_tombs")
tombs_in_use<-data.frame(tombs_in_use)
setDT(tombs_in_use, keep.rownames = "period")
tombs_in_use$period<-factor(tombs_in_use$period,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO"))


ggplot(no_tombs_9th,aes(decade,no_tombs, fill="Tombs in Use"))+geom_col()+theme_classic()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  xlim(1100,600)+
  labs(x="Date (Years BC)", y="Number of Tombs in Use")+
  scale_fill_brewer(palette = "Set2")

ggplot(tombs_in_use,aes(period,no_tombs, fill="Tombs in Use"))+geom_col()+theme_classic()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  labs(x="Period", y="Number of Tombs in Use")+
  scale_fill_brewer(palette = "Set2")

ggplot(tombs,aes(start_period, fill=tomb_type_condensed))+geom_bar()+theme_classic()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  labs(x="Period", y="Number of New Tombs")+
  scale_fill_brewer(palette = "Set2")



``````{r rates of burials}

tombs_ranked<-tombs[with(tombs, order(-tombs$total_pottery)), ]
tombs_top_12<-head(tombs_ranked,12)

tombs_top_12$tomb

no_tombs_top<-colSums(tombs_top_12[158:207]!=0)

no_tombs_top<-data.frame(no_tombs_top)
colnames(no_tombs_top)<-c("no_tombs")
row.names(no_tombs_top)<-dates
no_tombs_top<-data.frame(no_tombs_top)
setDT(no_tombs_top, keep.rownames = "decade")
no_tombs_top$decade<-as.numeric(no_tombs_top$decade)


aorist_tombs_top<-colSums(tombs_top_12[158:207])
aorist_tombs_top<-data.frame(aorist_tombs_top)
colnames(aorist_tombs_top)<-c("aoristic_sum")
row.names(aorist_tombs_top)<-dates
aorist_tombs_top<-data.frame(aorist_tombs_top)
setDT(aorist_tombs_top, keep.rownames = "decade")
aorist_tombs_top$decade<-as.numeric(aorist_tombs_top$decade)


aorist_by_tomb_top<-merge(aorist_tombs_top,no_tombs_top)
aorist_by_tomb_top$aorist_by_tomb<-aorist_by_tomb_top$aoristic_sum/aorist_by_tomb_top$no_tombs


ggplot()+geom_col(data=aorist_by_tomb_top,aes(decade,aorist_by_tomb,fill="12 Largest Tombs"))+
  geom_col(data=aorist_by_tomb,aes(decade,aorist_by_tomb, fill="All Tombs"),alpha=0.7)+
  xlim(1100,600)+theme_minimal()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Density/Number of Tombs Represented")+
  scale_fill_brewer(palette = "Set2")

```

imports1<-ggplot(imports,aes(tomb_century,ave_date,fill=tomb_century))+geom_boxplot()+
  theme_bw()+theme(plot.title = element_text(hjust=0.5), legend.position = "none",
                   text=element_text(family="Garamond", size=12))+
  labs(title="All Imports",x="", y="Average Import Date (Years BC)")+
  scale_fill_brewer(palette = "Set2")+scale_y_continuous(expand=c(0,10),limits=c(600,1000))
imports2<-ggplot(data=subset(imports,import_region=="Greece"),aes(tomb_century,ave_date,fill=tomb_century))+geom_boxplot()+
  theme_bw()+theme(plot.title = element_text(hjust=0.5), legend.position = "none",
                   text=element_text(family="Garamond", size=12))+
  labs(title="Greek Imports",x="Century of Tomb Construction", y="")+
  scale_fill_brewer(palette = "Set2")+scale_y_continuous(expand=c(0,10),limits=c(600,1000))
imports3<-ggplot(data=subset(imports,import_region=="Near East"),aes(tomb_century,ave_date,fill=tomb_century))+geom_boxplot()+
  theme_bw()+theme(plot.title = element_text(hjust=0.5), legend.position = "none",
                   text=element_text(family="Garamond", size=12))+
  labs(title="Near Eastern Imports",x="", y="")+
  scale_fill_brewer(palette = "Set2")+scale_y_continuous(expand=c(0,10),limits=c(600,1000))

ggarrange(imports1,imports2,imports3,ncol=3,label.x = 1)

```{r}

imitations<-subset(pots,imitation!="")

imitation_aorist<-colSums(imitations[27:76])
imitation_aorist<-data.frame(imitation_aorist)
colnames(imitation_aorist)<-c("aoristic_sum")
row.names(imitation_aorist)<-dates
setDT(imitation_aorist, keep.rownames = "decade")
imitation_aorist$decade<-as.numeric(imitation_aorist$decade)

ggplot(imitation_aorist,aes(decade,aoristic_sum))+geom_col()
```

```{r boxplot,  fig.dim=c(7,4), dpi=300,}


ggplot(tombs,aes(group,total_pottery,fill=group))+geom_col()

aorist_tomb_values<-tombs[c(1,158:207)]
aorist_tomb_values[aorist_tomb_values == 0] <- NA

aorist_tomb_values<-data.frame(aorist_tomb_values)
colnames(aorist_tomb_values)[2:51]<-dates

aorist_melt<-melt(aorist_tomb_values)
aorist_melt$variable<-as.numeric(as.character(aorist_melt$variable))

aorist_melt$period<-ifelse(aorist_melt$variable<=1100 & aorist_melt$variable>=980,"SM",
                           ifelse(aorist_melt$variable<=970 & aorist_melt$variable>=930,"EPG",
                                  ifelse(aorist_melt$variable<=920 & aorist_melt$variable>=880,"MPG",
                                         ifelse(aorist_melt$variable<=870 & aorist_melt$variable>=850,"LPG",
                                                ifelse(aorist_melt$variable<=840 & aorist_melt$variable>=820,"PGB",
                                                       ifelse(aorist_melt$variable<=810 & aorist_melt$variable>=800,"EG",
                                                              ifelse(aorist_melt$variable<=790 & aorist_melt$variable>=750,"MG",
                                                                     ifelse(aorist_melt$variable<=740 & aorist_melt$variable>=720,"LG",
                                                                            ifelse(aorist_melt$variable<=710 & aorist_melt$variable>=680,"EO",
                                                                                   ifelse(aorist_melt$variable<=670 & aorist_melt$variable>=640,"LO",
                                                                                          ifelse(aorist_melt$variable<=630 & aorist_melt$variable>=600,"A",""
                                                                                          )))))))))))

decade_ranges<-seq(from = 600, to = 1100, by = 10)
decade_ranges<-rev(decade_ranges)
decade_ranges<-as.factor(decade_ranges)
aorist_melt$variable<-as.factor(aorist_melt$variable)
aorist_melt$variable<-factor(aorist_melt$variable, levels=(decade_ranges))
aorist_melt$period<-factor(aorist_melt$period,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))
aorist_melt$variable<-as.numeric(as.character(aorist_melt$variable))



ggplot(aorist_melt,aes(variable,value,fill=period,outlier.size=0.3))+geom_boxplot(aes(group = cut_width(variable, 10)))+theme_bw()+
  theme(legend.title=element_blank(),
        text=element_text(family="Garamond", size=12),
        axis.text.x = element_text(angle = 70, hjust = 1),
        panel.grid.major.x = element_blank())+
  labs(x="Date (Years BC)", y="Aoristic Sums per Tomb")+
  scale_fill_brewer(palette = "Set3")+
  scale_x_reverse(expand=c(0,0))+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))

tombs$century_built<-factor(tombs$century_built,levels=c("11th","10th","9th","8th","7th"))
ggplot(tombs,aes(start_period,total_import))+geom_boxplot()

imports<-subset(pots,pots$import!="")
greekimports<-subset(imports,imports$import_region=="Greece")
NEimports<-subset(imports,imports$import_region=="Near East")

import_aorist<-colSums(imports[27:76])
import_aorist<-data.frame(import_aorist)
colnames(import_aorist)<-c("aoristic_sum")
row.names(import_aorist)<-dates
setDT(import_aorist, keep.rownames = "decade")
import_aorist$decade<-as.numeric(import_aorist$decade)

greekimport_aorist<-colSums(greekimports[27:76])
greekimport_aorist<-data.frame(greekimport_aorist)
colnames(greekimport_aorist)<-c("aoristic_sum")
row.names(greekimport_aorist)<-dates
setDT(greekimport_aorist, keep.rownames = "decade")
greekimport_aorist$decade<-as.numeric(greekimport_aorist$decade)

NEimport_aorist<-colSums(NEimports[27:76])
NEimport_aorist<-data.frame(NEimport_aorist)
colnames(NEimport_aorist)<-c("aoristic_sum")
row.names(NEimport_aorist)<-dates
setDT(NEimport_aorist, keep.rownames = "decade")
NEimport_aorist$decade<-as.numeric(NEimport_aorist$decade)

greekimport_aorist$origin<-"Greece"
NEimport_aorist$origin<-"Near East"
allimport_aorist<-rbind(greekimport_aorist,NEimport_aorist)
View(allimport_aorist)

ggplot()+geom_col(data=import_aorist,aes(decade,aoristic_sum),alpha=0.2)+
  geom_col(data=allimport_aorist,aes(decade,aoristic_sum, fill=origin),position="dodge")+
  theme_bw()+theme(legend.title=element_blank(),
                   text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  scale_fill_brewer(palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,20))+
  scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

tombs$start_period<-factor(tombs$start_period,levels=c("SM", "EPG", "MPG", "PG","LPG", "PGB", "EG", "MG","G", "LG", "EO","O","LO"))
ggplot(data=subset(tombs,total_import>0),aes(start_period,total_import))+geom_boxplot()
imports_ranked<-tombs[with(tombs, order(-tombs$total_import)), ]
imports_top_12_tombs<-as.vector(head(imports_ranked$tomb,12))
imports_top_12<-imports[is.element(imports$tomb, imports_top_12_tombs),]

cols1<-c(3,27:76)
top_aorist_imports<-imports_top_12[,cols1]
top_aorist_imports<-data.frame(top_aorist_imports)
top_aorist_imports<-aggregate(top_aorist_imports[,2:51], by=list(top_aorist_imports$tomb), FUN=sum)
colnames(top_aorist_imports)<-c("tomb",dates)
top_aorist_imports_melt<-melt(top_aorist_imports)
top_aorist_imports_melt$variable<-as.numeric(as.character(top_aorist_imports_melt$variable))
top_aorist_imports_melt$tomb<-factor(top_aorist_imports_melt$tomb,levels=imports_top_12_tombs)


ggplot(top_aorist_imports_melt,aes(variable, value))+geom_col()+theme(legend.position = "none")+facet_wrap(~tomb)+
  geom_col()+theme_bw()+theme(legend.title=element_blank(),
                              text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sums")+
  scale_fill_brewer(palette = "Set3")+
  theme(legend.position="none")+
  coord_cartesian(xlim=c(1100,610))+scale_y_continuous()+
  scale_x_reverse(expand = c(0, 0),limits=c(1100,610))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

```
polychrome<-pithoi[pithoi$additional %like% "Polychrome",]
View(polychrome)

ggplot(subset(tombs,polychrome_pithoi>0), aes(polychrome_pithoi/est_burials,fill=group))+geom_histogram()
polychrome$group<-ifelse(polychrome$tomb=="P"|polychrome$tomb=="292"|polychrome$tomb=="75"|polychrome$tomb=="107"|polychrome$tomb=="285"|polychrome$tomb=="II"|polychrome$tomb=="218","A","B")
tombs$group<-ifelse(tombs$tomb=="P"|tombs$tomb=="292"|tombs$tomb=="75"|tombs$tomb=="107"|tombs$tomb=="285"|tombs$tomb=="II"|tombs$tomb=="218","A","B")

groupA<-subset(pots, group=="A" & century=="7th")
groupB<-subset(pots, group=="B" & century=="7th")
ggplot(groupB,aes(century,fill=polychrome))+geom_bar(position="fill")

pots$polychrome <- ifelse(grepl("olychrome",pots$additional), "Polychrome", "Other")

count(groupB$polychrome)
122/811*100
66/561*100

pots$group<-ifelse(pots$tomb=="P"|pots$tomb=="292"|pots$tomb=="75"|pots$tomb=="107"|pots$tomb=="285"|pots$tomb=="II"|pots$tomb=="218","A",
                   ifelse(pots$tomb=="X"|pots$tomb=="G"|pots$tomb=="104"|pots$tomb=="Q"|pots$tomb=="283","B","C"))

imports<-subset(pots,import!="")
imports_A<-subset(imports,group=="A")
imports_B<-subset(imports,group=="B")
imports_C<-subset(imports,group=="C")

import_A_aorist<-colSums(imports_A[27:76])
import_A_aorist<-data.frame(import_A_aorist)
colnames(import_A_aorist)<-c("aoristic_sum")
row.names(import_A_aorist)<-dates
setDT(import_A_aorist, keep.rownames = "decade")
import_A_aorist$decade<-as.numeric(import_A_aorist$decade)

import_A_aorist$group<-"A"
import_A_aorist$aoristic_sum<-import_A_aorist$aoristic_sum/7

import_B_aorist<-colSums(imports_B[27:76])
import_B_aorist<-data.frame(import_B_aorist)
colnames(import_B_aorist)<-c("aoristic_sum")
row.names(import_B_aorist)<-dates
setDT(import_B_aorist, keep.rownames = "decade")
import_B_aorist$decade<-as.numeric(import_B_aorist$decade)

import_B_aorist$group<-"B"
import_B_aorist$aoristic_sum<-import_B_aorist$aoristic_sum/5

import_C_aorist<-colSums(imports_C[27:76])
import_C_aorist<-data.frame(import_C_aorist)
colnames(import_C_aorist)<-c("aoristic_sum")
row.names(import_C_aorist)<-dates
setDT(import_C_aorist, keep.rownames = "decade")
import_C_aorist$decade<-as.numeric(import_C_aorist$decade)

import_C_aorist$group<-"C"
import_C_aorist$aoristic_sum<-import_C_aorist$aoristic_sum/35

imports_C$tomb

aorist_import_groups<-rbind(import_A_aorist,import_B_aorist,import_C_aorist)

ggplot(aorist_import_groups,aes(decade,aoristic_sum,fill=group))+ geom_col(position="dodge")+
  theme_bw()+theme(legend.position="bottom",text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  guides(fill=guide_legend(title="Group"))+
  scale_fill_brewer(palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,1.5))+
  scale_x_reverse(expand = c(0, 0),limits=c(1000,600))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

ggplot(data=subset(imports,import_region!=""),aes(import_region))+geom_bar()+facet_grid(~group)

names(imports)

imitations<-subset(pots,pots$imitation!="")
imitation_aorist<-colSums(imitations[27:76])
imitation_aorist<-data.frame(imitation_aorist)
colnames(imitation_aorist)<-c("aoristic_sum")
row.names(imitation_aorist)<-dates
setDT(imitation_aorist, keep.rownames = "decade")
imitation_aorist$decade<-as.numeric(imitation_aorist$decade)

ggplot(imitations,aes(group))+geom_bar()

tombs$group<-ifelse(tombs$tomb=="P"|tombs$tomb=="292"|tombs$tomb=="75"|tombs$tomb=="107"|tombs$tomb=="285"|tombs$tomb=="II"|tombs$tomb=="218","A",
                   ifelse(tombs$tomb=="X"|tombs$tomb=="G"|tombs$tomb=="104"|tombs$tomb=="Q"|tombs$tomb=="283","B","C"))
TombsB<-subset(tombs,tombs$group=="B")
ggplot(subset(pots),aes(group, fill=imitation))+geom_bar(position="fill")+facet_wrap(~century)
ggplot(subset(imports,tomb=="G"),aes(import_region))+geom_bar()+facet_wrap(~century)
