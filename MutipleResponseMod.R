install.packages('jmvtools', repos=c('https://repo.jamovi.org', 'https://cran.r-project.org'))
jmvtools::check()

jmvtools::create('MultipleResponse')

jmvtools::addAnalysis(name='multipleresponse', title='Multiple Response')

setwd('MultipleResponse')

jmvtools::install()
