library(ggplot2)
library(ggvis)
library(dplyr)
library(RSQLite)

library(datasets)

source("./Rfun/wordcloud/wcfun.R",encoding="utf-8")
#library(RSQLite.extfuns)
#在app启动时处理数据集----
##movie explorer data----
db<-src_sqlite("data/movies.db")
omdb<-tbl(db,"omdb")
tomatoes<-tbl(db,"tomatoes")
#合并表，然后过滤评论数小于10的数据，选择特定的列
all_movies<-inner_join(omdb,tomatoes,by="ID") %>%
  filter(Reviews>=10) %>%
  select(ID,imdbID,Title,Year,Rating_m=Rating.x,Runtime,Genre,Released,
         Director,Writer,imdbRating,imdbVotes,Language,Country,Oscars,Cast,
         Rating=Rating.y,Meter,Reviews,Fresh,Rotten,userMeter,userRating,
         userReviews,BoxOffice,Production)

#kmeansExamples----
palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))


# 定义服务器逻辑----
shinyServer(function(input,output,session) {
  
  #Movie explorer start----
  movies<-reactive({
    reviews<-input$reviews
    oscars<-input$oscars
    minyear<-input$year[1]
    maxyear<-input$year[2]
    minboxoffice<-input$boxoffice[1]*1e6
    maxboxoffice<-input$boxoffice[2]*1e6
    
    #应用过滤
    m<-all_movies %>% filter(
      Reviews>=reviews,
      Oscars>=oscars,
      Year>=minyear,
      Year<=maxyear,
      BoxOffice>=minboxoffice,
      BoxOffice<=maxboxoffice
      ) %>% arrange(Oscars)
    #通过人过滤(可选)
    if(input$genre!="All"){
     genre<-paste0("%",input$genre,"%")
     m<-m %>% filter(Genre %like% genre)
    }
    #通过导演过滤(可选)
    if(!is.null(input$director)&&input$director !=""){
     director<-paste0("%",input$director,"%")
     m<-m %>% filter(Director %like% director)
    }
    #通过演员过滤(可选)
    if(!is.null(input$cast)&&input$cast!=""){
     cast<-paste0("%",input$cast,"%")
     m<-m %>% filter(Cast %like% cast)
    }
    
    m<-as.data.frame(m)
    #添加一列来标识该电影是否赢得了奥斯卡
    m$has_oscar<-character(nrow(m))
    m$has_oscar[m$Oscars == 0]<-"NO"
    m$has_oscar[m$Oscars == 1]<-"Yes"
    
    m
    
  })
  
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
  
  #带有ggvis图的rective表达式
  vis<-reactive({
    #坐标表名称
    xvar_name<-names(axis_vars)[axis_vars == input$xvar]
    yvar_name<-names(axis_vars)[axis_vars == input$yvar]
    
    xvar<-prop("x",as.symbol(input$xvar))
    yvar<-prop("y",as.symbol(input$yvar))
    
    movies %>% 
      ggvis(x=xvar,y=yvar) %>%
      layer_points(size :=50,size.hover :=200,fillOpacity :=0.2,
                   fillOpacity.hover :=0.5,stroke =~has_oscar,key :=~ID) %>%
      add_tooltip(movie_tooltip,"hover") %>%  
      add_axis("x",title=xvar_name) %>%
      add_axis("y",title=yvar_name) %>%
      add_legend("stroke",title="Win Oscars",values=c("Yes","No")) %>%
      scale_nominal("stroke",domain=c("Yes","No"),range=c("orange","#aaa")) %>%
      set_options(width=500,height=500)
      
  })
  
  vis %>% bind_shiny("me_plot")
  output$me_movies<-renderText({nrow(movies())})
  #Movie explorer end----
  
  #KMeans Example start----
  selectedData<-reactive({
    iris[,c(input$xcol,input$ycol)]
  })
  clusters<-reactive({
    kmeans(selectedData(),input$clusters)
  })
  output$ke_plot<-renderPlot({
    par(mar=c(5.1,4.1,0,1))
    plot(selectedData(),col=clusters()$cluster,pch=20,cex=3)
    points(clusters()$centers,pch=4,cex=4,lwd=4)
  })
  #KMeans Example end----
  
  #Telephones by region Start----
  output$phonePlot<-renderPlot({
    barplot(WorldPhones[,input$region],main=input$region,ylab="Numbers of Telephons",xlab="Year")
  })
  #Telephones by region End----
  print("end1")
  #Word cloud Start----
  terms<-reactive({
    #when the update button is press。。。
    input$bookupdate
    print("end2")
    #隔离处理，不能做其他事情
    isolate({
      withProgress({
        #getTermMatrix(input$bookselects)
      },min=0,max=1,value=0,message="Processing......",session)
    })
    
  })
  print("end3")
  wordcloud_rep<-repeatable(wordcloud)
  
  output$wordcloudplot<-renderPlot({
    v<-terms()
    print("end4")
    wordcloud_rep(names(v),v,scale=c(4,0.5),min.freq=input$wordfreq,max.words=input$wordnums,colors=brewer.pal(8,"Dark2"))
  })
  
  #Word cloud End----
  
})