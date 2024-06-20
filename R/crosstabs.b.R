
# This file is a generated template, your changes will not be overwritten

crosstabsClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "crosstabsClass",
    inherit = crosstabsBase,
    private = list(
        .init = function() {
            # Add the "total" row here (to prevent flickering)
            self$results$crosstab$addRow(rowKey='.total', values=list(var="Total"))
            self$results$crosstab$addFormat(rowKey=".total", col=1, Cell.BEGIN_GROUP)
            if ( self$options$computedValues == "count" || self$options$computedValues == "options" ) {
              self$results$crosstab$addRow(rowKey='.nbofcases', values=list(var="Number of cases"))
              self$results$crosstab$addFormat(rowKey=".nbofcases", col=1, Cell.BEGIN_GROUP)
            }
            # Set the size of the plot
            image <- self$results$plot
            size <- self$options$size
            if ( size == "small" )
              image$setSize(300, 200)
            else if ( size == "medium" )
              image$setSize(400,300)
            else if ( size == "large" )
              image$setSize(600,400)
            else if ( size == "huge" )
              image$setSize(800,500)           
        },

        .run = function() {
            # Table setup
            if ( self$options$computedValues == "count" ) {
              cellType = "integer"
              cellFormat = ""
            } else {
              cellType = "number"
              cellFormat = "pc"
            }
            table <- self$results$crosstab
            if ( self$options$computedValues == "options" ) {
              table$setTitle("Crosstab (% by row)")
            } else if ( self$options$computedValues == "cases" ) {
              table$setTitle("Crosstab (% of Cases)")
            } else if ( self$options$computedValues == "responses" ) {   
              table$setTitle("Crosstab (% of Responses)")
            }
            # Columns
            if ( ! is.null(self$options$group) ) {
                groups <- self$data[,self$options$group]
                for(i in 1:nlevels(groups))
                  table$addColumn(name = levels(groups)[i], type=cellType, format=cellFormat, superTitle=self$options$group)
                table$addColumn(name = "Total", title="Overall", type=cellType, format=cellFormat)
            }
            # Exceptions
            if ( length(self$options$resps) < 1 )
              return()
            if ( length(self$options$resps) == 1 || is.null(self$options$group)) {
              for(i in 1:length(self$options$resps)) {
                table$setCell(rowKey = self$options$resps[i] ,1,self$options$resps[i])
              }
              return()
            }
            # Computation
            crosstab <- private$.crossTab(self$data, self$options$resps, self$options$group, 
                                  self$options$endorsed, self$options$order, self$options$computedValues)
            # Filling the table
            for(i in 1:(nrow(crosstab)-2))
              table$setRow(rowNo=i,
                           values = c(var=rownames(crosstab)[i], crosstab[i,]))
            table$setRow(rowKey='.total',
                         values = crosstab[i+1,])
            if ( self$options$computedValues == "count" || self$options$computedValues == "options" ) {
              table$setRow(rowKey='.nbofcases', values = crosstab[i+2,])
            }
            image <- self$results$plot
            image$setState(crosstab[1:length(self$options$resps),1:nlevels(groups)])
            
        },

        .plot = function(image, ggtheme, theme, ...) {  # <-- the plot function
          if (is.null(image$state))
            return(FALSE)
          
          optionsVar <- "Options"
          groupVar <- self$options$group
          
          if (self$options$xaxis == "xcols") {
            xVarName <- ensym(groupVar)
            zVarName <- ensym(optionsVar)
          } else {
            xVarName <- ensym(optionsVar)
            zVarName <- ensym(groupVar)
          }
          
          #plotData <- image$state
          plotData <- cbind("Options" = factor(rownames(image$state), levels=rownames(image$state)),image$state)
          plotData <- pivot_longer(plotData, cols=colnames(image$state), names_to = self$options$group, values_to = "Count")
          
          plot <- ggplot(plotData, aes(x=!!xVarName, y=Count)) +  geom_col( aes(fill=!!zVarName), position = self$options$bartype) + ggtheme
          if ( self$options$computedValues == "responses" ) {
            plot <- plot + labs(y="% of Responses") + scale_y_continuous(labels=percent_format())
          } else if ( self$options$computedValues == "cases" ) {
            plot <- plot + labs(y="% of Cases") + scale_y_continuous(labels=percent_format())
          } else     if ( self$options$computedValues == "options" ) {
            plot <- plot + labs(y="% within groups") + scale_y_continuous(labels=percent_format())
          }
            
          return(plot)
          
        },
                
        .crossTab = function (data, items = NULL, group = NULL, endorsedOption = 1, order='none', values='count') {
          options = data[, items]
          groups = list(data[,group])
          # CrossTab
          crossTab <- aggregate(options == endorsedOption, groups, sum, na.rm = TRUE)
          # Save group names
          groupNames <- crossTab[,1]
          # Transpose the content of the table
          crossTab <- as.data.frame(t(crossTab[,-1])) 
          # Rename the columns of the table
          names(crossTab) <- groupNames
          # Compute the number of cases by group
          NbOfCases <- aggregate( !apply(apply(options, 1, is.na), 2, all), groups, sum )
          NbOfCases <- c( NbOfCases[,2], sum(NbOfCases[,2]))
          # Add the margin column to crosstab
          crossTab <- cbind(crossTab, "Total" = rowSums(crossTab))
          # Sorting crosstab
          if (order == 'decreasing') {
            crossTab<-crossTab[order(crossTab$Total, decreasing = TRUE),]
          } else if (order == 'increasing') {
            crossTab<-crossTab[order(crossTab$Total, decreasing = FALSE),]
          }
          # add margin row to  crosstab
          NbOfResps <- colSums(crossTab)
          crossTab <- rbind(crossTab, "Total" = NbOfResps)
          #
          if (values == 'cases') {
            crossTab <- sweep( crossTab , 2, NbOfCases, "/")
            crossTab <- rbind(crossTab, "Nb of Cases"=NbOfCases)
          } else if (values == 'responses' ) {
            crossTab <- sweep( crossTab , 2, NbOfResps, "/")
            crossTab <- rbind(crossTab, "Nb of Cases"=NbOfCases)
          } else if (values == 'options' ) {
            crossTab <- rbind(crossTab, "Nb of Cases"=NbOfCases)
            crossTab <- sweep( crossTab , 1, rowSums(crossTab)/2, "/") 
          } else {
            crossTab <- rbind(crossTab, "Nb of Cases"=NbOfCases)
          }
          # Return result
          return(crossTab)
        }
    )
)
