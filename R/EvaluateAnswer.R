#' Evaluate whether the answer that user gives is correct
#' and return feedback for the answer
#'
#' @param answer Answer that student provides.
#' @param assignmentID Corresponding assignment ID.
#' @param taskID Corresponding task ID.
#' @return A string of characters for a feedback.
#' @examples
#' data <- GenerateData("aafabc@bu.edu", 1)
#' answer <- mean(data)
#' EvaluateAnswer(answer, assignmentID = 1, taskID = 1)
#'
#' @export
EvaluateAnswer <- function(answer,
                           assignmentID,
                           taskID) {
  # creating a logger object
  logging::getLogger(name="EvaluateAnswerLogger")

  # adding a handler that would log everything to Rassigny.log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "EvaluateAnswerLogger", file=log.config[["logfile_path"]])

  tryCatch({
    # get student email address stored in meta.env environment
    studentEmail <- general.env$studentEmail
    if (is.null(studentEmail)) stop("Create data first.")
    # generate data for studentEmail
    data <- GenerateData(studentEmail, assignmentID)

    # get correct answer
    correct.answer <- GetListOfAnswers(assignmentID, taskID)

    # get threshold for this question
    threshold <- GetListOfThresholds(assignmentID, taskID)

    # get limits
    limit <- GetListOfLimits(assignmentID, taskID)

    # get feedback
    feedback <- GetListOfFeedbacks(assignmentID, taskID)

    # get key for feedback according to condition whether limit exists or not
    # GetDefaultEvaluation returns key for default questtion.
    # GetEvaluation returns key for question which has limits.
    if (is.null(limit)) {
      evaluation <- GetDefaultEvaluation(answer, correct.answer, threshold)
    } else {
      evaluation <- GetEvaluation(answer, correct.answer, threshold, limit)
    }

    # write history csv if evaluation return 'eqaul'
    if (evaluation == "equal") {
      # get file path
      col.name <- paste("assignment", assignmentID, sep="")
      path.history <- paste(log.config[["history_path"]], "Rassigny-history.csv", sep = "")

      # If the file is not exists, create new file
      if (!file.exists(path.history)) {
        write.csv(history.init, file = path.history)
      }

      # If
      history <- read.csv(path.history, row.names=NULL)
      history[[col.name]][taskID] <- 1
      write.csv(history, file=path.history, row.names=FALSE)
    }

    logging::loginfo("legal argument passed for assignmentID: %d", assignmentID, logger ="EvaluateAnswerLogger")
    return(paste(answer, 'is the', feedback[[evaluation]], sep = ' '))

    #Handling for warning
  },warning = function(w) {
    logging::logwarn("%s", w, logger="EvaluateAnswerLogger")
    warning(w)
    #Handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="EvaluateAnswerLogger")
    stop(e)
  })
}
