# Linguistic tools and statistical processing
This repository is to present the final homework we did with Santiago Herrera Yanez in the frame of the course linguistic tools and statistical processing. 
Main objectives of this project is gain experience using the R language. Our subject was English intensifiers and analysing them in a diachronic corpus. 
Original French file explaining the project can be found in the files, with all the scripts seperately for corpus processing and statistical plots. 

Professsor: Guillaume Desagulier

Introduction
---
English expressions such as awfully glad or terribly good have always aroused our linguistic
interest, because they are constructions formed by an intensity marker and an adjective that have
and an adjective which present interesting semantic properties. From a lexical point of view
lexical point of view, the polarity of single words is sometimes ambiguous or contradictory: as in the
examples, the polarity of the adverb is often opposed to that of the adjective. We
There are also contrary cases, e.g. amazingly bad, where the value of the polarity is reversed. In
however, in both cases, the intensity marker is only pointing in the same direction as the
direction as the adjective. Obviously, these examples coexist with others like terribly ill
or extremely precarious, in which the polarity of the words is similar. In the end, it is
the co-occurring adjective that marks the value of the polarity.
To further investigate this issue, we decided to conduct a diachronic study of 8
intensity markers of American English from the Corpus of Historical American English
(COHA)1, with the aim of exploring the differences in usage of this type of construction over the different
the different decades included in the corpus and thus observe their evolution. This
exploration was based on the following linguistic hypothesis: the use of the pair
intensity-adjective marker of opposite polarities is more widespread the closer we are to the
closer to the present. This hypothesis could be confirmed or not thanks to a diachronic
diachronic study. Although we consider the COHA corpus to be fairly representative of American English, we do not attempt to
American English, we only seek to test this hypothesis within the limits of this
corpus.

For this purpose, we have developed two complementary approaches. In the first place, we have
In a first step, we worked on the polarity of the co-occurring adjectives of the intensity markers. In a second
secondly, we made observations on the frequencies of these adjectives. In both
both cases, we looked for statistically significant relationships between the decades, as well as important
important information about the intensity marker-adjective pair. This method of
This method of analysis has obvious limitations, such as the inability to analyze its pragmatic use,
in particular, irony. Moreover, it becomes necessary to answer other questions about the
process, for example, how to recover the polarity of adjectives.

These questions will be addressed throughout this work, with each section reflecting a part of the exploration and
Each section reflects a part of the exploration and evaluation of the data. First, a brief description of the corpus is given.
corpus and then explain how we created and constituted the data on which we worked.
worked on. Based on several multivariate exploratory methods, we explore the data collected in order to
data collected in order to evaluate, in a first instance, our hypothesis, and to adjust it in the face of
to adjust it to the new information obtained. Finally, we test it statistically. To
conclude this work, we ended with a reflection on the approach, the limitations and on other
to explore. All the work was carried out by means of tools and scripts written in R which are attached
to this document. 

Corpus description and data collection
---
The COHA corpus is a corpus of American English containing, in its current version
475 billion words, retrieved from more than 100,000 texts, covering the decades between
decades between 1820 and 2010. The version of the corpus we used (the previous one),
on the other hand, goes from 1810 to 2000. Although it is a less balanced version than the current
the current one, as in the case of the 1810 decade, it is a fairly homogeneous corpus within each
within each decade. Indeed, the entire corpus is evenly divided into
genre (fiction, non-fiction), composed of texts of varied genre, newspapers, novels, non-fiction
non-fictional books, etc. For all this, without however denying that the current version would have been
a more interesting resource to exploit (the addition of subtitles and the 2010 decade are a plus), the corpus
a plus), the corpus used allows us to have an in-depth look at the variation of
American English.

More specifically, we had access to the corpus in raw text format, tokenized and
normalized, without any further processing. The text file in question, containing the corpus, is
composed of 20 lines, one per decade. As it is a large corpus, its processing was necessarily
was necessarily done in flow. At first, we decided to exploit not only the tokens but also the
not only the tokens but also the sentences. Nevertheless, the segmentation into sentences proved to be difficult and unreliable, especially
difficult and not reliable, in particular in the first decades, in dramatic and poetic texts.
dramatic and poetic texts.

In order to explore our object of study and to obtain the occurrences of intensity markers. We
chosen to work from the beginning with the following 8 intensity markers, with the aim of
to make the data to be analyzed manageable: extremely, terribly, awfully, dreadfully,
tremendously, amazingly, insanely and colossally. These are all adverbs, which alternate their
polarity, and which are likely to appear in the contexts and uses described in the
introduction,

To retrieve them, from each line/decade, we segmented the text into sentences from which we extracted the target words, the adverbs, and the words to the right of them, the adjectives.
In order to perform the necessary filtering, before extraction, we labeled the words with their
parts of speech using the CoreNLP library, available in R. The segmentation into
sentence, despite the difficulty, is therefore a necessary step to perform the labeling
efficiently.

As far as polarity is concerned, in a first step, we used the CoreNLP module to
analysis of the sentiments present in the sentences, then we used bigrams and finally only
bigrams and finally only adjectives. The fact of having collected these different data, which
redundant, and the final choice about which data to use will be explained in the next section.
explained in the next section.

All this process allowed us to obtain a large dataset containing the occurrences of the
intensity markers and their right context, along with other information about their polarity, which
polarity, which could be used in several studies. In our case, we immediately
In our case, we immediately filtered the data in order to keep only the adverbs with
adjectives. To do this, we targeted their labels according to the annotation scheme of the
Penn Treebank.

Data mining
---
- Summary of frequency counts
Our corpus is composed, finally, of a total of 394 449 164 tokens, with a distribution
that increases, in general terms, over the years. 
<img width="499" alt="pic1" src="https://user-images.githubusercontent.com/77155381/170534478-3ebbc1ba-b4a2-42f3-a78b-c2c663fdc4e8.PNG">

The decades 1810-20 are clearly under represented, while the 20th century has a major presence in the corpus. A homogenization of values is necessary to be able to properly exploit the corpus. 
As far as intensity markers are concerned, there is a significant disparity between the different adverbs chosen. Extremely, terribly and awfully have higher frequency values than the rest, being the first one the one that considerably exceeds the average. 
Words like insanely, colossally, although interesting from a semantic point of view, have a very reduced presence in the whole corpus, for which reason we have decided to exclude them from our study.
Moreover, if we also notice that the ratio number of markers / tokens (below) shows a rather important dispersion between the first half of the 19th century and the rest of the corpus. 
An important exception is the decade 1970, where we did not find a significant number of these intensity markers. 

<img width="548" alt="pic2" src="https://user-images.githubusercontent.com/77155381/170534708-e9c3fbf3-45c1-4ad1-a09a-c8f3adf674c8.PNG">

<img width="726" alt="pic3" src="https://user-images.githubusercontent.com/77155381/170535298-09f777be-7483-491a-9ac8-9f571a2a3d6a.PNG">


Given this dispersion and the need to find time periods that allow us to analyze the change or not in the use of its markers, we decided to group decades. 
This allows us to reduce the number of observations to be analyzed, without losing the time variable.
We decided to carry out a classical segmentation by half-centuries: from the decade of 1810 to that of 1850, from 1860 to 1900, 
from 1910 to 1950 and from 1960 to 2000. Indeed, this new grouping makes the analysis more interpretable and also reduces the frequency dispersion in
our subsets (Figure 4). Nevertheless, the 1810-1850 grouping continues to be less comparable than the remainders. 

<img width="701" alt="pic4" src="https://user-images.githubusercontent.com/77155381/170535280-92134396-9446-4353-8447-93abe0eca0cd.PNG">

Polarity
---

As mentioned in the introduction, studying the polarity of one's constructs is one of the approaches we have chosen. First, we decided to use the CoreNLP sentiment analyzer, based on a neural network architecture and rules, which has 5 levels of polarity: neutral, very positive, positive, very negative and negative. To simplify our variables, the very positive and very negative levels were classified into the positive and negative classes respectively.

We extracted the polarity of the sentences where the constructions appear, the polarity of the bigram (adverb-adjectives) and, finally, the polarity of the adjective only. The aim was to see if it was possible to consider the sentence as the context that determines the polarity of the construction and thus be able to study the occurrences of the bigram in a wider context of use. However, since sentence segmentation is not reliable and during a preliminary observation of the results some doubtful results were found, it was decided not to use sentence polarity. For another problem, the polarity obtained from bigrams was also excluded: the sentiment analyzer had a tendency to classify constructions that had lexically opposite polarities as neutral, but this was not systematic. All of these problems led to a change in the method of polarity analysis in favor of using the Opinion Lexicon, a stable, systematic, and linguistically fundamental resource. The observations of the polarities of co-occurring adjectives from the CoreNLP is in any case available in the Appendix.

As for the polarity lexicon in question, it is a list of opinion words or positive and negative polarity words in English. It consists of approximately 6800 words. This list has been compiled over many years from the experiments of Bing Liu. This lexicon is quite extensive, not only in terms of the number of words, but also in terms of word abbreviations and possible typos. Therefore, each adjective was labeled according to whether it belonged to the positive or negative word list. The words that were not in any list were classified as NA.

As mentioned, after analyzing the data, it was decided to annotate only the adjectives, the right context of the target word, which gave more accurate results in terms of polarity analysis. In this regard, it is believed that the analysis of adjectives through the lexicon is more accurate on a single word, as it is. Because of these considerations and in order to create graphs that would allow us to explore our hypothesis, we were forced to modify our initial dataframe. More specifically, the graphs below were created using only the polarity of the right context (adjective), which was added to the final dataset.

In the graphs below, we can observe the proportion of positive and negative co-occurring adjectives over the entirety of each intensity marker. We can also see that combining the decades results in a more balanced diachronic analysis (Figure 6 vs. Figure 7). In these graphs, we used the three most frequent terms, extremely, awfully and terribly, and amazingly, whose occurrence is more balanced in polarity. Graphs with other terms and any other analysis with CoreNLP can be found in the appendices. 

<img width="509" alt="pic5" src="https://user-images.githubusercontent.com/77155381/170535719-6ed6bc12-67cd-4fff-807d-cabbfd86d687.PNG">

The greatest change in positive usage over time is observed in awfully, while the least change is observed in extremely. The usage of amazingly has remained predominantly positive throughout the decades, while terribly has the lowest positive usage. However, over the past five decades, the positive use of awfully has decreased. The largest difference we see is between the second and third decade groups for the awfully marker. Since these two groups have a more balanced rate of intensity markers, there would appear to be a shift in the use of awfully and possibly a statistically significant relationship between construct polarity and time. This statistical significance remains to be verified. Moreover, these graphs show that such changes are not produced for all the intensity markers we have chosen to analyze. One of the reasons may be the infrequent use of these intensity markers with adjectives in the corpus. In any case, the downward spikes alert us to an anomaly in the corpus, see 1850. As we said, it seems best not to work with the first group of decades.

<img width="486" alt="pic6" src="https://user-images.githubusercontent.com/77155381/170536032-6810e162-db28-4ed5-89f0-abf09177fe26.PNG">

Through the Multiple correspondence analysis (MCA) method, the relationship between the first observations (marker, polarity of the adjective and decade group) and the variables was analyzed in order to further inspect the use of awfully and terribly. 

The first dimension shows a significant separation between the decades 1810-50 and the rest of the corpus. This difference was expected. Further on, we will see that the adjectives that co-occur with the markers are also very different. In the second dimension, we observe that, indeed, from 1910-2000 the use of terribly and awfully, is more positive than during 1860-1900. It should be noted that terribly is generally closer to the negative polarity than awfully. 

<img width="419" alt="pic7" src="https://user-images.githubusercontent.com/77155381/170536342-619ff609-064a-45ba-bd12-257502dea5fc.PNG">

Co-occurring adjectives
---

The other approach to consider is the study of co-occurring adjectives. Knowing which are the most frequent occurrences allows us to understand its use. It is a question of being able to characterize each adverb according to their immediate adjectival context. To take advantage of our observations in the previous section, we have chosen to focus more specifically on awfully and terribly, hoping to find other complementary information to solidify the answer to our hypothesis, which is now more restricted in scope. 

A first approximation shows us that these adverbs share only two co-occurring adjectives: sorry and hard. Indeed, since we are working with high frequencies, we are in the domain of collocation and each adverb seems to have its own collocative bases (here, adjectives). Moreover, we observe that terribly co-occurs more with words that can be considered as neutral or negative than awfully. 
<img width="393" alt="pic8" src="https://user-images.githubusercontent.com/77155381/170536511-711b698e-062b-4758-9fe6-09661fada102.PNG">

Then, we decided to apply another multivariate method to analyze our data: multidimensional positioning (MDS). The idea was to take advantage of the bigram frequencies to create a distance or disimilarity matrix able to give us information about the proximity of a word to another according to its distribution in the corpus. For this purpose, instead of evaluating the adjectives according to the adverbs, we have tried to evaluate the distance between the marker according to its use in different groups of decades. The 50 most frequent adjectives of the marker for each era were taken into account. The aim was to create a matrix from the relevant information and for this reason the low frequencies were ignored. 

In fact, we find similar results to those seen in the previous section. Here, in the clustered version (K-means), we see that the distance between the use of the awfully intensity marker from 1860-1900 and 1910-1950 is shorter, having a closer semantic similarity.

<img width="465" alt="pic9" src="https://user-images.githubusercontent.com/77155381/170536712-8c5180fb-8184-400a-97fc-7d0d46e33558.PNG">

If we look at the MDS version for the intensity marker terribly, the trend seen in the previous section is reaffirmed: usage in the decades between 1910 and 2000, when the adverbs are semantically close, coincides with the time when the polarity is more positive. 
<img width="471" alt="pic10" src="https://user-images.githubusercontent.com/77155381/170536929-d49d66fd-f896-4bf8-8c6c-f33991da7842.PNG">

In both cases, the first period of decades remains sustancialmente different to the rest, marking rather a particularity of the corpus than of the evolution of the intensity markers. 

We also tried to present the rows and columns together in an interpretable way, through the CA scaled symmetric biplot method. The 7 most frequent adjectives for the two intensity markers were projected across the different decade groups (Figure 11 for awfully), but the results are more difficult to interpret. There are not enough co-occurring adjectives to draw a partial conclusion different from the one already expressed. Adding more adjectives would make the graph unreadable. 
<img width="464" alt="pic11" src="https://user-images.githubusercontent.com/77155381/170537022-967bf51c-e101-4892-83b8-d241945b4e4c.PNG">

Hypothesis reformulation and testing
---

At this point, our working hypothesis has been modified in light of the data exploration. It was initially too ambitious and vague. It is difficult to prove that the intensity-adjective marker constructions of opposite polarity are more widespread in the present day. On the other hand, we found patterns of change in the use of two intensity markers in our corpora that appear to be statistically significant. Notably, in the case of the adverb terribly, we observe a trend upward in its use with adjectives of positive polarity in the last century. In the case of the adverb awfully, its use in a positive context seems to increase since the middle of the previous century and decrease as we approach the decade of the 2000s. 

Thus, an initial reformulation of the hypothesis is as follows:

- H0: the use of the markers terribly and awfully (its co-occurring adjectives and the polarity of the latter) and the time and moment it is used are independent.
- H1: the use of the markers terribly and awfully (its co-occurring adjectives and the polarity of the latter) and the time and moment used are interdependent.

A second pair of more specific hypotheses is possible: 

- H0: the use of the markers terribly and awfully with an adjective of lexically opposite polarity is no longer prevalent as we approach the 2000s.
- H1: the use of the markers terribly and awfully with an adjective of lexically opposite polarity is more widespread as we approach the 2000s.

In order to verify these hypotheses, knowing where to target thanks to the exploration, we applied Fisher's Exact Test. The aim is to find that there is a statistically significant relationship between the use of the markers and the different groups of decades, which justifies a more in-depth study of these markers. Regarding the choice of the test, given the size of our observations and variables, it was considered quite relevant to use, despite its cost. 

For this, a 2x2 matrix was created with the occurrences of each marker according to their polarity context for each period and compared. Again, we exclude the period 1810-1850 for its already explained problematic nature. 

<img width="501" alt="pic12" src="https://user-images.githubusercontent.com/77155381/170537230-bc3a5293-02b0-40f8-89b6-421d881af37c.PNG">

In the case of the adverb awfully, we see that between the periods 1910-1950 and 1960-2000, there is not a significant relationship between the variables. This coincides with the periods where awfully, at the beginning, has a tendency to be used with adjectives of positive polarity and which decreases at the end. But, on the other hand, if we compare its two periods with the period of 1860-1900, its "positive" use seems to be related to the moment of its realization. On the terribly side, the values are weakly significant for the comparison between the periods 1910-1950 / 1960-2000 and 1860-1900 / 1960-2000. Indeed, these are the periods where its use has changed. Finally, these results encourage us to continue the study of its markers. 

Conclusion
---
Through different aspects of the studied phenomenon, using data on co-occurrences and polarity, taking advantage of external resources, such as the lexicon, and several multivariate exploratory techniques through a new programming language, we have managed to get an overview of the use of some intensity markers in American English. Nevertheless, the results obtained justify further study of these constructions in order to determine more clearly their change over time. The use of the new version of the COHA corpus is of great interest to us, especially because of the balancing of the last decades and the addition of the period 2010-2019, ideal elements to continue our study. Finally, it is necessary to expand our list of markers to study. 




