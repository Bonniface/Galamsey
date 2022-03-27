library(shiny)
library(shinyWidgets)
library(leaflet)
library(markdown)
library(shinythemes)
library(semantic.dashboard)
library(shinycssloaders)
#source("Dashboard_global.R")
ui <- shinyUI(
  navbarMenu(
    title = "Small Scale Mining In Ghana",
    theme = shinytheme("cosmo"),
    tabPanel("Map",tags$img(src ="index.png"),
             div(class = "Outer",
                 tags$head(
                   includeCSS("Dashboard_css.css")
                 ),#Head
                 leaflet("",width="100%",height="100%"),
                 absolutePanel(
                   id = "control",class = "panel panel-default",fixed = TRUE,
                   draggable = TRUE, top = 50,left = "8%",
                   right = "auto",bottom = "auto",
                   width = 0,height = 0,
                   dropdownButton(label = "",
                                  icon = icons("gear"),
                                  status = "primary",
                                  circle = TRUE,
                                  width = 250
                                  )
                   
                 ),#Close Panle
                 absolutePanel(
                   radioGroupButtons("Boundaries", "Boundaries",
                                     choices = c("All", "Ecowas", "Region","District","Settlement","Protected"), 
                                     selected = "ALL"),
                   
                 ),#Close Panle
               
             )#Close Div
      )#TabPanel
  )#Close Nav
)#Close Ui
 server <- function(input, output,session) {
  
}
 shinyApp(ui, server) 
  
  
  

