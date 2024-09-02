install.packages('jmvtools', repos=c('https://repo.jamovi.org', 'https://cran.r-project.org'))
jmvtools::check()

jmvtools::create('vijMR') # Module Name

setwd('vijMR')

jmvtools::addAnalysis(name='frequencies', title='MR Frequencies') # name = function/files name, title = menu item name
jmvtools::addAnalysis(name='crosstabs', title='MR Crosstabs') # name = function/files name, title = menu item name

jmvtools::install()

