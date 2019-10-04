# Function that returns a list of thresholds for corresponding assignment.
# If taskID in the argument is specified, this function returns a threshold
# for corresponding assignment and task.
GetListOfThresholds <- function(assignmentID, taskID=NULL) {

  # creating a logger object
  GetListOfThresholdsLogger <- logging::getLogger('GetListOfThresholdsLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'GetListOfThresholdsLogger')

  tryCatch({

    thresholds <- GetInfos(assignmentID, "matchingThreshold")
    if (is.null(taskID)) {
      logging::loginfo("Returned matchingThreshold for assignmentID: %d", assignmentID, logger = 'GetListOfThresholdsLogger')
      return(thresholds)
    } else {
      num.thresholds <- length(thresholds)
      if (taskID > num.thresholds || taskID <= 0) stop()
      logging::loginfo("Returned matchingThreshold for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfThresholdsLogger')
      return(thresholds[[taskID]])
    }

  }, warning = function(W){
    logging::logwarn(' %s ', w, logger = 'GetListOfThresholdsLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(' %s ', e, logger = 'GetListOfThresholdsLogger')
    stop(e)
  })

}
