# Function that returns a list of correct answers for corresponding assignment.
# If taskID in the argument is specified, this function returns a correct answer
# for corresponding assignment and task.
GetListOfAnswers <- function(assignmentID, taskID = NULL) {
  # creating a logger object
  logging::getLogger(name="GetListOfAnswersLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetListOfAnswersLogger", file=log.config[["logfile_path"]])

  tryCatch({
    # get student email from global variable
    studentEmail <- general.env$studentEmail

    # error handling for non existing student email
    if (is.null(studentEmail)) stop("Create data first.")
    data <- GenerateData(studentEmail, assignmentID)

    # get json content
    json <- GetJson(assignmentID)

    # get temp data
    temp_data <- GetTempData(assignmentID)

    # get list of answers
    answers <- GetInfosWithEval(assignmentID, "CorrectAnswer", temp_data)

    # return a list of answers or a grade coresponding to taskID
    if (is.null(taskID)) {
      logging::loginfo("Returned matchingThreshold for assignmentID: %d", assignmentID, logger = 'GetListOfAnswersLogger')
      return(answers)
    } else {
      num.answers <- length(answers)
      if (taskID > num.answers || taskID <= 0) stop("Incorrect taskID")
      logging::loginfo("Returned matchingThreshold for assignmentID: %d and taskID: %d", assignmentID, taskID, logger = 'GetListOfAnswersLogger')
      return(answers[[taskID]])
    }
  } , warning = function(w) {
    logging::logwarn("%s", w, logger="GetListOfAnswersLogger")
    warning(w)
    # handling for error
  }, error = function(e) {
    # error handling for not created data
    if (is.null(studentEmail)) {
      logging::logerror("Not created data by studnet", logger="GetListOfAnswersLogger")
      stop("Create data first.")

    } else {
      logging::logerror("%s", e, logger="GetListOfAnswersLogger")
      stop(e)
    }
  })
}
