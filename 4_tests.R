### CALCULATE HYPHOTESIS TEST ###
### SOURCE : https://corpling.modyco.fr/workshops/M2TAL/3.hypothesis.testing.html ###


rm(list=ls(all=TRUE))

df <- readRDS("df_intensifiers.rds")
df.grouped <- readRDS("df_intensifiers_grouped.rds")

#### Get matrix of values ####

df.tests <- df.grouped[,c("targetWord","adjSentiment","decade")]
df.tests <- subset(df.tests, !is.na(df.tests$adjSentiment))

# Choosing intensifier to test

inten <- "terribly"

df.tests <- df.tests %>%
            filter (targetWord == inten)%>%
            count (targetWord, adjSentiment, decade, sort=TRUE)

# Label the intensifiers with their polarity value
neg <- paste(df.tests$targetWord[1], "neg", sep="-")
pos <- paste(df.tests$targetWord[1], "pos", sep="-")
df.tests$targetWord[df.tests$adjSentiment == "Negative"] <- neg
df.tests$targetWord[df.tests$adjSentiment == "Positive"] <- pos

# Adjusting et pivoting df
df.tests <- subset(df.tests, select = -c(adjSentiment))
df.tests <- pivot_wider(df.tests, names_from = decade, values_from = n)

# Reordering df
df.tests <- df.tests[, c(5, 3, 2, 4)]

# Conversion to matrix
matrix <- as.matrix(df.tests[, 1:4])

#### Hypothesis tests ####

# Values of 1860-1900 et 1910-1950
fisher.test(matrix[, c(2,3)])

# Values of 1910-1950 et 1960-2000
fisher.test(matrix[, c(3,4)])

# Values of 1860-1900 et 1960-2000
fisher.test(matrix[, c(2,4)])




