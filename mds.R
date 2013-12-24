library(ggplot2)
library(TeachingDemos)
library(RColorBrewer)
library(reshape)
library(maptools)
library(stringr)


setwd("/Volumes/genefs/MikheyevU/sasha/projects/oceanica/")

mydb = dbConnect(MySQL(), user='pheidole', password='oceanica', dbname='oceanica', host='ecoevo.unit.oist.jp')
run_stats <- dbGetQuery(mydb,"SELECT * FROM run_stats")
dbDisconnect(mydb)

#just old and modern populations

names <- read.table("data/all.txt",header=F)
names <- lapply(names,str_match, ".*/(.*)\\.realigned.*")$V1[,2]

dat <- read.csv("output/pheidole\ yield.csv",header=T)

covar_dist <- read.table("data/all.covar",header=F)
eigenV <- data.frame(V1 = eigen(covar_dist)$vectors[,1],V2 = eigen(covar_dist)$vectors[,2],pop = c(run_stats[run_stats$id %in% names,"geo"]), species = c(run_stats[run_stats$id %in% names,"species"]))

rownames(eigenV) <- names
#eigenV <- eigenV[order(rownames(eigenV)),]  # arrange matrix to match ngsAdmix input

ggplot(subset(eigenV,species == "Pheidole oceanica"), aes(x=V1,y=V2,color=pop,label=pop))+geom_point()+theme_bw()+geom_text()

structure <- read.table("data/angsd/genolike_1_k2.qopt",header=F) # load ngsAdmix data

eigenV$k1 <- structure$V1
eigenV$k2 <- structure$V2
#eigenV$k3 <- structure$V3

#all populations

# all_names <- read.table("data/angsd/all.txt",header=F)
# all_names <- lapply(names,str_match, "*?./(.*?)\\..*")$V1[,2]

# all_covar_dist <- read.table("data/angsd/all.covar",header=F)
# eigenV <- data.frame(V1 = eigen(covar_dist)$vectors[,1],V2 = eigen(covar_dist)$vectors[,2],pop = c(rep("old",32),rep("modern",32)))  # re-arrange results to match structure data

# rownames(eigenV) <- names
# eigenV <- eigenV[order(rownames(eigenV)),]  # arrange matrix to match ngsAdmix input

# ggplot(eigenV, aes(x=V1,y=V2,color=pop))+geom_point()+theme_bw()


scatterpie <- function(x,y,data,data.colors) {
    piefun <- function(w,data.colors) pie(w,labels="",col=data.colors)
    plot(x,y,type="n",xlab="Principal Component 1",ylab="Principal Component 2")
    for (i in 1:length(x)) {
        my.symbols(x[i],y[i],symb=piefun,symb.plots=TRUE,add=TRUE,inches=.3,MoreArgs=list(as.matrix(data[i,]),data.colors))
    }
}

scatterpie2 <- function(x,y,data,data.colors) {
    died=c(1,5,6,25,26,28,29,30)
    piefun <- function(w,data.colors) pie(w,labels="",col=data.colors)
    plot(x,y,type="n",axes=FALSE, frame.plot=FALSE,xlab="",ylab="",xlim=c(.1,.2),ylim=c(-.15,.05))
    for (i in 1:length(x)) {
        my.symbols(x[i],y[i],symb=piefun,symb.plots=TRUE,add=TRUE,inches=.3,MoreArgs=list(as.matrix(data[i,]),data.colors))
        if (i %in% died)  text(x[i], y[i], "*")
    }

}


#label.cols <- brewer.pal(5, 'Set3')
pdf("mds.pdf")
label.cols <- c("steelblue","gold","red")
scatterpie(eigenV[,1],eigenV[,2],eigenV[,4:ncol(eigenV)],label.cols)
#subplot(scatterpie2(eigenV[1:32,1],eigenV[1:32,2],eigenV[1:32,5:6],label.cols),-.04,.5,c(2,4))
dev.off()


######  Plot dead vs surving bees in the modern population

pdf("plots/bee survival.pdf")
ggplot(subset(eigenV,pop=="modern"),aes(x=factor(dead),y=pop2))+geom_boxplot(fill="lightgray")+theme_bw()+ylab("Proportion cluster 2") + xlab("Died during survey period from 2011 to 2012")
dev.off()

mylogit <- glm(dead~pop2,data=subset(eigenV,pop=="modern"),family=binomial(logit))
exp(coef(mylogit))



vp <- viewport(width = 0.4, height = 0.4, x=.8,y=.8)

full <- function() {
    print(p)
    theme_set(theme_bw(base_size = 8))
    print(sp,vp=vp)
}
full()


mds <- subset(mds,POP=="modern")

p <- ggplot(data=mds,aes(x=C1,y=C2,color=pop))+geom_point()+theme(legend.position = "none",legend.key = element_blank(),panel.background=element_blank(),panel.background = element_blank())+scale_x_continuous()

p + annotate("text", x=mds$C1,y=mds$C2,label=rownames(mds))

sp <- ggplot(data=mds,aes(x=C1,y=C2,color=pop))+geom_point()+theme(legend.position = "none",legend.key = element_blank(),panel.background=element_blank())+scale_x_continuous("")+scale_y_continuous("")+labs(title="full data")

vp <- viewport(width = 0.4, height = 0.4, x=.8,y=.8)

full <- function() {
    print(p)
    theme_set(theme_bw(base_size = 8))
    print(sp,vp=vp)
}
full()
