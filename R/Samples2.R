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
ggplot(aorist_KNC_pithoibyall,aes(decade,aorist_KNC_pithoibyall))+geom_col()
