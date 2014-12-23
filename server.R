library(shiny)
library(datasets)
library(ggplot2)

# 定义服务器逻辑
shinyServer(function(input, output) {
  
  dataset <- reactive({
    diamonds[sample(nrow(diamonds), input$sampleSize),]
  })
  
})