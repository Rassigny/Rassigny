#An internal function to get json content.
#The json contents are stored in system.rda in R directory.
#When you want to add assignment, add new json file to data-raw directory
#and in JsonContent.R write code for create and add new json object to system.rda
GetJson <- function(assignmentID) {
  # creating a logger object
  logging::getLogger(name="GetJsonLogger")

  # adding a handler that would log everything to METCS555.log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetJsonLogger", file=log.config[["logfile_path"]])
  tryCatch({
    # pick corresponding json object by assignmentID
    if (is.null(assignmentID)) stop()
    if (!is.null(assignmentID) && typeof(assignmentID) != "double") stop()
    json <- switch(assignmentID,
                   "1" = json.assignment1,
                   "2" = json.assignment2,
                   "3" = json.assignment3,
                   "4" = json.assignment4,
                   "5" = json.assignment5,
                   "6" = json.assignment6)
    if (is.null(json)) stop()
    logging::loginfo("legal argument passed for assignmentID: %d", assignmentID, logger ="GetJsonLogger")
    return(json)
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetJsonLogger")
    warning(w)
    #handling for error
  }, error = function(e) {
    # error handling for no passed value for assignmentID
    if (is.null(assignmentID)) {
      logging::logerror("assignmentID is not passed", logger="GetJsonLogger")
      stop("missing assignmentID")

      # error handling for wrong assignmentID passed
    } else if (!is.null(assignmentID) && typeof(assignmentID) != "double"){
      logging::logerror("assignmentID: %s is not a double", assignmentID, logger = "GetJsonLogger")
      stop("assignmentID is  not a number")
    } else if (is.null(json)) {
      logging::logerror("wrong assignmentID: %d is passed", assignmentID, logger="GetJsonLogger")
      stop("missing assignmentID")

    } else {
      logging::logerror("%s", e, logger="GetJsonLogger")
      stop(e)
    }
  })
}
