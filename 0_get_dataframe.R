### CREATE A MATRIX FROM THE CORPUS COHA USING A PATTERN ###
### TOKENISATION, POS-TAGGING, SENTIMENTAL ANALYSIS BY ONE FONCTION ###


rm(list=ls(all=TRUE))

library(coreNLP)

initCoreNLP(type = c("english_all"), mem = "10g")

#### Get dataframe from COHA ####
get.dataframe = function(corpus.path, pattern) {
  
  # List to stock results
  mylist <- list()
  i <- 0
  d <- 1800
  
  # For each line/decade
  for (decade in corpus.path) {
    
    # Get sentences
    sentences <- unlist(strsplit(decade, " \\. "))
    
    # Variables to count
    d <- d + 10
    len.sentences <- length(sentences)
    i.sent <- 0
    
    # For each sentence
    for (sent in sentences){
      i.sent <- i.sent + 1
      print(cat(c("Decade :", d, "Sentences :", i.sent,"/", len.sentences, sep=" ")))
      
      # Once the pattern is founded -> tokenisation of the sentence
      if (grepl(pattern, sent, ignore.case=T, perl=T) ) {
        
        split.sent <- unlist(strsplit(sent, " "))
        
        # Parsing with coreNLP
        output <- annotateString(sent)
        
        # Phrase sentiment
        phrase.sentiment <- getSentiment(output)$sentiment[1]
        
        df <- getToken(output)
        idexs <- grep(pattern, df$token, perl=T)
        
        # Getting target word and right context, and their part-of-speach
        for (idx.word in idexs) {
          i <- i + 1
          
          target.word <- df$token[idx.word]
          target.pos <- df$POS[idx.word]
          
          if (idx.word == length(df$token)) {
            right.context <- NA
            right.pos <- NA } else {
              right.context <- df$token[idx.word+1]
              right.pos <- df$POS[idx.word+1]}        
          
          # Bigram sentiment with coreNLP
          bigram <- c(target.word, right.context)
          bigram.sentiment <- getSentiment(annotateString(bigram))$sentiment[1]
          
          mylist[[i]] <- c(target.word,  right.context, target.pos, right.pos, bigram.sentiment, phrase.sentiment, d)
        }
      }
    }
  }
  
  # Creation of dataframe
  df <- do.call(rbind.data.frame, mylist)
  colnames(df) <- c("targetWord", "rightContext", "targetPOS", "leftPOS", "bigramSent", "phraseSent", "decade")
  return(df)
}

corpus.file <- scan(file="all-coha.txt", what="char", sep="\n")
pat <- "\\b(fucking|extremely|awfully|bloody|terribly|tremendously|dreadfully|insanely|amazingly|colossally)\\b"

df.data <- get.dataframe(corpus.file, pat)

# Save df
saveRDS(df.data, file="df.rds")

