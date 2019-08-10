##ui.R##

shinyUI(
###choose theme and title###
    navbarPage(
        title = "Census 2020 Hard to Count Population App",
        theme = shinytheme("flatly"),
###create welcome tab with brief intro###
    tabPanel("Welcome",
        mainPanel(
            div(
                style = "margin-left: 6%;",
                
                h3(strong("Welcome to the 2020 Census Hard to Count Shiny App ")),
                br(),
                br(),
                p("This Shiny App maps and graphs the 'hard to count' population state-wise, to provide information
                  to local, regional, and national organizations to ensure a fair and accurate count 
                  for the decennial 2020 Census. "),
                br(),
                h4(strong("What is the 'hard to count' population?")),
                p("In prior censuses, the self-response rate in many parts of the country has been relatively high.
                  But in other parts of the country and for some population groups more than others, the 
                  self-response rate has been relatively low."),
                p(strong("These areas and population groups are considered 'hard to count'.")),
                br(),
                h4(strong("How is hard-to-count population defined?")),
                p("For the HTC map, a state is considered hard-to count if its self-response rate in the 2010 
                  decennial census was 73% or less, which will be shaded in light orange or red. The 73% mail return rate threshold is used because it represents 
                  all tracts nationwide that are in the bottom 20 percent of 2010 mail return rates - i.e., the worst 20% of return rates. 
                  This is consistent with the definition of hard-to-count tracts from the 2010 census outreach campaign."),
                p("For the charts, each state's population is visualized by some of the historically undercounted groups such as: young
                  children, rural residents; linguistically isolated households; frequent movers; 
                  and foreign born residents among others. The last insight tab visualizes each group by all of HTC states' population."),
                br(),
                h4(strong("Why does it matter?")),
                p("An undercount of the population would have far-reaching consequences. It 
                  would skew the data that are used to determine how many congressional representatives each state gets and their representation 
                  in state legislatures and local government bodies."),
                p("It would also shape how billions of dollars are allocated a year, including for schools and hospitals. It would undermine the
                  integrity of a wide variety of economic data and other statistics that businesses, researchers and policymakers depend on
                  to make decisions."),
                br(),
                h4(strong("Where is the data from?")),
                p("The data was obtained from the", a("U.S. Census Bureau",
                                                      href = "https://www.census.gov/data/datasets/2010/dec/2010-participation-rates.html"),
                  "and", a("American FactFinder by the Census Bureau."),
                                                      href = "https://bit.ly/2gghFV3"),
                br(),
                p(strong("Enjoy your visit!"))
                
            )
        )     
    ),

 ###create hard to count map showing states's Mail return rate  
    
    tabPanel("HTC map", leafletOutput("htcmap", height = 800),
             tags$head(includeCSS('style.css')),
             absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                           draggable = TRUE, top = 80, left = "auto", 
                           right = 20, bottom = "auto",
                           width = 330, height = "auto",
                          
                            selectInput("state_m", label = h4("States"),
                                        choice = c("",state.name ),
                                        selected = ""),
                              htmlOutput("bar_C")
                           
                        )),

###visualizing data by states###
    tabPanel("HTC insight: States",
             
      sidebarLayout( 
          
            sidebarPanel(width = 2,
            
                 selectizeInput("state_n",
                           label = "Select a State",
                           choice,
                           width = 150)
                         ),
          ###main Panel to display output
          mainPanel(
            htmlOutput("bar")
  
                
            
                        
      ))),
###
      tabPanel("HTC insight: Groups",
          sidebarLayout(
            
            sidebarPanel(width = 2,
                         
                         selectizeInput("groups",
                                        label = "Select a Group",
                                        choices = htc_graph$charact,
                                        width = 250)
            ),
            ###main Panel to display output
            mainPanel(
              htmlOutput("chart")
            
          ))),
###display data table
      tabPanel("Data",
               
        fluidPage(
          
          DT::dataTableOutput("table1"))
      
      
      )


  


    )



)




  

    