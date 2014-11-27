library(shiny)
# 定义带菜单栏的用户界面
shinyUI(navbarPage("R小站",
  #菜单栏开始-----
  #首页
  tabPanel("首页",
     fluidPage(
       fluidRow(
         column(6, offset = 3,
            p("该R小站以shiny框架为基础搭建,主要包含于R相关的技术总结和应用实例。通过web方式与大家共享，希望多多交流，共同进步！
              作者:xinglongjian,
              github:https://github.com/xinglongjian,
              个人博客:http://www.xinglongjian.com
              ", 
            style = "font-family: '\"Times New Roman\",Georgia,Serif';")
         )
       ),
       br(),
       fluidRow(
         column(4,
            wellPanel(
              h3("Buttons"),
              actionButton("action", label = "Action"),
              br(),
              br(), 
              submitButton("Submit"))),
         column(4,
            wellPanel(
              h3("Buttons"),
              actionButton("action", label = "Action"),
              br(),
              br(), 
              submitButton("Submit"))),
         column(4,
            wellPanel(
              h3("Buttons"),
              actionButton("action", label = "Action"),
              br(),
              br(), 
              submitButton("Submit")))
         )
       )),
  #R基础
  navbarMenu("R基础",
     tabPanel("R语言",
        navlistPanel(
          "header",
          tabPanel("Tab1",
            h3("This is the first panel")
          ),
          "-----",
          tabPanel("Tab2",
            h3("dfsdfad")
            )
          )),           
     tabPanel("R语法")        
  ),
  #Shiny基础
  tabPanel("Shiny基础"),
  #统计分析
  navbarMenu("统计分析",
     tabPanel("R语言"),           
     tabPanel("R语法")        
  ),
  #菜单栏结束-----
  id="rshinydemo",
  inverse=TRUE,
  collapsable=TRUE,
  fluid=TRUE,
  responsive=TRUE
))