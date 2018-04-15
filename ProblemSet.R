library(shiny)
#install.packages("EBMAforecast")
# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Presidential Forecast"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "plot",
                  label = "Choose a forecast:",
                  choices = c("Campbell", "Lewis-Beck", "EWT2C2", "Fair", "Hibbs", "Abramowitz")),
      
      # Input: Specify the number of observations to view ----
      numericInput("obs", "Number of elections to view:", 10),
      
      # Include clarifying text ----
      helpText("Note: while the data view will show only the specified",
               "number of observations, the summary will still be based",
               "on the full dataset."),
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      

      
      # Output: Header + table of distribution ----
      h4("Observations"),
      tableOutput("view"),
      plotOutput("plot", click="plot_click"), 
      verbatimTextOutput("info")
    )
    
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  library("EBMAforecast")
  data(presidentialForecast)
  
plotInput <- reactive({
    switch(input$plot,
           "Campbell" = presidentialForecast$Campbell,
           "Lewis-Beck" = presidentialForecast$`Lewis-Beck`,
           "EWT2C2" = presidentialForecast$EWT2C2,
           "Fair" = presidentialForecast$Fair,
           "Hibbs" = presidentialForecast$Hibbs,
           "Abramowitz" = presidentialForecast$Abramowitz)
  })
  
  
output$plot <- renderPlot({
    input$newplot
    plot(x=1:15, y=presidentialForecast$Actual, main="Election Results", xlab="Election Year",
         ylab="Prediction",type="l", col="Red")
    lines(x=1:15, y=plotInput(), col="Blue")
  })
  
# Return the requested dataset ----
datasetInput <- reactive({presidentialForecast})


# Show the first "n" observations ----
output$view <- renderTable({
  head(datasetInput(), n = input$obs)
})

output$info <- renderText({
  paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
})


}
# Create Shiny app ----
shinyApp(ui, server)