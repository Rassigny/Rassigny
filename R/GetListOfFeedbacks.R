# Function that returns a list of feedbacks for corresponding assignment.
# If taskID in the argument is specified, this function returns a feedback
# for corresponding assignment and task.
GetListOfFeedbacks <- function(assignmentID, taskID=NULL) {
  # creating a logger object
  logging::getLogger(name="GetListOfFeedbacksLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetListOfFeedbacksLogger", file=log.config[["logfile_path"]])

  tryCatch({
    # get json content
    json <- GetJson(assignmentID)

    # get list of rubric from json content, whose element is null when the rubricType is default
    rubrics <- GetListOfSubRubrics(assignmentID)

    # get number of list of rubrics
    num.rubric <- length(rubrics)
    feedbacks <- list()

    # get default feedback
    default.feedback <- getElement(json, "defaultRubric")[["feedback"]]

    # if the element is null, insert default feedback to feedbacks list,
    # otherwise insert feedbacks corresponding to taskID
    for (i in 1:num.rubric) {
      if(is.null(rubrics[[i]])) {
        feedbacks[[i]] <- default.feedback
      } else {
        feedbacks[[i]] <- rubrics[[i]][["feedback"]]
      }
    }

    # return a list of feedbacks or a grade coresponding to taskID
    if (is.null(taskID)) {
      logging::loginfo("Returned matchingThreshold for assignmentID: %d", assignmentID, logger = 'GetListOfFeedbacksLogger')
      return(feedbacks)
    } else {
      if (taskID > num.rubric || taskID <= 0) stop("Incorrect taskID")
      logging::loginfo("Returned matchingThreshold for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfFeedbacksLogger')
      return(feedbacks[[taskID]])
    }

    # handling for warning
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetListOfFeedbacksLogger")
    warning(w)
    # handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="GetListOfFeedbacksLogger")
    stop(e)
  })
}
