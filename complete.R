complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases
	  v <- numeric(0)

    	  for (i in id) {
        	dataFrame <- getmonitor(i, directory)
        	v <- c(v, nrow(na.omit(dataFrame)))
        }

    	  data.frame(id = id, nobs = v)
}