library(lattice)

#
# |------------------------------------------------------------------------------------------|
# | I N I T I A L I Z A T I O N |
# |------------------------------------------------------------------------------------------|
Init <- function(fileStr, workDirStr = "C:/Users/Jonathan/Downloads/ComputingForDataAnalysis/Assignment2") {
    setwd(workDirStr)
    retDfr <- read.csv(fileStr, colClasses = "character")
    return(retDfr)
}

#
# |------------------------------------------------------------------------------------------|
# | I N T E R N A L F U N C T I O N S |
# |------------------------------------------------------------------------------------------|
rankall <- function(outcomeChr, rankObj = "best") {
    # --- Init loading outcome data
    outcomeDfr <- Init("ProgAssignment2-data/outcome-of-care-measures.csv")

    # --- Coerce character into numeric
    suppressWarnings(outcomeDfr[, 11] <- as.numeric(outcomeDfr[, 11]))
    suppressWarnings(outcomeDfr[, 17] <- as.numeric(outcomeDfr[, 17]))
    suppressWarnings(outcomeDfr[, 23] <- as.numeric(outcomeDfr[, 23]))

    # --- Create a data frame of freq by state Remove row.names
    tableDfr <- data.frame(State = names(tapply(outcomeDfr$State, outcomeDfr$State, 
        length)), Freq = tapply(outcomeDfr$State, outcomeDfr$State, length))
    rownames(tableDfr) <- NULL

    # --- Create a data frame of possible inputs and respective columns
    inputDfr <- data.frame(Outcome = c("heart attack", "heart failure", "pneumonia"), 
        Col = c(11, 17, 23))

    # --- Check that outcome is valid
    if (nrow(inputDfr[inputDfr$Outcome == outcomeChr, ]) == 0) 
        stop("invalid outcome")

    # --- Assert create an empty vector Add column rank for debug
    nameChr <- character(0)
    # rankChr <- character(0)

    # --- Return hospital name in that state with the ranked THIRTY(30)-day
    # death rate Create a data frame with given ONE (1) state Determine the
    # relevant column Reorder the new data frame from best to worst
    for (stateChr in tableDfr$State) {
        stateDfr <- outcomeDfr[outcomeDfr$State == stateChr, ]
        colNum <- inputDfr[inputDfr$Outcome == outcomeChr, 2]
        stateDfr <- stateDfr[complete.cases(stateDfr[, colNum]), ]
        stateDfr <- stateDfr[order(stateDfr[, colNum], stateDfr$Hospital.Name), 
            ]

        # --- Convert 'best' and 'worst' to numeric Determine the relevant row
        if (rankObj == "best") 
            rankNum <- 1 else if (rankObj == "worst") 
            rankNum <- nrow(stateDfr) else suppressWarnings(rankNum <- as.numeric(rankObj))

        # --- Append hospital name to character vector
        nameChr <- c(nameChr, stateDfr[rankNum, ]$Hospital.Name)
        # rankChr <- c( rankChr, rankNum )
    }

    # --- Return value is a data frame (hospital, state)
    return(data.frame(hospital = nameChr, state = tableDfr$State))
}

rankhospital <- function(stateChr, outcomeChr, rankObj) {
    # --- Init loading outcome data
    outcomeDfr <- Init("ProgAssignment2-data/outcome-of-care-measures.csv")

    # --- Coerce character into numeric
    suppressWarnings(outcomeDfr[, 11] <- as.numeric(outcomeDfr[, 11]))
    suppressWarnings(outcomeDfr[, 17] <- as.numeric(outcomeDfr[, 17]))
    suppressWarnings(outcomeDfr[, 23] <- as.numeric(outcomeDfr[, 23]))

    # --- Create a data frame of freq by state Remove row.names
    tableDfr <- data.frame(State = names(tapply(outcomeDfr$State, outcomeDfr$State, 
        length)), Freq = tapply(outcomeDfr$State, outcomeDfr$State, length))
    rownames(tableDfr) <- NULL

    # --- Create a data frame of possible inputs and respective columns
    inputDfr <- data.frame(Outcome = c("heart attack", "heart failure", "pneumonia"), 
        Col = c(11, 17, 23))

    # --- Check that state and outcome are valid
    if (nrow(tableDfr[tableDfr$State == stateChr, ]) == 0) 
        stop("invalid state")
    if (nrow(inputDfr[inputDfr$Outcome == outcomeChr, ]) == 0) 
        stop("invalid outcome")

    # --- Return hospital name in that state with the ranked THIRTY(30)-day
    # death rate Create a data frame with given ONE (1) state Determine the
    # relevant column Reorder the new data frame from best to worst
    stateDfr <- outcomeDfr[outcomeDfr$State == stateChr, ]
    colNum <- inputDfr[inputDfr$Outcome == outcomeChr, 2]
    stateDfr <- stateDfr[complete.cases(stateDfr[, colNum]), ]
    stateDfr <- stateDfr[order(stateDfr[, colNum], stateDfr$Hospital.Name), 
        ]

    # --- Convert 'best' and 'worst' to numeric 'Worst' code is not valid if
    # omit NA from results Determine the relevant row
    if (rankObj == "best") 
        rankObj <- 1
    if (rankObj == "worst") 
        rankObj <- nrow(stateDfr)
    # if( rankObj=='worst' ) rankObj <- tableDfr[tableDfr$State==stateChr, 2]
    suppressWarnings(rankNum <- as.numeric(rankObj))

    # --- Return value is a character Return data frame for debug
    return(stateDfr[rankNum, ]$Hospital.Name)
    # return(stateDfr)
}

best <- function(stateChr, outcomeChr) {
    # --- Init loading outcome data
    outcomeDfr <- Init("ProgAssignment2-data/outcome-of-care-measures.csv")

    # --- Coerce character into numeric
    suppressWarnings(outcomeDfr[, 11] <- as.numeric(outcomeDfr[, 11]))
    suppressWarnings(outcomeDfr[, 17] <- as.numeric(outcomeDfr[, 17]))
    suppressWarnings(outcomeDfr[, 23] <- as.numeric(outcomeDfr[, 23]))

    # --- Create a data frame of freq by state Remove row.names
    tableDfr <- data.frame(State = names(tapply(outcomeDfr$State, outcomeDfr$State, 
        length)), Freq = tapply(outcomeDfr$State, outcomeDfr$State, length))
    rownames(tableDfr) <- NULL

    # --- Create a data frame of possible inputs and respective columns
    inputDfr <- data.frame(Outcome = c("heart attack", "heart failure", "pneumonia"), 
        Col = c(11, 17, 23))

    # --- Check that state and outcome are valid
    if (nrow(tableDfr[tableDfr$State == stateChr, ]) == 0) 
        stop("invalid state")
    if (nrow(inputDfr[inputDfr$Outcome == outcomeChr, ]) == 0) 
        stop("invalid outcome")

    # --- Return hospital name in that state with lowest THIRTY(30)-day death
    # rate Create a data frame with given ONE (1) state Determine the relevant
    # row and column
    stateDfr <- outcomeDfr[outcomeDfr$State == stateChr, ]
    colNum <- inputDfr[inputDfr$Outcome == outcomeChr, 2]
    rowNum <- which.min(stateDfr[, colNum])
    return(stateDfr[rowNum, ]$Hospital.Name)
}

freqVtr <- function(inDfr, orderVtr) {
    # --- Assert 'directory' is a character vector of length 1 indicating the
    # location of the CSV files.  'threshold' is a numeric vector of length 1
    # indicating the number of completely observed observations (on all
    # variables) required to compute the correlation between nitrate and
    # sulfate; the default is 0.  Return a numeric vector of correlations.

    # --- Assert create an empty numeric vector
    outVtr <- numeric(0)

    for (ord in orderVtr) {
        # --- Append numeric vector
        outVtr <- c(outVtr, inDfr[inDfr$State == ord, 2])
    }

    # --- Assert return value is a numeric vector
    return(outVtr)
}