options(scipen=999)
#generazione numeri per valori di skill e visibilità
set.seed(1)
sk<-sample(1:100,10)
set.seed(2)
vs<-sample(1:100,10)


skills<-list()
visibilità<-list()
for (i in 1:10){
  a<-round(sk[i]/sum(sk),5)
  b<- round(vs[i]/sum(vs),5)
  skills<-as.numeric(append(skills,list(a)))
  visibilità<-as.numeric(append(visibilità,list(b)))
}
skills<-sort(skills,decreasing = TRUE)
visibilità<-sort(visibilità,decreasing = TRUE)

#CREAZIONE DATASET 
set.seed(1)

#Lista dei candidati
candidates<-list('candidato1','candidato2','candidato3','candidato4','candidato5','candidato6','candidato7','candidato8','candidato9','candidato10')

#Lista delle skill
skill<- list('0.18201', '0.17155', '0.14226', '0.12343', '0.10669', '0.08996','0.08159', '0.07113', '0.02929', '0.00209')
# Aggiungo ad ogni candidato la sua skill
candidate_skill<- mapply(c,candidates,skill,SIMPLIFY = FALSE)
#elenco dei valori delle visibiltà in ordine di posizione

#Generazione 1000 Permutazioni 
permutazioni<-replicate(1000,list(sample(candidate_skill,replace = FALSE)))


#Conversione in Dataframe
df_permutazioni<-(as.data.frame(do.call(rbind, permutazioni)))

# Inserimento valori visibilità della posizione

visibility=list(0.17002,0.15539,0.14808,0.14442,0.13894,0.12797,0.05850,0.03108,0.01463,0.01097)



#Calcolo di Welfare e Fairness
R<-list()
G<-list()

for (i in 1:1000){
  somma<-0
  calcolo<-0
  for (j in 1:10){
    skl<-as.numeric(df_permutazioni[[j]][[i]][2])
    somma<-somma+skl*as.numeric(visibility[j])
    calcolo<- calcolo+skl*log2(skl/(as.numeric(visibility[j])))
  }
  R<-append(R,list(somma))
  G<-append(G,list(calcolo))
  
}

# Inserimento Welfare E Fairness in dataframe

df_permutazioni$welfare<-R
df_permutazioni$fairness<-G


#Calcolo dello score
A<-list()
for (i in (1:1000)){
  contatore<-0
  for (j in (1:1000)){
    if (isTRUE(df_permutazioni$welfare[[i]]>df_permutazioni$welfare[[j]])&(df_permutazioni$fairness[[i]]<df_permutazioni$fairness[[j]])){
      contatore<-contatore+1
    }
  }
  A<-append(A,list(contatore/999))
}
#Inserimento Score nel dataframe
df_permutazioni$score<-A
df_permutazioni$score<-unlist(df_permutazioni$score)


#RIMOZIONE DEL VALORE DI SKILL DAL CANDIDATO
for (j in 1:1000){
  for (i in 1:10){
    df_permutazioni[[i]][[j]]<-df_permutazioni[[i]][[j]][1]}
}

#salvataggio datatset

saveRDS(df_permutazioni, file="Dataset-AIML.Rda")


#CARICAMENTO DATASET
dataset <- readRDS(file="Dataset-AIML.Rda")


library(fastDummies)

#TRASFORMAZIONE DELLE VARIABILI IN VARIABILI DUMMIES


dataset_dummies <- dummy_cols(dataset,select_columns = colnames(dataset[1:10]))
dataset_dummies[1:10]<-NULL
dataset_dummies$welfare<-NULL
dataset_dummies$fairness<-NULL

attach(dataset_dummies)


library(gamlss)
modello_gamlss<-gamlss(score ~.,data = dataset_dummies)
summary(modello_gamlss)
Rsq(modello_gamlss)

plot(modello_gamlss)

