##############################################################################/
##############################################################################/
#R code for the Drosophila suzukii pesticide resistance: Experiment 4
##############################################################################/
##############################################################################/

source("droso_data_load.R")


##############################################################################/
#What is the effect of number of flies used for a test on LD50 evaluation?####
##############################################################################/

#we select the data of phosmet test with the St Foy population
numberdata<-dataDroz[dataDroz$number_comp==1,]
#because on the 2016-06-23, the behaviour of the flies was abnormal, 
#this repetition was removed before analysis
numberdata<-numberdata[numberdata$date!="2016-06-23",]
#first we remove unnecessary levels in the data frame
numberdata<-drop.levels(numberdata)

#we then create a dataframe for the results
REZdroz<-data.frame("repet"=as.character(),"ED50"=as.numeric(),
                    "IC_low"=as.numeric(),"IC_up"=as.numeric(),
                    "SE"=as.numeric())

countEffec<-aggregate(cbind(dead,total)~date+sex+repet,data=numberdata,"sum")

#and here comes the loop for LD50 evaluation
for (i in 1: length(levels(numberdata$repet))) {
  temp.m1<-drm(dead/total~dose,weights=total,
               data=numberdata[numberdata$repet==levels(numberdata$repet)[i],],
               fct=LN.2(),
               type="binomial")
  temp<-ED(temp.m1,50,interval="delta",reference="control")
  tempx<-data.frame("date"=names(table(numberdata$repet))[i],
                    "ED50"=temp[1],"IC_low"=temp[3],"IC_up"=temp[4],
                    "SE"=temp[2])
  REZdroz<-rbind(REZdroz,tempx)
}
REZdroz<-REZdroz[order(as.character(REZdroz$date)),]
results<- merge(countEffec,REZdroz,by.x="repet",by.y="date",all=FALSE)


##############################################################################/
#Figure 5: Scatter plot of the LD50 with different number of flies per dose####
##############################################################################/

legx<-expression(bold("Mean number of ")*bolditalic("D. suzukii ")*
                   bold("per dose"))
op<-par(mar=c(5,5,1,1),mfrow=c(1,2))
plot(results$ED50[results$sex=="female"]~results$total[results$sex=="female"],
     xlab ="Mean number of D. suzukii per dose",ylab="LD50 (mg/l)",
     ylim=c(0,100),xlim=c(20,270),bty="n",ann=FALSE,axes=FALSE,
     cex=2,pch=21,col=rgb(0,0,0,0.0),bg=rgb(0,0,0,0.0))
axis(1,at=c(35,70,105,140,175,210,245),
     labels=c("5","10","15","20","25","30","35"),
     cex.axis=1.5,font.axis=2,lwd.ticks=2)
axis(2,at=c(0,20,40,60,80,100),labels=c("0","20","40","60","80","100"),
     cex.axis=1.5,font.axis=2,lwd.ticks=2,las=1)
title(xlab=legx,
      ylab="LD50 (mg/l)",cex.lab=2,font.lab=2)
text(230,y=90,labels='\\VE',vfont=c("sans serif","bold"),cex=5)
totfem<-drm(dead/total~dose,weights=total,
            data=numberdata[numberdata$sex=="female",],
            fct=LN.2(),
            type="binomial")
totfemREZ<-ED(totfem,50,interval="delta",reference="control")
abline(totfemREZ[1],0,col="red",lwd=2)
abline(totfemREZ[3],0,col="red",lwd=2,lty=2)
abline(totfemREZ[4],0,col="red",lwd=2,lty=2)
plotCI(results$total[results$sex=="female"],
       results$ED50[results$sex=="female"],
       ui=results$ED50[results$sex=="female"]+
         results$SE[results$sex=="female"],
       li=results$ED50[results$sex=="female"]-
         results$SE[results$sex=="female"],
       #ui=results$IC_up[results$sex=="female"],
       #li=results$IC_low[results$sex=="female"],
       add=TRUE,cex=2,pch=21,col=rgb(0,0,0,1),pt.bg=rgb(0.7,0.7,0.7,1),
       gap=0.014)
box(lwd=3,lty=1)

par(mar=c(5,2,1,4))
plot(results$ED50[results$sex=="male"]~results$total[results$sex=="male"],
     xlab ="Mean number of D. suzukii per dose",ylab="LD50 (mg/l)",
     ylim=c(0,100),xlim=c(20,270),bty="n",ann=FALSE,axes=FALSE,
     cex=2,pch=24,col=rgb(0,0,0,0.0),bg=rgb(0,0,0,0.0))
axis(1,at=c(35,70,105,140,175,210,245),
     labels=c("5","10","15","20","25","30","35"),
     cex.axis=1.5,font.axis=2,lwd.ticks=2)
axis(2,at=c(0,20,40,60,80,100),labels=FALSE,
     cex.axis=1.5,font.axis=2,lwd.ticks=2,las=1)
title(xlab=legx,
      ylab="",cex.lab=2,font.lab=2)
text(230,y=90,labels='\\MA',vfont=c("sans serif","bold"),cex=5)
totmal<-drm(dead/total~dose,weights=total,
            data=numberdata[numberdata$sex=="male",],
            fct=LN.2(),
            type="binomial")
totmalREZ<-ED(totmal,50,interval="delta",reference="control")
abline(totmalREZ[1],0,col="red",lwd=2)
abline(totmalREZ[3],0,col="red",lwd=2,lty=2)
abline(totmalREZ[4],0,col="red",lwd=2,lty=2)
plotCI(results$total[results$sex=="male"],
       results$ED50[results$sex=="male"],
       ui=results$ED50[results$sex=="male"]+
         results$SE[results$sex=="male"],
       li=results$ED50[results$sex=="male"]-
         results$SE[results$sex=="male"],
       #ui=results$IC_up[results$sex=="male"],
       #li=results$IC_low[results$sex=="male"],
       add=TRUE,cex=2,pch=24,col=rgb(0,0,0,1),pt.bg=rgb(1,1,1,1.0),
       gap=0.011)
box(lwd=3,lty=1)
par(op)
#export to pdf 15*7 inches


##############################################################################/
#END
##############################################################################/