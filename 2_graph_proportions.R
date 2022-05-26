#----------------Pour l'obtenir les proportions positifs--------------------------#
#Pour relancer, vous pouvez utiliser le dataframe on a créer avec le script dataframe_final
df.intensifiers <- readRDS(file = "df_intensifiers.rds")

decades <- c("1810", "1820", "1830", "1840", "1850", "1860", "1870", "1880", "1890", "1900", "1910", "1920", "1930", "1940", "1950","1960", "1970", "1980", "1990", "2000")

#fonction pour obtenir le nombre d'occurence positif d'une terme dans une decennie
#Pour voir la difference entre coreNLP et lexicon 
#vous devez choisir le column adjSentiment ou adjSentiment.coreNLP

nb.occurences.pos = function(word, dec, df) {
  get.decade <- df%>% filter(grepl(dec, decade))
  #df.filtered.pos <- get.decade%>% filter(grepl("Positive", adjSentiment.coreNLP))
  df.filtered.pos <- get.decade%>% filter(grepl("Negative", adjSentiment))
  nb.pos <- list(length(which(df.filtered.pos$targetWord==word)))
  return(nb.pos)
}

#Fonction pour obtenir le nombre d'occurence total d'une terme dans une decennie 
nb.occurences.total = function(word, dec, df) {
  get.decade <- df%>% filter(grepl(dec, decade))
  df.filtered.int <-get.decade%>% filter(grepl(word, targetWord)) 
  nb.total <- list(length(which(df.filtered.int$targetWord==word)))
  return(nb.total)
}

#Compter le nombre d'occurences total d'une terme avec la fonction au-dessus 
get.total.numbers= function(word){
  total <- c()
  for(val in decades){
    tmp <- nb.occurences.total(word, val, df.intensifiers)
    total <- c(total, tmp)
    total <- unlist(total)}
  return(total)
}

#Compter le nombre d'occurences positif d'une terme avec la fonction au-dessus
get.pos.numbers= function(word){
  pos <- c()
  for(val in decades){
    tmp <- nb.occurences.pos(word, val, df.intensifiers)
    pos <- c(pos, tmp)
    pos <- unlist(pos)}
  return(pos)
}


#Utiliser les fonctions avec les 4 termes plus fréquentes 
total.am <- get.total.numbers("amazingly")
pos.am <- get.pos.numbers("amazingly")
total.aw <- get.total.numbers("awfully")
pos.aw <- get.pos.numbers("awfully")
total.ter <- get.total.numbers("terribly")
pos.ter <- get.pos.numbers("terribly")
total.ex <- get.total.numbers("extremely")
pos.ex <- get.pos.numbers("extremely")

#Exploration avec les autres termes 

#total.am <- get.total.numbers("amazingly")
#pos.am <- get.pos.numbers("amazingly")
#total.dr <- get.total.numbers("dreadfully")
#pos.dr <- get.pos.numbers("dreadfully")
#total.tr <- get.total.numbers("tremendously")
#pos.tr <- get.pos.numbers("tremendously")

#Fonction pour obtenir les proportions d'utilisation d'une terme positif par décennie
get.means = function(total, pos){
  i <- 0
  means <- c()
  for (val in decades){
    i <- i + 1
    tmp <- pos[i]/total[i]
    means <-c(means, tmp)}
  return(means)
}


means.ex <- get.means(total.ex, pos.ex)
means.ter <- get.means(total.ter, pos.ter)
means.am <- get.means(total.am, pos.am)
means.aw <- get.means(total.aw, pos.aw)
#means.tr <- get.means(total.tr, pos.tr)
#means.dr <- get.means(total.dr, pos.dr)

list.means <- Map(c, means.ex, means.ter, means.am, means.aw)

#list.means <- Map(c, means.am, means.dr, means.tr)
merged <- c(unlist(list.means))


#-------------------Obtention des graphes des proportions pour chaque décennie----
#Cette graphe va répresenter les proportions d'utilisation positif des termes
#"extremely", "terribly", "amazingly", "awfully"
#source: https://corpling.modyco.fr/workshops/M2TAL/2.descriptive.stats.html#fig:valleyplot

numbers <- merged
mat <- matrix(numbers, 4,20)
rownames(mat) <- c("extremely", "terribly", "amazingly", "awfully")
colnames(mat) <- decades
df.messy <- as.data.frame(mat)
df.messy <- rownames_to_column(df.messy, var = "intensifier")

df.tidy <- df.messy %>%
  pivot_longer(
    !(intensifier), 
    names_to = "decade", 
    values_to = "count", 
    values_drop_na = TRUE 
  )

df.tidy.sorted.decades <- df.tidy%>%
  arrange(count) %>%
  mutate(decade = factor(decade, levels=decades))
ggplot(df.tidy.sorted.decades, aes(x = decade, y = count, group=intensifier, color = intensifier)) + 
  geom_line(aes(group = intensifier))


#----------------Obtention des graphes des proportions pour les groupes des décennies-------


#Fonction pour obtenir les proportions d'utilisation positif pour chaque groupe de decennie

get.decades = function(int, group1, group2, group3, group4){
  get.filtered1 <- df.tidy %>% filter(grepl(int, intensifier) & grepl(group1, decade))
  get.filtered2 <- df.tidy %>% filter(grepl(int, intensifier) & grepl(group2, decade))
  get.filtered3 <- df.tidy %>% filter(grepl(int, intensifier) & grepl(group3, decade))
  get.filtered4 <- df.tidy %>% filter(grepl(int, intensifier) & grepl(group4, decade))
  sum1 <- sum(get.filtered1$count)/length(get.filtered1$count)
  sum2 <- sum(get.filtered2$count)/length(get.filtered2$count)
  sum3 <- sum(get.filtered3$count)/length(get.filtered3$count)
  sum4 <- sum(get.filtered4$count)/length(get.filtered4$count)
  return(c(sum1, sum2, sum3, sum4))
  
}

ex <- get.decades("extremely", "1810|1820|1830|1840|1850", "1860|1870|1880|1890|1900", "1910|1920|1930|1940|1950", "1960|1970|1980|1990|2000")
aw <- get.decades("awfully", "1810|1820|1830|1840|1850", "1860|1870|1880|1890|1900", "1910|1920|1930|1940|1950", "1960|1970|1980|1990|2000")
tr <- get.decades("terribly", "1810|1820|1830|1840|1850", "1860|1870|1880|1890|1900", "1910|1920|1930|1940|1950", "1960|1970|1980|1990|2000")
am <- get.decades("amazingly", "1810|1820|1830|1840|1850", "1860|1870|1880|1890|1900", "1910|1920|1930|1940|1950", "1960|1970|1980|1990|2000")

list.means.decades <- Map(c, ex, tr, am, aw)
merged.decades <- c(unlist(list.means.decades))

#-----------------Utilisation des donées pour le graphe des decennies groupé--

decades <- c("1810-1850", "1860-1900", "1910-1950", "1960-2000")
numbers <- merged.decades
mat <- matrix(numbers, 4,4)
rownames(mat) <- c("extremely", "terribly", "amazingly", "awfully")
colnames(mat) <- decades
df.messy <- as.data.frame(mat)
df.messy <- rownames_to_column(df.messy, var = "intensifier")

df.tidy <- df.messy %>%
  pivot_longer(
    !(intensifier), 
    names_to = "decade",
    values_to = "count",
    values_drop_na = TRUE 
  )

df.tidy.sorted.decades <- df.tidy%>%
  arrange(count) %>%
  mutate(decade = factor(decade, levels=decades))

ggplot(df.tidy.sorted.decades, aes(x = decade, y = count, group=intensifier, color = intensifier)) + 
  geom_line(aes(group = intensifier))
#---------------------------------------------------------------------------------