lib2load <- c('tidyverse','shiny','shinydashboard','shinymanager',
              'dashboardthemes','shinyWidgets','shinydashboardPlus',
              'shinyalert','plotly','DT','kableExtra','shinycssloaders')

lapply(lib2load, require, character.only = TRUE)

options(shiny.maxRequestSize=30*1024^2)

# credentials

credentials <- data.frame(
  user = c("Kim"),
  password = c("pass"), 
  admin = c(TRUE),
  comment = "SIMPLE TEXT",
  stringsAsFactors = FALSE
)

# ui of the application

ui <- dashboardPage(
  
  # header
  
  dashboardHeader(title = "My Dashboard"),
  
  # sidebar
  
  dashboardSidebar(
    
    sidebarUserPanel(
      name = 'Status',
      subtitle = a(href = "#", icon("circle",class = "text-success"),"Online")
    ),
    
    sidebarMenu(
      id = "tabs",
      menuItem("Report", tabName = "tab1", icon = icon("dashboard"))
    ),
    collapsed = FALSE
  ),
  
  # body
  
  dashboardBody(
    
    shinyalert::useShinyalert(),
    shinyDashboardThemes(theme = "blue_gradient"), 
    
  )
)

# in order to use credentials login

ui <- secure_app(ui)

server <- function(input, output, session) {
  
  # in order to use credentials login
  
  res_auth <- secure_server(check_credentials = check_credentials(credentials))
  
  # shiny alert to welcome user
  
  observe({
    shinyalert::shinyalert(
      title = "Welcome Back",
      text = paste0("Hope you are doing well, "
                    , res_auth$user
                    , '!'), #HTML()
      closeOnEsc = TRUE,
      closeOnClickOutside = TRUE,
      html = FALSE,
      type = "success",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#509CBF",
      timer = 3500,
      imageUrl = "",
      animation = TRUE
    )    
  })
}

shinyApp(ui, server)
