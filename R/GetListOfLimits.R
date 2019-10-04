# Function that returns a list of sets of limits for corresponding assignment.
# If taskID in the argument is specified, this function returns a set of limits
# for corresponding assignment and task.
GetListOfLimits <- function(assignmentID, taskID=NULL) {
  # creating a logger object
  logging::getLogger(name="GetListOfLimitsLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetListOfLimitsLogger", file=log.config[["logfile_path"]])
  tryCatch({
    # get list of rubric fields in json content
    rubrics <- GetListOfRubrics(assignmentID)

    # get number of rubrics
    num.rubric <- length(rubrics)
    limits <- list()

    for (i in 1:num.rubric) {
      # if lower limit and upper limit do not exist, insert null to list of limits
      if (is.null(rubrics[[i]][["lower_limit"]]) &&
          is.null(rubrics[[i]][["upper_limit"]])) {
        limits[i] <- list(NULL)

        # if lower limit and upper limit exist, insert lower limit and upper limit to the list
      } else if (!is.null(rubrics[[i]][["lower_limit"]]) &&
                 !is.null(rubrics[[i]][["upper_limit"]])) {

        limits[[i]] <- list("lower_limit" = rubrics[[i]][["lower_limit"]],
                            "upper_limit" = rubrics[[i]][["upper_limit"]])

        # if only lower limit exists, insert lower limit
      } else if (!is.null(rubrics[[i]][["lower_limit"]])) {
        limits[[i]] <- list("lower_limit" = rubrics[[i]][["lower_limit"]])

        # if only upper limit exists, insert upper limit
      } else if (!is.null(rubrics[[i]][["upper_limit"]])) {
        limits[[i]] <- list("upper_limit" = rubrics[[i]][["upper_limit"]])
      }
    }

    # return a list of limits or a limit corresponding to taskID
    if (is.null(taskID)) {
      logging::loginfo("Returned matchingThreshold for assignmentID: %d", assignmentID, logger = 'GetListOfLimitsLogger')
      return(limits)
    } else {
      if (taskID > num.rubric || taskID <= 0) stop("Incorrect taskID")
      logging::loginfo("Returned matchingThreshold for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfLimitsLogger')
      return(limits[[taskID]])
    }
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetListOfLimitsLogger")
    warning(w)
    # handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="GetListOfLimitsLogger")
    stop(e)
  })
}
