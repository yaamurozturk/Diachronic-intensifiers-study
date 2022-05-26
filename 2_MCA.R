#### MCA FOR EXPLORING INTENSIFIERS BY THEIR POLARITY ###
### SOURCE : https://corpling.modyco.fr/workshops/M2TAL/4.multivariate.html ###

# Load file
df.grouped <- readRDS("df_intensifiers_grouped.rds")

# Keeping only the information we need
df.grouped <- subset(df.grouped, select = -c(rightContext, adjSentiment.coreNLP, bigramSentiment.coreNLP))

# Ignore rows with NA
df.subset <- subset(df.grouped, !is.na(df$adjSentiment))

# Intensifier to filter
inten <- "terribly"
inten <- "awfully"

df.int <- df.subset %>%
  filter(targetWord == inten)

# Label each intensifiers by periode of time
df.int$targetWord[df.int$decade == "1810-1850"] <- paste(inten, 1)
df.int$targetWord[df.int$decade == "1860-1900"] <- paste(inten, 2)
df.int$targetWord[df.int$decade == "1910-1950"] <- paste(inten, 3)
df.int$targetWord[df.int$decade == "1960-2000"] <- paste(inten, 4)

# Create dataframe
df.int <- data.frame(df.int)
str(df.int)

# Create MCA object and plotting it
mca.object <- MCA(df.int, graph=FALSE)
round(mca.object$eig, 2)

barplot(mca.object$eig[,2], names=paste("dimension", 1:nrow(mca.object$eig)), 
        xlab="dimensions", 
        ylab="percentage of variance")

plot.MCA(mca.object,
         invisible="ind",
         autoLab="yes",
         shadowtext=TRUE,
         habillage="quali", 
         title="")