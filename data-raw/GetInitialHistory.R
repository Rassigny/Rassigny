# function to get initialized history
  GetInitialHistory <- function(num.assignment) {
  # get number of question for each assignment
  num.questions <- c()
  for (i in seq(num.assignment)) {
    num.question <- length(getElement(get(paste("json.assignment", i, sep="")), "questions"))
    num.questions <- c(num.questions, num.question)
  }
  # get highest number of question
  max.num <- max(num.questions)
  # set each column of assignment to elements of 0 and NA
  assignment <- list()
  for (i in seq(num.assignment)) {
    col.name <- paste("assignment", i, sep="")
    initial <- c(rep(0, num.questions[i]), rep(NA, max.num - num.questions[i]))
    assignment[[col.name]] <- initial
  }
  return (history <- as.data.frame(assignment))
}

