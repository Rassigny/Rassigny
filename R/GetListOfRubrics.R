# Function to be used to create a list of contents rubric in json file,
# but there would be null in the list. This null elements will be replaced with
# default rubric in GetListOfRubrics() function.
GetListOfSubRubrics <- function(assignmentID) {
  # creating a logger object
  GetListOfSubRubricsLogger <- logging::getLogger('GetListOfSubRubricsLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'GetListOfSubRubricsLogger')
  tryCatch({
    sub.rubrics <- GetInfos(assignmentID, "rubric")
    logging::loginfo("Returned sub.rubrics for assignmentID: %d", assignmentID, logger = 'GetListOfSubRubricsLogger')
    return(sub.rubrics)
  },  warning = function(w){
    logging::logwarn(" %s ", w, logger = 'GetListOfSubRubricsLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(" %s ", e, logger = 'GetListOfSubRubricsLogger')
    stop(e)
  })
}


# Function that returns a list of rubrics for corresponding assignment.
# If taskID in the argument is specified, this function returns a rubric
# for corresponding assignment and task.
GetListOfRubrics <- function(assignmentID) {

  # creating a logger object
  GetListOfRubricsLogger <- logging::getLogger('GetListOfRubricsLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler in "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'GetListOfRubricsLogger')

  tryCatch({

    json <-GetJson(assignmentID)
    # rubrics with NULL
    rubrics <- GetListOfSubRubrics(assignmentID)
    # number of rubrics
    num.rubric <- length(rubrics)
    # default rubrics
    default.rubric <- getElement(json, "defaultRubric")
    # replacing null elements with default rubric
    for (i in 1:num.rubric) {
      if (is.null(rubrics[[i]])) {
        rubrics[[i]] <- default.rubric
      }
    }
    logging::loginfo("Returned rubrics for assignmentID: %d", assignmentID, logger = 'GetListOfRubricsLogger')
    return(rubrics)

  }, warning = function(w){
    logging::logwarn(" %s ", w, logger = 'GetListOfRubricsLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(" %s ", e, logger = 'GetListOfRubricsLogger')
    stop(e)
  })


}
