##server.R##

shinyServer(function(input,output){

###the HTC Map###
output$htcmap <- renderLeaflet({
      bins <- c(0, 60, 70, 73, 100)
      
      pal <- colorBin(c("#FED976","#FEB24C" , "#F03B20", "#BD0026"), 
                      domain = states_mrr$mrr,bins = bins, reverse = TRUE)
      labels <- sprintf("<strong>%s</strong><br/>MRR: %g%%",
                        states_mrr$name, states_mrr$mrr) %>% lapply(htmltools::HTML)
   
      htcmap <- leaflet(states_mrr) %>%
        setView(-96, 37.8, 4) %>%
        addProviderTiles("OpenStreetMap.Mapnik") %>%
        addPolygons(
          fillColor = ~pal(mrr),
          weight = 2,
          opacity = 0.7,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = labels,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")) %>%
        addLegend(pal = pal, values = ~states_mrr$mrr, opacity = 0.7, title = NULL,
                  position = "bottomleft" ) %>%
        
        addEasyButton(easyButton(
          icon="fa-globe", title="Zoom to Level 1",
          onClick=JS("function(btn, map){ map.setZoom(1); }"))) %>%
        addEasyButton(easyButton(
          icon="fa-crosshairs", title="Locate Me",
          onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
    })
    

 ###reactive input for the graph#
    stateInput <- reactive({
      
      
      graph_df %>% select(., characteristic, input$state_n, `United States`)
              
         })
    
  ###generate a plot of the data for that state:
   output$bar <- renderGvis({
     gvisBarChart(stateInput(),
                  options=list(
                    title = 'At-risk Populations by States in 2016',
                    #lineWidth=3, pointSize=5,
                    vAxis="{title:'Historically undercounted groups'}",
                    hAxis="{title:'Percentage of population/households population'}", 
                    width=1000, height=750)
              
                                )
   })
   
   
   groupInput <- reactive({
       htc_graph %>% filter(., charact == input$groups )
   })
   
   output$chart <- renderGvis({
     gvisColumnChart(groupInput(),
                     options=list(
                       title = 'At-risk Populations by Groups in 2016',
                       #lineWidth=3, pointSize=5,
                       vAxis="{title:'Percentage of population/households population'}",
                       hAxis="{title:'Historically Undercounted Group'}", 
                       width=1000, height=750))
                     
                    
                     
   })
  ##data table###
  output$table1 <- DT::renderDataTable({
     raw_data
  })


})



  

  

  
  
  
  
  

