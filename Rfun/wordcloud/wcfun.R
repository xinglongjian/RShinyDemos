#Text Mining Package 
library(tm) 
#Word Clouds
library(wordcloud)
#Memoise functions
library(memoise)

# Using "memoise" to automatically cache the results
getTermMatrix<-memoise(function(book){
  
  if(!(book %in% books))
     stop("Unknown book")
  text<-readLines(sprintf("./data/wordcloud/%s.txt.gz",book),encoding="UTF-8")
  #构建语料库
  myCorpus=Corpus(VectorSource(text))
  #全部转为小写
  myCorpus=tm_map(myCorpus,content_transformer(FUN=tolower)) 
  #去掉标点符号
  myCorpus=tm_map(myCorpus,removePunctuation)
  #去掉数字
  myCorpus=tm_map(myCorpus,removeNumbers)
  #去掉一些常用词
  myCorpus=tm_map(myCorpus,removeWords,c(stopwords("SMART"),"thy","thou","thee","the","and","but"))
  #构建一个文档矩阵
  myDTM=TermDocumentMatrix(myCorpus,control=list(minWordLength=1))
  #转化为矩阵
  m = as.matrix(myDTM)
  
  sort(rowSums(m),decreasing=TRUE)
  
})