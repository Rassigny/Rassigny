#' Generate a data set that is unique for
#' each student and for corresponding assignment.
#'
#' @param studentEmail Student email address.
#' @param assignmentID Corresponding assignment ID.
#' @return A dataframe for corresponding assignemnt
#' @examples
#' GenerateData("zakizaki@bu.edu", 1)
#' @export


GenerateData <- function(studentEmail, assignmentID) {
  logging::logReset()
  # creating a logger object
  logging::getLogger(name="GenerateDataLogger")
  # adding a handler that would log everything to METCS555.log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GenerateDataLogger", file=log.config[["logfile_path"]])
  tryCatch({
    # if arguments are not character strings, throw error.
    # if the assignmentID is not numeric, throw error
    if (is.null(assignmentID)) stop()
    if (typeof(studentEmail) != "character" || !isValidEmail(studentEmail)) stop()
    if (class(assignmentID) != "numeric" &&
        !is.null(assignmentID)) stop()

    #set random seed to create data according to student email address
    SetRandomSeed(studentEmail)
    data <- switch(assignmentID,
                   "1" = GenerateData1(studentEmail),
                   "2" = GenerateData2(studentEmail),
                   "3" = GenerateData3(studentEmail),
                   "4" = GenerateData4(studentEmail),
                   "5" = GenerateData5(studentEmail),
                   "6" = GenerateData6(studentEmail))
    if (is.null(data)) stop()
    #store student email address to general.env environment
    SetStudentEnv(studentEmail)
    SetAssignmentEnv(assignmentID)

    logging::loginfo('legal argument passed for assignmentID: %d', assignmentID, logger = "GenerateDataLogger")
    return(data)

  }, warning = function(w) {

    warning(w)
    logging::logwarn("%s", w, logger="GenerateDataLogger")
    warning(w)

  }, error = function(e) {
    #Error handling for assignmentID not passed
    if (is.null(assignmentID)) {
      logging::logerror("assignmentID is not provided",  logger="GenerateDataLogger")
      stop("Missing assignmentID")
    }
    #Error handling for out of range of assingmentID
    else if (is.null(data)) {

      logging::logerror("data for assignmentID: %d is not created ", assignmentID, logger="GenerateDataLogger")
      stop("There is not data for this assignmentID")

    }
    #Error handling for wrong input for assignmentID
    else if (class(assignmentID) != "numeric" &&
             !is.null(assignmentID)) {

      logging::logerror("Wrong assignmentID: %d error in GenerateData", assignmentID, logger="GenerateDataLogger")
      stop("Wrong input for assignementID argument.")


    }
    #Error handling for wrong studentEmail
    else if (typeof(studentEmail) != "character" || !isValidEmail(studentEmail)){

      logging::logerror("Wrong studentEmail: %s error in GenerateData", studentEmail, logger="GenerateDataLogger")
      stop("Wrong studentEmail")

      #Error handling for undefined error
    } else {

      logging::logerror("%s" ,e, logger="GenerateDataLogger")
      stop(e)

    }
  })
}

#Check valid email
isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@+bu.edu\\>", as.character(x), ignore.case=TRUE)
}
