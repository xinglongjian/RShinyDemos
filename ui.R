library(shiny)
library(ggplot2)
library(ggvis)

library(datasets)
dataset <- diamonds

# 定义带菜单栏的用户界面
shinyUI(navbarPage("R小站",
  #菜单栏开始-----
  #一级菜单“首页”----
  #
  tabPanel("首页",
     fluidPage(
       #addResourcePath("./www/js/index.js"),
       fluidRow(
         column(10, offset = 1,
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
              withTags(
                div(
                  h4("US Cities"),
                  div( class="row-fluid",
                       div( class="span5","Atlanta, GA"),            
                       div(class='span3',checkboxInput(inputId = "atl12",label = "2012",value=TRUE)),
                       div(class='span3',checkboxInput(inputId = "atl13",label = "2013", value=FALSE))),
                  div( class="row-fluid",
                       div( class="span5","Austin, TX"),            
                       div(class='span3',checkboxInput(inputId = "aus12",label = "2012",value=FALSE)),
                       div(class='span3',checkboxInput(inputId = "aus13",label = "2013",value=FALSE))),
                  div( class="row-fluid",
                       div( class="span5","Honolulu, HI"),            
                       div(class='span3',checkboxInput(inputId = "hnl12",label = "2012",value=FALSE)),
                       div(class='span3',checkboxInput(inputId = "hnl13",label = "2013",value=FALSE))),
                  div( class="row-fluid",
                       div( class="span5","Los Angeles, CA"),            
                       div(class='span3',checkboxInput(inputId = "lax12",label = "2012",value=FALSE)),
                       div(class='span3',checkboxInput(inputId = "lax13",label = "2013",value=FALSE))),
                  div( class="row-fluid",
                       div( class="span5","Miami, FL"),            
                       div(class='span3',checkboxInput(inputId = "mia12",label = "2012",value=FALSE)),
                       div(class='span3',checkboxInput(inputId = "mia13",label = "2013",value=FALSE)))
                )
           ))
         ),
         column(4,
                wellPanel(
                  withTags(
                    div(
                      h4("Outside the US"),
                      div( class="row-fluid",
                           div( class="span5","London, UK"),            
                           div(class='span3', checkboxInput(inputId = "lhr12", label = "2012", value=FALSE)),
                           div(class='span3', checkboxInput(inputId = "lhr13", label = "2013", value=FALSE))),
                      div( class="row-fluid",
                           div( class="span5", "Sydney, AUS"),            
                           div(class='span3', checkboxInput(inputId = "syd12", label = "2012", value=FALSE)),
                           div(class='span3', checkboxInput(inputId = "syd13", label = "2013", value=FALSE))),
                      div( class="row-fluid",
                           div( class="span5", "Brisbane, AUS"),            
                           div(class='span3', checkboxInput(inputId = "bne12", label = "2012", value=FALSE)),
                           div(class='span3', checkboxInput(inputId = "bne13", label = "2013", value=FALSE))),
                      div( class="row-fluid",
                           div( class="span5", "Singapore, SIN"),            
                           div(class='span3', checkboxInput(inputId = "sin12", label = "2012", value=FALSE)),
                           div(class='span3', checkboxInput(inputId = "sin13", label = "2013", value=FALSE))),
                      div( class="row-fluid",
                           div( class="span5", "Mumbai, IND"),            
                           div(class='span3', checkboxInput(inputId = "bom12", label = "2012", value=FALSE)),
                           div(class='span3', checkboxInput(inputId = "bom13", label = "2013", value=FALSE)))
                    )
                  )
            )
         ),
         column(4,
            p("参考：",a("WeatherCompare", href="https://github.com/Ram-N/WeatherCompare"))
       )),
       fluidRow(
         tabsetPanel(id ="graphtabs",
              tabPanel("Wiki-Style Char", 
                  plotOutput(outputId="WikiChart", width = "100%", height = "800px")       
              )
        )
       )
       )),
  #一级菜单“Shiny”----
  navbarMenu("Shiny例子",
      #"Shiny例子"-"Interactive visualizations" ---- 
      tabPanel("Interactive visualizations",
          navlistPanel(
            "header",
            tabPanel("Movie explorer",
                fluidRow(
                  column(3,
                      wellPanel(
                        h4("Filter"),
                        sliderInput("reviews","Minimum number of reviews on Rotten Tomatoes",10,300,80,step=10),
                        sliderInput("year","Year released",1940,2014,value=c(1970,2014)),
                        sliderInput("oscars","Minimum number of Oscar wins(call categories)",0,4,0,step=1),
                        sliderInput("boxoffice","Dollars at Box Office (millions)",0,800,c(0,800),step=1),
                        selectInput("genre","Genre (a movie can have multiple genres)",
                                   c("All","Action","Adventure","Animation","Biography","Comedy",
                                     "Crime","Documentary","Drama","Family","Fantasy","History",
                                     "Horror","Music","Musical","Mystery","Romance","Sci-Fi",
                                     "Short","Sport","Thriller","War","Western")),
                        textInput("director","Director name contains (e.g., Miyazaki)",value = ""),
                        textInput("cast","Cast names contains (e.g. Tom Hanks)",value = "")
                      ),
                      wellPanel(
                        selectInput("xvar","X-axis Variable",axis_vars,selected="Meter"),
                        selectInput("yvar","Y-axis Variable",axis_vars,selected="Reviews"),
                        tags$small(paste0("Note: The Tomato Meter is the proportion of positive reviews",
                                         " (as judged by the Rotten Tomatoes staff), and the Numeric rating is",
                                         " a normalized 1-10 score of those reviews which have star ratings",
                                         " (for example, 3 out of 4 stars)."))
                        )
                  ),
                  column(9,
                        ggvisOutput("me_plot"),
                        wellPanel(
                          span("Number of movies selected:"),
                          textOutput("me_movies"),
                          p("参考：",a("官网Movie explorer例子",href="http://shiny.rstudio.com/gallery/movie-explorer.html"))
                          
                          )
                  )
                )
            ),
            tabPanel("NVD3 line chart output",h3("This is the first panel")
            ),
            tabPanel("Google Charts",h3("This is the first panel")
            ),widths = c(3, 9))
        ),
      #"Shiny例子"-"Start simple" ----
      tabPanel("Start simple",
          navlistPanel(
            "header",
            tabPanel("Kmeans example",
                fluidRow(
                  column(3,
                     wellPanel(
                       selectInput('xcol','X 变量',irisnames),
                       selectInput('ycol','Y 变量',irisnames,selected=irisnames[[2]]),
                       numericInput('clusters','簇数',3,min=1,max=9)
                       )
                      ),
                  column(9,
                      plotOutput('ke_plot'),
                      wellPanel(
                        h3("K-means聚类算法:"),
                        p("K-means算法接受参数k，然后将事先输入的n个数据对象划分为k个聚类以便使得所获得的聚类满足：同一聚类中的对象相似度高，而不同聚类中的对象相似度低。
                          聚类相似度是利用各聚类中对象的均值所获得一个中心对象来进行计算的。"),
                        p("K-means算法是最为经典的基于划分的聚类算法，是十大经典数据挖掘算法之一。K-means算法的基本思想是：以空间中k个点为中心进行聚类，对最靠近他们的对象归类。
                          通过迭代的方法，逐次更新各聚类中心的值，直到得到最好的聚类结果。"),
                        p("参考：",a("官网Kmeans example例子",href="http://shiny.rstudio.com/gallery/kmeans-example.html"))
                      )
                  ))   
            ),
            tabPanel("Telephones by region",
                fluidRow(
                  column(3,
                    wellPanel(
                      selectInput("region","区域:",choices=colnames(WorldPhones)),
                      hr(),
                      helpText("来源于AT&T(1961)全世界的电话数据.")
                      )),
                  column(9,
                      plotOutput("phonePlot"),
                      wellPanel(
                        p("参考：",a("官网Telephones by region例子",href="http://shiny.rstudio.com/gallery/telephones-by-region.html"))
                        )
                    )
                  )
            ),
            tabPanel("Word cloud",
                fluidRow(
                  column(4,wellPanel(
                    selectInput("bookselects","选择一本书",choices=books),
                    actionButton("bookupdate","更新"),
                    hr(),
                    sliderInput("wordfreq","频率最小值：",min=1,max=50,value=15),
                    sliderInput("wordnums","单词最大数", min=1,max=300,value=100)
                    )),
                  column(8,
                    plotOutput("wordcloudplot"),
                    wellPanel(
                      p("参考：",a("官网Word cloud例子",href="http://shiny.rstudio.com/gallery/word-cloud.html",target="blank"))
                    )
                    )
                  
                  )
            ),
#             tabPanel("Single-file shiny app",
#                      h3("This is the first panel")
#             ),
            widths = c(3, 9))
      ),
      #"Shiny例子"-"Widgets" ----
      tabPanel("Widgets",
          navlistPanel(
            "header",
            tabPanel("basic-datatable",
                fluidRow(
                  column(4,
                      selectInput("man","制造商:",c("All",unique(as.character(mpg$manufacturer))))
                      ),
                  column(4,
                      selectInput("trans","传输方式:",c("All",unique(as.character(mpg$trans))))
                      ),
                  column(4,
                      selectInput("cyl","气缸数：",c("All",unique(as.character(mpg$cyl))))
                      )
                  ),
                fluidRow(
                  dataTableOutput(outputId="basictable")
                )
            ),
#             tabPanel("Date and date range",h3("This is the first panel")
#             ),
#             tabPanel("Custom input control",h3("This is the first panel")
#             ),
#             tabPanel("MathJax",h3("This is the first panel")
#             ),
            widths = c(3, 9))
      )
      #"Shiny例子"-"Application layout" ----
#       tabPanel("Application layout",
#           navlistPanel(
#             "header",
#             tabPanel("Tabsets",h3("This is the first panel")
#             ),
#             tabPanel("Plot plus three columns",h3("This is the first panel")
#             ),
#             tabPanel("Navbar Example",h3("This is the first panel")
#             ),
#             tabPanel("Vertical Layout",h3("This is the first panel")
#             ),
#             tabPanel("Retirement simulation",h3("This is the first panel")
#             ),
#             tabPanel("navlistPanel example",h3("This is the first panel")
#             ),
#             tabPanel("Absolutely-positioned panels",h3("This is the first panel")
#             ),
#             tabPanel("Including HTML, text, and Markdown files",h3("This is the first panel")
#             ),
#             tabPanel("Inline Output",h3("This is the first panel")
#             ),
#             widths = c(3, 9))
#       ),
      #"Shiny例子"-"Dynamic user interface" ----
#       tabPanel("Dynamic user interface",
#           navlistPanel(
#             "header",
#             tabPanel("conditionalPanel demo",h3("This is the first panel")
#             ),
#             tabPanel("Dynamic UI",h3("This is the first panel")
#             ),
#             tabPanel("Update input demo",h3("This is the first panel")
#             ),widths = c(3, 9))
#       ),
      #"Shiny例子"-"Reactive programming" ----
#       tabPanel("Reactive programming",
#           navlistPanel(
#             "header",
#             tabPanel("Reactivity",h3("This is the first panel")
#             ),
#             tabPanel("actionButton demo",h3("This is the first panel")
#             ),
#             tabPanel("submitButton demo",h3("This is the first panel")
#             ),
#             tabPanel("isolate demo",h3("This is the first panel")
#             ),
#             tabPanel("Observer demo",h3("This is the first panel")
#             ),
#             tabPanel("Timer",h3("This is the first panel")
#             ),
#             tabPanel("Reactive poll and file reader",h3("This is the first panel")
#             ),widths = c(3, 9))
#       ),
      #"Shiny例子"-"Advanced Shiny" ----
#       tabPanel("Advanced Shiny",
#          navlistPanel(
#             "header",
#             tabPanel("Server-to-client custom messages",h3("This is the first panel")
#             ),
#             tabPanel("Client data and query string",h3("This is the first panel")
#             ),
#             tabPanel("Image output",h3("This is the first panel")
#             ),
#             tabPanel("Chat room",h3("This is the first panel")
#             ),
#             tabPanel("Download knitr Reports",h3("This is the first panel")
#             ),
#             tabPanel("Selectize rendering methods",h3("This is the first panel")
#             ),
#             tabPanel("Option groups for server-side selectize",h3("This is the first panel")
#             ),
#             tabPanel("Creating a UI from a loop",h3("This is the first panel")
#             ),
#             tabPanel("Progress bar example",h3("This is the first panel")
#             ),
#             tabPanel("Alternative Progress Bar",h3("This is the first panel")
#             ),widths = c(3, 9))
#       ),
      #"Shiny例子"-"Shiny Server Pro" ----
#       tabPanel("Shiny Server Pro",
#           navlistPanel(
#             "header",
#             tabPanel("Authentication and database",h3("This is the first panel")
#             ),
#             tabPanel("Personalized UI",h3("This is the first panel")
#             ),widths = c(3, 9))
#       ),
      #"Shiny例子"-"Internationalization" ----
#       tabPanel("Internationalization",
#           navlistPanel(
#             "header",
#             tabPanel("Unicode characters",h3("This is the first panel")
#             ),widths = c(3, 9))
#       )
      ),     
  #一级菜单“数据挖掘”----
  navbarMenu("数据挖掘",
             #"数据挖掘"-"基础知识" ----     
             tabPanel("基础知识",
                      navlistPanel(
                        "header",
                        tabPanel("Tab1",
                                 h3("This is the first panel")
                        ),
                        "-----",
                        tabPanel("Tab2",
                                 h3("dfsdfad")
                        ),widths = c(3, 9))
             ),  
             #"数据挖掘"-"例子" ---- 
             tabPanel("例子",
                      navlistPanel(
                        "header",
                        tabPanel("练习",
                                 plotOutput('plot'),
                                 hr(),
                                 fluidRow(
                                   column(2,
                                          "sidebar"
                                   ),
                                   column(10,
                                          "main"
                                   )
                                 )
                        ),
                        "-----",
                        tabPanel("ddd",
                                 h3("This is the first panel")
                        ),widths = c(3, 9))
             )        
  ),        
  #一级菜单“统计分析”----
  #navbarMenu("统计分析",
  ##   tabPanel("R语法")        
  #),
  #菜单栏结束-----
  id="rshinydemo",
  inverse=TRUE,
  collapsable=TRUE,
  fluid=TRUE,
  responsive=TRUE
))