library(ggplot2)
library(ggvis)
library(plyr)
library(dplyr)
library(RSQLite)

library(datasets)

source("./Rfun/wordcloud/wcfun.R",encoding="utf-8")
source("./Rfun/weather/weather.R",encoding="utf-8")
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
  
  #index----
  city.compare.list<-reactive({
    c1<-NULL
    #2012
    if(input$atl12 ==1) {c1<-c(c1,4)}
    if(input$aus12 ==1) {c1<-c(c1,6)}
    if(input$hnl12 ==1) {c1<-c(c1,13)}
    if(input$lax12 ==1) {c1<-c(c1,23)}
    if(input$mia12 ==1) {c1<-c(c1,26)}
    if(input$lhr12 ==1) {c1<-c(c1,21)}
    if(input$syd12 ==1) {c1<-c(c1,38)}
    if(input$bne12 ==1) {c1<-c(c1,9)}
    if(input$sin12 ==1) {c1<-c(c1,36)}
    if(input$bom12 ==1) {c1<-c(c1,29)}
    #2013
    if(input$atl13 ==1) {c1<-c(c1,5)}
    if(input$aus13 ==1) {c1<-c(c1,7)}
    if(input$hnl13 ==1) {c1<-c(c1,14)}
    if(input$lax13 ==1) {c1<-c(c1,24)}
    if(input$mia13 ==1) {c1<-c(c1,27)}
    if(input$lhr13 ==1) {c1<-c(c1,22)}
    if(input$syd13 ==1) {c1<-c(c1,39)}
    if(input$bne13 ==1) {c1<-c(c1,10)}
    if(input$sin13 ==1) {c1<-c(c1,37)}
    if(input$bom13 ==1) {c1<-c(c1,30)}
    
    city.compare.list<-cities[c1]
  })
  
  num.cities<-reactive({
    length(city.compare.list())
  })
  
  xfontsize<-reactive({
    n<-num.cities()
    if(n<=5) {fnt=20}
    if((n>5)&(n<=9)) {fnt=15}
    if(n>=10){fnt=10}
    return(fnt)
  })
  #subset of cities
  city.df<-reactive({
    subset(city.temp.df,City %in% city.compare.list())
  })
  #summarize the data into Monthlies,1row =1month for 1city
  summarized.df<-reactive({
    
    df<-city.df()
    #extract the month as new column in df
    df$Month<-months(as.Date(df$Date))
    #df$MonthNum<-as.numeric(format(as.Date(df$Date),"%m"))
    #ddply:for each subset of a data.frame,combine results into a data.frame
    monthly.df<-ddply(df,.(City,Month),plyr::summarise,
                      meanT=round(mean(Temperature),1),
                      maxT=round(max(Temperature),0),
                      minT=round(min(Temperature),0))
    daily.max.min<-ddply(df,.(City,Month,Date),plyr::summarise,
                         Dmax=max(Temperature),
                         Dmin=min(Temperature))
    city.temp.mean.of.Max.and.Min<-ddply(daily.max.min,.(City,Month),plyr::summarise,
                                         MeanDMax=round(mean(Dmax),1),
                                         MeanDMin=round(mean(Dmin),1))
    #attach these two columns to the monthly.df
    monthly.df$MeanDmax<-city.temp.mean.of.Max.and.Min$MeanDMax
    monthly.df$MeanDmin<-city.temp.mean.of.Max.and.Min$MeanDMin
    #monthly.df<-monthly.df %>% plyr::arrange(MonthNum)
    
    monthly.df<-within(monthly.df,Month<-factor(Month,levels=month.name))
    return(monthly.df)
  })
  output$WikiChart<-renderPlot({
    smalldf<-summarized.df()
    p<-ggplot(data=smalldf,aes(x=Month,
                               y=meanT,
                               ymin=minT,
                               ymax=maxT))
    p<-p+geom_crossbar(width=0.2,fill="red")
    p<-p+geom_text(data=smalldf,aes(y=maxT+5,label=maxT),color="red")
    p<-p+geom_text(data=smalldf,aes(y=minT-5,label=minT),color="blue")
    p<-p+facet_grid(City ~ .)
    
    p<-p+xlab("Month 2012")+ylab("")
    p<-p+labs(title="City Mean, Max & Min Temperatures, by Month")
    print(p)
  })
  
  #Movie explorer start----
  tryCatch(
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
      ) %>% dplyr::arrange(Oscars)
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
    
  }),
  error = function(e){
    print("movies error.")
    print(e)
    }
  )
  
  #带有ggvis图的rective表达式
  tryCatch(
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
      
  }),error=function(e){
    print(e)
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
  #Word cloud Start----
  terms<-reactive({
    #when the update button is press。。。
    input$bookupdate
    #隔离处理，不能做其他事情
    isolate({
      withProgress({
        getTermMatrix(input$bookselects)
      },min=0,max=1,value=0,message="Processing......")
    })
    
  })
  wordcloud_rep<-repeatable(wordcloud)
  
  output$wordcloudplot<-renderPlot({
    v<-terms()
    wordcloud_rep(names(v),v,scale=c(4,0.5),min.freq=input$wordfreq,max.words=input$wordnums,colors=brewer.pal(8,"Dark2"))
  })
  
  #Word cloud End----
  
  #Basic table start----
  output$basictable<-renderDataTable({
    data<-mpg
    if(input$man!="All"){
      data<-data[data$manufacturer==input$man,]
    }
    if(input$cyl!="All"){
      data<-data[data$cyl==input$cyl,]
    }
    if(input$trans!="All"){
      data<-data[data$trans==input$trans,]
    }
    data
  },options = list(
    searching  = FALSE,
    language=list(
      emptyTable="表中数据为空",
      lengthMenu="显示 _MENU_ 结果",
      loadingRecords="加载......",
      processing="查询......",
      infoEmpty="表中数据为空",
      info="显示第_START_至_END_结果，总共 _TOTAL_ "
      )
    
  ))
  #Basic table end----
})