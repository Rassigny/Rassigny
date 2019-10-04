#' GetListOfTasks returns a list of tasks for corresponding assignment.
#' Student can see what tasks they are assigned by calling this function.
#'
#' @param assignmentID Corresponding assignment Id.
#' @param taskID Corresponding task ID. Default is NULL.
#' @return A list of tasks or a number of a task.
#' @examples
#' data <- GenerateData('student@gmail.com', 2)
#' GetListOfTasks(2)
#'
#' data <- GenerateData('student@gmail.com', 1)
#' GetListOfTasks(1, 3)
#' @export
GetListOfTasks <- function(assignmentID, taskID=NULL) {

  # creating a logger object
  GetListOfTasksLogger <- logging::getLogger('GetListOfTasksLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'GetListOfTasksLogger')

  tryCatch({

    json <- GetJson(assignmentID)
    # fetching the value stored under "temp_data" from the JSON file
    temp_data <- GetTempData(assignmentID)
    # fetching the value stored under "taskDescription" from the JSON file
    tasks <- GetInfosWithEval(assignmentID, "taskDescription", temp_data)

    if (is.null(taskID)) {
      logging::loginfo("Returned tasks for assignmentID: %d", assignmentID, logger = 'GetListOfTasksLogger')
      return(tasks)
    } else {
      num.tasks <- length(tasks)
      if (taskID > num.tasks || taskID <= 0) stop()
      logging::loginfo("Returned tasks for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfTasksLogger')
      return(tasks[[taskID]])
    }

  }, warning = function(w){
    logging::logwarn(" %s ", w, logger = 'GetListOfTasksLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(" %s ", e, logger = 'GetListOfTasksLogger')
    stop(e)
  })

}
