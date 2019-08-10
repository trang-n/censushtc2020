##global.R
#install.packages("devtools")
#install.packages("googleVis")
# install.packages('shinyHeatmaply')
library(rsconnect)
library(expss)
library(ggsci)
library(geojsonio)
library(shinyHeatmaply)
library(googleVis)
library(tidyverse)
library(DT)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(RColorBrewer)

#read in files
raw_data <- read.csv("./data/htc_tract.csv")
colnames(raw_data) <- as.character((unlist(raw_data[1,])))
raw_data <- raw_data[-1,]
rownames(raw_data) <- NULL

states_mrr <- geojson_read( "./data/us-states.json", what = "sp")
long_lat <- read.csv("./data/stateLL.csv")

state_char <- read.csv("./data/social_states.csv")
nation_char <- read.csv("./data/totalPop.csv")
state_char <- state_char[,-1]
state_char <- state_char %>% rename(., state_name = Geography)
state_char <- state_char %>% rename(., tot_HH = tot_HH.)
state_char <- state_char %>% rename(., enterb4_2000 = enterb4_2009)
nation_char <- nation_char %>% rename(., state_name = Geography)
nation_char <- nation_char %>% rename(., tot_HH = tot_HH.)
state_char<- rbind(state_char, nation_char)
state_char <- state_char %>% mutate(., no_internet = 100 - HH_internet)
state_char <- state_char %>% mutate(., no_comp = 100 - HH_comp)
                                
###calculate poverty rate from raw_data
raw_data %>% group_by(., Poverty_TOTAL, State_name)
choice <- state.name
choice
class(choice)

#declare all variables

df <- state_char %>%
  select(., state_name, under_five, HH_rent, no_internet,
         no_comp, non_espeaker, limited_eprof, 
         diff_state, respop_abroad, enter2010later)


df$state_name <- as.character(df$state_name)
graph_df <- data.frame(characteristic = colnames(df)[-1], t(df[-1]))

colnames(graph_df)[-1]  <- df[,1]
rownames(graph_df)<- NULL

###change characteristics
graph_df$characteristic
graph_df$charact <- c("Children under 5 ", "Households occupied by renters ",
                             "Households w/o internet ", "Households w/o computer ",
                              "Non-english speakers ",
                             "Limited English proficiency ", "Residents from different state ",
                             "Residents from abroad ", "Residents entered after 2010 ")

graph_df$characteristic <- graph_df$charact
####
htc_st <- as.character(states_mrr$name[states_mrr$mrr<73])
htc_st <- htc_st[-22]
htc_st
htc_graph <- graph_df %>% select(.,  charact, htc_st)
htc_graph




plt <- googleVis::gvisColumnChart(graph_df)
#plot(plt)
