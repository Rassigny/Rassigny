#' ListOfReviews returns a list of reviews for corresponding assignment.
#' Instructors can see what tasks assigned for students and the corresponding answers.
#'
#' @param password Password to access the istructor side of the package
#' @param studentEmail Corresponding student email address
#' @param assignmentID Corresponding assignment Id.
#' @param taskID Corresponding task ID. Default is NULL.
#' @return A list of reviews or a number of a review.
#' @export
ListOfReviews <- function(password, studentEmail, assignmentID, taskID = NULL) {

  # creating a logger object
  ListOfReviewsLogger <- logging::getLogger('ListOfReviewsLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'ListOfReviewsLogger')

  tryCatch({

    # check for the password (stored in the binary file)
    if(password == password.true){
      data <- GenerateData(studentEmail, assignmentID)
      logging::loginfo('Data generated for studentEmail: %s and assignmentID: %d', studentEmail, assignmentID, logger = 'ListOfReviewsLogger')
      answers <- GetListOfAnswers(assignmentID)
      tasks <- GetListOfTasks(assignmentID)
      reviews <- list()

      # combining the tasks and answers into one list
      for (i in seq(1, length(tasks))) {
        review <- list()
        review["Task"] <- tasks[[i]]
        review["Answer"] <- answers[[i]]
        reviews[[i]] <- review
      }
      if (is.null(taskID)) {
        logging::loginfo('Returning ListOfReviews for studentEmail: %s and assignmentID: %d', studentEmail, assignmentID, logger = 'ListOfReviewsLogger')
        return(reviews)
      } else {
        num.answers <- length(answers)
        if (taskID > length(reviews) || taskID <= 0) logging::loginfo('Incorrect taskID: %d', taskID, logger = 'ListOfReviewsLogger')
        logging::loginfo('Returning ListOfReviews for studentEmail: %s, assignmentID: %d and taskID: %d', studentEmail, assignmentID, taskID, logger = 'ListOfReviewsLogger')
        return(reviews[[taskID]])
      }
    } else {
      stop("Access Denied! This incident will be reported!")
    }

  }, warning = function(w){
    logging::logwarn(' %s ', w, logger = 'ListOfReviewsLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(' %s ', e, logger = 'ListOfReviewsLogger')
    stop(e)
  })


}
