# Function that returns a list of grades for corresponding assignment.
# If taskID in the argument is specified, this function returns a grade
# for corresponding assignment and task.
GetListOfGrades <- function(assignmentID, taskID=NULL) {
  # creating a logger object
  logging::getLogger(name="GetListOfGradesLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetListOfGradesLogger", file=log.config[["logfile_path"]])

  tryCatch({
    # get list of grades
    grades <- GetInfos(assignmentID, "grade")

    # return a list of grades or a grade coresponding to taskID
    if (is.null(taskID)) {
      logging::loginfo("Returned matchingThreshold for assignmentID: %d", assignmentID, logger = 'GetListOfGradesLogger')
      return(grades)
    } else {
      num.grades <- length(grades)
      if (taskID > num.grades || taskID <= 0) stop("Incorrect taskID")
      logging::loginfo("Returned matchingThreshold for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfGradesLogger')
      return(grades[[taskID]])
    }
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetListOfGradesLogger")
    warning(w)
    # handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="GetListOfGradesLogger")
    stop(e)
  })

}
