# tw-dashboard
R shiny dashboard app to oversee and manage Groundwork's TW PMP and SHV programmes

Dependencies
------------
Required packages

```{r}
#packages
install.packages(shinydashboard)
install.packages(RPostgreSQL)
install.packages(data.table)
install.packages(markdown)
install.packages(reshape2)
install.packages(ggplot2)
install.packages(shinyjs)
install.packages(shiny)
install.packages(dplyr)

#devtools
install.packages('devtools')
devtools::install_github('rstudio/DT')
```

Required files
```{r}
#database parms
db.R
```