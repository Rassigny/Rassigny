# Function that returns a list of partial grades for corresponding assignment.
# If taskID in the argument is specified, this function returns a partial grade
# for corresponding assignment and task.
GetListOfPartialGrades <- function(assignmentID, taskID=NULL) {
  # creating a logger object
  logging::getLogger(name="GetListOfPartialGradesLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetListOfPartialGradesLogger", file=log.config[["logfile_path"]])

  tryCatch({
    rubrics <- GetListOfRubrics(assignmentID)
    num.rubric <- length(rubrics)
    partial.grades <- list()
    for (i in 1:num.rubric) {
      if (is.null(rubrics[[i]][["partialGrade"]])) {
        partial.grades[i] <- list(NULL)
      } else {
        partial.grades[[i]] <- rubrics[[i]][["partialGrade"]]
      }
    }
    if (is.null(taskID)) {
      logging::loginfo("Returned matchingThreshold for assignmentID: %d", assignmentID, logger = 'GetListOfPartialGradesLogger')
      return(partial.grades)
    } else {
      if (taskID > num.rubric || taskID <= 0) stop("Incorrect taskID")
      logging::loginfo("Returned matchingThreshold for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfPartialGradesLogger')
      return(partial.grades[[taskID]])
    }
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetListOfPartialGradesLogger")
    warning(w)
    # handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="GetListOfPartialGradesLogger")
    stop(e)
  })
}
