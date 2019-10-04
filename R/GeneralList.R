# General function to get a list of character strings of contents in json file.
GetInfos <- function(assignmentID, info) {
  # creating a logger object
  logging::getLogger(name="GetInfosLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetInfosLogger", file=log.config[["logfile_path"]])
  tryCatch({
    # get json content
    json <- GetJson(assignmentID)

    # get number of questions with the assignment
    num.question <- length(getElement(json, "questions"))

    # get list of elements corresponding to feild name, which is "info" parameter.
    infos <- list()
    for (i in 1:num.question) {
      element <- getElement(json, "questions")[[i]][[info]]
      infos <- append(infos, list(element))
    }

    logging::loginfo("legal argument passed for assignmentID: %d", assignmentID, logger ="GetInfosLogger")
    return(infos)
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetInfosLogger")
    warning(w)

  }, error = function(e) {
    logging::logerror("%s", e, logger="GetInfosLogger")
    stop(e)
  })
}


# General function to get a list of contents which need to evaluate first in json file.
GetInfosWithEval <- function(assignmentID,
                             info,
                             temp_data = list()) {
  # creating a logger object
  logging::getLogger(name="GetInfosWithEvalLogger")

  # adding a handler that would log everything to log file
  # the default level for this handler in "INFO (20)"
  logging::addHandler(logging::writeToFile, logger = "GetInfosWithEvalLogger", file=log.config[["logfile_path"]])

  tryCatch({
    # get student email from global variable
    studentEmail <- general.env$studentEmail

    # error handling for not existing student email
    if (is.null(studentEmail)) stop("Create data first.")

    # error handling for untried assignment
    if (!(assignmentID %in% general.env$assignmentIDs)) stop()

    # get data
    data <- GenerateData(studentEmail, assignmentID)

    # get json content
    json <- GetJson(assignmentID)

    # get number of questions with the assignment
    num.question <- length(getElement(json, "questions"))

    # get list of elements corresponding to feild name, which is "info" parameter, with evaluation.
    infos <- list()
    for (i in 1:num.question) {
      element <- eval(parse(text = getElement(json, "questions")[[i]][[info]]))
      infos <- append(infos, element)
    }

    logging::loginfo("legal argument passed for assignmentID: %d", assignmentID, logger ="GetInfosWithEvalLogger")
    return(infos)
  }, warning = function(w) {
    logging::logwarn("%s", w, logger="GetInfosWithEvalLogger")
    warning(w)
  }, error = function(e) {
    if (!(assignmentID %in% general.env$assignmentIDs)) {
      logging::logerror("Not created data for assignmentID %d", assignmentID, logger="GetInfosWithEvalLogger")
      stop("There is not data created for this assignment.")
    }
    logging::logerror("%s", e, logger="GetInfosWithEvalLogger")
    stop(e)
  })
}
