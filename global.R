
axis_vars <- c(
  "Tomato Meter" = "Meter",
  "Numeric Rating" = "Rating",
  "Number of reviews" = "Reviews",
  "Dollars at box office" = "BoxOffice",
  "Year" = "Year",
  "Length (minutes)" = "Runtime"
)

irisnames<-c('萼片长度'='Sepal.Length','萼片宽度'='Sepal.Width','花瓣长度'='Petal.Length','花瓣宽度'='Petal.Width')

# The list of valid books wordcloud
books <<- list("A Mid Summer Night's Dream" = "summer","The Merchant of Venice" = "merchant", "Romeo and Juliet" = "romeo")
#生成提示信息的函数
movie_tooltip<-function(x){
  if(is.null(x)) return(NULL)
  if(is.null(x$ID)) return(NULL)
  
  #通过ID获取电影信息
  all_movies<-isolate(movies())
  movie<-all_movies[all_movies$ID == x$ID,]
  
  paste0("<b>",movie$Title,"</b><br/>",movie$Year,"<br/>",
         "$",format(movie$BoxOffice,big.mark=",",scientific=))
}