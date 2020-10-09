tombs_ranked<-tombs[with(tombs, order(-tombs$total_pottery)), ]
tombs_top_20<-head(tombs_ranked,20)
top20<-as.vector(tombs_top_20$tomb)
pots_top_20<-pots[is.element(pots$tomb, top20),]
pots_top_20$tomb<-factor(pots_top_20$tomb,levels=top20)

cols<-c(1,158:207)
aorist_all_tomb_names<-tombs_top_20[,cols]
aorist_all_tomb_names<-data.frame(aorist_all_tomb_names)
colnames(aorist_all_tomb_names)<-c("tomb",dates)

aorist_all_tomb_melt<-melt(aorist_all_tomb_names)
aorist_all_tomb_melt$variable<-as.numeric(as.character(aorist_all_tomb_melt$variable))


top_20<-tombs_top_20$tomb
aorist_all_tomb_melt$tomb<-factor(aorist_all_tomb_melt$tomb,levels=top_20)


ggplot(aorist_all_tomb_melt,aes(variable, value))+geom_col()+theme(legend.position = "none")+facet_wrap(~tomb,scales="free_y")+
  geom_col()+theme_bw()+theme(legend.title=element_blank(),
                              text=element_text(family="Garamond", size=20))+
  labs(x="Date (Years BC)", y="Aoristic Sums")+
  scale_fill_brewer(palette = "Set3")+
  theme(legend.position="none")+
  coord_cartesian(xlim=c(1100,610))+scale_y_continuous()+
  scale_x_reverse(expand = c(0, 0),limits=c(1100,610))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

View(tombs_9th_aorist)
tombs_9th_aorist<-rowSums(tombs_9th[,178:187])
tombs_9th_aorist<-data.frame(tombs_9th_aorist)
row.names(tombs_9th_aorist)<-tombs_9th$tomb
tombs_9th$aorist<-tombs_9th_aorist$tombs_9th_aorist

ggplot(subset(tombs_9th,tombs_9th$est_burials>1),aes(chamber_area,aorist,color=cem_condensed))+geom_point()+
  theme_bw()+theme(legend.title=element_blank(),text=element_text(family="Garamond", size=12))+
  labs(x=bquote('Chamber Area ('*m^2*')'), y="Estimated Total Burials")+
  scale_color_brewer(palette = "Set2",labels=c(" KNC  "," Fortetsa"))+
  scale_x_continuous(expand=c(0,0),limits=c(0,10))+
  scale_y_continuous(expand=c(0,0),limits=c(0,50))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

tomb_chambers<-subset(tombs,chamber_area>0)
tomb_chambers[tomb_chambers == 0] <- NA

chamber_cors<-matrix(0, ncol = 0, nrow = 1)
chamber_cors<-data.frame(chamber_cors)


for(i in colnames(tomb_chambers[158:207])) {
  chamber_cors[[paste0(i)]] <- cor(tomb_chambers$chamber_area,tomb_chambers[[i]],method="spearman",
                                   use="complete.obs")
}
View(chamber_cors)
colnames(chamber_cors)<-dates

chamber_cors<-melt(chamber_cors)
chamber_cors$variable<-as.numeric(as.character(chamber_cors$variable))

ggplot(chamber_cors,aes(variable,value))+geom_line()+
  scale_x_reverse(limit=c(1100,640))


aorist_KNC_pithoibyall<-aorist_KNC_pithoi$aoristic_sum/aorist_KNC$aoristic_sum
aorist_KNC_pithoibyall<-data.frame(aorist_KNC_pithoibyall)
row.names(aorist_KNC_pithoibyall)<-dates
setDT(aorist_KNC_pithoibyall, keep.rownames = "decade")
aorist_KNC_pithoibyall$decade<-as.numeric(aorist_KNC_pithoibyall$decade)
View(aorist_KNC_pithoibyall)
ggplot(data=subset(pots,pots$height>0 & pots$shape=="Oinochoe"),aes(century,height,fill=century))+geom_boxplot()

ggplot(data=subset(pots,type!="Other"),aes(diameter,height, color=century))+geom_point()+facet_wrap(~type,scales="free_y")

objects<-read.csv("../data/raw_data/KnossosObjects.csv",header=TRUE)

objects$group<-ifelse(objects$tomb=="P"|objects$tomb=="292"|objects$tomb=="75"|objects$tomb=="107"|objects$tomb=="285"|objects$tomb=="II"|objects$tomb=="218","A",
                     ifelse(objects$tomb=="X"|objects$tomb=="G"|objects$tomb=="219"|objects$tomb=="Q"|objects$tomb=="283","B","C"))
ggplot(objects,aes(category,fill=group))+geom_bar()
ggplot(subset(objects,category=="Weapon"),aes(tomb,fill=group))+geom_bar()
names(objects)

ggplot(subset(imports,century!="NA"))+geom_bar(aes(tomb,fill=group))+facet_grid(~century,scales="free_x")

tomb_rank_names<-as.vector(tombs_ranked$tomb)
pots$tomb<-factor(pots$tomb,levels=tomb_rank_names)


ggplot(subset(tombs,est_burials>1 & cooking>0),aes(cooking/est_burials, fill=group))+geom_histogram()+
  theme_bw()+theme(legend.title=element_blank(),
                   text=element_text(family="Garamond", size=12))+
  labs(x="Total Non-Ceramics/Burials", y="Number of Tombs")+
  scale_fill_brewer(palette = "Set2",labels=c(" Group A  ", " Other Tombs"))+
  scale_y_continuous(expand=c(0,0))+scale_x_continuous(expand=c(0,0))

antiques<-subset(pots,antique!="")
ggplot(antiques,aes(tomb,fill=group))+geom_bar()
levels(pots$type)

ggplot(data=subset(pots,import!="" & century!="NA"),aes(tomb,fill=import_region))+
  geom_bar()+facet_wrap(~century,scales="free_x")

ggplot()+geom_point(data=subset(pots,import!="" & type=="Oil vessel"),aes(diameter,height,color="imports",shape=shape))+
    geom_point(data=subset(pots,imitation!="" & type=="Oil vessel"),aes(diameter,height,color="imitations",shape=shape))+xlim(0,12)

groupAcups<-subset(pots,group=="A" & type=="Drinking vessel")
gini_imports<-merge(tombs_gini,import_aorist)

import_aorist<-colSums(imports[27:76])
import_aorist<-data.frame(import_aorist)
colnames(import_aorist)<-c("aoristic_sum")
row.names(import_aorist)<-dates
setDT(import_aorist, keep.rownames = "decade")
import_aorist$decade<-as.numeric(import_aorist$decade)

gini_import<-merge(imports_gini,import_aorist)
ggplot(data=subset(gini_aorist_sub,period!="A"),aes(aoristic_sum,gini_coefficient,color=period))+geom_point(size=2)+scale_color_brewer(palette="Set3")+
  theme_bw()+theme(legend.title=element_blank(),
                   text=element_text(family="Garamond", size=12))
import_aorist_tomb[import_aorist_tomb == 0] <- NA

gini_aorist[gini_aorist == "NaN"] <- 0
cor(gini_import_pos$gini_coefficient,gini_aorist$aoristic_sum,method="spearman")
gini_import_pos<-subset(gini_import,gini_import$gini_coefficient>0)

gini_aorist<-merge(tombs_gini,aorist_all_tombs)

import_aorist_tomb<-data.frame(import_aorist_tomb)
colnames(import_aorist_tomb)[2:51]<-dates

chisq.test(gini_import_pos)
cor(gini_import_pos$gini_coefficient,gini_import_pos$aoristic_sum)


imports_gini<-matrix(0, ncol = 0, nrow = 1)
imports_gini<-data.frame(imports_gini)
for(i in colnames(import_aorist_tomb[2:51])) {
  imports_gini[[paste0(i)]] <- ineq(import_aorist_tomb[[i]],type="Gini")
}

View(gini_import_pos)

imports_gini<-t(imports_gini)
imports_gini<-data.frame(imports_gini)

colnames(imports_gini)<-c("gini_coefficient")
row.names(imports_gini)<-dates
imports_gini<-data.frame(imports_gini)
setDT(imports_gini, keep.rownames = "decade")
imports_gini$decade<-as.numeric(imports_gini$decade)


rects <- data.frame(xstart = c(1100,970,920,875,840,810,790,745,700,670,630),
                    xend = c(970,920,875,840,810,790,745,710,670,630,600),
                    col = c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))
rects$col<-factor(rects$col,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))
gini_aorist$period<-factor(gini_aorist$period,levels=c("SM", "EPG", "MPG", "LPG", "PGB", "EG", "MG", "LG", "EO", "LO","A"))

periods1<-c("A","A","A","LO","LO","LO","LO","EO","EO","EO","EO","LG","LG","LG","LG","MG","MG","MG","MG","EG","EG","PGB","PGB","PGB","LPG",
    "LPG","LPG","LPG","MPG","MPG","MPG","MPG","EPG","EPG","EPG","EPG","EPG","SM","SM","SM")

gini_aorist$period<-periods1
gini_aorist_sub<-subset(gini_aorist,decade<1000)

ggplot() +
  geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf, fill = col), alpha = 0.4) +
  geom_line(data = imports_gini, aes(decade,gini_coefficient),size=0.5)+
  theme_bw()+theme(text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Gini Coefficient")+
  scale_fill_brewer(name="Period",palette = "Set3")+ coord_cartesian(
    xlim = c(1100, 600), ylim = c(0.2,0.65))+ scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  scale_y_continuous(expand=c(0,0))

cols2<-27:76
total<-sapply(levels(imports$tomb),function(x){sum(imports[,cols2][imports$tomb])},USE.NAMES=F)

import_aorist_tomb<-aggregate(imports[,27:76], by=list(tomb=imports$tomb), FUN=sum)
notimports<-subset(pots,import!="Y")
background_aorist_tomb<-aggregate(notimports[,27:76], by=list(tomb=notimports$tomb), FUN=sum)
tombs_with_imports<-as.vector(import_aorist_tomb$tomb)
View(aorist_background)
tombsnoimports<-subset(tombs,tombs$total_import=="0")

aorist_background<-background_aorist_tomb[background_aorist_tomb$tomb %in% tombsnoimports$tomb, ]

import_aorist_and_not<-rbind(import_aorist_tomb,aorist_background)
aorist_background[aorist_background != 0] <- 0
import_aorist_tomb[import_aorist_tomb == 0] <- NA
import_aorist_and_not<-import_aorist_and_not[-c(2:11)]
View(import_aorist_and_not)


imports_gini<-matrix(0, ncol = 0, nrow = 1)
imports_gini<-data.frame(imports_gini)
for(i in colnames(import_aorist_and_not[2:41])) {
  imports_gini[[paste0(i)]] <- ineq(import_aorist_and_not[[i]],type="Gini")
}

View(gini_import_pos)

imports_gini<-t(imports_gini)
imports_gini<-data.frame(imports_gini)

colnames(imports_gini)<-c("gini_coefficient")
dates1<-seq(from = 1000, to = 610, by = -10)
row.names(imports_gini)<-dates1
imports_gini<-data.frame(imports_gini)
setDT(imports_gini, keep.rownames = "decade")
imports_gini$decade<-as.numeric(imports_gini$decade)
View(imports_gini)

ggplot() +
  geom_rect(data = rects, aes(xmin = xstart, xmax = xend, ymin = -Inf, ymax = Inf, fill = col), alpha = 0.4) +
  geom_line(data = imports_gini, aes(decade,gini_coefficient),size=0.5)+
  theme_bw()+theme(text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Gini Coefficient")+
  scale_fill_brewer(name="Period",palette = "Set3")+ coord_cartesian(
    xlim = c(1100, 600), ylim = c(0.2,1))+ scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  scale_y_continuous(expand=c(0,0))

import_aorist1<-subset(import_aorist,decade<1010)
import_gini_comp<-merge(imports_gini,import_aorist1)
import_gini_comp<-subset(import_gini_comp,decade>630)

gini_import<-merge(imports_gini,import_aorist)
ggplot(data=subset(import_gini_comp),aes(aoristic_sum,gini_coefficient,color=period))+geom_point(size=2)+scale_color_brewer(palette="Set3")+
  theme_bw()+theme(legend.title=element_blank(),
                   text=element_text(family="Garamond", size=12))
cor.test(gini_aorist_fin$gini_coefficient,gini_aorist_fin$aoristic_sum,method="spearman")
chisq.test(import_gini_comp[,2:3])
gini_aorist_fin<-subset(gini_aorist_sub,period!="A")

import_aorist_tomb<-aggregate(imports[,27:76], by=list(tomb=imports$tomb), FUN=sum)
names()

ggplot(pots,aes(group,fill=import))+geom_bar(position="fill")

(sum(pots$group=="A" & pots$import !=""))/(sum(pots$group=="A"))*100
nrow(subset(pots,pots$group=="B" & pots$import =="Y"))/nrow(subset(pots,pots$group=="B"))*100
nrow(subset(pots,pots$group=="A" & pots$import =="Y"))/nrow(subset(pots,pots$group=="A"))*100
nrow(subset(pots,pots$group=="C" & pots$import =="Y"))/nrow(subset(pots,pots$group=="C"))*100

ggplot(subset(imports,century!=""),aes(tomb,fill=group))+geom_bar()+facet_wrap(~century,scales="free_x")


import_aorist$count<-colSums(import_aorist_tomb[,2:51] !=0)
ggplot(data=import_aorist)+geom_line(aes(decade,aoristic_sum))+geom_line(aes(decade,count))+scale_x_reverse()

```{r importsgroups, fig.dim=c(8,4),dpi=300, fig.align='center',fig.cap="Insert Figure 15 here"}

pots$group<-ifelse(pots$tomb=="P"|pots$tomb=="292"|pots$tomb=="75"|pots$tomb=="107"|pots$tomb=="285"|pots$tomb=="II"|pots$tomb=="218","A",
                   ifelse(pots$tomb=="X"|pots$tomb=="G"|pots$tomb=="219"|pots$tomb=="Q"|pots$tomb=="283","B","C"))

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

import_B_aorist<-colSums(imports_B[27:76])
import_B_aorist<-data.frame(import_B_aorist)
colnames(import_B_aorist)<-c("aoristic_sum")
row.names(import_B_aorist)<-dates
setDT(import_B_aorist, keep.rownames = "decade")
import_B_aorist$decade<-as.numeric(import_B_aorist$decade)

import_B_aorist$group<-"B"

import_C_aorist<-colSums(imports_C[27:76])
import_C_aorist<-data.frame(import_C_aorist)
colnames(import_C_aorist)<-c("aoristic_sum")
row.names(import_C_aorist)<-dates
setDT(import_C_aorist, keep.rownames = "decade")
import_C_aorist$decade<-as.numeric(import_C_aorist$decade)

import_C_aorist$group<-"C"

aorist_import_groups<-rbind(import_A_aorist,import_B_aorist,import_C_aorist)

ggplot(aorist_import_groups,aes(decade,aoristic_sum,fill=group))+ geom_col(position="dodge")+
  theme_bw()+theme(legend.position="bottom",text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sum")+
  guides(fill=guide_legend(title="Group"))+
  scale_fill_brewer(palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,12))+
  scale_x_reverse(expand = c(0, 0),limits=c(1000,600))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))

```

In Figure \@ref(fig:importsgroups), it is apparent not only that a range of tombs benefitted from the increase in imports in the LPG-EG periods, but that there was also potentially significant patterning in where those artefacts ended up. The Group A and B tombs trace quite different paths, even echoing those of Greek and Near Eastern imports more generally - indeed, tombs Q and G contained only Greek imports - while across all other tombs ('Group C'), there was no doubt variegation not observable here. This period is often charactersied as one of 'strategies' of mortuary display employed by a variety of elite groups, and this certainly accords with these observed trends; certain artefact types cluster in particular tombs, but with many engaging in some form with the deposition of, presumably valuable, items from overseas.

tombs$group<-ifelse(tombs$tomb=="P"|tombs$tomb=="292"|tombs$tomb=="75"|tombs$tomb=="107"|tombs$tomb=="285"|tombs$tomb=="II"|tombs$tomb=="218","A",
                   ifelse(tombs$tomb=="X"|tombs$tomb=="G"|tombs$tomb=="219"|tombs$tomb=="Q"|tombs$tomb=="283","B","C"))

GroupA<-subset(tombs,group=="A")

aorist_GroupA <- colSums(GroupA[158:207])
aorist_GroupA<-data.frame(aorist_GroupA)

colnames(aorist_GroupA)<-c("aoristic_sum")
row.names(aorist_GroupA)<-dates
aorist_GroupA<-data.frame(aorist_GroupA)
setDT(aorist_GroupA, keep.rownames = "decade")
aorist_GroupA$decade<-as.numeric(aorist_GroupA$decade)

aorist_GroupA$group<-"A"

GroupB<-subset(tombs,tombs$group=="B")

aorist_GroupB <-colSums(GroupB[158:207])
aorist_GroupB<-data.frame(aorist_GroupB)

colnames(aorist_GroupB)<-c("aoristic_sum")
row.names(aorist_GroupB)<-dates
aorist_GroupB<-data.frame(aorist_GroupB)
setDT(aorist_GroupB, keep.rownames = "decade")
aorist_GroupB$decade<-as.numeric(aorist_GroupB$decade)

aorist_GroupB$group<-"B"

aorist_groups<-rbind(aorist_GroupA,aorist_GroupB)

ggplot(aorist_groups,aes(decade,aoristic_sum,fill=group))+geom_col(position="dodge")+
  theme_bw()+theme(text=element_text(family="Garamond", size=12))+
  scale_fill_brewer(palette = "Set2")+scale_x_reverse()

ggplot(tombs, aes(tombs$chamber_area,tombs$dromos_length,color=century_built,label=tomb))+geom_point()+geom_label()

ggplot(subset(pithoi,century=="9th"),aes(height,rim_diameter,color=additional))+geom_point(size=3)

ggplot(pots, aes(group,fill=import))+geom_bar(position="fill")+facet_wrap(~century)
names(tombs)

ggplot(NULL)+

  geom_col(data=aorist_KNC,aes(decade,aoristic_sum,fill=" KNC  "))+

  theme_bw()+theme(legend.title=element_blank(),
                   text=element_text(family="Garamond", size=12))+
  labs(x="Date (Years BC)", y="Aoristic Sum (All Vessels)")+
  scale_fill_brewer(palette = "Set2")+
  scale_y_continuous(expand=c(0,0),limits=c(0,225))+
  scale_x_reverse(expand = c(0, 0),limits=c(1100,600))+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),"cm"))
