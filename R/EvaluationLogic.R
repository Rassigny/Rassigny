# Function to get the key for feedback for default rubric
# This is used in EvaluateAnswer() function.
GetDefaultEvaluation <- function(answer, correct.answer, threshold) {
  # creating a logger object
  logging::getLogger(name="GetDefaultEvaluationLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetDefaultEvaluationLogger", file=log.config[["logfile_path"]])
  tryCatch({
    # check if answer is correct taking account of threshold
    if (correct.answer - threshold <= answer &&
        answer <= correct.answer + threshold) {
      evaluation <- "equal"
    }
    # check if answer is smaller taking account of threshold
    else if (answer < correct.answer - threshold) {
      evaluation <- "smaller"
    }
    # check if answer is bigger taking account of threshold
    else if (answer > correct.answer + threshold) {
      evaluation <- "bigger"
    }

    logging::loginfo("legal argument passed", logger ="GetDefaultEvaluationLogger")
    return(evaluation)
    # Handling for warning
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetDefaultEvaluationLogger")
    warning(w)
    # Handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="GetDefaultEvaluationLogger")
    stop(e)
  })
}

# function to get the key for feedback for custom rubric
# This is used in EvaluateAnswer() function.
GetEvaluation <- function(answer, correct.answer, threshold, limit) {
  # creating a logger object
  logging::getLogger(name="GetEvaluationLogger")

  # adding a handler that would log everything to Rassigny.log file
  # the default level for this handler in "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetEvaluationLogger", file=log.config[["logfile_path"]])

  tryCatch({
    # check if answer is smaller than lower limit. If it is, return "smaller".
    if (answer < limit[["lower_limit"]]) {
      evaluation <- "smaller"
    }
    # check if answer is bigger than upper limit. If it is, return "bigger".
    else if (answer > limit[["upper_limit"]]) {
      evaluation <- "bigger"
    }
    # check if answer is between value of threshold and either of upper limit or lower limit.
    # This condition might be never used in our current implementation.
    else if ((answer > correct.answer + threshold && answer <= limit[["upper_limit"]]) ||
             (answer < correct.answer - threshold && answer >= limit[["lower_limit"]])) {
      evaluation <- "between"
    }
    # check if answer is within threshold. If it is, return "equal"
    else if (answer <= correct.answer + threshold &&
             answer >= correct.answer - threshold) {
      evaluation <- "equal"
    }
    logging::loginfo("legal argument passed", logger ="GetEvaluationLogger")
    return(evaluation)
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetEvaluationLogger")
    warning(w)
    #Handling for error
  }, error = function(e) {
    logging::logerror("%s", e, logger="GetEvaluationLogger")
    stop(e)
  })
}

