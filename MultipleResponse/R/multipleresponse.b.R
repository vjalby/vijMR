
# This file is a generated template, your changes will not be overwritten

multipleresponseClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "multipleresponseClass",
    inherit = multipleresponseBase,
    private = list(
        .init = function() {
            image <- self$results$plot
            size <- self$options$size
            if ( size == "small" ) {
                image$setSize(300, 200)
            } else if ( size == "medium" ) {
                image$setSize(400,300)
            } else if ( size == "large" ) {
              image$setSize(600,400)
            } else if ( size == "huge" ) {
              image$setSize(800,500)
            }
        },
        .run = function() {
            # `self$data` contains the data
            # `self$options` contains the options
            # `self$results` contains the results object (to populate)

            if ( length(self$options$resps) < 2 )
                return()

            myresult <- private$.multipleResponse(self$data, self$options$resps, self$options$endorsed, self$options$order)
            #self$results$text$setContent( myresult$df )

            table <- self$results$responses
            for(i in 1:(nrow(myresult$df)-1))
                table$setRow(rowNo=i,
                             values=list(var=myresult$df[i,1],
                                         freq=myresult$df[i,2],
                                         responsepercent=myresult$df[i,3],
                                         casepercent=myresult$df[i,4]))

            if ( self$options$showTotal ) {
                i <- nrow(myresult$df)
                table$addRow("total",
                             values=list(var="Total",
                                         freq=myresult$df[i,2],
                                         responsepercent=myresult$df[i,3],
                                         casepercent=myresult$df[i,4]))
            }

            table$setNote('noc', paste("Number of cases:", myresult$nrOfCases) , init=FALSE)

            image <- self$results$plot
            image$setState(myresult$df[1:(nrow(myresult$df)-1),])

        },
        .plot = function(image, ggtheme, theme, ...) {  # <-- the plot function
            if (is.null(image$state) || length(self$options$resps) < 2)
                return(FALSE)

            plotData <- image$state

            # to be sure the factor ordering is kept
            plotData$Option <- factor(plotData$Option, levels=plotData$Option)

            if ( self$options$yaxis == "responses") {
                plot <- ggplot(plotData, aes(Option, Responses )) +
                    labs(y="% of Responses") + scale_y_continuous(labels=percent_format())
            } else if ( self$options$yaxis == "cases") {
                plot <- ggplot(plotData, aes(Option, Cases )) +
                    labs(y="% of Cases") + scale_y_continuous(labels=percent_format())
            } else {
                plot <- ggplot(plotData, aes(Option, Frequency )) + labs(y="Counts")
            }

            plot <- plot + geom_col(fill=theme$color[2]) + labs(x="")  + ggtheme

            return(plot)

        },
        .multipleResponse = function (data, items = NULL, endorsedOption = 1, order='none') {
            # From userfriendlyscience package
            data = data[, items]
            nrOfEndorsements = sum(data == endorsedOption, na.rm = TRUE)
            endorsementsPerItem = colSums(data == endorsedOption, na.rm = TRUE)
            nrOfCases = sum(!apply(apply(data, 1, is.na), 2, all))
            totals = as.numeric(c(endorsementsPerItem, nrOfEndorsements))
            res <- data.frame(c(names(endorsementsPerItem), "Total"),
                              totals, (totals/nrOfEndorsements),
                              (totals/nrOfCases))

            names(res) <- c("Option", "Frequency", "Responses", "Cases")

            # Sort
            n <- length(items)
            if (order == 'decreasing') {
                res<-res[c(order(res$Frequency[1:n], decreasing = TRUE),n+1),]
            } else if (order == 'increasing') {
                res<-res[c(order(res$Frequency[1:n], decreasing = FALSE),n+1),]
            }

            return( list('nrOfCases'=nrOfCases, 'df'=res) )

        }
    )
)
