### DATA EXPLORATION ###
### SUMMARY OF FREQUENCY COUNTS ###

rm(list=ls(all=TRUE))

library(tidyverse)
library(data.table)
library(ggplot2)

df <- readRDS("df_intensifiers.rds")
df.grouped <- readRDS("df_intensifiers_grouped.rds")

# Eliminating columns of sentiments
df <- subset(df, select = -c(adjSentiment, adjSentiment.coreNLP, bigramSentiment.coreNLP))
df.grouped <- subset(df.grouped, select = -c(adjSentiment, adjSentiment.coreNLP, bigramSentiment.coreNLP))

td <- as_tibble(df)
td.grouped <- as_tibble(df.grouped)

# Frequency of intensifiers
td.freq <- td %>%
  group_by(targetWord) %>%
  count(targetWord, sort=TRUE)

# Graphs of this frequency with plot and ggplot
plot(td.freq$n,
     xlab="intensifieurs",
     ylab="frequency",
     type='l',
     col="lightgrey")
text(td.freq$n, 
     labels = td.freq$targetWord,
     cex=0.7)

ggplot(td.freq, aes(x = reorder(targetWord, -n), y = n, group=1, label=targetWord)) +
  geom_line() +
  xlab("") +
  theme_bw()

# Frequency of intensifiers by decade
freq.by.decade <- td %>%
  group_by(decade) %>%
  count(decade, sort=TRUE)

# Barplot of intensifiers by decade
ggplot(freq.by.decade, aes(decade, n)) +
  geom_col() +
  xlab("decade") +
  ylab("Intensifiers") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Get ratio intensifiers/number of tokens of each decade. Using a CSV

csv <- read.csv('tokens_intensifiers.csv', sep=";", stringsAsFactors=FALSE)

# Transforming the csv in a proper dataframe with the good columns and rows
df.ratio <- transpose(csv)
rownames(df.ratio) <- colnames(csv)
colnames(df.ratio) <- c("tokens", "intensifiers", "ratio")
df.ratio$decade <- row.names(df.ratio)

# as numeric to make operations
df.ratio[, 1]  <- as.numeric(df.ratio[, 1])
df.ratio[, 2]  <- as.numeric(df.ratio[, 2])
df.ratio[, 3]  <- as.numeric(df.ratio[, 3])

ggplot(df.ratio, aes(decade, ratio)) +
  geom_col() +
  xlab("decades") +
  ylab("nb. intensifiers / nb. tokens") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggplot(df.ratio, aes(decade, tokens)) +
  geom_col() +
  xlab("decades") +
  ylab("nb. tokens") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Same thing but for each group of decades
# Get ratio intensifiers/number of tokens of each GROUP of decades. Using a CSV

csv.grouped <- read.csv('tokens_intensifiers_grouped.csv', sep=";")

df.ratio.grouped <- transpose(csv.grouped)
rownames(df.ratio.grouped) <- colnames(csv.grouped)
colnames(df.ratio.grouped) <- c("tokens", "intensifiers", "ratio")
df.ratio.grouped$decade <- row.names(df.ratio.grouped)

ggplot(df.ratio.grouped, aes(decade, ratio)) +
  geom_col() +
  xlab("decades") +
  ylab("nb. intensifiers / nb. tokens") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), axis.text.y=element_blank(), axis.ticks.y=element_blank())

# Box plot comparing boths ratios, by each decade and by group of decades
boxplot(df.ratio$ratio, df.ratio.grouped$ratio)

# OTHER INFORMATION

# Frequency by decades grouped
freq.by.decades.grouped <- td.grouped %>%
  group_by(decade) %>%
  count(decade, sort=TRUE)

# Just for awfully and terribly
td.awfully <- td %>% filter(targetWord == "awfully")
freq.awfully.by.decade <- td.awfully %>%
  group_by(targetWord, decade) %>%
  count(targetWord, decade, sort=TRUE)

ggplot(freq.awfully.by.decade, aes(decade, n)) +
  geom_col() +
  xlab("decade") +
  ylab("awfully") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

td.terribly <- td %>% filter(targetWord == "terribly")
freq.terribly.by.decade <- td.terribly %>%
  group_by(targetWord, decade) %>%
  count(targetWord, decade, sort=TRUE)

ggplot(freq.terribly.by.decade, aes(decade, n)) +
  geom_col() +
  xlab("decade") +
  ylab("terribly") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

