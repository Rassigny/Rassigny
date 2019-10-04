# Function that returns temp_data from json files.
GetTempData <- function(assignmentID) {

  # creating a logger object
  GetTempDataLogger <- logging::getLogger('GetTempDataLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'GetTempDataLogger')
  tryCatch({
    studentEmail <- general.env$studentEmail
    # test to see if student has generated the data first
    if (is.null(studentEmail)){
      logging::logerror("studentEmail is not configured in the general.env", logger = 'GetTempDataLogger')
      logging::logerror("Student has not generated data yet", logger = 'GetTempDataLogger')
      stop("Create data first.")
    }
    if (!(assignmentID %in% general.env$assignmentIDs)){
      logging::logerror("assignmentID: %d is not configured in the general.env", assignmentID, logger = 'GetTempDataLogger')
      logging::logerror("Student has not generated data yet", logger = 'GetTempDataLogger')
      stop("There is no data created for this assignment.")
    }

    data <- GenerateData(studentEmail, assignmentID)
    json <- GetJson(assignmentID)
    temp_data <- json[["temp_data"]]
    num.temp <- length(temp_data)
    temps <- list()
    for (i in 1:num.temp) {
      element <- eval(parse(text = temp_data[[i]]))
      temps[[i]] <- element
    }

    logging::loginfo("Returned temp_data for assignmentID: %d", assignmentID, logger = 'GetTempDataLogger')
    return(temps)

  }, warning = function(w){
    logging::logwarn(' %s ', w, logger = 'GetTempDataLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(' %s ', e, logger = 'GetTempDataLogger')
    stop(e)
  })

}
