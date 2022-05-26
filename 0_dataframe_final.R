#Ce script permet d'annoter des adjectifs avec CoreNLP et Opinion Lexicon. 
#Les proportions des usages positifs des termes que nous avons choisis sont montrées. 
#Les graphes pour les groupes de décennies et chaque groupe peuvent être créés pour chaque type d'analyse de sentiment. 
#Ces options doivent être modifiées manuellement dans ce script.

#Chargement des packages

library(dplyr)
library(tidyverse)
library(coreNLP)

#CoreNLP nécessite un espace supplémentaire pour l'annotation
#ce qui peut être nécessaire si le dataset est grand

initCoreNLP(type = c("english_all"), mem = "10g")

#Collection de dataframe final que nous utiliserons 
#Le reste de ce script a des parties pour créer les données dans ce dataframe  
#Ce dataframe est utilisé pour créer des graphes de proportion
#df.intensifiers <- readRDS(file = "df_intensifiers.rds")


#-------Sentiments des adjectives-------------------------------------#
#Chargement du dataframe sans sentiments d'adjectives
df.tokens <- readRDS(file = "df.rds")
adj.tokens <- df.tokens$rightContext
adj.split <- strsplit(adj.tokens, " ")

#Chargement des listes Opinion Lexicon pour l'annotation des adjectives
pos.list <- readLines("positive-words.txt")
neg.list <- readLines("negative-words.txt")
pos.split <- unlist(strsplit(pos.list, " "))
neg.split <- unlist(strsplit(neg.list, " "))

#elimination des columns on n'utilise pas, comme sentiment de bigrammes ou POS 
df.filt <- df.tokens[ -c(3,4,6) ]

#analyse de sentiments avec Opinion Lexicon

data.list <- data.frame()
for (el in adj.tokens){
  if (el %in% pos.split) {
    tmp <- ("Positive")}
  else if (el %in% neg.split) {
    tmp <- ("Negative")}
  else {tmp <- NA}
  data.list <- rbind(data.list, tmp)}

#Sentiment analysis from CoreNlp only for Adjectives
df.core <-  data.frame()
for (el in adj.split){
  tmp <- getSentiment(annotateString(el))
  df.core <- rbind(df.core, tmp)
}

#Ajouter les deux analyses dans le dataframe 
df.filt <- df.filt %>%
  add_column(adjSentiment.list = data.list$X.Positive., sentiment.CoreNlp.ADJ = df.core$sentiment) 

#Sauvegarder ce dataframe

#saveRDS(df.filt, file="adj.sentimentsv2.rds")
#-----------------------------------------------------------------------------------
#Création de dataframe finale avec les noms des colonnes néttoyé

df <- readRDS("D:\\stats-r\\projet\\adj.sentimentsv2.rds")

df <- df[ , c("targetWord", "rightContext", "adjSentiment.list", "sentiment.CoreNlp.ADJ", "bigramSent", "decade")]

colnames(df)[3] <- "adjSentiment"
colnames(df)[4] <- "adjSentiment.coreNLP"
colnames(df)[5] <- "bigramSentiment.coreNLP"

saveRDS(df, file="D:\\stats-r\\projet\\df_intensifiers.rds")

#Création de dataframe avec les décennies en groupe 

df[df == '1810' | df == '1820'| df == '1830'| df == '1840'| df == '1850'] <- '1810-1850'
df[df == '1860' | df == '1870'| df == '1880'| df == '1890'| df == '1900'] <- '1860-1900'
df[df == '1910' | df == '1920'| df == '1930'| df == '1940'| df == '1950'] <- '1910-1950'
df[df == '1960' | df == '1970'| df == '1980'| df == '1990'| df == '2000'] <- '1960-2000'

saveRDS(df, file="D:\\stats-r\\projet\\df_intensifiers_grouped.rds")