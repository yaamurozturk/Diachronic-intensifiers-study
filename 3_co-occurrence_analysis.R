### EXPLORE CO-OCCURRENCES OF INTENSIFIERS OF CORPUS COHA ###
### SOURCE : https://corpling.modyco.fr/workshops/M2TAL/4.multivariate.html ###

rm(list=ls(all=TRUE))

library(tidyverse)
library(ggpubr)
library("FactoMineR")
library("factoextra")
library(data.table)

df <- readRDS("df_intensifiers.rds")
df.grouped <- readRDS("df_intensifiers_grouped.rds")

#### General frequencies ####

# Frequency of bigrams
freq.forms <- df %>%
  group_by(targetWord, rightContext) %>%
  count(targetWord, rightContext, sort=TRUE)

# Frequency of bigrams with awfully

freq.forms <- df %>%
  filter(targetWord == "awfully") %>%
  group_by(targetWord, rightContext) %>%
  count(targetWord, rightContext, sort=TRUE)

# Frequency of bigrams by group of decade
freq.forms <- df.grouped %>%
  filter(targetWord == "terribly") %>%
  group_by(targetWord, rightContext, decade) %>%
  count(targetWord, rightContext, decade, sort=TRUE)

# Frequency of bigrams by group of decade with awfully

freq.forms <- df.grouped %>%
  filter(targetWord == "awfully") %>%
  group_by(targetWord, rightContext, decade) %>%
  count(targetWord, rightContext, decade, sort=TRUE)

#### Matrix of dissimilarity and CA####

##### Data #####

# Choose intensifier to filter
inten <- "terribly"

df.int <- df.grouped %>%
  filter(targetWord == inten) %>%
  group_by(targetWord, rightContext, decade) %>%
  count(targetWord, rightContext, decade, sort=TRUE)

# Label each intensifier with their period of time
df.int$targetWord[df.int$decade == "1810-1850"] <- paste(inten, 1)
df.int$targetWord[df.int$decade == "1860-1900"] <- paste(inten, 2)
df.int$targetWord[df.int$decade == "1910-1950"] <- paste(inten, 3)
df.int$targetWord[df.int$decade == "1960-2000"] <- paste(inten, 4)

df.int <- data.frame(df.int)
df.subset <- subset(df.int, select = -c(decade))

# List of distinct intensifiers, list of distinct adjectives and it's number 
intensifiers <- sort(unlist(distinct_all(df.int %>% select(targetWord))))
right.context <- sort(unlist(distinct_all(df.int %>% select(rightContext))))
n.coocs <- n_distinct(df.int$rightContext)

# Create a dataframe of co-occurrences with the intensifiers labeled by period
df.cooc <- pivot_wider(df.subset, names_from = targetWord, values_from = n, values_fill=0)
df.cooc <- df.cooc %>% remove_rownames %>% column_to_rownames(var="rightContext")

# Transpose of the dataframe to work with the intensifiers distances
df.cooc.t <- transpose(df.cooc)
rownames(df.cooc.t) <- colnames(df.cooc)
colnames(df.cooc.t) <- rownames(df.cooc)

# Creation of a subset with the 50 more frequent adjectives for each version of intensifier
most.freq.coocs <- c()

for (i in intensifiers) {
  tmp <- row.names(df.cooc %>% top_n(50, df.cooc[, i]))
  most.freq.coocs <- c(most.freq.coocs, tmp)
}

most.freq.subset <- df.cooc[rownames(df.cooc) %in% most.freq.coocs, ]
most.freq.subset.t <- transpose(most.freq.subset)
rownames(most.freq.subset.t) <- colnames(most.freq.subset)
colnames(most.freq.subset.t) <- rownames(most.freq.subset)

##### Creation of dissimilarity matrix #####
dist.object <- dist(most.freq.subset.t, method="canberra", diag=T, upper=T)
dist.matrix <- as.matrix(dist.object)
dist.matrix

# MDS
mds <- cmdscale(dist.matrix,eig=TRUE, k=2)

x <- mds$points[,1]
y <- mds$points[,2]

# Dimensional examination

plot(x, y, xlab="Dim.1", ylab="Dim.2", type="n")
text(x, y, labels = row.names(most.freq.subset.t), cex=.7)
# for the first two dimensions
mds.df <- as.data.frame(mds$points) # convert the coordinates
colnames(mds.df) <- c("Dim.1", "Dim.2") # assign column names

# K-means clusterisation to group and color the clusters

kmclusters <- kmeans(mds.df, 3) # k-means clustering with 3 groups
kmclusters <- as.factor(kmclusters$cluster) # convert to a factor
mds.df$groups <- kmclusters # join to the existing data frame
mds.df

ggscatter(mds.df, x = "Dim.1", y = "Dim.2", 
          label = rownames(most.freq.subset.t),
          color = "groups",
          palette = "jco",
          size = 1,
          ellipse = TRUE,
          ellipse.type = "convex",
          repel = TRUE)


##### CA scaled biplot #####

# Creation again of a subset, this time, with the 5 more frequent adjectives for each version of intensifier
most.freq.coocs <- c()

for (i in intensifiers) {
  tmp <- row.names(df.cooc %>% top_n(5, df.cooc[, i]))
  most.freq.coocs <- c(most.freq.coocs, tmp)
}

most.freq.subset <- df.cooc[rownames(df.cooc) %in% most.freq.coocs, ]
most.freq.subset.t <- transpose(most.freq.subset)
rownames(most.freq.subset.t) <- colnames(most.freq.subset)
colnames(most.freq.subset.t) <- rownames(most.freq.subset)

ca.object <- CA(most.freq.subset.t, graph=FALSE)

ca.object$eig

# Dimensional examination
barplot(ca.object$eig[,2], names=paste("dimension", 1:nrow(ca.object$eig)), 
        xlab="dimensions", 
        ylab="percentage of variance")

fviz_ca_biplot(ca.object, map ="colprincipal",
               arrow = c(FALSE, FALSE), repel = TRUE)
                    