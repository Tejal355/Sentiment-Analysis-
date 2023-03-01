install.packages("ggplot2")
install.packages("tm")
install.packages("wordcloud")
install.packages("syuzhet")
install.packages("SnowballC")
library(ggplot2)
library(tm)
library(wordcloud)
library(syuzhet)
library(SnowballC)
getwd()
texts = readLines("article.txt")
View(texts)
print(texts)
docs=Corpus(VectorSource(texts))
docs
trans = content_transformer(function(x, pattern) gsub(pattern, "", x))
docs = tm_map( docs , trans,"/")
docs = tm_map(docs,content_transformer(tolower))
docs = tm_map(docs, removeNumbers)
docs = tm_map(docs,removeWords,stopwords("english"))
docs = tm_map(docs,removePunctuation)
docs = tm_map(docs,stripWhitespace)
docs = tm_map(docs,stemDocument)
docs
dtm = TermDocumentMatrix(docs)
mat = as.matrix(dtm)
mat
v = sort(rowSums(mat), decreasing = T)
v
d = data.frame(word= names(v), freq = v)
head(d)
set.seed(1100)
wordcloud( words = d$word, freq = d$freq, min.freq = 1, max.words = 200,
           random.order = F,rot.per = 0.45,
           colors = brewer.pal(8,"Dark2"))
?get_nrc_sentiment
sentiment = get_nrc_sentiment(texts)
sentiment
head(sentiment)
text = cbind(texts , sentiment)
text
Totalsentiment= data.frame(colSums(text[,c(2:11)])) 
Totalsentiment
names(Totalsentiment) = "count"
Totalsentiment = cbind("sentiment" = rownames(Totalsentiment),
                       Totalsentiment)
Totalsentiment
rownames(Totalsentiment) = NULL

ggplot( data = Totalsentiment , aes( x = sentiment , y = count)) +
  geom_bar(aes(fill = sentiment), stat = "identity")+
  theme(legend.position = "none")+ xlab("Total Sentiment")+
  ylab(" Total count")+ ggtitle("Total Sentiment Score")

