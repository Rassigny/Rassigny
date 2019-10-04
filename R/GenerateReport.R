#' GenerateReport generates a CSV file with all the questions and answers for the given studentEmail.
#'
#' @param password Password to generate the report
#' @param studentEmail Corresponding student email address
#' @return A CSV file with all the questions and answers
#' @export
GenerateReport <- function(password, studentEmail) {

  # creating a logger object
  GenerateReportLogger <- logging::getLogger('GenerateReportLogger')

  # adding a handler that would log everything to log file
  # the default level for this handler is "INFO (20)"
  logging::addHandler(logging::writeToFile, file=log.config[["logfile_path"]], logger = 'GenerateReportLogger')

  tryCatch({

    # check for the password (stored in the binary file)
    if(password == password.true){
      df <- data.frame(matrix(ncol = 3))
      colnames(df) <- c("AssignmentID", "TaskDescription", "CorrectAnswer")
      # generating report for each assignment
      for(i in 1:num.assignment){
        i <- as.numeric(i)
        data <- GenerateData(studentEmail, assignmentID = i)
        logging::loginfo('Data generated for studentEmail: %s and assignmentID: %d', studentEmail, i, logger = 'GenerateReportLogger')
        answers <- GetListOfAnswers(i)
        tasks <- GetListOfTasks(i)
        temp_df <- data.frame(matrix(ncol = 3, nrow = length(tasks)))
        colnames(temp_df) <- c("AssignmentID", "TaskDescription", "CorrectAnswer")
        temp_df$AssignmentID <- rep(c(i), times = length(tasks))
        temp_df$TaskDescription <- unlist(tasks)
        temp_df$CorrectAnswer <- unlist(answers)

        # appending the data.frame for each assignment
        df <- rbind(df, temp_df)
      }
      df <- na.omit(df)
      filename <- paste(log.config[["report_path"]], studentEmail, '.csv', sep = '')
      write.csv(df, filename, row.names = FALSE)

    } else {
      stop("Access Denied! This incident will be reported!")
    }

  }, warning = function(w){
    logging::logwarn(' %s ', w, logger = 'GenerateReportLogger')
    warning(w)
  }, error = function(e){
    logging::logerror(' %s ', e, logger = 'GenerateReportLogger')
    stop(e)
  })


}
