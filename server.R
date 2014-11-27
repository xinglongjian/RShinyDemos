library(shiny)
library(datasets)

# 定义服务器逻辑
shinyServer(function(input, output) {
  
  #cars2<-cars
  #cars2$random<-sample(
    #strsplit("规划话费调度","")[[1]],nrow(cars2),replace=TRUE
   # )
  
 # datasetInput<-reactive({
  #  switch(input$dataset,"掩饰"=rock2,"pressure"=pressure)
 # })
  
  #output$rockvars<-renderUI({
  #  if (input$dataset !="掩饰")return()
  #  selectInput("vars","从掩饰数据中选择"，names(rock2)[-1])
  #})
  
  #output$rockplot<-renderPlot({
  #  validate(need(input$vars,""))
  #  par(mar=c(4,4,.1,.1))
  #  plot(as.formula(paste("面积~",input$vars)),data=rock2)
  #})
})