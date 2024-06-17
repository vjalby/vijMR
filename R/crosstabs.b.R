
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
        },
        .run = function() {
            # `self$data` contains the data
            # `self$options` contains the options
            # `self$results` contains the results object (to populate)
            if ( self$options$computedValues == "count" ) {
                cellType = "integer"
                cellFormat = ""
            } else {
                cellType = "number"
                cellFormat = "pc"
            }
                
            crosstab <- private$.crossTab(self$data, self$options$resps, self$options$group, 
                                  self$options$endorsed, self$options$order, self$options$computedValues)
            #self$results$text$setContent(crosstab)
            #self$results$text$setContent( levels(self$data[,self$options$group]))
            # construction of the table
            table <- self$results$crosstab
            groups <- self$data[,self$options$group]
            for(i in 1:nlevels(groups))
                table$addColumn(name = levels(groups)[i], type=cellType, format=cellFormat, superTitle=self$options$group)
            table$addColumn(name = "Total", title="Overall", type=cellType, format=cellFormat)
            for(i in 1:(nrow(crosstab)-2))
              table$setRow(rowNo=i,
                           values = c(var=rownames(crosstab)[i], crosstab[i,]))
            table$setRow(rowKey='.total',
                         values = crosstab[i+1,])
            if ( self$options$computedValues == "count" || self$options$computedValues == "options" ) {
              table$setRow(rowKey='.nbofcases', values = crosstab[i+2,])
            }
        },
        
        .crossTab = function (data, items = NULL, group = NULL, endorsedOption = 1, order='none', values='count') {
          # From userfriendlyscience package
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
